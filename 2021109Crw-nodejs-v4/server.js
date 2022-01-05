const fs = require('fs');
const https = require('https');
const express = require('express');
const cors = require('cors');
const app = express();


app.use(cors());

const URI = 'https://api.themoviedb.org/3/';
const API_KEY = '?api_key=ac4ad449fe4f41ff06ac82d245f9dd34';
const OPT = '&language=en-US&page=1&include_adult=false';



async function TMDBCall(path, opt = OPT) {
  return data = await new Promise(function(resolve, reject) {
    var req = https.get(URI + path + API_KEY + opt, res => {
      let body = "";

      res.on('data', data => {
        body += data;
      });

      res.on("end", () => {
        body = JSON.parse(body);
        resolve(body);
      });

    });

    req.end();
  })
}

const data_key = {
  'poster_path': 'https://image.tmdb.org/t/p/w500',
  'key': 'https://www.youtube.com/watch?v=',
  'avatar_path': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHnPmUvFLjjmoYWAbLTEmLLIRCPpV_OgxCVA&usqp=CAU',
  'avatar_path_origin': 'https://image.tmdb.org/t/p/original',
  'profile_path': 'https://image.tmdb.org/t/p/w500',
  'imdb_id': 'https://www.imdb.com/name/',
  'facebook_id': 'https://www.facebook.com/',
  'instagram_id': 'https://www.instagram.com/',
  'twitter_id': 'https://www.twitter.com/',
  'backdrop_path': 'https://image.tmdb.org/t/p/w780',
}

const param_keys = {
  0: ['id', 'title', 'poster_path'],
  1: ['site', 'type', 'name', 'key'],
  2: ['title', 'genres', 'spoken_languages', 'release_date', 'runtime', 'overview',
      'vote_average', 'tagline', 'poster_path'],
  3: ['author', 'content', 'created_at', 'url', 'author_details'],
  4: ['id', 'name', 'character', 'profile_path'],
  5: ['id', 'name', 'poster_path', 'first_air_date'],
  6: ['name', 'genres', 'spoken_languages', 'first_air_date', 'episode_run_time',
      'overview', 'vote_average', 'tagline', 'poster_path'],
  7: ['birthday', 'gender', 'name', 'homepage', 'also_known_as', 'known_for_department', 'biography', 'profile_path', 'place_of_birth'],
  8: ['imdb_id', 'facebook_id', 'instagram_id', 'twitter_id'],
  9: ['id', 'name', 'title', 'backdrop_path', 'media_type', "vote_average", "poster_path", "title", "name"],
  10: ['id', 'title', 'backdrop_path'],
  11: ['id', 'title', 'poster_path', 'release_date'],
  12: ['id', 'name', 'poster_path', 'first_air_date']
} 

const social = {
  "twitter_id": "",
  "facebook_id": "",
  "imdb_id": "",
  "instagram_id": "",
}

function TMDBParse(data, params, filter=false, filter2=false, filter3=false) {
  if ('cast' in data) {
    data = {'results': data['cast']};
  } else if (!('results' in data)) {
      data = {'results': [data]};
  }

  response = {'data': []}
  for (obj in data['results']) {
    item = {};
    for (key in params) {
      if (params[key] in data_key) {
        if (params[key] in social) {
          if (data['results'][obj][params[key]] == null || data['results'][obj][params[key]] == "") {
            item[params[key]] = "";
          } else {
            item[params[key]] = data_key[params[key]] + data['results'][obj][params[key]];
          }
        } else if (params[key] == "backdrop_path" && data['results'][obj][params[key]] == null) {
          item[params[key]] = "https://bytes.usc.edu/cs571/s21_JSwasm00/hw/HW6/imgs/movie-placeholder.jpg" 
        } else if(params[key] == "poster_path" && data['results'][obj][params[key]] == null) { 
          item[params[key]] = "https://cinemaone.net/images/movie_placeholder.png"
        } else {
          item[params[key]] = data_key[params[key]] + data['results'][obj][params[key]];
        }
      } else if (params[key] == 'author_details' && data['results'][obj][params[key]] != null) {
        item['avatar_path'] = data['results'][obj][params[key]]['avatar_path'];
        if (item['avatar_path'] == null) {
          item['avatar_path'] = data_key['avatar_path'];
        } else if (item['avatar_path'].includes("/https://")) {
           item['avatar_path'] = item['avatar_path'].substring(1);
        } else {
           item['avatar_path'] = data_key['avatar_path_origin'] + item['avatar_path'];
        }
        item['rating'] = ((parseFloat(data['results'][obj][params[key]]['rating']) / 2).toFixed(1)).toString() + '/5.0'
      } else if (params[key] == 'first_air_date' || params[key] == 'release_date') {
        item[params[key]] = data['results'][obj][params[key]].split('-')[0];
      } else if (params[key] == 'vote_average') {
        item[params[key]] = ((parseFloat(data['results'][obj][params[key]]) / 2).toFixed(1)).toString() + '/5.0'
      } else if (params[key] == 'gender') {
        if (data['results'][obj][params[key]] == 1) {
          item[params[key]] = 'Female';
        } else if(data['results'][obj][params[key]] == 2) {
          item[params[key]] = 'Male';
        } else {
          item[params[key]] = 'Undefined';
        }
      } else if (params[key] == 'also_known_as') {
        also_known_as = '';
        for (i in data['results'][obj][params[key]]) {
          also_known_as += data['results'][obj][params[key]][i] + ', ';
        } 
        item[params[key]] = also_known_as.slice(0, -1);
      } else if (params[key] == "created_at") {
          iso = (data['results'][obj][params[key]] + '').split(/\D+/);
          date = new Date(Date.UTC(iso[0], --iso[1], iso[2], iso[3], iso[4], iso[5], iso[6]));
          months = {0: "January", 1: "February", 2: "March", 3: "April", 4: "May", 5: "June", 6: "July", 7: "August", 8: "September", 9: "October", 10: "November", 11: "December"}
          var ampm = date.getHours() >= 12 ? 'PM' : 'AM';
          item[params[key]] = months[iso[1]] + ' ' + iso[2] + ', ' + iso[0];
       } else if (params[key] == 'genres') {
        genre = '';
        for (i in data['results'][obj][params[key]]) {
          genre += data['results'][obj][params[key]][i]['name'] + ',';
        }
        item[params[key]] = genre.slice(0, -1);
      } else if (params[key] == 'spoken_languages') {
        language = '';
        for (i in data['results'][obj][params[key]]) {
          language += data['results'][obj][params[key]][i]['english_name'] + ',';
        }
        item[params[key]] = language.slice(0, -1);
      } else if (params[key] == "media_type") {
        if (data['results'][obj][params[key]] == 'tv') {
          if (data['results'][obj]['first_air_date'] === undefined) {
            item['release_year'] = data['results'][obj]['first_air_date']
          } else {
            item['release_year'] = data['results'][obj]['first_air_date'].split('-')[0];
          }
        } else {
          if (data['results'][obj]['release_date'] === undefined) {
            item['release_year'] = data['results'][obj]['release_date']
          } else {
            item['release_year'] = data['results'][obj]['release_date'].split('-')[0];
          }
        }
        item[params[key]] = data['results'][obj][params[key]];
      } else {
        item[params[key]] = data['results'][obj][params[key]];
      }
    }
    response['data'].push(item);
  }

  if (filter) {
    for (var i = 0; i < response['data'].length; i++) {
      if (response['data'][i]['profile_path'].includes("null")) {
        response['data'].splice(i, 1);
        i--;
      }
    }
  }

  if (filter2) {
    for (var i = 0; i < response['data'].length; i++) {
      type = response['data'][i]['media_type'].trim();
      if (type.includes("tv")) {
        response['data'][i]['title'] = response['data'][i]['name'];
      } else if (type.includes("movie") || type.includes("tv")) {
      } else {
        response['data'].splice(i, 1);
        i--;
      }
    }
  }

  if (filter3) {
    if (response['data'].length == 0) {
      response['data'].push(
       { 
         site: 'YouTube',
         type: 'Trailer',
         name: 'Default',
         key: 'null'
       }
      );
    }

    var trailer = []

    for (obj in response['data']) {
      if (response['data'][obj]['type'] == 'Trailer') {
        trailer.push(response['data'][obj])
      }
    }
    if (trailer.length == 0) {
      response['data'].push(
       { 
         site: 'YouTube',
         type: 'Trailer',
         name: 'Default',
         key: 'null'
       }
      );
    } else {
      response['data'] = trailer
    }
  }

  return response
}

async function getHome() {
  curMov = TMDBParse(await TMDBCall('movie/now_playing'), param_keys[0]);
  topRateMov = TMDBParse(await TMDBCall('movie/top_rated'), param_keys[11]);
  popMov = TMDBParse(await TMDBCall('movie/popular'), param_keys[11]);
  airTV = TMDBParse(await TMDBCall('tv/airing_today'), param_keys[12]);
  topRateTV = TMDBParse(await TMDBCall('tv/top_rated'), param_keys[5]);
  popTV = TMDBParse(await TMDBCall('tv/popular'), param_keys[5]);
  return {"curMov": curMov, "popMov": popMov, "topRateMov": topRateMov, "airTV": airTV, "popTV": popTV, "topRateTV": topRateTV}
}


async function getProfile(ID, type='movie/') {
  if (type == 'tv/') {
    recommend = TMDBParse(await TMDBCall(type + ID + '/recommendations'), param_keys[5]);
    detail = TMDBParse(await TMDBCall(type + ID), param_keys[6]);
    similar = TMDBParse(await TMDBCall(type + ID + '/similar'), param_keys[5]);
  } else {
    recommend = TMDBParse(await TMDBCall(type + ID + '/recommendations'), param_keys[0]);
    detail = TMDBParse(await TMDBCall(type + ID), param_keys[2]);
    similar = TMDBParse(await TMDBCall(type + ID + '/similar'), param_keys[0]);
  }

  video = TMDBParse(await TMDBCall(type + ID + '/videos'), param_keys[1], false, false, true);
  review = TMDBParse(await TMDBCall(type + ID + '/reviews'), param_keys[3]);
  cast = TMDBParse(await TMDBCall(type + ID + '/credits'), param_keys[4], true);
  return {"recommend": recommend, "detail": detail, "similar": similar, "video": video, "review": review, "cast": cast}
}

async function getCastProfile(ID) {
  detail = TMDBParse(await TMDBCall('person/' + ID), param_keys[7]);
  external = TMDBParse(await TMDBCall('person/' + ID + '/external_ids'), param_keys[8]);
  return {"detail": detail, "external": external}
}

async function getSearch(query) {
  return TMDBParse(await TMDBCall('search/multi', opt=OPT+'&query=' + query), param_keys[9], false, true);
}




app.get('/', (req, res) => {
  getHome().then((data) => res.send(data))
});

app.get('/search', (req, res) => {
  getSearch(req.query.query).then((data) => res.send(data))
});

app.get('/watch/movie', (req, res) => {
  getProfile(req.query.id).then((data) => res.send(data))
});

app.get('/watch/tv', (req, res) => {
  getProfile(req.query.id, 'tv/').then((data) => res.send(data))
});

app.get('/cast', (req, res) => {
  getCastProfile(req.query.id).then((data) => res.send(data))
});

app.get('/mylist', (req, res) => {
  res.json({})
});

const PORT = process.env.PORT;
app.listen(PORT, () => {
  console.log(`Listening at http://localhost:${PORT}`)
});

module.exports = app;

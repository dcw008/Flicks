# Project 2 - *Flicks*

**Flicks** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).


Time spent: **36** hours spent in total


## User Stories

The following **required** functionality is completed:


=======
Week 1:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.


=======
Week 2:

- [x] User can view movie details by tapping on a cell.
- [x] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [x] Customize the selection effect of the cell.

The following **optional** features are implemented:


=======
Week 1:

- [ ] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.


=======
Week 2:

- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the navigation bar.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!
- [x] Scrollable TextView inside the table view cell
- [x] Stretchy header image animation inside the details page
- [x] Clear and white gradient at the bottom of the header
- [x] Embed Youtube Video in the details page
- [x] User can view ratings, runtime, date, genres
- [x] Display recommended movies inside a collection view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. 
2. 

## Video Walkthrough 

https://www.youtube.com/embed/8IXK0fjzBpA


## Notes

Describe any challenges encountered while building the app.

Getting the custom stretchy header on the details page was pretty challenging
because it was the first time for me working with customizing UI with animations.
Getting the animation to work with the gradient added later was also tricky because
before, I was programmatically adding it as a sublayer. However, when the frame
of the view was being updated upon scrolling, the gradient would adjust the height
much slower because it had to calculate its dimensions each time. I ended up fixing
this issue by having the gradient as a custom view, which visually has no noticeabledelay!

It was also a good experience to access numerous different endpoints within the 
MovieDatabaseAPI so I could get a lot of cool data on a certain page such as
getting details, recommendations, and even a video trailer.
## License

    Copyright [2017] [Derrick Wong]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

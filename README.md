### Besterday
 
The best thing you did yesterday.

Besterday helps you record a short, happy memory (a "bestie") for each day of your life. This enables you to dwell on the positive, and as time goes on you can also use this to reflect back on great moments in the past.

The app consists of two main views:
* Profile: Overview of your "bestie" stats, including your longest consecutive streak and a count of all the besties you've ever recorded
* Bestie Permalink: Let's you view and edit a full-sized bestie, enabling you both to post your latest memory or to edit past moments.

There are also a few ways to browse your besties:
* Swipe-to-browse: Once you dive into a bestie, you can swipe left/right to browse older or newer besties
* Profile feed: You can browse all of your besties in one place at the bottom of your profile. These feature smaller besties sorted chronologically.
*

####### Core functionality [v1]
* [x] Login with facebook 
* [x] Create new text-only bestie
* [x] Clicking on “done” in initial composer view brings up profile view
* [x] bestie needs to be tied to a user 
* [x] custom main view header - profile pic, name, create date
* [x] User stats: completion rate, total besties, best streak
* [x] grid view of besties sorted by date 
* [x] view bestie / composer / edit - tap to fade out text and show underlying image, tap again to fade text back in


####### More functionality [v2]
* [x] Conditionally show composer view (only if Bestie has not been created for yesterday)
* [x] Add photo to bestie using camera roll
* [x] Swipe left/right in composer to browse besties 

####### Visual candy [v3]
* [x] Profile header should collapse in a cool animated way when scrolling the feed (fades back, and perspective shifts to tilt backwards)
* [x] composer should have same color scheme as the card that called it
* [x] Stats should be dynamically displayed (should show a bar partially filled in)
* [x] Animate grid of besties on Profile View
* [x] animated transition between feed and composer
* [x] Have the background be black when the image is tapped
* [x] feed should display the image, same as the composer

####### More functionality [v4]
* [x] get a provisioning profile so we can install this on a phone for the demo
* [x] Wire up self-created date, change stats to calculate from those dates instead of Parse's hardcoded createdAt
* [x] feed should truncate long besties and make sure they don't overlap with the date
* [x] fix bug where bringing up the profile makes items load twice (NOTE: hack to avoid re-animation, Parse's cache policy still loads twice with cache THEN network)
* [x] Splash screen/app icon
* [x] demo script

####### Roadmap
* [ ] calendar view with circle size indicating number of words in the bestie
* [ ] local notification reminding user to write yesterday's bestie
* [ ] settings page so that user can set when to get the local notif
* [ ] analyze bestie create date and remind user in the hour that they've posted the most
* [ ] icarousel (cover flow) view
* [ ] word count graph, nodes should be tappable to open that bestie
* [ ] share besties on facebook (indication on the composer as to whether it's shared and unshare, if that's easy)* [x] most commonly used words with a pie chart
* [ ] our own social graph
* [ ] add friends, share besties, view of your friends' besties; composer adds public/private toggle
* [ ] % shared
* [ ] add friends, friend view with chat heads


### Work log

Wes: 22h55m
Larry: 21h
Raylene: 16h

### Notes

Developer notes are on [Quip](https://quip.com/8WIxAZrbzGQE).

### Walkthrough
![Video Walkthrough](http://i.giphy.com/5xaOcLu9SZBxhDuTwis.gif)

Credits
---------
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [DateTools](https://github.com/MatthewYork/DateTools)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [TTTAttributedLabel](https://github.com/mattt/TTTAttributedLabel)

(function() {

  /***************************
   *      BasicCarousel      *
   ***************************/
  /*
    BasicCarousel is a library that allows you to cycle to previous/ subsequent
    fabs by clicking left/ right arrows.

    You can regester all elements of a compaitible class with

        basicCarousel.register('.basic-carousel');

    Valid HTML scheme will look something like this:

      .basic-carousel
        a.fab-backward-btn
        a.fab-forward-btn
        .forward
        .back

    As long as you have that basic structure you should be able to click the two
    anchor elements and be able to cycle the .forward and .back elements to
    to previous/ subsequent fabs.
  */
  var BasicCarousel = function() {
    var nextFabEndpoint = "/tools/next_fab";
    var prevFabEndpoint = "/tools/previous_fab";

    // apply this to a selector that will get divs...
    // the divs must have a data-user-id and a data-fab-id
    // The divs must also contain navigation buttons:
    // .fab-backward-btn and .fab-forward-btn
    this.register = function(selector) {

      $(selector).each(function() {

        // Make it so when you click the child nav button, they look for the
        // parent's data and conduct the appropriate ajax/ view change action
        $(this).children('.fab-backward-btn').first().click(function() {
          cycleFab_click(this, false);
        });

        $(this).children('.fab-forward-btn').first().click(function() {
          cycleFab_click(this, true);
        });

      });

    };
    // This is the entire fab figure for the carousel that's been interacted with
    this.fab_encapsulator = null;

    // this is the button that was clicked to interact with the carousel
    this.button_element = null;

    function cycleFab_click(button_element, forward) {
      this.button_element = button_element = $(button_element);
      this.fab_encapsulator = fab_encapsulator = button_element.parent();

      if (button_element.hasClass('carouselBusy'))
        return; // we're already waiting for a server response it seems

      var cycle_options = {
        user_id: fab_encapsulator.attr('data-user-id'),
        fab_id: fab_encapsulator.attr('data-fab-id'),
        fab_period: fab_encapsulator.attr('data-fab-period')
      }

      var direction = forward ? 'forward' : 'backward';

      setCarouselToBusy();

      requestCycledFab(direction, cycle_options, function(markup) {
        var options = JSON.parse(markup.split(';')[0]);
        var new_fab_id = options.fab_id;
        var new_fab_period = options.fab_period;

        markup = markup.split(";").slice(1).join(";");

        populateFabInDisplay(markup, function(oldBackwardAndForward) {

          slideExistingFabAway(direction, function() {

            animateEntry(oldBackwardAndForward[0], direction);
            animateEntry(oldBackwardAndForward[1], direction);

            setCarouselToReady();
          });

        });

        fab_encapsulator.attr('data-fab-period', new_fab_period);
      });
    }

    // Disable the buttons
    // Display a loading thing
    function setCarouselToBusy() {
      fab_encapsulator.children('a').addClass('carouselBusy');
      button_element.addClass('icon-spin5 animate-spin carouselShrink');
      button_element.html('');
    }

    // reverse UI state imposed by setCarouselToBusy
    function setCarouselToReady() {
      fab_encapsulator.children('a').removeClass('carouselBusy');
      button_element.removeClass('icon-spin5 animate-spin carouselShrink');

      // Restore the original symbols now that the glyphicon is disabled
      if (button_element.hasClass('fab-forward-btn'))
        button_element.html('&gt;');
      else
        button_element.html('&lt;');
    }

    function slideExistingFabAway(direction, cbForShowingNew) {
      var old_backward_notes = fab_encapsulator.children('.back').first();
      var old_forward_notes = fab_encapsulator.children('.forward').first();

      animateDisappearance(old_forward_notes, direction);
      animateDisappearance(old_backward_notes, direction, cbForShowingNew);
    }

    function animateDisappearance(notes, direction, cb) {
      var polarity = direction === "forward" ? -1 : 1;
      var base_dist = 1050;
      if (polarity === -1)
        base_dist -= 320;

      notes.animate({
          left: (base_dist * polarity)
        }, {
          duration: 100,
          easing: "swing",
          complete: function() {
            /* delete the element if it exists */
            if (notes[0].remove) notes[0].remove();
            if (typeof cb === "function")
              cb();
          }
        }
      );
    }

    function animateEntry(newColumn, direction) {
      var motionFrom = direction === "forward" ? "right" : "left";

      $(newColumn).show("slide", { direction: motionFrom }, 120);
    }

    function requestCycledFab(direction, cycle_options, cb) {
      var action = (direction == "forward") ? nextFabEndpoint : prevFabEndpoint
      var query_list = [];
      query_list.push("user_id=" + cycle_options.user_id);
      if (cycle_options.fab_period != undefined)
        query_list.push("fab_period=" + encodeURI(cycle_options.fab_period));

      var url = action + '?' + query_list.join("&");
      return ajaxRequest(url, function(data) {
        cb(data);
      });
    }

    function ajaxRequest(url, cb) {
      $.ajax({
        url: url,
        success: function(data){
          if (data != "no such fab")
            cb(data);
        },
        error: function(e){
          console.log("ajaxRequest failed for " + url);
        }
      });
    }

    // removes the old forward notes, and overwrites the backward notes with
    // the backward AND forward
    function populateFabInDisplay(markup, cb) {
      var ulElements = parseTheUlElementsFromServerResponse(markup);

      // Apply the new elements to the DOM
      fab_encapsulator.append(ulElements[0]);
      fab_encapsulator.append(ulElements[1]);

      // Get references to them as objects
      var backward_notes = fab_encapsulator.children('.back').last();
      var forward_notes = fab_encapsulator.children('.forward').last();

      // Hide them before the user notices what we're doing
      backward_notes.hide();
      forward_notes.hide();

      cb([backward_notes, forward_notes]);
    }


    // Parse the two <ul> sections out of the html response from the server
    // Those represent the FAB notes of both back and forward
    function parseTheUlElementsFromServerResponse(markup) {
      // Make an element to facilitate DOM manipulation
      var parsingDiv = document.createElement('div');

      parsingDiv.innerHTML = markup;

      var back_markup = parsingDiv.children[0].outerHTML;
      var forward_markup = parsingDiv.children[1].outerHTML;
      return [back_markup, forward_markup];
    }

  };
  window.basicCarousel = new BasicCarousel();

})();

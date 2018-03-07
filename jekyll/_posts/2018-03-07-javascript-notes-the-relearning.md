---
layout: post
title: 'Javascript Notes: The Relearning'
---
Learning to use this demo: https://github.com/muaz-khan/RecordRTC/blob/master/simple-demos/audio-recording.html  
Starting from the top... What is this?  `<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">`  ah of course, it's for mobile devices.  https://stackoverflow.com/questions/14775195/is-the-viewport-meta-tag-really-necessary  
  
What is this?  `<div><audio controls autoplay></audio></div>`  It's the audio widget, which I did not know was an HTML tag.  `controls` shows the play, seek, volume controls, `autoplay` plays without pressing play.
  
What is this?  `<script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>`   Oh... we need to use this adapter for cross browser compatibility, insulating us from name changes.  
  
Why does the demo code declare vars all over the place... Let's move them to the top.  Demo still works.  
  
So.. the control flow here is convoluted, impossible to read top to bottom.  Let's start from pressing the "Start Recording" button.  Using the inspector I see the button has a click event.  I see where this is set, and I'll move it to the top.  Ah finally some sense; all the click handlers are set in a block.  So I'll just move all the click handlers to the top.
  
Alright, the btnStartRecording.onclick.  This smells bad, I'm pretty sure?
```
btnStartRecording.onclick = function() {
    this.disabled = true;
    this.style.border = '';
    this.style.fontSize = '';

    if (!microphone) {
        captureMicrophone(function(mic) {
            microphone = mic;

// Different behavior for Safari?  Changes button style, does an alert?
            if(isSafari) {
                replaceAudio();

                audio.muted = true;
                setSrcObject(microphone, audio);
                audio.play();

                btnStartRecording.disabled = false;
                btnStartRecording.style.border = '1px solid red';
                btnStartRecording.style.fontSize = '150%';

                alert('Please click startRecording button again. First time we tried to access your microphone. Now we will record it.');
                return;
//Return from calling function inside callback?  What?
            }

//Calling this function again, using a helper named click which,
//instead of calling the function, sends another click event?
//Hmm, maybe because we want the call to happen asynchronous to this
//function call we're currently in, as opposed to recursive?
            click(btnStartRecording);
        });
        return;
    }
console.log("\ndid we get here?\n");
    replaceAudio();

    audio.muted = true;
    setSrcObject(microphone, audio);
    audio.play();

    var options = {
        type: 'audio',
        numberOfAudioChannels: isEdge ? 1 : 2,
        checkForInactiveTracks: true,
        bufferSize: 16384
    };

    if(navigator.platform && navigator.platform.toString().toLowerCase().indexOf('win') === -1) {
        options.sampleRate = 48000; // or 44100 or remove this line for default
    }

    if(recorder) {
        recorder.destroy();
        recorder = null;
    }

    recorder = RecordRTC(microphone, options);

    recorder.startRecording();

    btnStopRecording.disabled = false;
    btnDownloadRecording.disabled = true;
};
```
What happens when I Do Not Allow access to the microphone?  The console.log does not get logged.  
  
First I refresh the page. Then click the button.  The microphone is null so captureMicrophone() is called.  captureMicrophone() sets the Release Button (a global variable) to not disabled.  captureMicrophone() then checks that same microphone global, which is still null at this time.  Then tries to getUserMedia(), and since I Do Not Allow, we get the alert.  Ah.. at this point the function returns, but Does Not call the Callback!  So, the Start Recording click handler returns, and that's the end of the story.  



//note, what is naviggator?

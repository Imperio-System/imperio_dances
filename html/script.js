var timeFirstKey = 7000
var timeBetweenKeys = 1000
var maxScore = 100000
var perfect = "PERFECTO!"
var keepItUp = "SIGUE ASÍ"
var notBad = "NO ESTÁ MAL"
var tooBad = "UFFF, MUY MAL"
//don't touch
var score = 0
var keyPoints = 0
var usableTime = 0
const resourceName = window.GetParentResourceName ? GetParentResourceName () : 'imperio_dances';

function generateKey() {
    if ($("body").css('display') != 'block') {
        return
    }

    usableTime = usableTime - timeBetweenKeys;

    var key = getRandomArbitrary(1, 4);

    switch (key) {
        case 1:
            key = "W"
            break;
        case 2:
            key = "S"
            break;
        case 3:
            key = "A"
            break;
        default:
            key = "D"
            break;
    }

    var id = key + Math.floor(Math.random() * 100000)

    html = '<div class="key ' + key + '" id="' + id + '" style="background: url(\'./img/' + key + '.png\') no-repeat center;"></div>';

    $("#bar").append(html);

    $("#" + id).animate({
        "right": "110%"
    }, 6000, function() {
        $("#" + id).remove();
    });

    if (usableTime > 0) {
        setTimeout(generateKey, timeBetweenKeys);
    }
}

function getRandomArbitrary(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

window.addEventListener('message', function(event) {
    if (event.data.show == "start") {
        $("body").show();
        $("#bar").show();
        $("#square").show();

        var duration = parseInt(event.data.duration) * 1000;

        score = 0;
        usableTime = duration - (timeFirstKey + 10000);

        var keyAmmount = usableTime / timeBetweenKeys;

        keyPoints = Math.round(maxScore / keyAmmount);

        setTimeout(function() {
            $("body").hide();
            $.post(`https://${resourceName}/endDance`);
        }, duration);

        setTimeout(generateKey, timeFirstKey);
    } else if (event.data.show == "stop") {
        $("body").hide();
    } else {
        var squarePosition = parseInt($("#square").css("right"), 10);

        $("." + event.data.key).each(function() {
            var value = parseInt($(this).css("right"), 10);

            if (value > squarePosition * 0.95) {
                document.getElementById($(this).attr("id")).style.display = "none";

                var hit = (value * 100) / squarePosition;

                if (hit > 100) {
                    hit = 100 - (hit - 100);
                }

                if (hit > 99) {
                    $("#message").html(perfect);
                    $("#message").css("color", "#edff00");
                    setTimeout(function() {
                        $("#message").html("")
                    }, 600);
                    score = score + keyPoints;
                } else if (hit > 97) {
                    $("#message").html(keepItUp);
                    $("#message").css("color", "#00752a");
                    setTimeout(function() {
                        $("#message").html("")
                    }, 600);
                    score = score + Math.round(keyPoints / 2);
                } else if (hit > 94) {
                    $("#message").html(notBad);
                    $("#message").css("color", "#1c04a2");
                    setTimeout(function() {
                        $("#message").html("")
                    }, 600);
                    score = score + Math.round(keyPoints / 3);
                } else {
                    $("#message").html(tooBad);
                    $("#message").css("color", "#7e0000");
                    setTimeout(function() {
                        $("#message").html("")
                    }, 600);
                }
                $.post(`https://${resourceName}/updatePoints`, JSON.stringify({
                    ammount: score
                }));
            }
        });
    }
});
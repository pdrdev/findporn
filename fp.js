function filterByDates()
{
    var maxDaysSinceUploaded =  document.getElementById('max_uploaded_days').value
    var maxDaysSinceAdded =  document.getElementById('max_added_days').value

    var now = new Date().getTime() / 1000
    var allElements = document.getElementsByTagName('div')
    for (var i = 0, n = allElements.length; i < n; i++)
    {
        if (allElements[i].getAttribute('uploaded_timestamp') && allElements[i].getAttribute('added_timestamp'))
        {
            var uploadedTimeStamp = allElements[i].getAttribute('uploaded_timestamp')
            var addedTimeStamp = allElements[i].getAttribute('added_timestamp')
            var diffTimeUploaded = now - uploadedTimeStamp
            var diffTimeAdded = now - addedTimeStamp
            var daysUploaded = diffTimeUploaded / 24 / 60 / 60
            var daysAdded = diffTimeAdded / 24 / 60 / 60

            var hide = (maxDaysSinceUploaded && (daysUploaded > maxDaysSinceUploaded)) || (maxDaysSinceAdded && (daysAdded > maxDaysSinceAdded));
            if (!hide)
            {
                allElements[i].style.display = 'block'
            } else
            {
                allElements[i].style.display = 'none'
            }
        }
    }

    filterEmptyQueries()
    filterEmptySections()
}

function filterEmptyQueries()
{
    var needsFiltering = document.getElementById('filter_empty_queries').checked

    var queryDivs = document.getElementsByClassName('query')
    for (var i = 0, n = queryDivs.length; i < n; i++)
    {
        var queryDiv = queryDivs[i]
        if (!needsFiltering)
        {
            queryDiv.style.display = 'block'
            continue
        }

        var foundVisible = false
        var hrefDivs = queryDiv.getElementsByClassName('href')
        for (var j = 0; j < hrefDivs.length; j++)
        {
            var hrefDiv = hrefDivs[j]
            foundVisible = foundVisible || (hrefDiv.style.display != 'none')
        }

        if (foundVisible)
        {
            queryDiv.style.display = 'block'
        }
        else
        {
            queryDiv.style.display = 'none'
        }
    }
}

function filterEmptySections()
{
    var needsFiltering = document.getElementById('filter_empty_sections').checked

    var sectionDivs = document.getElementsByClassName('section')
    for (var i = 0, n = sectionDivs.length; i < n; i++)
    {
        var sectionDiv = sectionDivs[i]
        if (!needsFiltering)
        {
            sectionDiv.style.display = 'block'
            continue
        }

        var foundVisible = false
        var hrefDivs = sectionDiv.getElementsByClassName('href')
        for (var j = 0; j < hrefDivs.length; j++)
        {
            var hrefDiv = hrefDivs[j]
            foundVisible = foundVisible || (hrefDiv.style.display != 'none')
        }

        if (foundVisible)
        {
            sectionDiv.style.display = 'block'
        }
        else
        {
            sectionDiv.style.display = 'none'
        }
    }
}

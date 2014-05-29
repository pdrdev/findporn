function filterByUploadDate()
{
    var maxDays =  document.getElementById('max_upload_days').value

    var now = new Date().getTime() / 1000
    var allElements = document.getElementsByTagName('div')
    for (var i = 0, n = allElements.length; i < n; i++)
    {
        if (allElements[i].getAttribute('upload_timestamp'))
        {
            var uploadTimeStamp = allElements[i].getAttribute('upload_timestamp')
            var diffTime = now - uploadTimeStamp
            var days = diffTime / 24 / 60 / 60

            if (!maxDays || days <= maxDays)
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

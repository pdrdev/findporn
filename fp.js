function filterByUploadDate()
{
    var maxDays = document.getElementById('max_upload_days').value

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
}

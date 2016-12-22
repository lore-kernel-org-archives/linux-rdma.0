From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to
 depdendencies, descriptions, formatting
Date: Thu, 22 Dec 2016 11:35:36 -0700
Message-ID: <20161222183536.GB5660@obsidianresearch.com>
References: <20161222180220.49558-1-jarod@redhat.com>
 <20161222181323.GA5053@obsidianresearch.com>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bf346322-4ef4-032d-9ea2-5a63ae7737e5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 01:17:00PM -0500, Jarod Wilson wrote:

> >>- Add explicit dependencies on kmod, initscripts and systemd, as there
> >>  are container and vm cases where there might not be a kernel
> >>  installed
> >
> >Do we need initscripts?
> 
> Not really sure, the Fedora package reviewer insists we do.

Hm, no idea what for. We don't provide any LSB init scripts any more,
right?

> >> Requires: %{name}%{?_isa} = %{version}-%{release}
> >>+Requires: logrotate
> >
> >I don't think we use logrotate for anything unless the srp rsyslog
> >examples are being used? Maybe it would be better to move the logrotate
> >and rsyslog stuff to doc/examples or something?
> 
> This is another one where the package reviewer seems insistent.

By default "journald -u srp_daemon" does the same job, so I view
these files as obsolete for pre-systemd distros.

I think we should just not include the rsyslog and logrotate config
files at all. Sophisticated users that need that stuff can install
rsyslog and setup their own filtering. I assume that is the FC policy?
That avoids the reviewer comment.

It certainly makes 0 sense to Require logrotate without also requiring
rsyslog because rsyslog is the thing that writes the file being
rotated...

Forcing rsyslog is *really* not desirable, most people don't want/need
that overhead. Forcing logrotate is not desirable because it forces a
useless cron job to run and folks in this world are sensitive to that
jitter..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

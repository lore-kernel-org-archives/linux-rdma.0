From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 10:38:07 -0700
Message-ID: <20161222173807.GA15461@obsidianresearch.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221234014.GA13538@obsidianresearch.com>
 <0d77c962-607b-1e05-4fbf-41195446128d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d77c962-607b-1e05-4fbf-41195446128d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 02:32:07AM -0500, Jarod Wilson wrote:

> >>BuildRequires: valgrind-devel
> >>honli: systemd and dracut also needed.
> >
> >Not to build?
> 
> Argh. From https://fedoraproject.org/wiki/Packaging:Systemd

Hum, I wonder if that works from docker containers.. C7 was doing
something wonky with fake systemd packages in docker.

> >>honli: Please add "Requires:" entries against rsyslog, systemd, kmod,
> >>honli: logrotate, initscripts, and dracut.
> >
> >It might make sense to depend on kmod in rdma core since it is using
> >the module loading infrastructure..
> 
> The kernel itself already requires it, so unless you're installing on a
> system that somehow has no kernel installed, it's entirely redundant.

Containers don't have the kernel packages.

Containers won't trigger udev rules, but they might be using
systemd.

I also have some Xen systems that boot without kernel packages (shared
kernel comes from the dom0), they will trigger udev related rules and
module loading paths, the scripts shouldn't outright fail because kmod
is accidently not installed.

> >Use this for now:
> >
> >https://github.com/linux-rdma/rdma-core/archive/v12-rc2.tar.gz
> >
> >Best to make sure the release process is going to work :)
>
> Ugh. I rather dislike tarballs that don't have the package name in them.
> Download it, some time passes, and you look at it and aren't sure
> what it

Yes.. Somehow libfabric is doing this:

https://github.com/ofiwg/libfabric/releases

It looks like they produced the .tar.gz by hand and then uploaded it
again as an attached release file?

Should we do this too, Doug?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

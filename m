From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Wed, 21 Dec 2016 16:40:14 -0700
Message-ID: <20161221234014.GA13538@obsidianresearch.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 21, 2016 at 05:08:34PM -0500, Jarod Wilson wrote:

> Fedora package review bug:
>   https://bugzilla.redhat.com/show_bug.cgi?id=1404043

To elaborate on that discussion..

>> lrwxrwxrwx. 1 honli honli 15 Dec 20 00:37 librspreload.so.1 -> librspreload.so
>> lrwxrwxrwx. 1 honli honli 15 Dec 20 00:37 librspreload.so.1.0.0 -> librspreload.so

> This looks like an upstream problem, just doing a build in a freshly
> unpacked tree sans-rpm has similar results. I'll address it there.

I see you found the packaging bug.. FYI the mechanism in cmake is to
produce build/lib/librspreload.so and no symlinks.

Two symlinks are produces under build/librdmacm/ but those are just
artifacts of how the install install process works for symlinks.

Once installed via DESTDIR=`pwd`/inst ninja install everything ends up
properly:

$ ls -l build/inst/usr/local/lib/rsocket/ 
-rw-r--r-- 1 jgg orc 117696 Dec 12 17:29 librspreload.so
lrwxrwxrwx 1 jgg orc     15 Dec 21 16:12 librspreload.so.1 -> librspreload.so
lrwxrwxrwx 1 jgg orc     15 Dec 21 16:12 librspreload.so.1.0.0 -> librspreload.so

It is appropriate for all these links to be in the same package as the
.so - these are not 'devel' links. They are compat for people using
the wrong name of the preload library. Eg users should be doing

LD_PRELOAD=/usr/lib/rsocket/librspreload.so foo

But since the old build system didn't build with the plugin option we
go out of our way to include these historical symlinks just incase
someone is using them improperly.

>> The service had been named as "srpd" since 2009, should we keep the old name?

> I'd stick with following upstream.

srp_daemon.service hasn't migrated out of redhat/ yet, I've got no
objection to adding a systemd alias for srpd if it is a well known
historical name..

+[Install]
+Alias=srpd.service

> Question 2: why libibacmp.so.* removed for new ibacm-12-1.fc26 pkg?
> (libibcm.f26 keeps libibcm.so.1.0.12)

The presence of the .so and .so.1 files was a bug in the old build
system that did not call libtool with the plugin option. This library
is only for dlopen and should never be used by the linker, so no need
for the aliases.

> Comment 2: iwpmd no longer start after syslog.target, as it does not write
> any log files. iwpmd send log message to /var/log/messages.

syslog.target is obsolete, Upstream systemd says not to use it.

> honli: libnl3-devel is required for iwpmd libibverbs

As you say, taken care of by pkgconfig(libnl-3.0), etc

> BuildRequires: valgrind-devel
> honli: systemd and dracut also needed.

Not to build?

> honli: Please add "Requires:" entries against rsyslog, systemd, kmod,
> honli: logrotate, initscripts, and dracut.

It might make sense to depend on kmod in rdma core since it is using
the module loading infrastructure..

rsyslog/logrotate are just examples for srp, as packaged it uses the
standard syslog logger, so they are not Requires

dracut.. we don't need it, but if it is present there are plugins
included, not a Requires..

Not sure why initscripts?

systemd is automatic via rpm, right?

> I could, but this situation is temporary, there will be an upstream
> release and a full URL shortly. This was noted in comment #1, but I
> could add that same text to

Use this for now:

https://github.com/linux-rdma/rdma-core/archive/v12-rc2.tar.gz

Best to make sure the release process is going to work :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

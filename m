From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 02:32:07 -0500
Message-ID: <0d77c962-607b-1e05-4fbf-41195446128d@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221234014.GA13538@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221234014.GA13538-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-21 6:40 PM, Jason Gunthorpe wrote:
> On Wed, Dec 21, 2016 at 05:08:34PM -0500, Jarod Wilson wrote:
>
>> Fedora package review bug:
>>   https://bugzilla.redhat.com/show_bug.cgi?id=1404043
>
> To elaborate on that discussion..
>
>>> lrwxrwxrwx. 1 honli honli 15 Dec 20 00:37 librspreload.so.1 -> librspreload.so
>>> lrwxrwxrwx. 1 honli honli 15 Dec 20 00:37 librspreload.so.1.0.0 -> librspreload.so
>
>> This looks like an upstream problem, just doing a build in a freshly
>> unpacked tree sans-rpm has similar results. I'll address it there.
>
> I see you found the packaging bug.. FYI the mechanism in cmake is to
> produce build/lib/librspreload.so and no symlinks.
>
> Two symlinks are produces under build/librdmacm/ but those are just
> artifacts of how the install install process works for symlinks.
>
> Once installed via DESTDIR=`pwd`/inst ninja install everything ends up
> properly:
>
> $ ls -l build/inst/usr/local/lib/rsocket/
> -rw-r--r-- 1 jgg orc 117696 Dec 12 17:29 librspreload.so
> lrwxrwxrwx 1 jgg orc     15 Dec 21 16:12 librspreload.so.1 -> librspreload.so
> lrwxrwxrwx 1 jgg orc     15 Dec 21 16:12 librspreload.so.1.0.0 -> librspreload.so
>
> It is appropriate for all these links to be in the same package as the
> .so - these are not 'devel' links. They are compat for people using
> the wrong name of the preload library. Eg users should be doing

Yeah, they look correct in the resulting binaries after some tweaks.

>>> The service had been named as "srpd" since 2009, should we keep the old name?
>
>> I'd stick with following upstream.
>
> srp_daemon.service hasn't migrated out of redhat/ yet, I've got no
> objection to adding a systemd alias for srpd if it is a well known
> historical name..
>
> +[Install]
> +Alias=srpd.service

That works too.

>> BuildRequires: valgrind-devel
>> honli: systemd and dracut also needed.
>
> Not to build?

Argh. From https://fedoraproject.org/wiki/Packaging:Systemd

Packaging
Filesystem locations

Packages with systemd unit files must put them into %{_unitdir}. 
%{_unitdir} evaluates to /lib/systemd/system on all Fedora systems 
(F-15+). Unit files are architecture independent (hence, not %{_lib}) 
and needed early in the boot process.

Please note that in order for the %{_unitdir} macro to exist, your 
package must have:

BuildRequires: systemd

So it seems BR: systemd *is* necessary. Not so sure about dracut. 
Frankly, I think that's poor design, and the macros should be in one of 
the core rpm macros packages, but oh well.

I'm not aware of any dracut build deps, and indeed, my build in a Fedora 
rawhide mock chroot worked fine w/just systemd added.

>> honli: Please add "Requires:" entries against rsyslog, systemd, kmod,
>> honli: logrotate, initscripts, and dracut.
>
> It might make sense to depend on kmod in rdma core since it is using
> the module loading infrastructure..

The kernel itself already requires it, so unless you're installing on a 
system that somehow has no kernel installed, it's entirely redundant.

> rsyslog/logrotate are just examples for srp, as packaged it uses the
> standard syslog logger, so they are not Requires
>
> dracut.. we don't need it, but if it is present there are plugins
> included, not a Requires..

And dracut is another one already required by the kernel.

> Not sure why initscripts?
>
> systemd is automatic via rpm, right?

Also required by the kernel.

>> I could, but this situation is temporary, there will be an upstream
>> release and a full URL shortly. This was noted in comment #1, but I
>> could add that same text to
>
> Use this for now:
>
> https://github.com/linux-rdma/rdma-core/archive/v12-rc2.tar.gz
>
> Best to make sure the release process is going to work :)

Ugh. I rather dislike tarballs that don't have the package name in them. 
Download it, some time passes, and you look at it and aren't sure what 
it actually is anymore just by looking at the file name. It causes some 
annoyances with rpm specs too (can't use standard %setup macro, because 
it expects %{name}-%{version}, etc).

I'll re-spin the patch series in the morning w/updates from further 
discussion here.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

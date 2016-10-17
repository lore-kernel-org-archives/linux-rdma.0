From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 14:20:37 -0400
Message-ID: <20161017182037.GK14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017174611.GB6430-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 11:46:11AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 17, 2016 at 12:22:21PM -0400, Jarod Wilson wrote:
> > Worksforme. As mentioned in reply to Leon, I really don't care what the
> > directory is called, just that we get this stuff out there, instead of
> > being in our own custom glue package. I do think maybe Leon's suggestion
> > of having a directory to put a bunch of distro-specific directories under
> > would be good for cleanliness, but I also seem to recall that debian
> > actually looks for a directory in the root of the tarball, so it may need
> > to stay like it is.
> 
> Okay, let us just do a very minimal upstreaming and tackle things from
> there..

Sounds like a plan.

> > > Common stuff should be installed via cmake
> > > 
> > > > diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
> > > > new file mode 100644
> > > > index 0000000..1cd031a
> > > > +++ b/glue/redhat/ibacm.service
> > > 
> > > Can we just put this in ibacm/ ?
> > 
> > Probably.
> 
> Okay, the only thing I really don't like being upstream is the
> opensm.service..
> 
> Do you know why acm needs that?

I think Doug already attempted to address this elsewhere in the thread,
and he'd know better than me.

> > > > +++ b/glue/redhat/iwpmd.service
> > > > @@ -0,0 +1,12 @@
> > > > +[Unit]
> > > > +Description=Starts the IWPMD daemon
> > > > +Documentation=file:///usr/share/doc/iwpmd/README
> > > 
> > > File does not exit? There is a man page now
> > > 
> > > We already have a iwpmd/iwpmd.service that is almost identical, can you
> > > you just update it and drop this version?
> > 
> > Bah, that's a carryover from our individually packaged iwpmd, didn't look
> > closely enough. Can we merge a bit from ours into the 'stock' one? The
> > main relevant difference I see is we have ours set to load after
> > syslog.target as well as network.target.
> 
> syslog.target is obsolete now, just drop it from all your unit files
> unless you need to support systemd <= 35. systemd no longer even
> documents this special target exists.
> 
> commit e8f2b5c11e9db0bab2654e75c2558955effb82fe
> Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date:   Mon Sep 12 15:53:10 2016 -0600
> 
>     iwpmd: Remove syslog.target from service file
>     
>     Debian's Lintian remarks:
>     
>     W: rdma-plumbing: systemd-service-file-refers-to-obsolete-target lib/systemd/system/iwpmd.service syslog.target
>     
>     Apparently systemd stopped recommending this in version 35, socket activation
>     eliminates the need.
>     
>     Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Ah, okay. So not needed for any distro that is even remotely modern.

> > > > +SUBSYSTEM=="module", KERNEL=="cxgb*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > > +SUBSYSTEM=="module", KERNEL=="ib_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > > +SUBSYSTEM=="module", KERNEL=="mlx*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > > +SUBSYSTEM=="module", KERNEL=="iw_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > > +SUBSYSTEM=="module", KERNEL=="be2net", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > > +SUBSYSTEM=="module", KERNEL=="enic", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > > 
> > > Also cross distro
> > 
> > Yeah, these are definitely prime candidates for being cross-distro. And
> > really, I was thinking maybe these should be part of the core upstream
> > udev/systemd rules set, rather than something we ship here.
> 
> Okay. The trick will be to standardize the systemd_wants name ..

Perhaps rdma-core should go with rdma-core.service? We were shipping a
package called 'rdma' that carried that.

> > > > +# When we detect a new verbs device is added to the system, set the node
> > > > +# description on that device
> > > > +# If rdma-ndd is installed, defer the setting of the node description to it.
> > > > +SUBSYSTEM=="infiniband", KERNEL=="*", ACTION=="add", TEST!="/usr/sbin/rdma-ndd", RUN+="/bin/bash -c 'sleep 1; echo -n `hostname -s` %k > /sys/class/infiniband/%k/node_desc'"
> > > 
> > > Shouldn't this udev drop-in by in the rdma-ndd package?
> > 
> > Honestly don't even have a clue what rdma-ndd is. :) Don't remember what
> > Doug said about this one...
> 
> Guess I didn't read closely enough, this is used if rdma-ndd is not
> installed..
> 
> So something like that should be upstream, but the 'sleep 1' is ugly -
> this should probably be a systemd service that runs after
> network-online.target not as a script run from udev?
> 
> rdma-ndd dynamically sets the NodeDescription to the hostname in the
> adaptor for the subnet manager/tools to ready. I guess this hunk is
> setting the NodeDescription one-shot at boot..

Rather than having this janky udev rule, what if we simply made rdma-ndd
part of what's installed with rdma-core, rather than something found in
yet another infiniband package? (Looks like it's in infiniband-diags,
wasn't even aware rdma-ndd existed until looking at this here).

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

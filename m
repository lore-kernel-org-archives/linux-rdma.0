From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 16:04:10 -0800
Message-ID: <adaljictxqd.fsf@roland-alpha.cisco.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com>
	<adafx8kx41h.fsf@roland-alpha.cisco.com>
	<1257970050.992.317.camel@chromite.mv.qlogic.com>
	<adaaayswzrh.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com>
	<adaaaysvf69.fsf@roland-alpha.cisco.com>
	<1257981770.992.336.camel@chromite.mv.qlogic.com>
	<20091111234744.GA1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091111234744.GA1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Wed, 11 Nov 2009 16:47:44 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Maybe give some thought to using a syscall interface through uverbs
 > for some of this?

Actually I think for exposing SL-to-VL and other things like that, sysfs
is pretty good.  Having something usable from both scripts and programs
seems pretty useful, and having an opaque uverbs interface isn't really
an improvement (especially when we have to design something extensible
that device-specific stuff can be put into).

 > IMHO, sysfs is getting out of hand for rdma:

I'm not sure how much of a problem this really is...

 > $ find /sys/class/infiniband/mlx4_0 -type f | wc -l
 > 660

and presumably 512 of those are gid and pkey table entries?

 > $ strace -o /tmp/t /opt/ofa-1.5/sbin/perfquery ; grep sys/ /tmp/t | wc -l
 > 289

That seems a little crazy, but maybe it's an app that's doing silly
stuff?  If I do ibv_rc_pingpong, the only /sys related things I see are:

    open("/sys/class/infiniband_verbs/abi_version", O_RDONLY) = 3
    open("/sys/class/infiniband_verbs", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
    stat("/sys/class/infiniband_verbs/abi_version", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
    stat("/sys/class/infiniband_verbs/uverbs0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
    open("/sys/class/infiniband_verbs/uverbs0/ibdev", O_RDONLY) = 4
    open("/sys/class/infiniband_verbs/uverbs0/abi_version", O_RDONLY) = 4
    open("/sys/class/infiniband_verbs/uverbs0/device/vendor", O_RDONLY) = 3
    open("/sys/class/infiniband_verbs/uverbs0/device/device", O_RDONLY) = 3
    open("/sys/class/infiniband/mlx4_0/node_type", O_RDONLY) = 3

which is reasonable I think.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

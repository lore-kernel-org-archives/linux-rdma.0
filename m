From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 17:33:58 -0700
Message-ID: <20091112003358.GB1966@obsidianresearch.com>
References: <1257966478.992.300.camel@chromite.mv.qlogic.com> <adafx8kx41h.fsf@roland-alpha.cisco.com> <1257970050.992.317.camel@chromite.mv.qlogic.com> <adaaayswzrh.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911111303080.25952@topaz.mv.qlogic.com> <adaaaysvf69.fsf@roland-alpha.cisco.com> <1257981770.992.336.camel@chromite.mv.qlogic.com> <20091111234744.GA1966@obsidianresearch.com> <adaljictxqd.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaljictxqd.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2009 at 04:04:10PM -0800, Roland Dreier wrote:
> 
>  > Maybe give some thought to using a syscall interface through uverbs
>  > for some of this?
> 
> Actually I think for exposing SL-to-VL and other things like that, sysfs
> is pretty good.  Having something usable from both scripts and programs
> seems pretty useful, and having an opaque uverbs interface isn't really
> an improvement (especially when we have to design something extensible
> that device-specific stuff can be put into).

I guess it depends on the purpose, a noticable problem with sysfs is
that there is no good way to be notified when the data changes. PKey,
SL2VL, GID tables, sm_lid etc are all SM dynamic information and many
cases that are using them should probably have code to know when the
SM changes them and make appropriate adjustments.

For instance a long running SMP using program has no way to be
notified when the sm_lid changes, or the GID table changes - but it
can pick up an IB async event for the pkey table changes.. What should
new things do?

It also means we can never have something like ifrename for IB - too
racey with sysfs.

>  > IMHO, sysfs is getting out of hand for rdma:
> 
> I'm not sure how much of a problem this really is...

Neither am I.. But I've seen the various eternal lkml arguments about
sysfs, netlink, syscall, etc and it does seem like the preferred
option is a little bit of all them. It does seem worth asking from
time to time if the rdma stuff in sysfs is appropriate.

>  > $ find /sys/class/infiniband/mlx4_0 -type f | wc -l
>  > 660
> 
> and presumably 512 of those are gid and pkey table entries?

Probably. TBH, those are the ones I find most un-sysfs-like..

>  > $ strace -o /tmp/t /opt/ofa-1.5/sbin/perfquery ; grep sys/ /tmp/t | wc -l
>  > 289
> 
> That seems a little crazy, but maybe it's an app that's doing silly
> stuff?  If I do ibv_rc_pingpong, the only /sys related things I see are:

It is reading the pkey and gid tables for some reason. There is no
other way to get that data except by trundling through sysfs.. Which I
guess really is my point - it isn't so much that the stuff is in sysfs
that is strange, but that it is *only* in sysfs.

>     open("/sys/class/infiniband_verbs/abi_version", O_RDONLY) = 3
>     open("/sys/class/infiniband_verbs", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
>     stat("/sys/class/infiniband_verbs/abi_version", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
>     stat("/sys/class/infiniband_verbs/uverbs0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
>     open("/sys/class/infiniband_verbs/uverbs0/ibdev", O_RDONLY) = 4
>     open("/sys/class/infiniband_verbs/uverbs0/abi_version", O_RDONLY) = 4
>     open("/sys/class/infiniband_verbs/uverbs0/device/vendor", O_RDONLY) = 3
>     open("/sys/class/infiniband_verbs/uverbs0/device/device", O_RDONLY) = 3
>     open("/sys/class/infiniband/mlx4_0/node_type", O_RDONLY) = 3
> 
> which is reasonable I think.

Yes, I also think that is pretty much fine.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

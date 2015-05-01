From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Fri, 1 May 2015 09:41:55 +0300
Message-ID: <CAAKD3BDj8MWhOu0wK7hRWHWf3Q6PmwYzr7Yp3oc6jpGBTs28JA@mail.gmail.com>
References: <553DF294.4070507@mellanox.com>
	<CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
	<553F931F.6000302@mellanox.com>
	<20150428174312.GB5497@obsidianresearch.com>
	<5540F8F4.5010906@dev.mellanox.co.il>
	<20150429164847.GA12781@obsidianresearch.com>
	<5541E5ED.7000606@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FC929B@ORSMSX109.amr.corp.intel.com>
	<20150430175252.GB32666@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FC9419@ORSMSX109.amr.corp.intel.com>
	<20150430212842.GB7709@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430212842.GB7709-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 1, 2015 at 12:28 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Apr 30, 2015 at 07:21:08PM +0000, Hefty, Sean wrote:
>> > But, how could RDMA CM work? Inbound CM messages will be filtered if
>> > the IP is not in the HW GID table?
>>
>> I'm not understanding the issue.
>>
>> If a device has some requirement to program its assigned IP
>> addresses into some HW table, I don't see why upper layers should be
>> made to care.
>
> Okay, I was only thinking about the first couple patches in this
> series.  Three drivers will have this HW gid table, so having a driver
> helper library in the common code makes sense to me.
>
> But then the series it just seems to go crazy - what is with all these
> net dev patches? Now we are doing something with bonding? And a lot of
> screwy looking rocev2 gid type stuff? And driver updates? And 33 patches worth?
>

Actually, we're in the middle of splitting this series into two series
- the first introduces
the roce_gid_cache management and the second will introduce RoCE V2.
The bonding changes are crucial - the mlx4 driver currently support bonding
and changing to a new mechanism without supporting bonding will cause
a regression.

> You are totally right, this GID index and GID type stuff is getting
> *everywhere*, and it is hard to follow the *why* of all the changes
> are really needed.
>
> Matan, if you want to progress this, then split it up.  Make a patch
> to library the existing roce GID table driver code and update the
> drivers. Just that bit alone has already spawned a huge discussion.
>

It's already in progress. The new series is expected to be a lot smaller.

> Work the other ancillary unrelated patches in small chuncks through
> their trees.
>

The DRV patch was already sent to net. Regarding the bonding and ipv6
patch - we can't change them without a good reason which relies in this
patchset.

> Then come back to rocev2 with an actual core API proposal patch set
> that can be discussed.
>
> Honestly, I'm not willing to even look at a patch set this big and
> rambly.

Ok, hopefully we'll have something soon enough.

>
> Jason

Thanks a lot for the review and your comments.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

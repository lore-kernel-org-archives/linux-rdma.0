From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Sun, 5 Apr 2015 08:15:46 +0300
Message-ID: <CAJ3xEMgsHAFJomuCN+EzMcYaxTOTQqHuDdr9zztuO9pH9QicXw@mail.gmail.com>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
	<20150331.114824.651005354305268415.davem@davemloft.net>
	<1828884A29C6694DAF28B7E6B8A82373A8FBB790@ORSMSX109.amr.corp.intel.com>
	<CAJ3xEMgm+6t1OSMZFJ41Hr4=8B1cKP+5svwc38Lg0wfpCZMO=g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FBBCE3@ORSMSX109.amr.corp.intel.com>
	<CAJ3xEMgptECgnWXfW7wN8sjqRfUvzF3tCN=Lj8MZtdOG8yg3jQ@mail.gmail.com>
	<20150402223135.GA12588@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150402223135.GA12588-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 3, 2015 at 1:31 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Apr 02, 2015 at 05:32:53PM +0300, Or Gerlitz wrote:
>> On Wed, Apr 1, 2015 at 12:33 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> [snip]

>> Your claim says more or less "don't touch the good old
>> include/rdma/ib_verbs.h from 2.6.12, just add new low-level drivers"
>> -- this is very close to claiming that it doesn't make sense to change
>> anything in the low areas of the core networking stack or in
>> netdevice.h over the years, just add new Ethernet drivers. This does
>> not make any sense.

> I don't think the question is "if" we should change the core but "how".

> Seans point is that the core seems to be in constant flux.  Furthermore, Roland
> and others have found enough problems with the core changes in the past that
> they are _not_ comfortable applying them without serious review.

Ira, examples please for core changes that went in and later turned to
be problematic?! I refer to APIs and structural changes that turned to
be such (not or to less extent point bugs, which should be avoided
too, you know..)

> Many of the changes proposed here are completely new and require serious
> time to understand.
> Most people on this list have limited time and are unable to review every
> vendors hardware implementation.  What they do care about is how those
> changes
> affect the core and how those core changes then affect their hardware, other
> hardware they use, and the ULPs.  This becomes a huge amount of time.

You're mixing between vendor's driver code to core changes -- "unable
to review every vendors hardware implementation" -- is clear and we
didn't ask for that.

As for what's involved in merging core API changes - you made good
description of what's needed there --- but this is all about the
development and evolution of a core stack for domain X (networking,
block storage, virtualization, RDMA or you namde it). Such an argument
must not be used, since can kill X's stack development and the rdma
case, leave us with the 10y old 2.6.12 based verbs header file.

> To facilitate this we should be looking for ways to minimize and be very clear
> the ramifications of the core changes.  In addition, we need to identify where
> the core needs to be cleaned up such that future core changes are either 1)
> unnecessary or 2) easily reviewable because of their limited impact to other
> areas.

I am not sure to follow on the core cleanup proposal, but open for
suggestions / ideas, please elaborate on this little further.

> With all that said, I too must voice my concerns with Rolands lack of activity.

> There have been some good discussions recently on re-architecting the device
> feature indicators which were spawned from my OPA MAD changes.

> Various alternatives have been submitted and discussed but Roland has not
> weighed in on which are acceptable.  This makes it difficult to determine what
> direction we should take.

Indeed. No maintainer voice makes it kind of impossible for
discussions to converge. What happens over the last years is that when
there's no easy consensus on matter Y, everyone stops breathing and
wait to see what happens on the rc1 night, b/c Roland doesn't spell
his view/preference (nor exposes his for-next branch till the last
minute, see now) many times it seems more as coin flipping.

> Also, recently I found out my repo for the 0-day build was no longer testing my
> branches because Rolands for-next branch was too old.  I see today that Roland
> has updated to 4.0 rc now.  Thank you.


I added Sagi, Haggai and Shachar from Mellanox. They are behind few of
the major core changes that went in -- Protection/Signature (Sagi),
ODP (all), so if you find some concrete example on why/how these
changes were not architectured well enough, they will be happy to
listen and  respond.

BTW - the Signature verbs are now on their way to new use case, namely
offloading CPU %% used today for CRC and such calculations in
Web2/Hadoop  applications.

Haggai/Shachar are in-charge on the changes for name-spaces to support
containers on which Sean isn't responding for few months.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

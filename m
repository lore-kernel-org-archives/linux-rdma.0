From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 7/8] IB/core: Advertise supported vector CALC
 capabilities
Date: Sun, 6 Mar 2016 11:45:52 +0200
Message-ID: <56DBFC50.6010206@dev.mellanox.co.il>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <1456215928-9305-8-git-send-email-leon@leon.nu>
 <20160223184400.GA27769@obsidianresearch.com>
 <56D71DEE.6070406@dev.mellanox.co.il>
 <20160302183847.GB7084@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302183847.GB7084-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

>> And I honestly don't understand the "one vendor" complaint. It's really
>> hard to make progress this way? Yes, one vendor introduces a feature,
>> it's always the case. Do we need to wait for others to do it too for it
>> to make upstream? If a feature is useful and exposed correctly there is
>> nothing stopping other vendors to do it too (given that the API is
>> not tied to a vendor implementation).
>
> I don't necessarily mean other vendors have to implement it, just sign
> off on it.
>
> We have the IBTA as a multi-vendor body that has historically defined
> the verbs API. It would be appropriate if verbs changes were ack'd by
> their SW-WG.

I think it did, I'll let Liran answer on that.

> The OFA has talked about a 'verbs working group' (what happened to
> that Liran?) that could also evolve into an appropriate place to get
> such a sign off. It may be a more inclusive/neutral place these days
> with so many non-IB verbs implementations.

I'll let Liran comment on this too, but I know for a fact that Liran is
setting these meetings on a weekly basis and the vast majority of the
features Mellanox send out are introduced there. I joined a few times
to talk about some of the kernel API changes we did lately and the
upcoming "erasure coding offload" feature in the storage space...

>> Generally speaking, I'm confident that all the smart people on
>> Linux-rdma can converge on suitable APIs that are actually useful,
>
> The thing is, I don't think the right people are necessarily reading
> this list. There are now many vendors of verbs hardware out there, do
> you really think posting to the list is enough to catch all of their
> attention?

Actually I disagree, our verbs API is evolving and I don't see a better
place to shape and build it other than Linux-rdma. A vendor that cares
about RDMA verbs API should listen to this list, participate in the
discussions (also the API related ones) and help in bug fixes and
maintenance. That's the best way vendors can promote their cause
(user-space or kernel).

> My concern is changes to verbs are very rarely a software only change
> - there is almost always a hardware component and within the industry
> cross-vendor hardware specifications are typically negotiated by trade
> associations not the Linux Kernel mailing list.

That's true, but almost all user-space management stuff are handled in
the kernel leaving user-space to either ask uverbs or the HW device
for a service.

Are you suggesting that new offload features that are proposed would
also introduce a SW implementation that can run on any device? That's
not a terrible idea, but it would be a lot of extra work and might
bloat our verbs library.

What do others think?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

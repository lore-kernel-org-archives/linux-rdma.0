From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/10] IB: remove the unused usecnt field from struct
 ib_mr
Date: Sun, 20 Dec 2015 13:42:30 +0200
Message-ID: <56769426.7010807@dev.mellanox.co.il>
References: <1450446906-10336-1-git-send-email-hch@lst.de>
 <1450446906-10336-11-git-send-email-hch@lst.de>
 <567657D1.5010700@mellanox.com> <5676756B.6090208@dev.mellanox.co.il>
 <56769223.7090308@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56769223.7090308-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> However, I think that the patch from Shani 6b52a12bc3fc ("IB/uverbs:
>> Implement memory windows support in uverbs") is wrong. A memory
>> window allocation should really reference the MR and not the PD (which
>> is referenced by the MR). Otherwise the MR deregistration is allowed
>> with windows bound to it. If this is the case then this field is not
>> useless and we should fix ib_uverbs_alloc_mw()?
>>
>> Haggai, can you shed some light here? It's Shani's and your code.
> A memory window takes reference on its PD during creation. It can only
> be used by that PD, and it isn't bound to any memory region yet.

Right! it's still not bound. I mixed up the details. Thanks for
reminding me.

> You are right that we want to prevent deregistration of an MR when there
> are memory windows bound to it. This is suggested (although not
> required) by the IBA specifications (section 10.6.7.2.6 Deregistering
> Regions with Bound Windows). The problem with the usecnt field in ib_mr
> as you wrote is that it needs to reflect what happens at bind /
> invalidate time, but bind can happen in user-space without the kernel
> knowing, and invalidation can similarly occur due to a
> send-with-invalidate message being received.

That's true. I didn't see user-space do that either but if it's not
required it's probably a good idea not to complicate things.

> This is why in the ConnectX-3 implementation of memory windows we didn't use the
> ib_mr.usecnt field, but relied on a hardware implementation of the
> reference count.
>
> As I said, the spec also allows a device to proceed with deregistering
> an MR, leaving an orphan memory window. I don't think we can prevent
> this in the kernel, and I'm not sure it would be a good idea anyway, so
> I think it is okay to remove the use_cnt field.

I completely agree. we don't have any way to maintain mw<->mr reference
so let's drop it.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

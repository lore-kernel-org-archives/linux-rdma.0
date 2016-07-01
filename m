From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Oops with mlx5/NFSoRDMA client with 4.7-rc5ish
Date: Thu, 30 Jun 2016 20:23:29 -0400
Message-ID: <7E3193AB-418F-4B03-AAD7-019D022C1FBE@oracle.com>
References: <730f57aa-b1f6-c6da-4936-bebba1954ca7@redhat.com> <94C521BC-7BB0-46B7-8597-F1BE10C8CB04@oracle.com> <2771797c-a7e5-61c6-4ad6-79322d04b5a5@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2771797c-a7e5-61c6-4ad6-79322d04b5a5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 30, 2016, at 6:11 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> On 6/30/2016 2:44 PM, Chuck Lever wrote:
>> 
>>> On Jun 30, 2016, at 2:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> 
>>> This could easily be an mlx5 issue given that it starts with a DMAR
>>> error, but I would also hope that NFSoRDMA can manage to survive the
>>> DMAR error.
>> 
>> I'm afraid I don't know what a DMAR error is.
> 
> When you have your IOMMU enabled (by default it isn't, and even if you
> have it enabled, if you are running as a bare metal install, it might
> not be used either if your default iommu setting is passthrough),
> attempts by the card to DMA to areas that are not currently mapped
> trigger DMA errors.  In this case DMAR is DMA Read.  It is usually a
> sign that something is wrong in the drivers memory registration
> routines, or that there is a race somewhere with the card.

Thanks, two questions:

1. Is the verbs consumer aware of DMAR errors?

2. I enabled my iommu and NFS/RDMA tests run OK.
   How do I ensure it's not passthrough?


> I copied you
> because it showed up in NFSoRDMA, but the DMAR error points it to being
> more likely an mlx5 issue.

That is also my expectation, but I'll try to be helpful
where I can. And also, the reply handler shouldn't oops.


>> Those are happening in the forward path (send) and the
>> GPF happens on receive. Can you give me an idea what
>> the source code looks like around
>> 
>>  rpcrdma_reply_handler+0x18e/0xce0 ?
> 
> I didn't have this kernel compiled with debug info, so that's a bitch to
> work out.  I'll rebuild, reinstall, and see if I get the oops again.
> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>    GPG Key ID: 0E572FDD
> 

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

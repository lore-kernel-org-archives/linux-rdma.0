From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 qp allocation
Date: Sat, 15 Feb 2014 00:07:25 +0530
Message-ID: <CANwwZzUiCPELWzxnwru5vsPqq9_VQCR88FVYQ+E83q-+ycUMYw@mail.gmail.com>
References: <CANwwZzUfoNB1pyyu8VC2Do3mvCBOmeam+_9CAEW-eQbVCMdHNQ@mail.gmail.com>
	<20140211133141.7d5f4929@jpm-OptiPlex-GX620>
	<CANwwZzUMPvvOEWN5xA+eOiT9uA4zOG+-cDhCks4Utv+8fqao9g@mail.gmail.com>
	<20140213153859.5c41f8ee@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213153859.5c41f8ee@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jack,

Thanks so much for clarifying my understanding!!

Best Regards,
Bob

On Thu, Feb 13, 2014 at 7:08 PM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Thu, 13 Feb 2014 00:18:22 +0530
> Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> The VFs need to allocate the memory for Send Queue Buffer, Receive
>> Queue Buffer, Completion Queue Buffer, Event Queue Buffer.
>>
>> Is that right?
>
> Yes.
>
>>
>> Also, as the QPs, CQs etc are created by the HCA when ALLOC_RES
>> command is issued, does the PF driver need to maintain anything to
>> associate the QPs, CQs created by the HCA with owners(VFs) possessing
>> them?
>
> Of course. These resources must be de-allocated if, for example, the
> VM running the VF crashes -- or we have a resource leak.
>
> This also is used for security checking, to make sure that a VF does
> not mess around with resources that do not "belong" to it.
>
> -Jack
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

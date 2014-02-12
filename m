From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 qp allocation
Date: Thu, 13 Feb 2014 00:18:22 +0530
Message-ID: <CANwwZzUMPvvOEWN5xA+eOiT9uA4zOG+-cDhCks4Utv+8fqao9g@mail.gmail.com>
References: <CANwwZzUfoNB1pyyu8VC2Do3mvCBOmeam+_9CAEW-eQbVCMdHNQ@mail.gmail.com>
	<20140211133141.7d5f4929@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211133141.7d5f4929@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jack,

Thanks for the reply. Now I understand. On a related note, I had the
following question. Would really appreciate if you can help answer the
same:

Considering the resources QPs, CQs, EQs etc after going through the
code my understanding is that:

1. Physical Function Driver/Hypervisor allocates memory only for the
ICM space for these resources.
2. Virtual Function Driver needs to allocate corresponding system
memory for the resources

For e.g let's say I need 32K QPs, 64K CQs, 512 EQs, the PF driver
allocates the memory only for the ICM.

The VFs need to allocate the memory for Send Queue Buffer, Receive
Queue Buffer, Completion Queue Buffer, Event Queue Buffer.

Is that right?

Also, as the QPs, CQs etc are created by the HCA when ALLOC_RES
command is issued, does the PF driver need to maintain anything to
associate the QPs, CQs created by the HCA with owners(VFs) possessing
them?

I would really appreciate your help!

Thanks so much..

Best Regards,
Bob


On Tue, Feb 11, 2014 at 5:01 PM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Wed, 29 Jan 2014 15:52:09 +0530
> Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> These paths are taken based on the return value of mlx4_is_func(dev).
>> This is true for MASTER or SLAVE which I believe is Physical Function
>> Driver/Virtual Function Driver. So for SRIOV, it covers all cases.
>>
>> The MAP_ICM portion which gets executed as part of __mlx4_qp_alloc_icm
>> never gets called??
>
> For slaves (VFs), the command is sent via the comm channel to the
> Hypervisor.  It is the Hypervisor which invokes map_icm on behalf of
> that slave.
>
> -Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

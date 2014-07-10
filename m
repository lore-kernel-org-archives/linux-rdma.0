From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4: using dma_sync_single_for_cpu/dma_sync_single_for_cpu for
 writing MTT instead of WRITE_MTT hcr command
Date: Thu, 10 Jul 2014 20:19:56 +0530
Message-ID: <CANwwZzV+q-QYEMNW62uW0PFHpTOhPmq4iKo1XuC7iqqWKsyWBA@mail.gmail.com>
References: <CANwwZzXShD8DvJb8vEeJrcwKeW4T0cx-zFdo1Mt1JftxCXtboA@mail.gmail.com>
	<20140710105517.544ff8c1@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710105517.544ff8c1@jpm-OptiPlex-GX620>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jack,

Thanks so much for the response.. This is really helpful!


Best Regards,
Marc

On Thu, Jul 10, 2014 at 1:25 PM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Wed, 9 Jul 2014 18:40:46 +0530
> Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi,
>>
>> I was going through the mr.c file as part of understanding WRITE_MTT
>> command in the mlx4 code.
>>
>> I could see that instead of issuing the WRITE_MTT HCR command, in case
>> of SRIOV, we're directly accessing the ICM space for the MTT Table,
>> taking the ownership and updating it. We're doing this using
>> dma_sync_single_for_cpu and dma_sync_single_for_cpu.
>>
>> I was curious as to why this approach was chosen instead of using the
>> HCR command.
>>
>> Can anyone please explain the reason/motivation behind this approach?
>>
> Performance. Direct write to memory is much faster than via HCR
>
> -Jack
>
>>
>>
>> Thanks so much,
>>
>>
>> Best Regards,
>> Marc
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

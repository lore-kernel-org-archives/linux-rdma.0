From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB: Introduce Work Queue object and its
 verbs
Date: Sun, 18 Oct 2015 18:13:03 +0300
Message-ID: <5623B6FF.6020106@dev.mellanox.co.il>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
 <1444893410-13242-3-git-send-email-yishaih@mellanox.com>
 <561F68D0.4050205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561F68D0.4050205-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/15/2015 11:50 AM, Sagi Grimberg wrote:
> Hi Yishai,
>
>> +/**
>> + * ib_create_wq - Creates a WQ associated with the specified protection
>> + * domain.
>> + * @pd: The protection domain associated with the WQ.
>> + * @wq_init_attr: A list of initial attributes required to create the
>> + * WQ. If WQ creation succeeds, then the attributes are updated to
>> + * the actual capabilities of the created WQ.
>> + *
>> + * wq_init_attr->max_wr and wq_init_attr->max_sge determine
>> + * the requested size of the WQ, and set to the actual values allocated
>> + * on return.
>> + * If ib_create_wq() succeeds, then max_wr and max_sge will always be
>> + * at least as large as the requested values.
>> + *
>> + * Return Value
>> + * ib_create_wq() returns a pointer to the created WQ, or NULL if the
>> request
>> + * fails.
>> + */
>> +struct ib_wq *ib_create_wq(struct ib_pd *pd,
>> +               struct ib_wq_init_attr *init_attr);
>> +
>
> We started shifting function documentations from the header declarations
> to the *.c implmentations. Would you mind moving it too?

OK, will move as part of V1 to be in the C file.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

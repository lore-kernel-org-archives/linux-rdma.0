From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 01/10] IB/core: Introduce protected memory regions
Date: Sun, 3 Nov 2013 14:14:43 +0200
Message-ID: <52763E33.8060505@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-2-git-send-email-sagig@mellanox.com> <5273E03C.3010501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5273E03C.3010501-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/1/2013 7:09 PM, Bart Van Assche wrote:
> On 31/10/2013 5:24, Sagi Grimberg wrote:
>> +/**
>> + * ib_mr_init_attr - Memory region init attributes passed to routine
>> + *    ib_create_mr.
>> + * @max_reg_descriptors: max number of registration units that
>> + *   may be used with UMR work requests.
>> + * @flags: MR creation flags bit mask.
>> + */
>> +struct ib_mr_init_attr {
>> +    int        max_reg_descriptors;
>> +    int        flags;
>> +};
>
> Is this the first patch that add the abbreviation "UMR" to a header 
> file in include/rdma ? If so, I think it's a good idea not only to 
> mention the abbreviation but also what UMR stands for.
>
> Bart.
>

You are correct,
I prefer to remove this abbreviation UMR as it is not tightly related to 
signature.

The the max_reg_descriptors parameter is the equivalent to 
max_page_list_len of ib_alloc_fast_reg_mr().
The difference is that this memory region can also register indirect 
memory descriptors {key, addr, len} rather than u64 physical addresses.
For example signature enabled memory region may register 2 descriptors: 
data and protection.

I'll modify the explanation here in v3.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

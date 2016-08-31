From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/7] Introduce Work Queue object and its verbs
Date: Wed, 31 Aug 2016 10:22:54 +0300
Message-ID: <a96c9044-645c-1839-3add-159c74fe566f@dev.mellanox.co.il>
References: <1472569796-26162-1-git-send-email-yishaih@mellanox.com>
 <1472569796-26162-2-git-send-email-yishaih@mellanox.com>
 <778f70c0-d5e8-030f-8e47-3d16772e2faf@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <778f70c0-d5e8-030f-8e47-3d16772e2faf-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/31/2016 9:57 AM, Sagi Grimberg wrote:
>
>> +/*
>> + * Work Queue. QP can be created without internal WQs "packaged"
>> inside it,
>> + * this QP can be configured to use "external" WQ object as its
>> + * receive/send queue.
>> + * WQ associated (many to one) with Completion Queue it owns WQ
>> properties
>> + * (PD, WQ size etc).
>> + * WQ of type IBV_WQT_RQ:
>> + * - Contains receive WQEs, in this case its PD serves as scatter as
>> well.
>> + * - Exposes post receive function to be used to post a list of work
>> + *   requests (WRs) to its receive queue.
>> + */
>> +struct ibv_wq {
>> +    struct ibv_context     *context;
>> +    void               *wq_context;
>> +    struct    ibv_pd           *pd;
>> +    struct    ibv_cq           *cq;
>> +    uint32_t        wq_num;
>> +    uint32_t        handle;
>> +    enum ibv_wq_state       state;
>> +    enum ibv_wq_type    wq_type;
>> +    int (*post_recv)(struct ibv_wq *current,
>> +             struct ibv_recv_wr *recv_wr,
>> +             struct ibv_recv_wr **bad_recv_wr);
>
> What was the reason not to go with the normal ibv_context_ops callout
> scheme?
>

This is a data path flow, using the extended ops layout (i.e 
verbs_get_ctx) to find the provider pointer in each call is redundant 
and expensive. Same mechanism was used for ibv_cq_ex which was the first 
extended object that was used in the data path. Please note that from 
application point of view there is the static inline function 
ibv_post_wq_recv that should be used, so its code will be consistent 
with other verbs around. (See also ibv_start_poll, ibv_next_poll usage 
for ibv_cq_ex)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

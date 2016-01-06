From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 10/15] IB/srpt: Fix srpt_handle_cmd() error paths
Date: Wed, 6 Jan 2016 15:36:42 +0100
Message-ID: <568D267A.9@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD249.1000100@sandisk.com>
 <568D2553.8050302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568D2553.8050302-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/06/2016 03:31 PM, Sagi Grimberg wrote:
> On 05/01/2016 16:25, Bart Van Assche wrote:
>> @@ -1518,8 +1517,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
>>       if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
>>           pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>>                  srp_cmd->tag);
>> -        ret = TCM_INVALID_CDB_FIELD;
>> -        goto send_sense;
>> +        goto put;
>
> Do you still need to call target_put_sess_cmd() in this failure?

Good catch. I will update this patch before I repost this patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

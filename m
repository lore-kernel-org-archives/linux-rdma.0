From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Sat, 22 Aug 2015 06:38:47 +0000
Message-ID: <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-2-git-send-email-hch@lst.de>,<55D59553.4080306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D59553.4080306-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday, August 20, 2015 11:52 AM, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> on behalf of Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 8/19/2015 7:37 PM, Christoph Hellwig wrote:
>> We have many WR opcodes that are only supported in kernel space
>> and/or require optional information to be copied into the WR
>> structure.  Reject all those not explicitly handled so that we
>> can't pass invalid information to drivers.
>>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> ---
>>   drivers/infiniband/core/uverbs_cmd.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
>> index a15318a..f9f3921 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -2372,6 +2372,12 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
>>               next->send_flags = user_wr->send_flags;
>>
>>               if (is_ud) {
>> +                     if (next->opcode != IB_WR_SEND &&
>> +                         next->opcode != IB_WR_SEND_WITH_IMM) {
>> +                             ret = -EINVAL;
>> +                             goto out_put;
>> +                     }
>> +
>>                       next->wr.ud.ah = idr_read_ah(user_wr->wr.ud.ah,
>>                                                    file->ucontext);
>>                       if (!next->wr.ud.ah) {
>> @@ -2413,7 +2419,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
>>                               next->wr.atomic.rkey = user_wr->wr.atomic.rkey;
>>                               break;
>>                       default:
>> -                             break;
>> +                             ret = -EINVAL;
>> +                             goto out_put;
>>                       }
>>               }
>>
>>
> 
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Haggai, can you also have a look?

It looks like the default case in the non-UD branch is currently used to handle plain IB_WR_SEND operations, so the patch would cause these to return an error.

Haggai--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

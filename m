From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srpt: allocate ib_qp_attr on the stack
Date: Wed, 28 Dec 2016 13:38:06 +0200
Message-ID: <68100bd6-3194-efa2-1f48-38c2c73cc52d@mellanox.com>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
 <1482922813-8392-3-git-send-email-maxg@mellanox.com>
 <20161228110613.GA4735@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228110613.GA4735@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/28/2016 1:06 PM, Yuval Shaia wrote:
> One minor comment in line but w/ or w/o it:
>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> On Wed, Dec 28, 2016 at 01:00:12PM +0200, Max Gurtovoy wrote:
>> No reason to allocate it dynamically.
>>
>> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/ulp/srpt/ib_srpt.c |   18 +++++++-----------
>>  1 files changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> index 0b1f69e..aa18d74 100644
>> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
>> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> @@ -984,24 +984,20 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
>>   */
>>  static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
>>  {
>> -	struct ib_qp_attr *attr;
>> +	struct ib_qp_attr attr;
>>  	int ret;
>>
>> -	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
>> -	if (!attr)
>> -		return -ENOMEM;
>> -
>> -	attr->qp_state = IB_QPS_INIT;
>> -	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
>> +	memset(&attr, 0, sizeof(attr));
>> +	attr.qp_state = IB_QPS_INIT;
>> +	attr.qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
>>  	    IB_ACCESS_REMOTE_WRITE;
>> -	attr->port_num = ch->sport->port;
>> -	attr->pkey_index = 0;
>> +	attr.port_num = ch->sport->port;
>> +	attr.pkey_index = 0;
>
> Correct me if i'm wrong but this looks like redundant since we zeroed the
> entire attr object few lines ago.
>

Yes this is redundant but I think it's implies the flags you'll pass 
ib_modify_qp. don't realy mind,

Bart, your call :)

>>
>> -	ret = ib_modify_qp(qp, attr,
>> +	ret = ib_modify_qp(qp, &attr,
>>  			   IB_QP_STATE | IB_QP_ACCESS_FLAGS | IB_QP_PORT |
>>  			   IB_QP_PKEY_INDEX);
>>
>> -	kfree(attr);
>>  	return ret;
>>  }
>>
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Fix the endian problem for hns
Date: Thu, 1 Feb 2018 16:14:34 +0800
Message-ID: <3f40f133-602b-14f5-bd91-526f845d4170@huawei.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
 <1517314845-126094-2-git-send-email-oulijun@huawei.com>
 <1517413485.19117.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517413485.19117.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2018/1/31 23:44, Doug Ledford 写道:
> On Tue, 2018-01-30 at 20:20 +0800, Lijun Ou wrote:
>> The hip06 and hip08 run on a little endian ARM, it needs to
>> revise the annotations to indicate that the HW uses little
>> endian data in the various DMA buffers, and flow the necessary
>> swaps throughout.
>>
>> The imm_data use big endian mode. The cpu_to_le32/le32_to_cpu
>> swaps are no-op for this, which makes the only substantive
>> change the handling of imm_data which is now mandatory swapped.
>>
>> This also keep match with the userspace hns driver and resolve
>> the warning by sparse.
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_common.h |   6 +-
>>  drivers/infiniband/hw/hns/hns_roce_device.h |   2 +-
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  57 ++++--
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  | 258 ++++++++++++-------------
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  51 +++--
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 283 ++++++++++++++--------------
>>  drivers/infiniband/hw/hns/hns_roce_main.c   |   2 +-
>>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 +-
>>  8 files changed, 357 insertions(+), 320 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_common.h b/drivers/infiniband/hw/hns/hns_roce_common.h
>> index dd67faf..319cb74 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_common.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_common.h
>> @@ -43,15 +43,15 @@
>>  	__raw_writel((__force u32)cpu_to_le32(value), (addr))
>>  
>>  #define roce_get_field(origin, mask, shift) \
>> -	(((origin) & (mask)) >> (shift))
>> +	(((le32_to_cpu(origin)) & (mask)) >> (shift))
>>  
>>  #define roce_get_bit(origin, shift) \
>>  	roce_get_field((origin), (1ul << (shift)), (shift))
>>  
>>  #define roce_set_field(origin, mask, shift, val) \
>>  	do { \
>> -		(origin) &= (~(mask)); \
>> -		(origin) |= (((u32)(val) << (shift)) & (mask)); \
>> +		(origin) &= ~cpu_to_le32(mask); \
>> +		(origin) |= cpu_to_le32(((u32)(val) << (shift)) & (mask)); \
>>  	} while (0)
>>  
>>  #define roce_set_bit(origin, shift, val) \
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 42c3b5a..2503d7f 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -466,7 +466,7 @@ struct hns_roce_qp {
>>  	struct ib_qp		ibqp;
>>  	struct hns_roce_buf	hr_buf;
>>  	struct hns_roce_wq	rq;
>> -	__le64			doorbell_qpn;
>> +	u32			doorbell_qpn;
> 
> Why the change in size here?  Did you mean to go from 64bits down to
> 32bits?
> 
Maybe the 64bit is wasted after anlaysis. because the qpn of qpc and wqe are 24bit. the max value of qpn
is 2 ^ 24 - 1 and the 32bit is enough.
>>
>>  		} else if (ibqp->qp_type == IB_QPT_RC) {
>>  			ctrl = wqe;
>>  			memset(ctrl, 0, sizeof(struct hns_roce_wqe_ctrl_seg));
>>  			for (i = 0; i < wr->num_sge; i++)
>> -				ctrl->msg_length += wr->sg_list[i].length;
>> +				ctrl->msg_length =
>> +				     cpu_to_le32(le32_to_cpu(ctrl->msg_length) +
>> +				     wr->sg_list[i].length);
> 
> Minor nit:
> 
> Doing le32_to_cpu and cpu_to_le32 over and over again in a loop is
> horribly inefficient.  It would be much better IMO if you had a local
> variable to use for the length, used that in the loop, and then only at
> the end of the loop do a single cpu_to_le32 of the local variable to
> store in msg_length.  Same comment applies to the other spot in this
> patch that does the same loop.
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

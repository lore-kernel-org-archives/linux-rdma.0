From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/4] RDMA/hns: Support rq record doorbell for
 the user space
Date: Sun, 11 Feb 2018 13:44:58 +0800
Message-ID: <cf70c781-bab1-ae9a-86fa-873a8265214d@huawei.com>
References: <1518176700-126906-1-git-send-email-liuyixian@huawei.com>
 <1518176700-126906-2-git-send-email-liuyixian@huawei.com>
 <20180209152353.GC7570@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209152353.GC7570-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/2/9 23:23, Jason Gunthorpe wrote:
> On Fri, Feb 09, 2018 at 07:44:57PM +0800, Yixian Liu wrote:
> 
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
>> index 42c3b5a..2da30fc 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
>> @@ -105,6 +105,10 @@
>>  #define PAGES_SHIFT_24				24
>>  #define PAGES_SHIFT_32				32
>>  
>> +enum {
>> +	HNS_ROCE_SUPPORT_RQ_RECORD_DB = BIT(0),
>> +};
> 
> This belongs in the uapi header same remark in userspace. Dont' use
> BIT in uapi headers.
> 
> Same remark for the other cap_flags in other patches
> 
>> diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
>> index 5d74019..1b05d00 100644
>> +++ b/include/uapi/rdma/hns-abi.h
>> @@ -48,6 +48,10 @@ struct hns_roce_ib_create_qp {
>>  	__u8    reserved[5];
>>  };
>>  
>> +struct hns_roce_ib_create_qp_resp {
>> +	__u32	cap_flags;
>> +};
>> +
>>  struct hns_roce_ib_alloc_ucontext_resp {
>>  	__u32	qp_tab_size;
>>  };
> 
> All structures in this file need to be aligned to 64 bits, add the
> implicit padding necessary.
> 
> Jasn
> 
Thanks! I will fix these problems.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Wei Hu (Xavier)" <xavier.huwei-WVlzvzqoTvw@public.gmane.org>
Subject: Re: [PATCH for-next 8/9] RDMA/hns: Remove unused struct members in
 hns-abi.h
Date: Fri, 29 Sep 2017 00:12:57 +0800
Message-ID: <3bdd5f2d-d42a-5d54-41a3-a01abecb7a10@tom.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
 <1506574654-56699-9-git-send-email-xavier.huwei@huawei.com>
 <20170928090203.GS2297@mtr-leonro.local> <59CCE378.6070209@huawei.com>
 <20170928130437.GV2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928130437.GV2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/9/28 21:04, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 07:56:40PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2017/9/28 17:02, Leon Romanovsky wrote:
>>> On Thu, Sep 28, 2017 at 12:57:33PM +0800, Wei Hu (Xavier) wrote:
>>>> From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> This patch mainly deletes some unused struct members for
>>>> hns_roce_ib_create_qp in order to match libhns, because
>>>> the num of struct members of hns_roce_ib_create_qp must
>>>> be the same with hns_roce_create_qp in libhns.
>>>>
>>>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    include/uapi/rdma/hns-abi.h | 2 --
>>>>    1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
>>>> index 5d74019..79251b6 100644
>>>> --- a/include/uapi/rdma/hns-abi.h
>>>> +++ b/include/uapi/rdma/hns-abi.h
>>>> @@ -41,10 +41,8 @@ struct hns_roce_ib_create_cq {
>>>>
>>>>    struct hns_roce_ib_create_qp {
>>>>    	__u64	buf_addr;
>>>> -	__u64   db_addr;
>>>>    	__u8    log_sq_bb_count;
>>>>    	__u8    log_sq_stride;
>>>> -	__u8    sq_no_prefetch;
>>>>    	__u8    reserved[5];
>>>>    };
>>> It is classical UAPI breakage which kernel tries to avoid.
>>>
>>> In RDMA, we do allow rename of fields from reserved to something, but
>>> don't allow binary layout change.
>>>
>>> NAK to this change.
>>>
>>> Thanks
>> Hi, Leon
>>      Now there is an inconsistency between hns_roce_ib_create_qp in kernel
>> driver and hns_roce_create_qp  in libhns as below:
>>
>> struct hns_roce_create_qp {
>>      struct ibv_create_qp        ibv_cmd;
>>      __u64                buf_addr;
>>      __u8                log_sq_bb_count;
>>      __u8                log_sq_stride;
>>      __u8                reserved[5];
>> };
>>      It is better to modify hns_roce_create_qp in libhns, right?
> Yes, it can work, because it is user space problem, where you used wrong
> structure.
>
> Thanks
Thanks, Leon
I will pull it out off this series in patch v2.
>>      Thanks
>>
>>      Regards
>> Wei Hu
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

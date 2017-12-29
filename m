From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next 6/6] RDMA/hns: Assign dest_qp when
 deregistering mr
Date: Fri, 29 Dec 2017 09:01:05 +0800
Message-ID: <7507a107-8486-0a22-1af7-b7397572c09f@huawei.com>
References: <1514287514-88723-1-git-send-email-oulijun@huawei.com>
 <1514287514-88723-7-git-send-email-oulijun@huawei.com>
 <20171228213227.GA14821@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228213227.GA14821-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/12/29 5:32, Jason Gunthorpe Ð´µÀ:
> On Tue, Dec 26, 2017 at 07:25:14PM +0800, Lijun Ou wrote:
>> It needs to create eight reserve QPs for resolving
>> a bug of hip06. When deregistering mr, it will issue
>> a rdma write for every reserve QPs.
>>
>> In the above process, it needs to assign dest_qp.
>> Otherwise, it will trigger free mr work fail.
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> index 6100ace..490a1fc 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> @@ -775,6 +775,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
>>  			goto create_lp_qp_failed;
>>  		}
>>  
>> +		attr_mask |= IB_QP_DEST_QPN;
> 
> This seems really weird, several other values of attr are set without a
> corresponding attr_mask bit.
> 
> Jason
Yes, Maybe other fileds which need to attr_mask bit need to work in this scene.
Are you?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

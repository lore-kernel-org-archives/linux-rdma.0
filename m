From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/6] RDMA/hns: Add rq inline data support for
 hip08 RoCE
Date: Fri, 29 Dec 2017 09:45:09 +0800
Message-ID: <df6ca4aa-bbde-cae7-a3cb-f469124f3490@huawei.com>
References: <1514287514-88723-1-git-send-email-oulijun@huawei.com>
 <1514287514-88723-2-git-send-email-oulijun@huawei.com>
 <20171228212217.GA14490@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228212217.GA14490-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/12/29 5:22, Jason Gunthorpe Ð´µÀ:
> On Tue, Dec 26, 2017 at 07:25:09PM +0800, Lijun Ou wrote:
> 
>> +	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
>> +		if (hr_qp->rq_inl_buf.wqe_list) {
>> +			kfree(hr_qp->rq_inl_buf.wqe_list[0].sg_list);
>> +			kfree(hr_qp->rq_inl_buf.wqe_list);
>> +			hr_qp->rq_inl_buf.wqe_list[0].sg_list = NULL;
> 
> You didn't fix this use after free that Leon commented on.
> 
> nulling something that is contained in something you are about to
> free is not at all useful.
> 
> Jason
> 
> 
Thanks. it may be a odd thing that I have modified it. I will check it and
fix it.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

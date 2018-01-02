From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/6] RDMA/hns: Add rq inline data support for
 hip08 RoCE
Date: Tue, 2 Jan 2018 20:20:54 +0800
Message-ID: <c2ab0660-07c4-19f8-0228-58642769fce3@huawei.com>
References: <1514540341-115107-1-git-send-email-oulijun@huawei.com>
 <1514540341-115107-2-git-send-email-oulijun@huawei.com>
 <20171229181843.GF6513@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171229181843.GF6513-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/12/30 2:18, Jason Gunthorpe Ð´µÀ:
> On Fri, Dec 29, 2017 at 05:38:56PM +0800, Lijun Ou wrote:
>> +		hr_qp->rq_inl_buf.wqe_list = kcalloc(1, hr_qp->rq.wqe_cnt *
>> +					       sizeof(struct hns_roce_rinl_wqe),
>> +					       GFP_KERNEL);
> 
> This is complete mis-use of the 2d allocator functions. It needs to
> be:
> 
> 	hr_qp->rq_inl_buf.wqe_list = kcalloc(hr_qp->rq.wqe_cnt,
> 					       sizeof(struct hns_roce_rinl_wqe),
> 					       GFP_KERNEL);
> 
> It is important that the first argument be the 'untrsuted' value so
> the multiply overflow checking works properly.
> 
Thanks
>> +		/* Firstly, allocate a list of sge space buffer */
>> +		hr_qp->rq_inl_buf.wqe_list[0].sg_list =
>> +					kcalloc(1, hr_qp->rq_inl_buf.wqe_cnt *
>> +					       init_attr->cap.max_recv_sge *
>> +					       sizeof(struct hns_roce_rinl_sge),
>> +					       GFP_KERNEL);
> 
> ditto
> 
> Jason
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

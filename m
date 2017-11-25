From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Add rereg mr interface in userspace
Date: Sat, 25 Nov 2017 09:23:14 +0800
Message-ID: <fb9f06ae-ae6a-14f2-6113-a15d6fdf37e9@huawei.com>
References: <1511266846-137693-1-git-send-email-oulijun@huawei.com>
 <20171121135310.GV18825@mtr-leonro.local>
 <facbc654-30ad-1bb7-f066-6dff2d5deaca@huawei.com>
 <20171124160347.GA3552@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171124160347.GA3552-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/11/25 0:03, Jason Gunthorpe Ð´µÀ:
> On Fri, Nov 24, 2017 at 04:38:28PM +0800, oulijun wrote:
> 
>>>> +int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
>>>> +			void *addr, size_t length, int access)
>>>> +{
>>>> +	struct ibv_rereg_mr cmd;
>>>> +	struct ibv_rereg_mr_resp resp;
>>>> +
>>>> +	if (flags & IBV_REREG_MR_KEEP_VALID)
>>>> +		return ENOTSUP;
>>>
>>> You need to write the supported flags here, so the people will
>>> be able to extend ibv_rereg_mr_flags without worries about your driver.
>>>
>>> Thanks
>> I think that it maybe not write. if the hw is not supported, the user will
>> not call ibv_rereg_mr and don't configure flags for IBV_REREG_MR_KEEP_VALID
>> besides, the kernel will check the flags.
> 
> Since the kernel checks it just get rid of the if statement.
> 
> Jason
> 
Thanks. it may be more simple.

Lijun Ou
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

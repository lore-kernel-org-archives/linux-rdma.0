From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Add rereg mr interface in userspace
Date: Fri, 24 Nov 2017 16:38:28 +0800
Message-ID: <facbc654-30ad-1bb7-f066-6dff2d5deaca@huawei.com>
References: <1511266846-137693-1-git-send-email-oulijun@huawei.com>
 <20171121135310.GV18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121135310.GV18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2017/11/21 21:53, Leon Romanovsky 写道:
> On Tue, Nov 21, 2017 at 08:20:46PM +0800, Lijun Ou wrote:
>> This patch adds the rereg mr verbs in userspace.
>>
>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  providers/hns/hns_roce_u.c       |  1 +
>>  providers/hns/hns_roce_u.h       |  2 ++
>>  providers/hns/hns_roce_u_verbs.c | 14 ++++++++++++++
>>  3 files changed, 17 insertions(+)
>>
>> diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
>> index ababd9c..9b5de44 100644
>> --- a/providers/hns/hns_roce_u.c
>> +++ b/providers/hns/hns_roce_u.c
>> @@ -118,6 +118,7 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
>>  	context->ibv_ctx.ops.alloc_pd	   = hns_roce_u_alloc_pd;
>>  	context->ibv_ctx.ops.dealloc_pd    = hns_roce_u_free_pd;
>>  	context->ibv_ctx.ops.reg_mr	   = hns_roce_u_reg_mr;
>> +	context->ibv_ctx.ops.rereg_mr	   = hns_roce_u_rereg_mr;
>>  	context->ibv_ctx.ops.dereg_mr	   = hns_roce_u_dereg_mr;
>>
>>  	context->ibv_ctx.ops.create_cq     = hns_roce_u_create_cq;
>> diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
>> index 0e98f22..2f4f3dc 100644
>> --- a/providers/hns/hns_roce_u.h
>> +++ b/providers/hns/hns_roce_u.h
>> @@ -254,6 +254,8 @@ int hns_roce_u_free_pd(struct ibv_pd *pd);
>>
>>  struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
>>  				 int access);
>> +int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
>> +			void *addr, size_t length, int access);
>>  int hns_roce_u_dereg_mr(struct ibv_mr *mr);
>>
>>  struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
>> diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
>> index d0ab10a..4fa188f 100644
>> --- a/providers/hns/hns_roce_u_verbs.c
>> +++ b/providers/hns/hns_roce_u_verbs.c
>> @@ -150,6 +150,20 @@ struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
>>  	return mr;
>>  }
>>
>> +int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
>> +			void *addr, size_t length, int access)
>> +{
>> +	struct ibv_rereg_mr cmd;
>> +	struct ibv_rereg_mr_resp resp;
>> +
>> +	if (flags & IBV_REREG_MR_KEEP_VALID)
>> +		return ENOTSUP;
> 
> You need to write the supported flags here, so the people will
> be able to extend ibv_rereg_mr_flags without worries about your driver.
> 
> Thanks
I think that it maybe not write. if the hw is not supported, the user will
not call ibv_rereg_mr and don't configure flags for IBV_REREG_MR_KEEP_VALID
besides, the kernel will check the flags.
> 
>> +
>> +	return ibv_cmd_rereg_mr(mr, flags, addr, length, (uintptr_t)addr,
>> +				access, pd, &cmd, sizeof(cmd), &resp,
>> +				sizeof(resp));
>> +}
>> +
>>  int hns_roce_u_dereg_mr(struct ibv_mr *mr)
>>  {
>>  	int ret;
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

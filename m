From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 3/7] libhns: Add verbs of pd and mr support
Date: Wed, 9 Nov 2016 16:01:44 +0800
Message-ID: <5822D7E8.6010202@huawei.com>
References: <1477731826-10787-1-git-send-email-oulijun@huawei.com>
 <1477731826-10787-4-git-send-email-oulijun@huawei.com>
 <20161109073426.GL27883@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109073426.GL27883-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/11/9 15:34, Leon Romanovsky 写道:
> On Sat, Oct 29, 2016 at 05:03:42PM +0800, Lijun Ou wrote:
>> This patch mainly introduces the verbs with pd and mr,
>> included alloc_pd, dealloc_pd, reg_mr and dereg_mr.
>>
>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>> v2:
>> - No change over v1
>>
>> v1:
>> - The initial submit
>> ---
>>  providers/hns/hns_roce_u.c       |  4 ++
>>  providers/hns/hns_roce_u.h       | 18 +++++++++
>>  providers/hns/hns_roce_u_abi.h   |  6 +++
>>  providers/hns/hns_roce_u_verbs.c | 79 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 107 insertions(+)
> 
> <....>
> 
>> +struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
>> +				 int access)
>> +{
>> +	int ret;
>> +	struct ibv_mr *mr;
>> +	struct ibv_reg_mr cmd;
>> +	struct ibv_reg_mr_resp resp;
>> +
>> +	if (addr == NULL) {
> 
> It can be great if you use one style for all your code e.g. if(!addr) ....
> 
ok, thanks your advice and i will consider to fix it.
>> +		fprintf(stderr, "2nd parm addr is NULL!\n");
>> +		return NULL;
>> +	}
>> +
>> +	if (length == 0) {
>> +		fprintf(stderr, "3st parm length is 0!\n");
>> +		return NULL;
>> +	}
>> +
>> +	mr = malloc(sizeof(*mr));
>> +	if (mr)
>> +		return NULL;
> 
> It looks like bug and you wanted if(!mr) and not if(mr).
> 
Yes, This is my careless for generating patch. my local server's code is if(!mr)
I will fix it.

Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

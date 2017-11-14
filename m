From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 4/5] mlx5: Add support for ibv_parent domain
 and its related verbs
Date: Tue, 14 Nov 2017 12:29:14 +0200
Message-ID: <4232d248-8fb3-1d64-e117-6034d9240a05@dev.mellanox.co.il>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-5-git-send-email-yishaih@mellanox.com>
 <20171113200320.GE22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113200320.GE22610-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2017 10:03 PM, Jason Gunthorpe wrote:
> On Sun, Nov 12, 2017 at 11:41:42PM +0200, Yishai Hadas wrote:
> 
>> @@ -319,6 +319,9 @@ struct mlx5_buf {
>>   struct mlx5_pd {
>>   	struct ibv_pd			ibv_pd;
>>   	uint32_t			pdn;
>> +	int 				is_parent_domain;
>> +	struct ibv_td			*td;
>> +	struct ibv_pd			*protection_domain;
> 
> is_parent_domain can just be protection_domain != NULL

It's not enough, there might be cases that protection_domain is NULL but 
still the object is a parent domain as of in the CQ case where td may be 
applicable but not the protection_domain. Better having here clear 
indication which is set upon the creation API rather than some semantic.

>> +struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
>> +			struct ibv_parent_domain_init_attr *attr)
>> +{
>> +	struct mlx5_pd	*pd;
>> +
>> +	pd = calloc(1, sizeof *pd);
>> +	if (!pd)
>> +		return NULL;
>> +
>> +	pd->is_parent_domain = 1;
>> +	pd->td = attr->td;
>> +	pd->protection_domain= attr->pd;
> 
> Don't we need some kind of ref counting here?
> 

We thought about it as well, however reference counting can't prevent 
race conditions when more than one thread uses the API.
We expect the application to work as the API is documented. (e.g. 
dealloc_parent_domain() first and then its internal protection domain 
and thread domain.

Similar behavior exists also in current code which puts the 
responsibility on the application to correctly use the API instead of 
using some reference counting /locks inside the libraries.

For example if one thread is calling alloc_pd() and then create_qp() and 
second thread will call in parallel to dealloc_pd() and it will run 
before the create_qp() will ended the application might oops in the user 
area when ibv_pd will be used post its free as part of the command.

> What is the intention for the final version of this patch?

The next patch of this RFC around QP creation introduces the expected usage.

Look at:
static void mlx5_get_domains(struct ibv_pd *pd, struct ibv_pd
                             **protection_domain, struct ibv_td **td)

It gets an ibv_pd and returns both the protection domain and the thread 
domain. This helper function will be used in other mlx5 verbs around 
that gets an ibv_pd. In the final series there may be a separate patch 
for that post this patch that introduces the parent domain.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

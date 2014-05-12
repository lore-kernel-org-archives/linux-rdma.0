From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Mon, 12 May 2014 15:22:10 +0300
Message-ID: <5370BCF2.7050107@mellanox.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com> <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com> <20140508190951.GB25849@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140508190951.GB25849-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/5/2014 10:09 PM, Jason Gunthorpe wrote:
> On Thu, May 08, 2014 at 09:51:23AM +0300, Or Gerlitz wrote:
>
>> +struct ibv_port_attr_ex {
>> +	union {
>> +		struct {
>> +			enum ibv_port_state	state;
>> +			enum ibv_mtu		max_mtu;
>> +			enum ibv_mtu		active_mtu;
>> +			int			gid_tbl_len;
>> +			uint32_t		port_cap_flags;
>> +			uint32_t		max_msg_sz;
>> +			uint32_t		bad_pkey_cntr;
>> +			uint32_t		qkey_viol_cntr;
>> +			uint16_t		pkey_tbl_len;
>> +			uint16_t		lid;
>> +			uint16_t		sm_lid;
>> +			uint8_t			lmc;
>> +			uint8_t			max_vl_num;
>> +			uint8_t			sm_sl;
>> +			uint8_t			subnet_timeout;
>> +			uint8_t			init_type_reply;
>> +			uint8_t			active_width;
>> +			uint8_t			active_speed;
>> +			uint8_t			phys_state;
>> +			uint8_t			link_layer;
>> +			uint8_t			reserved;
>> +		};
>> +		struct ibv_port_attr		port_attr;
>> +	};
>> +	uint32_t		comp_mask;
>> +	uint32_t		mask1;
>> +};
>
> I really don't like this deviation from the standard _ex
> pattern.
>
> Anonymous struct/union is a C11 feature and GNU extension. I don't
> think is appropriate for a user library to rely on. We cannot assume
> the user is has a compiler in C11 mode.
>
> The cannonical layout should be:
>
> struct ibv_port_attr_ex {
>     uint64_t comp_mask;
>     struct ibv_port_attr	port_attr;
>     // New stuff goes here
> }
>

It's not mandatory, but I think it could prevent future breakages and 
inconsistencies. Anyway, anonymous unions are supported in icc 9.2+, 
clang 3.1+ and of course gcc. However, I'll remove this in the next 
version of this series.

> It is fine to use comp_mask to indicate all the fields, no need for
> the weird mask1, lets not over complicate things for users.

I don't think that's the right thing to do. According to my 
understanding, the prefix of the extension verb is fully compatible with 
the old structure. Afterwards, comp_mask has a bit for every new field. 
mask1 is a new field that indicates which of the "old" values the user 
is interested in. If we want to be strict with the extension verbs 
definition, lets keep it all the way.

>
>>   struct verbs_context {
>>   	/*  "grows up" - new fields go here */
>> +	int (*drv_query_port_ex)(struct ibv_context *context, uint8_t port_num,
>> +				 struct ibv_port_attr_ex *port_attr);
>> +	int (*lib_query_port_ex)(struct ibv_context *context, uint8_t port_num,
>> +				  struct ibv_port_attr_ex *port_attr);
>>   	struct ibv_ah * (*drv_ibv_create_ah_ex)(struct ibv_pd *pd,
>>   						struct ibv_ah_attr_ex *attr);
>>   	int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
>
> I'm not sure what Roland decided to merge, but I am surprised to see
> drv_ elements here. That was nix'd in the round of review of the first
> patch set. eg create_qp_ex/etc don't have them.
>
> The flow is such that the verbs code has a chance to capture and
> override the function pointer after the driver sets it, there is no
> purpose to the drv_ values.
>
> I wouldn't like to see more added, and I think you should make a patch
> to ensure they are not necessary before it propogates too far.
>

I'll remove the drv_query_port_ex function and rename  lib_query_port_ex 
to query_port_ex and drv_ibv_create_ah_ex to create_ah_ex.

>> diff --git a/src/verbs.c b/src/verbs.c
>> index e7343a9..f8245b0 100644
>> +++ b/src/verbs.c
>> @@ -550,7 +550,7 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
>>   	int err;
>>   	struct ibv_ah *ah = NULL;
>>   #ifndef NRESOLVE_NEIGH
>> -	struct ibv_port_attr port_attr;
>> +	struct ibv_port_attr_ex port_attr;
>>   	int dst_family;
>>   	int src_family;
>>   	int oif;
>> @@ -570,7 +570,10 @@ struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
>>   		goto return_ah;
>>   	}
>>
>> -	err = ibv_query_port(pd->context, attr->port_num, &port_attr);
>> +	port_attr.comp_mask = IBV_QUERY_PORT_EX_ATTR_MASK1;
>> +	port_attr.mask1 = IBV_QUERY_PORT_EX_LINK_LAYER |
>> +			  IBV_QUERY_PORT_EX_CAP_FLAGS;
>> +	err = ibv_query_port_ex(pd->context, attr->port_num, &port_attr);
>>
>>   	if (err) {
>>   		fprintf(stderr, PFX "ibv_create_ah failed to query port.\n");
>
> I wonder if this belongs in a seperate patch, I had to read it twice
> to realize this change was to take advantage of the reduced query
> performance optimization.

Thanks, I'll move that to a different patch.

>
> Jason
>

Thanks for the comments,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

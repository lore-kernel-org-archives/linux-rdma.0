From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 3/5] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Thu, 12 Jun 2014 15:44:03 +0300
Message-ID: <5399A093.9070104@mellanox.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <1400405929-14313-4-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <20140521203107.GD26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140521203107.GD26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 21/5/2014 11:31 PM, Jason Gunthorpe wrote:
> On Sun, May 18, 2014 at 12:38:47PM +0300, Or Gerlitz wrote:
>>   struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
>>   {
>> -	struct ibv_ah *ah = pd->context->ops.create_ah(pd, attr);
>> +	int err;
>> +	struct ibv_ah *ah = NULL;
>> +#ifndef NRESOLVE_NEIGH
>> +	struct ibv_port_attr port_attr;
>> +	int dst_family;
>> +	int src_family;
>> +	int oif;
>> +	struct get_neigh_handler neigh_handler;
>> +	union ibv_gid sgid;
>> +	struct ibv_ah_attr_ex attr_ex;
>> +	int ether_len;
>> +	struct verbs_context *vctx = verbs_get_ctx_op(pd->context,
>> +						      create_ah_ex);
>> +	struct peer_address src;
>> +	struct peer_address dst;
>> +
>> +	if (!vctx) {
>> +#endif
>> +		ah = pd->context->ops.create_ah(pd, attr);
>> +#ifndef NRESOLVE_NEIGH
>> +		goto return_ah;
>> +	}
>> +
>> +	err = ibv_query_port(pd->context, attr->port_num, &port_attr);
>
> It feels like a regression to force this overhead. Many HCAs have no
> possibility to support anything but IB, or Ethernet and don't need
> this.
>
> This whole arrangement seems strange. create_ah_ex should be a full
> fledged user callable function, not a buried driver entry point.
> It is also very unusual for verbs to have all this generic code in
> a driver wrapper.
>
> I suspect the answer here is to have the driver call into helper
> functions from verbs to do this addressing
> work. 'get_ethernet_l2_from_ah' or something.
>
> If you do that then we don't even need create_ah_ex and query_port_ex
> - those function seem to only be required to support this wrapper
> technique.
>
> So please rethink how this flows.. Maybe wrapping is not the best
> choice??
>
> Jason
>

We could use a libibverbs API call in order to resolve the IP based GID 
into a MAC, but I think it could cause multiple vendors to have some 
code duplication. We hope that in the future, more products will use 
RoCE with IP based GIDs. All those providers will have to supply similar 
code that checks if the link layer is Ethernet and IP based GID is used, 
they'll have to use the libibverbs utility function.

A possible future create_ah_ex *libibverbs* could be a full fledged verb 
that uses the new provider's create_ah_ex. Currently, it's hidden inside 
the good old create_ah call, but we shouldn't limit ourselves to keep it 
that way.

Anyway, I have no objection to use a utility function instead of this 
method, but I do think that the current code has some advantages.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

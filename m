From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Tue, 17 Sep 2013 15:35:41 +0300
Message-ID: <52384C9D.6050900@mellanox.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com>  <1377694075-29287-4-git-send-email-matanb@mellanox.com> <1378908269.2258.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378908269.2258.31.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/9/2013 5:04 PM, Yann Droneaud wrote:
> Le mercredi 28 ao=C3=BBt 2013 =C3=A0 15:47 +0300, Matan Barak a =C3=A9=
crit :
>> From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Implement ib_uverbs_create_flow and ib_uverbs_destroy_flow to
>> support flow steering for user space applications.
>>
>> Change-Id: I0bc6dbe26f4776d00f95b6200ff43ccb24000e31
>> Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Seen this in linux-next as commit
> 436f2ad05a0b65b1467ddf51bc68171c381bf844
>
>> ---
>>   drivers/infiniband/core/uverbs.h      |    3 +
>>   drivers/infiniband/core/uverbs_cmd.c  |  228 +++++++++++++++++++++=
++++++++++++
>>   drivers/infiniband/core/uverbs_main.c |   13 ++-
>>   include/rdma/ib_verbs.h               |    1 +
>>   include/uapi/rdma/ib_user_verbs.h     |   89 +++++++++++++-
>>   5 files changed, 332 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniba=
nd/core/uverbs_cmd.c
>> index b105140..2856696 100644
>> --- a/drivers/infiniband/core/uverbs_cmd.c
>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>> @@ -2597,6 +2599,232 @@ out_put:
>>   	return ret ? ret : in_len;
>>   }
>>
>> +static int kern_spec_to_ib_spec(struct ib_kern_spec *kern_spec,
>> +				union ib_flow_spec *ib_spec)
>> +{
>> +	ib_spec->type =3D kern_spec->type;
>> +
>> +	switch (ib_spec->type) {
>> +	case IB_FLOW_SPEC_ETH:
>> +		ib_spec->eth.size =3D sizeof(struct ib_flow_spec_eth);
>> +		if (ib_spec->eth.size !=3D kern_spec->eth.size)
>> +			return -EINVAL;
>> +		memcpy(&ib_spec->eth.val, &kern_spec->eth.val,
>> +		       sizeof(struct ib_flow_eth_filter));
>> +		memcpy(&ib_spec->eth.mask, &kern_spec->eth.mask,
>> +		       sizeof(struct ib_flow_eth_filter));
>> +		break;
>> +	case IB_FLOW_SPEC_IPV4:
>> +		ib_spec->ipv4.size =3D sizeof(struct ib_flow_spec_ipv4);
>> +		if (ib_spec->ipv4.size !=3D kern_spec->ipv4.size)
>> +			return -EINVAL;
>> +		memcpy(&ib_spec->ipv4.val, &kern_spec->ipv4.val,
>> +		       sizeof(struct ib_flow_ipv4_filter));
>> +		memcpy(&ib_spec->ipv4.mask, &kern_spec->ipv4.mask,
>> +		       sizeof(struct ib_flow_ipv4_filter));
>> +		break;
>> +	case IB_FLOW_SPEC_TCP:
>> +	case IB_FLOW_SPEC_UDP:
>> +		ib_spec->tcp_udp.size =3D sizeof(struct ib_flow_spec_tcp_udp);
>> +		if (ib_spec->tcp_udp.size !=3D kern_spec->tcp_udp.size)
>> +			return -EINVAL;
>> +		memcpy(&ib_spec->tcp_udp.val, &kern_spec->tcp_udp.val,
>> +		       sizeof(struct ib_flow_tcp_udp_filter));
>> +		memcpy(&ib_spec->tcp_udp.mask, &kern_spec->tcp_udp.mask,
>> +		       sizeof(struct ib_flow_tcp_udp_filter));
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
>> +			      const char __user *buf, int in_len,
>> +			      int out_len)
>> +{
>> +	struct ib_uverbs_create_flow	  cmd;
>> +	struct ib_uverbs_create_flow_resp resp;
>> +	struct ib_uobject		  *uobj;
>> +	struct ib_flow			  *flow_id;
>> +	struct ib_kern_flow_attr	  *kern_flow_attr;
>> +	struct ib_flow_attr		  *flow_attr;
>> +	struct ib_qp			  *qp;
>> +	int err =3D 0;
>> +	void *kern_spec;
>> +	void *ib_spec;
>
> why void * here, there's a type for them, and the function
> kern_spec_to_ib_spec() has a prototype with those types.

We could use struct ib_kern_spec and union ib_flow_spec, but since ther=
e=20
is a lot of pointer arithmetic here, I think void * provides a more=20
readable code. Since the actual specs are of different size and are=20
placed one after another, traversing through the specs requires the=20
actual size rather than the union size.

>
>> +	int i;
>> +	int kern_attr_size;
>> +
>> +	if (out_len < sizeof(resp))
>> +		return -ENOSPC;
>> +
>> +	if (copy_from_user(&cmd, buf, sizeof(cmd)))
>> +		return -EFAULT;
>> +
>> +	if (cmd.comp_mask)
>> +		return -EINVAL;
>> +
>> +	if ((cmd.flow_attr.type =3D=3D IB_FLOW_ATTR_SNIFFER &&
>> +	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
>> +		return -EPERM;
>> +
>> +	if (cmd.flow_attr.num_of_specs < 0 ||
>
> num_of_specs is unsigned ...

Correct, this will be fixed.

>
>> +	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
>> +		return -EINVAL;
>> +
>> +	kern_attr_size =3D cmd.flow_attr.size - sizeof(cmd) -
>> +			 sizeof(struct ib_uverbs_cmd_hdr_ex);
>> +
>
> Please, no under/overflow. Check that cmd.flow_attr.size is bigger th=
an
> sizeof(cmd) + sizeof(struct ib_uverbs_cmd_hdr_ex) before computing
> kern_attr_size.

This introduces code duplication since we check that value and then=20
compute it. Since this value has an upper and lower limits and both=20
boundaries are checked, why is this problematic ?

>
>> +	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
>
> just like num_of_specs, it's unsigned !

Correct, this will be removed.

>
> cmd.flow_attr.size is certainly less then in_len, so you probably mea=
n
> cmd.flow_attr.size > (in_len - sizeof(cmd) - sizeof(struct
> ib_uverbs_cmd_hdr_ex)).

It's not certainly less than in_len, as the user initializes=20
cmd.flow_attr.size. Currently, our version of libibverbs place the=20
entire command size on cmd.flow_attr.size.

>
>> +	    kern_attr_size < 0 || kern_attr_size >
>> +	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
>> +		return -EINVAL;
>> +
>
> let's make kern_attr_size unsigned.

I think that it's not a good idea since we're iterating until we've got=
=20
to num_of_specs or we've got an invalid size in one of the spec=20
structures. Since we have an upper limit to kern_attr_size, I don't=20
think it's problematic to keep it as int.

>
> And be stricter: kern_attr_size !=3D cmd.flow_attr.num_of_specs *
> sizeof(struct ib_kern_spec) might be welcome.

The structures are TLV, so I can only check upper limit but not the=20
exact size without traversing them.

>
>> +	if (cmd.flow_attr.num_of_specs) {
>> +		kern_flow_attr =3D kmalloc(cmd.flow_attr.size, GFP_KERNEL);
>> +		if (!kern_flow_attr)
>> +			return -ENOMEM;
>> +
>> +		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
>
> might be sizeof(struct ib_kern_spec) as used in the computation.

This only copies the "header" and not the spec themselves.

>
>> +		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
>> +				   kern_attr_size)) {

This copies the specs.

>> +			err =3D -EFAULT;
>> +			goto err_free_attr;
>> +		}
>
> I don't feel comfortable with the bounds: previously it was
> sizeof(cmd) + sizeof(struct ib_uverbs_cmd_hdr_ex), and here
> copy_from_user() is copying starting from buf + sizeof(cmd) ... so wh=
ere
> is the struct ib_uverbs_cmd_hdr_ex ?

The cmd starts straight after ib_uverbs_cmd_hdr_ex, but in_len includes=
=20
sizeof(struct ib_uverbs_cmd_hdr_ex). Please take a look at the patch=20
which adds the extension verbs mechanism.

>
> And I dislike the + 1 throughout this portion of the code: why the fi=
rst
> element is being so different than the others. I didn't dig enough in
> the code to understand, but from my point of view, it doesn't fit.
>
>> +	kern_spec =3D kern_flow_attr + 1;
>> +	ib_spec =3D flow_attr + 1;
>> +	for (i =3D 0; i < flow_attr->num_of_specs && kern_attr_size > 0; i=
++) {
>> +		err =3D kern_spec_to_ib_spec(kern_spec, ib_spec);
>> +		if (err)
>> +			goto err_free;
>> +		flow_attr->size +=3D
>> +			((union ib_flow_spec *)ib_spec)->size;
>> +		kern_attr_size -=3D ((struct ib_kern_spec *)kern_spec)->size;
>> +		kern_spec +=3D ((struct ib_kern_spec *)kern_spec)->size;
>> +		ib_spec +=3D ((union ib_flow_spec *)ib_spec)->size;
>
> Why use void * for ib_spec and kern_spec if there's a union type for
> them ?

Since we use TLV, using void * actually introduces less castings.

>
>> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/i=
b_user_verbs.h
>> index 61535aa..0b233c5 100644
>> --- a/include/uapi/rdma/ib_user_verbs.h
>> +++ b/include/uapi/rdma/ib_user_verbs.h
>> @@ -86,7 +86,9 @@ enum {
>
>> +struct ib_kern_spec {
>> +	union {
>> +		struct {
>> +			__u32 type;
>> +			__u16 size;
>> +			__u16 reserved;
>> +		};
>> +		struct ib_kern_spec_eth	    eth;
>> +		struct ib_kern_spec_ipv4    ipv4;
>> +		struct ib_kern_spec_tcp_udp tcp_udp;
>> +	};
>> +};
>> +
>
> [Aside note: no IPv6 spec ?]
>
>
>> +struct ib_kern_flow_attr {
>> +	__u32 type;
>> +	__u16 size;
>> +	__u16 priority;
>> +	__u8  num_of_specs;
>> +	__u8  reserved[2];
>> +	__u8  port;
>> +	__u32 flags;
>> +	/* Following are the optional layers according to user request
>> +	 * struct ib_flow_spec_xxx
>> +	 * struct ib_flow_spec_yyy
>> +	 */
>> +};
>> +
>> +struct ib_uverbs_create_flow  {
>> +	__u32 comp_mask;
>
> Alignment notice: There's a hole here on 64bits system with stricter
> alignment rules.

Thanks! Do you recommend adding a u32 reserved field ?

>
>> +	__u64 response;
>> +	__u32 qp_handle;
>> +	struct ib_kern_flow_attr flow_attr;
>> +};
>> +
>
> Sorry I've missed that before it got included in infiniband git tree.
>
> Regards.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

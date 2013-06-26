From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/4] IB/core: Add receive Flow Steering support
Date: Thu, 27 Jun 2013 00:13:07 +0300
Message-ID: <CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w@mail.gmail.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
	<1372251464-13394-2-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD36FF3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD36FF3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2013 at 10:56 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> The input to ib_create_flow is instance of struct ib_flow_attr which
>> contain few mandatory control elements and optional flow specs.
>>
>> struct ib_flow_attr {
>>       enum ib_flow_attr_type type;
>>       u16      size;
>>       u16      priority;
>>       u8       num_of_specs;
>>       u8       port;
>>       u32      flags;
>
> This structure could be aligned better.

OK, I assume you mean arrange fields by decreasing size, correct? so
here we need to  put the flags field before the size field.

>
>>       /* Following are the optional layers according to user request
>>        * struct ib_flow_spec_yyy
>>        * struct ib_flow_spec_zzz
>>        */
>> };
>>
>> As these specs are eventually coming from user space, they are defined and
>> used in a way which allows adding new spec types without kernel/user ABI
>> change, and with a little API enhancement which defines the newly added spec.
>>
>> The flow spec structures are defined in a TLV (Type-Length-Value) manner,
>> which allows to call ib_create_flow with a list of variable length of
>> optional specs.
>>
>> For the actual processing of ib_flow_attr the driver uses the number of
>> specs and the size mandatory fields along with the TLV nature of the specs.
>>
>> Steering rules processing order is according to rules priority. The user
>> sets the 12 low-order bits from the priority field and the remaining
>> 4 high-order bits are set by the kernel according to a domain the
>> application or the layer that created the rule belongs to. Lower
>> priority numerical value means higher priority.
>
> Why are bit fields being exposed to the user in this way?

Yes, this is probably not general enough. So what would you suggest,
use a more integral division? e.g 16 bits for priority and 16 bits for
location?


>> +struct ib_flow *ib_create_flow(struct ib_qp *qp,
>> +                            struct ib_flow_attr *flow_attr,
>> +                            int domain)
>> +{
>> +     struct ib_flow *flow_id;
>> +     if (!qp->device->create_flow)
>> +             return ERR_PTR(-ENOSYS);
>> +
>> +     flow_id = qp->device->create_flow(qp, flow_attr, domain);
>> +     if (!IS_ERR(flow_id))
>> +             atomic_inc(&qp->usecnt);
>> +     return flow_id;
>> +}
>> +EXPORT_SYMBOL(ib_create_flow);
>> +
>> +int ib_destroy_flow(struct ib_flow *flow_id)
>> +{
>> +     int err;
>> +     struct ib_qp *qp = flow_id->qp;
>> +
>> +     if (!flow_id->qp->device->destroy_flow)
>> +             return -ENOSYS;
>
> We can assume destroy_flow exists if create_flow does.

OK, will fix.

>
>> +struct ib_flow_ib_filter {
>> +     __be32  l3_type_qpn;
>> +     u8      dst_gid[16];
>> +};


> Maybe this is just a naming issue, but why wouldn't an IB filter have SLID/DLID instead > of just DGID?  What does l3_type_qpn mean?  Is this just the QPN?

yes, its just the QPN, will fix the name to better match.

> The TCP/IP filters are broken into separate filters based in L4/L3.  It would seem to
> make sense if the IB filters were similarly divided into L2/L3/L4 filters.  IB and IPv6
> could probably share the same filter definition.

IPv6 filters wasn't defined through this submission, but as I wrote,
the scheme provided allows for adding more filters and flow specs.



>
>> +struct ib_flow_spec_ib {
>> +     enum ib_flow_spec_type   type;
>> +     u16                      size;
>> +     struct ib_flow_ib_filter val;
>> +     struct ib_flow_ib_filter mask;
>> +};
>> +
>> +struct ib_flow_ipv4_filter {
>> +     __be32  src_ip;
>> +     __be32  dst_ip;
>> +};
>> +
>> +struct ib_flow_spec_ipv4 {
>> +     enum ib_flow_spec_type     type;
>> +     u16                        size;
>> +     struct ib_flow_ipv4_filter val;
>> +     struct ib_flow_ipv4_filter mask;
>> +};
>> +
>> +struct ib_flow_tcp_udp_filter {
>> +     __be16  dst_port;
>> +     __be16  src_port;
>> +};
>> +
>> +struct ib_flow_spec_tcp_udp {
>> +     enum ib_flow_spec_type        type;
>> +     u16                           size;
>> +     struct ib_flow_tcp_udp_filter val;
>> +     struct ib_flow_tcp_udp_filter mask;
>> +};
>
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

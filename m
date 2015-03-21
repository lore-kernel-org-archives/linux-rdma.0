From: Yun Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Sat, 21 Mar 2015 08:49:50 +0100
Message-ID: <CAJuTgQUsZ34F-dKpsmW+5=axDWb93pA43LZ-qKbEjqyu-RUUmg@mail.gmail.com>
References: <550C2514.5070001@profitbricks.com>
	<6A3D3202-0128-4F33-B596-D7A76AB66DF8@gmail.com>
	<20150320235748.GA22703@phlsvsds.ph.intel.com>
	<20150321000541.GA24717@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150321000541.GA24717-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, Ira

Thanks for the reply :-)

On Sat, Mar 21, 2015 at 1:05 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> My apologies to those who are duplicated here.  This did not make it =
to the
> mailing list due to mail configuration issues.
>
> From ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org Fri Mar 20 18:55:29 2015
>
[snip]
>> -        if (rdma_node_get_transport(cma_dev->device->node_type) =3D=
=3D
>> RDMA_TRANSPORT_IB &&
>> -            rdma_port_get_link_layer(cma_dev->device, port) =3D=3D
>> IB_LINK_LAYER_ETHERNET)
>> +        if (rdma_mgmt_cap_iboe(cma_dev->device, port))
>
> This is still indicating a specific technology "iboe" rather than the=
 specific
> management capabilities the port has.
>
> Also this if statement does not seem to have anything to do with the =
management
> support.  Here the iboe_gid is a different format and needs to be pro=
cessed
> differently from the gid.

Agree, the mgmt cap here is more close to concept 'feature' rather
than 'protocol'.

The purpose is to help branch the management, like when vendor declare
his device support ibeo format, mad can get the hint by checking the
port attribute then branch the management path, which currently is
inferred from transport type and link layer type, not told by the
vendor.

>
>>               ret =3D ib_find_cached_gid(cma_dev->device, &iboe_gid,
>>                            &found_port, NULL);
>>           else
[snip]
>> +    enum rdma_transport_type tp =3D
>> +            rdma_node_get_transport(device->node_type);
>> +    enum rdma_link_layer ll =3D
>> +            rdma_port_get_link_layer(device, port_num);
>
> This does not separate the management capabilities from the transport=
 and link
> layer like Sean was advocating.  This is just refactoring the current
> implementation with the use of additional flags.

Yes, it's currently copy the logical we are using to branch the
management, however, if the vendor could provide his own setup code
here, we don't really need to infer anymore but following the
indicator from vendor, this 'default' method is for transition.

Sean, could you please give more hint or details on what you'd rather
like to have? I think I got some misunderstanding on your
suggestion...

>
>> +
[snip]
>>
>> +enum rdma_mgmt_flag {
>> +    IB_MGMT_PROTO_IB,
>> +    IB_MGMT_PROTO_SMI,
>> +    IB_MGMT_PROTO_IBOE,
>
> IB and IBoE are not management protocols.

May be it should be 'feature' rather than 'proto'?

We have management branch for iboe although it's not really a protocol
(or does it belong to any protocol specially?), also we have too much
places to check if device got infiniband feature, especially at the
beginning of initialization, I really want to have some way to
simplify these check, or make them more like a formal mechanism.

>
[snip]
>>
>> +int rdma_port_default_mgmt_flags(struct ib_device *device, u8 port_=
num);
>
> This should return u32.

Yeah.. that's why I call it a draft ;-)

Actually the flags are even not defined in bit but integer :-P just
try to introduce the idea see if it's close to Sean's proposal.

>
> I think I would rather see your other patch go in to clean up the cod=
e a bit
> and work this issue separately.

Agree, it seems like not a simple work, me too would rather to cleanup
the code of inferring firstly, put them together into some public
helper, waiting for adapt to some new mechanism.

Sean, what's your opinion?

Regards,
Michael Wang

>
> Ira
>
>> +
>> +static inline int rdma_mgmt_cap(struct ib_device *device, u8 port_n=
um)
>> +{
>> +    struct ib_port_attr port_attr;
>> +    memset(&port_attr, 0, sizeof port_attr);
>> +    ib_query_port(device, port_num, &port_attr);
>> +    return port_attr.mgmt_flags;
>> +}
>> +
>> +static inline int rdma_mgmt_cap_ib(struct ib_device *device)
>> +{
>> +    u8 port_num =3D device->node_type =3D=3D RDMA_NODE_IB_SWITCH ? =
0 : 1;
>> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IB;
>> +}
>> +
>> +static inline int rdma_mgmt_cap_smi(struct ib_device *device, u8 po=
rt_num)
>> +{
>> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_SMI;
>> +}
>> +
>> +static inline int rdma_mgmt_cap_iboe(struct ib_device *device, u8 p=
ort_num)
>> +{
>> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IBOE;
>> +}
>> +
>>   int ib_query_gid(struct ib_device *device,
>>            u8 port_num, int index, union ib_gid *gid);
>>
>>
>>
>> On 03/18/2015 12:36 AM, Hefty, Sean wrote:
>> >> But it makes sense to me to use management specific
>> >> fields/attributes/flags for the *management* pieces, rather than =
using the
>> >> link and/or transport layer protocols as a proxy.  Management rel=
ated code
>> >> should really branch based on that.
>> > As a proposal, we could add a new field to the kernel port attribu=
te structure.  The field would be a bitmask of management capabilities/=
protocols:
>> >
>> > IB_MGMT_PROTO_SM - supports IB SMPs
>> > IB_MGMT_PROTO_SA - supports IB SA MADs
>> > IB_MGMT_PROTO_GS - supports IB GSI MADs (e.g. CM, PM, ...)
>> > IB_MGMT_PROTO_OPA_SM - supports OPA SMPs (or whatever they are cal=
led)
>> > IB_MGMT_PROTO_OPA_GS - supports OPA GS MADs (or whatever is suppor=
ted)
>> >
>> > If the *GS flags are not sufficient to distinguish between MADs su=
pported over IB and RoCE, it can be further divided (i.e. CM, PM, BM, D=
M, etc.).
>> >
>> > This would provide a direct mapping of which management protocols =
are supported for a given port, rather than it being inferred by the li=
nk/transport fields, which should really be independent.  It would also=
 allow for simple checks by the core layer.
>> >
>> > If we want the code to be more generic, additional field(s) could =
be added, such as mad_size, so that any size of management datagram is =
supported.  This would be used instead of inferring the size based on t=
he supported protocol.
>> >
>> > - Sean
>> > N=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=
=C2=BD=C3=AF=C2=BF=C2=BDr=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BDy=C3=AF=C2=
=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BDb=C3=AF=C2=BF=C2=BDX=C3=AF=
=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=87=C2=A7v=C3=AF=C2=BF=C2=BD^=C3=AF=C2=
=BF=C2=BD)=C3=9E=C2=BA{.n=C3=AF=C2=BF=C2=BD+=C3=AF=C2=BF=C2=BD=C3=AF=C2=
=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD{=C3=AF=C2=BF=C2=BD=C3=AF=C2=
=BF=C2=BD=C3=99s=C3=AF=C2=BF=C2=BD{ay=C3=AF=C2=BF=C2=BD =C3=8A?=C3=9AT=C3=
=AF=C2=BF=C2=BD,j =C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BDf=C3=AF=C2=BF=C2=BD=
=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BDh=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=
=C3=AF=C2=BF=C2=BDz=C3=AF=C2=BF=C2=BD =C3=AF=C2=BF=C2=BDw=C3=AF=C2=BF=C2=
=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD =C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=
=BD=C3=AF=C2=BF=C2=BDj:+v=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=
=C2=BDw=C3=AF=C2=BF=C2=BDj=C3=AF=C2=BF=C2=BDm=C3=AF=C2=BF=C2=BD=C3=AF=C2=
=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD =C3=AF=C2=BF=C2=BD=C3=AF=C2=
=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BDzZ+=C3=AF=C2=BF=C2=BD=C3=AF=
=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=9D=
=C2=A2j"=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD!tml=3D
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

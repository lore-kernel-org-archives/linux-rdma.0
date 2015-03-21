From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap flag
Date: Fri, 20 Mar 2015 20:05:41 -0400
Message-ID: <20150321000541.GA24717@phlsvsds.ph.intel.com>
References: <550C2514.5070001@profitbricks.com> <6A3D3202-0128-4F33-B596-D7A76AB66DF8@gmail.com> <20150320235748.GA22703@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150320235748.GA22703-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

My apologies to those who are duplicated here.  This did not make it to=
 the
mailing list due to mail configuration issues.

=46rom ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org Fri Mar 20 18:55:29 2015

>=20
> Hi, folks
>=20
> I've done a draft (very rough draft...) according to my understanding=
 on
> Sean's proposal.
>=20
> The implementation is to allow device setup the management flags duri=
ng
> ib_query_port() (amso1100 as eg), and later we could use the flags to=
 check
> the capability.
>=20
> For new capability/proto, like OPA, device could setup new flag
> IB_MGMT_PROTO_OPA during query_port() callback, and some helper like
> rdma_mgmt_cap_opa() can be used for management branch.
>=20
> How do you think about this?

This is not saving us anything...  See below.

>=20
> Regards,
> Michael Wang
>=20
>=20
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index d570030..ad1685e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -375,8 +375,7 @@ static int cma_acquire_dev(struct rdma_id_private=
=20
> *id_priv,
>                        listen_id_priv->id.port_num) =3D=3D dev_ll) {
>           cma_dev =3D listen_id_priv->cma_dev;
>           port =3D listen_id_priv->id.port_num;
> -        if (rdma_node_get_transport(cma_dev->device->node_type) =3D=3D=
=20
> RDMA_TRANSPORT_IB &&
> -            rdma_port_get_link_layer(cma_dev->device, port) =3D=3D=20
> IB_LINK_LAYER_ETHERNET)
> +        if (rdma_mgmt_cap_iboe(cma_dev->device, port))

This is still indicating a specific technology "iboe" rather than the s=
pecific
management capabilities the port has.

Also this if statement does not seem to have anything to do with the ma=
nagement
support.  Here the iboe_gid is a different format and needs to be proce=
ssed
differently from the gid.

>               ret =3D ib_find_cached_gid(cma_dev->device, &iboe_gid,
>                            &found_port, NULL);
>           else
> @@ -395,8 +394,7 @@ static int cma_acquire_dev(struct rdma_id_private=
=20
> *id_priv,
>                   listen_id_priv->id.port_num =3D=3D port)
>                   continue;
>               if (rdma_port_get_link_layer(cma_dev->device, port) =3D=
=3D=20
> dev_ll) {
> -                if (rdma_node_get_transport(cma_dev->device->node_ty=
pe)=20
> =3D=3D RDMA_TRANSPORT_IB &&
> -                    rdma_port_get_link_layer(cma_dev->device, port) =
=3D=3D=20
> IB_LINK_LAYER_ETHERNET)
> +                if (rdma_mgmt_cap_iboe(cma_dev->device, port))
>                       ret =3D ib_find_cached_gid(cma_dev->device,=20
> &iboe_gid, &found_port, NULL);
>                   else
>                       ret =3D ib_find_cached_gid(cma_dev->device, &gi=
d,=20
> &found_port, NULL);
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/=
mad.c
> index 74c30f4..0ae6b04 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *d=
evice,
>       init_mad_qp(port_priv, &port_priv->qp_info[1]);
>=20
>       cq_size =3D mad_sendq_size + mad_recvq_size;
> -    has_smi =3D rdma_port_get_link_layer(device, port_num) =3D=3D=20
> IB_LINK_LAYER_INFINIBAND;
> +    has_smi =3D rdma_mgmt_cap_smi(device, port_num);
>       if (has_smi)
>           cq_size *=3D 2;
>=20
> @@ -3057,7 +3057,7 @@ static void ib_mad_init_device(struct ib_device=
=20
> *device)
>   {
>       int start, end, i;
>=20
> -    if (rdma_node_get_transport(device->node_type) !=3D RDMA_TRANSPO=
RT_IB)
> +    if (!rdma_mgmt_cap_ib(device))
>           return;
>=20
>       if (device->node_type =3D=3D RDMA_NODE_IB_SWITCH) {
> diff --git a/drivers/infiniband/core/verbs.c=20
> b/drivers/infiniband/core/verbs.c
> index f93eb8d..5ecf9c8 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -146,6 +146,26 @@ enum rdma_link_layer=20
> rdma_port_get_link_layer(struct ib_device *device, u8 port_
>   }
>   EXPORT_SYMBOL(rdma_port_get_link_layer);
>=20
> +int rdma_port_default_mgmt_flags(struct ib_device *device, u8 port_n=
um)
> +{
> +    int mgmt_flags =3D 0;
> +    enum rdma_transport_type tp =3D
> +            rdma_node_get_transport(device->node_type);
> +    enum rdma_link_layer ll =3D
> +            rdma_port_get_link_layer(device, port_num);

This does not separate the management capabilities from the transport a=
nd link
layer like Sean was advocating.  This is just refactoring the current
implementation with the use of additional flags.

> +
> +    if (tp =3D=3D RDMA_TRANSPORT_IB) {
> +        mgmt_flags |=3D IB_MGMT_PROTO_IB;
> +        if (ll =3D=3D IB_LINK_LAYER_INFINIBAND) {
> +            mgmt_flags |=3D IB_MGMT_PROTO_SMI;
> +            mgmt_flags |=3D IB_MGMT_PROTO_IBOE;
> +        }
> +    }
> +
> +    return mgmt_flags;
> +}
> +EXPORT_SYMBOL(rdma_port_default_mgmt_flags);
> +
>   /* Protection domains */
>=20
>   struct ib_pd *ib_alloc_pd(struct ib_device *device)
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c=20
> b/drivers/infiniband/hw/amso1100/c2_provider.c
> index bdf3507..04d005e 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -96,6 +96,9 @@ static int c2_query_port(struct ib_device *ibdev,
>       props->active_width =3D 1;
>       props->active_speed =3D IB_SPEED_SDR;
>=20
> +    /* Makeup flags here, by default or on your own */
> +    props->mgmt_flags =3D rdma_port_default_mgmt_flags(ibdev, port);
> +
>       return 0;
>   }
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..d19c7c9 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -90,6 +90,13 @@ enum rdma_link_layer {
>       IB_LINK_LAYER_ETHERNET,
>   };
>=20
> +enum rdma_mgmt_flag {
> +    IB_MGMT_PROTO_IB,
> +    IB_MGMT_PROTO_SMI,
> +    IB_MGMT_PROTO_IBOE,

IB and IBoE are not management protocols.

> +    /* More Here*/
> +};
> +
>   enum ib_device_cap_flags {
>       IB_DEVICE_RESIZE_MAX_WR        =3D 1,
>       IB_DEVICE_BAD_PKEY_CNTR        =3D (1<<1),
> @@ -352,6 +359,7 @@ struct ib_port_attr {
>       enum ib_mtu        active_mtu;
>       int            gid_tbl_len;
>       u32            port_cap_flags;
> +    u32            mgmt_flags;
>       u32            max_msg_sz;
>       u32            bad_pkey_cntr;
>       u32            qkey_viol_cntr;
> @@ -1743,6 +1751,32 @@ int ib_query_port(struct ib_device *device,
>   enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *dev=
ice,
>                              u8 port_num);
>=20
> +int rdma_port_default_mgmt_flags(struct ib_device *device, u8 port_n=
um);

This should return u32.

I think I would rather see your other patch go in to clean up the code =
a bit
and work this issue separately.

Ira

> +
> +static inline int rdma_mgmt_cap(struct ib_device *device, u8 port_nu=
m)
> +{
> +    struct ib_port_attr port_attr;
> +    memset(&port_attr, 0, sizeof port_attr);
> +    ib_query_port(device, port_num, &port_attr);
> +    return port_attr.mgmt_flags;
> +}
> +
> +static inline int rdma_mgmt_cap_ib(struct ib_device *device)
> +{
> +    u8 port_num =3D device->node_type =3D=3D RDMA_NODE_IB_SWITCH ? 0=
 : 1;
> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IB;
> +}
> +
> +static inline int rdma_mgmt_cap_smi(struct ib_device *device, u8 por=
t_num)
> +{
> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_SMI;
> +}
> +
> +static inline int rdma_mgmt_cap_iboe(struct ib_device *device, u8 po=
rt_num)
> +{
> +    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IBOE;
> +}
> +
>   int ib_query_gid(struct ib_device *device,
>            u8 port_num, int index, union ib_gid *gid);
>=20
>=20
>=20
> On 03/18/2015 12:36 AM, Hefty, Sean wrote:
> >> But it makes sense to me to use management specific
> >> fields/attributes/flags for the *management* pieces, rather than u=
sing the
> >> link and/or transport layer protocols as a proxy.  Management rela=
ted code
> >> should really branch based on that.
> > As a proposal, we could add a new field to the kernel port attribut=
e structure.  The field would be a bitmask of management capabilities/p=
rotocols:
> >
> > IB_MGMT_PROTO_SM - supports IB SMPs
> > IB_MGMT_PROTO_SA - supports IB SA MADs
> > IB_MGMT_PROTO_GS - supports IB GSI MADs (e.g. CM, PM, ...)
> > IB_MGMT_PROTO_OPA_SM - supports OPA SMPs (or whatever they are call=
ed)
> > IB_MGMT_PROTO_OPA_GS - supports OPA GS MADs (or whatever is support=
ed)
> >
> > If the *GS flags are not sufficient to distinguish between MADs sup=
ported over IB and RoCE, it can be further divided (i.e. CM, PM, BM, DM=
, etc.).
> >
> > This would provide a direct mapping of which management protocols a=
re supported for a given port, rather than it being inferred by the lin=
k/transport fields, which should really be independent.  It would also =
allow for simple checks by the core layer.
> >
> > If we want the code to be more generic, additional field(s) could b=
e added, such as mad_size, so that any size of management datagram is s=
upported.  This would be used instead of inferring the size based on th=
e supported protocol.
> >
> > - Sean
> > N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=D9s=EF=BF=BD{ay=EF=BF=BD=1D=CA?=DAT=EF=BF=BD,j=07=EF=BF=BD=EF=
=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=
=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=EF=BF=BDj=
:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

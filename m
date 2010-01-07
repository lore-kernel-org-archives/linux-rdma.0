From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_qos.c: merge SL2VL mapping capability check
Date: Thu, 7 Jan 2010 08:38:46 -0500
Message-ID: <f0e08f231001070538q78453f91kd47c931087dfa735@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100104170141.GK26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100104170141.GK26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 4, 2010 at 12:01 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
>
> The IBA 1.2.1 states (Vol.1, p.840, Table XX,

Table 146 PortInfo

> explanation (b)) that
> SL2VL mapping capability for switch external ports must be indicated =
on
> its port 0 PortInfo:CapMask.

That footnote was added at IBA 1.2.1.

> So it lets us to unify this capability check over all types of IB nod=
es.

Change appears to be for switches to always rely on this bit rather
than only when VLCap is 1. I wonder if there are any switches with
VLCap > 1 that don't set the IsSLMappingSupported CapabilityMask bit.
There shouldn't be (at least if they are IBA 1.2.1 compliant) but are
you sure about this ?

-- Hal

> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_qos.c | =C2=A0 22 +++++++---------------
> =C2=A01 files changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index 08f9a60..afeaa11 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c
> @@ -194,23 +194,15 @@ static ib_api_status_t sl2vl_update(osm_sm_t * =
sm, osm_port_t * p_port,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_api_status_t status;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint8_t i, num_ports;
> - =C2=A0 =C2=A0 =C2=A0 osm_physp_t *p_physp;
> + =C2=A0 =C2=A0 =C2=A0 ib_port_info_t *pi =3D &p_port->p_physp->port_=
info;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!(pi->capability_mask & IB_PORT_CAP_HAS_SL=
_MAP))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>
> - =C2=A0 =C2=A0 =C2=A0 if (osm_node_get_type(osm_physp_get_node_ptr(p=
)) =3D=3D IB_NODE_TYPE_SWITCH) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ib_port_info_g=
et_vl_cap(&p->port_info) =3D=3D 1) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* Check port 0's capability mask */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_physp =3D p_port->p_physp;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (p_physp->port_info.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0capability_mask & IB_PORT_CAP_HAS_SL_MAP))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (osm_node_get_type(osm_physp_get_node_ptr(p=
)) =3D=3D IB_NODE_TYPE_SWITCH)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0num_ports =3D =
osm_node_get_num_physp(osm_physp_get_node_ptr(p));
> - =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(p->port_info=
=2Ecapability_mask & IB_PORT_CAP_HAS_SL_MAP))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return IB_SUCCESS;
> + =C2=A0 =C2=A0 =C2=A0 else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0num_ports =3D =
1;
> - =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < num_ports; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D sl2=
vl_update_table(sm, p, i, port_num, force_update,
> --
> 1.6.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

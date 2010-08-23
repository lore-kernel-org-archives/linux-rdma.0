From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix sl2vl configuration
Date: Mon, 23 Aug 2010 10:25:10 -0400
Message-ID: <AANLkTinpju=SXu_PUmd_8gt8uPazNJnz6HhWU=RLgw+M@mail.gmail.com>
References: <4C505A39.4020201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C505A39.4020201-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 28, 2010 at 12:26 PM, Eli Dorfman (Voltaire)
<dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Subject: [PATCH] Fix sl2vl configuration
>
> For non-optimized sl2vl configuration in and out ports were reversed.

Are you sure these are reversed ? Any idea which commit introduced
this reversal of in and out ports ?

> For optimal sl2vl added override of default ALL settting with port's
> sl2vl when operational VL was other than the default port.

What is the motivation to override when the operational VLs is
different ? Why is that better than what is done currently ?

Is this really a policy issue ?

IMO there are two separate issues in this patch and they should be in
separate patches (for better git bisection).

Also, a couple of (possibly related) questions below.

> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_qos.c | =C2=A0 25 ++++++++++++++++++++-----
> =C2=A01 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index a571370..de0ae23 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c
> @@ -182,7 +182,7 @@ static ib_api_status_t sl2vl_update_table(osm_sm_=
t * sm, osm_physp_t * p,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tbl.raw_vl_by_=
sl[i] =3D (vl1 << 4) | vl2;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 if (!force_update && (p_tbl =3D osm_physp_get_=
slvl_tbl(p, in_port)) &&
> + =C2=A0 =C2=A0 =C2=A0 if (!force_update && in_port && (p_tbl =3D osm=
_physp_get_slvl_tbl(p, in_port)) &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!memcmp(p_tbl, &tbl, sizeof(=
tbl)))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IB_SUCC=
ESS;

Why exclude port 0 here ? Is it related to the change noted below ?

> @@ -209,6 +209,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_=
node_t *node,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned num_ports =3D osm_node_get_num_ph=
ysp(node);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i, j;
> + =C2=A0 =C2=A0 =C2=A0 uint8_t op_vl1;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> @@ -225,17 +226,31 @@ static int qos_extports_setup(osm_sm_t * sm, os=
m_node_t *node,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ib_switch_info_get_opt_sl2vlmapping(&n=
ode->sw->switch_info) &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sm->p_subn->opt.use_optimize=
d_slvl) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 op_vl1 =3D ib_port=
_info_get_op_vls(&p->port_info);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return sl2vl_updat=
e_table(sm, p, 1, 0x30000, force_update,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
&qcfg->sl2vl);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sl2vl_update_t=
able(sm, p, 0, 0x30000, force_update,

Why is the third parameter (in_port) changed from 1 to 0 here ? Maybe
that's related to the change above for the skipping of port 0 in
sl2vl_update_table.

-- Hal

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &qcfg->=
sl2vl))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* overwrite defau=
lt ALL configuration if port's
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op_vl=
 is different */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 2; i < =
num_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p =3D osm_node_get_physp_ptr(node, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ib_port_info_get_op_vls(&p->port_info) !=3D op_vl1 &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 sl2vl_update_table(sm, p, 0, 0x20000 | i, force_u=
pdate,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 &qcfg->sl2vl))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 /* non optimized sl2vl configuration */
> + =C2=A0 =C2=A0 =C2=A0 i =3D ib_switch_info_is_enhanced_port0(&node->=
sw->switch_info) ? 0 : 1;
> + =C2=A0 =C2=A0 =C2=A0 for (; i < num_ports; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0j =3D ib_switc=
h_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; j < num=
_ports; j++)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (sl2vl_update_table(sm, p, j, j << 8 | i,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 force_update, &qcfg->sl2vl))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> --
> 1.5.5
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

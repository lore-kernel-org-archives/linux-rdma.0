From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Multicast root switch calculation
Date: Thu, 28 Jan 2010 10:39:10 -0500
Message-ID: <f0e08f231001280739m31dae78cj5ab7bd78621dcbfc@mail.gmail.com>
References: <4B17C712.9010109@Voltaire.COM> <20100120102703.GB25576@me>
	 <39C75744D164D948A170E9792AF8E7CA01F6FA8A@exil.voltaire.com>
	 <20100120115936.GC25576@me> <20100127104503.GM26338@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100127104503.GM26338@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 27, 2010 at 5:45 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 13:59 Wed 20 Jan =C2=A0 =C2=A0 , Sasha Khapyorsky wrote:
>> On 13:32 Wed 20 Jan =C2=A0 =C2=A0 , Slava Strebkov wrote:
>> > "average hops" was chosen instead of "max hops" because in root we=
ight
>> > calculation the number of ports is also important, not only the di=
stance
>> > (hops).
>>
>> But this patch is declared as root switch calculation optimization, =
not
>> as algorithm change (actually I even missed this part in V1).
>
> I reworked this patch preserving original ("max hops") calculation
> method. Please look at this.
>
> The next step is to evaluate "max hops" -> "average hops" switch and =
to
> cleanup OSM_VENDOR_INTF_ANAFA macro.
>
> Sasha
>
>
> From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
> Date: Thu, 3 Dec 2009 16:11:30 +0200
> Subject: [PATCH] opensm: Multicast root switch calculation
>
> Proposed new algorithm for calculation of root switch for multicast
> spanning tree. Only edge switches(those connected to hosts)

What about switches whose peer port is a router ? Shouldn't they be
included here ?

> and
> switches - multicast members themselves are involved in root calculat=
ion.
> This gives improvement, especially on large fabrics, since number of
> switches usually much less then the number of ports, shared same mcas=
t
> group.
>
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/include/opensm/osm_switch.h | =C2=A0 12 +++
> =C2=A0opensm/opensm/osm_mcast_mgr.c =C2=A0 =C2=A0 =C2=A0| =C2=A0149 +=
+++++++++++++++++++++++++---------
> =C2=A02 files changed, 122 insertions(+), 39 deletions(-)
>
> diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/open=
sm/osm_switch.h
> index 205896d..cb6e5ac 100644
> --- a/opensm/include/opensm/osm_switch.h
> +++ b/opensm/include/opensm/osm_switch.h
> @@ -109,6 +109,9 @@ typedef struct osm_switch {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned endport_links;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned need_update;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0void *priv;
> + =C2=A0 =C2=A0 =C2=A0 cl_map_item_t mgrp_item;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t num_of_mcm;
> + =C2=A0 =C2=A0 =C2=A0 uint8_t is_mc_member;
> =C2=A0} osm_switch_t;
> =C2=A0/*
> =C2=A0* FIELDS
> @@ -151,6 +154,15 @@ typedef struct osm_switch {
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0When set indi=
cates that switch was probably reset, so
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fwd tables an=
d rest cached data should be flushed
> =C2=A0*
> +* =C2=A0 =C2=A0 =C2=A0mgrp_item
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map item for switc=
h in building mcast tree
> +*
> +* =C2=A0 =C2=A0 =C2=A0num_of_mcm
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0number of mcast me=
mbers(ports) connected to switch
> +*
> +* =C2=A0 =C2=A0 =C2=A0is_mc_member
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0whether switch is =
a mcast member itself
> +*
> =C2=A0* SEE ALSO
> =C2=A0* =C2=A0 =C2=A0 =C2=A0Switch object
> =C2=A0*********/
> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_=
mgr.c
> index dce9f2b..5c9d0bc 100644
> --- a/opensm/opensm/osm_mcast_mgr.c
> +++ b/opensm/opensm/osm_mcast_mgr.c
> @@ -157,50 +157,119 @@ static void mcast_mgr_purge_tree(osm_sm_t * sm=
, IN osm_mgrp_box_t * mbox)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_EXIT(sm->p_log);
> =C2=A0}
>
> -static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qlist_=
t * l,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 const osm_switch_t * p_sw)
> +static void mcast_mgr_build_switch_map(osm_sm_t * sm,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const cl=
_qlist_t * port_list,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qmap_=
t * p_mcast_member_sw_tbl)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 float avg_hops =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 uint32_t hops =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 uint32_t num_ports =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 cl_list_item_t *i;
> + =C2=A0 =C2=A0 =C2=A0 osm_switch_t *remote_sw;
> + =C2=A0 =C2=A0 =C2=A0 cl_list_item_t *list_item;
> + =C2=A0 =C2=A0 =C2=A0 osm_port_t *p_port;
> + =C2=A0 =C2=A0 =C2=A0 ib_net64_t port_guid;
> + =C2=A0 =C2=A0 =C2=A0 osm_physp_t *p_physp_remote;
> + =C2=A0 =C2=A0 =C2=A0 osm_node_t *remote_node;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_mcast_work_obj_t *wobj;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(sm->p_log);
>
> - =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0For each member of the multicast =
group, compute the
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0number of hops to its base LID.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D cl_qlist_head(l); i !=3D cl_qlist_e=
nd(l); i =3D cl_qlist_next(i)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wobj =3D cl_item_o=
bj(i, wobj, list_item);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops +=3D osm_swit=
ch_get_port_least_hops(p_sw, wobj->p_port);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_ports++;
> + =C2=A0 =C2=A0 =C2=A0 cl_qmap_init(p_mcast_member_sw_tbl);
> + =C2=A0 =C2=A0 =C2=A0 for (list_item =3D cl_qlist_head(port_list);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_item !=3D cl_qlist_en=
d(port_list);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_item =3D cl_qlist_nex=
t(list_item)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wobj =3D cl_item_o=
bj(list_item, wobj, list_item);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_port =3D wobj->p=
_port;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!p_port)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_port->p_node=
->sw) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* for switches - remote switch would be the switch itself */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 remote_node =3D osm_physp_get_node_ptr(p_port->p_physp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_physp_remote =3D osm_physp_get_remote(p_port->p_physp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 remote_node =3D osm_physp_get_node_ptr(p_physp_remote);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* get the remote =
switch of the mcmember */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remote_sw =3D remo=
te_node->sw;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port_guid =3D osm_=
node_get_node_guid(remote_node);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cl_qmap_get(p_=
mcast_member_sw_tbl, port_guid) =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_qmap_end(p_mcast_member_sw_tbl)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* insert switch to table */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_qmap_insert(p_mcast_member_sw_tb=
l, port_guid, &remote_sw->mgrp_item);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* New element in the table */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (osm_node_get_type(p_port->p_nod=
e) =3D=3D IB_NODE_TYPE_CA)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* for =
HCA update the MC count on the remote switch */

Should this be !=3D IB_NODE_TYPE_SWITCH so that both CAs and routers ar=
e
included here ?

-- Hal

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remote_=
sw->num_of_mcm++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* the =
switch is MC memeber */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remote_=
sw->is_mc_member =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 OSM_LOG_EXIT(sm->p_log);
> +}
>
> - =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0We should be here if there aren't=
 any ports in the group.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(num_ports);
> +static void mcast_mgr_destroy_switch_map(osm_sm_t * sm,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_qmap_t *p_mcast_member_sw_tbl)
> +{
> + =C2=A0 =C2=A0 =C2=A0 cl_map_item_t *p_item;
> + =C2=A0 =C2=A0 =C2=A0 osm_switch_t *p_sw;
>
> - =C2=A0 =C2=A0 =C2=A0 if (num_ports !=3D 0)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 avg_hops =3D (floa=
t)(hops / num_ports);
> + =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(sm->p_log);
>
> + =C2=A0 =C2=A0 =C2=A0 p_item =3D cl_qmap_head(p_mcast_member_sw_tbl)=
;
> + =C2=A0 =C2=A0 =C2=A0 while (p_item !=3D cl_qmap_end(p_mcast_member_=
sw_tbl)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw =3D PARENT_ST=
RUCT(p_item, osm_switch_t, mgrp_item);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->num_of_mcm =3D=
 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->is_mc_member=
 =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_item =3D cl_qmap=
_next(p_item);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 cl_qmap_remove_all(p_mcast_member_sw_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_EXIT(sm->p_log);
> - =C2=A0 =C2=A0 =C2=A0 return avg_hops;
> =C2=A0}
>
> =C2=A0/**************************************************************=
********
> =C2=A0Calculate the maximal "min hops" from the given switch to any
> =C2=A0of the group HCAs
> =C2=A0***************************************************************=
*******/
> -static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_=
t * l,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 const osm_switch_t * p_sw)
> +#ifdef OSM_VENDOR_INTF_ANAFA
> +static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t=
 * m,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 const osm_switch_t * this_sw)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 uint32_t max_hops =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 float avg_hops =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t hops =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 cl_list_item_t *i;
> - =C2=A0 =C2=A0 =C2=A0 osm_mcast_work_obj_t *wobj;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t num_ports =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t lid;
> + =C2=A0 =C2=A0 =C2=A0 uint32_t least_hops;
> + =C2=A0 =C2=A0 =C2=A0 cl_map_item_t *i;
> + =C2=A0 =C2=A0 =C2=A0 osm_switch_t *sw;
> +
> + =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(sm->p_log);
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D cl_qmap_head(m); i !=3D cl_qmap_end=
(m); i =3D cl_qmap_next(i)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sw =3D cl_item_obj=
(i, sw, mcast_item);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lid =3D cl_ntoh16(=
osm_node_get_base_lid(sw->p_node, 0));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 least_hops =3D osm=
_switch_get_least_hops(this_sw, lid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* for all host th=
at are MC members and attached to the switch,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0we sh=
ould add the (least_hops + 1) * number_of_such_hosts.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If sw=
itch itself is in the MC, we should add the least_hops only */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops +=3D (least_h=
ops + 1) * sw->num_of_mcm +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 leas=
t_hops * sw->is_mc_member;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_ports +=3D sw-=
>num_of_mcm + sw->is_mc_member;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* We should be here if there aren't any ports=
 in the group. */
> + =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(num_ports);
> +
> + =C2=A0 =C2=A0 =C2=A0 avg_hops =3D (float)(hops / num_ports);
> +
> + =C2=A0 =C2=A0 =C2=A0 OSM_LOG_EXIT(sm->p_log);
> + =C2=A0 =C2=A0 =C2=A0 return avg_hops;
> +}
> +#else
> +static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qmap_t=
 * m,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 const osm_switch_t * this_sw)
> +{
> + =C2=A0 =C2=A0 =C2=A0 uint32_t max_hops =3D 0, hops;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t lid;
> + =C2=A0 =C2=A0 =C2=A0 cl_map_item_t *i;
> + =C2=A0 =C2=A0 =C2=A0 osm_switch_t *sw;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(sm->p_log);
>
> @@ -208,9 +277,11 @@ static float osm_mcast_mgr_compute_max_hops(osm_=
sm_t * sm, cl_qlist_t * l,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 For each member of the multicast g=
roup, compute the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 number of hops to its base LID.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D cl_qlist_head(l); i !=3D cl_qlist_e=
nd(l); i =3D cl_qlist_next(i)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wobj =3D cl_item_o=
bj(i, wobj, list_item);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D osm_switc=
h_get_port_least_hops(p_sw, wobj->p_port);
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D cl_qmap_head(m); i !=3D cl_qmap_end=
(m); i =3D cl_qmap_next(i)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sw =3D cl_item_obj=
(i, sw, mgrp_item);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lid =3D cl_ntoh16(=
osm_node_get_base_lid(sw->p_node, 0));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D osm_switc=
h_get_least_hops(this_sw, lid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D (hops + 1=
) * sw->num_of_mcm + hops * sw->is_mc_member;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (hops > max=
_hops)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0max_hops =3D hops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> @@ -222,6 +293,7 @@ static float osm_mcast_mgr_compute_max_hops(osm_s=
m_t * sm, cl_qlist_t * l,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_EXIT(sm->p_log);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return (float)max_hops;
> =C2=A0}
> +#endif
>
> =C2=A0/**************************************************************=
********
> =C2=A0 =C2=A0This function attempts to locate the optimal switch for =
the
> @@ -230,32 +302,30 @@ static float osm_mcast_mgr_compute_max_hops(osm=
_sm_t * sm, cl_qlist_t * l,
> =C2=A0 =C2=A0of the multicast group.
> =C2=A0***************************************************************=
*******/
> =C2=A0static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * s=
m,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qlist_t *list)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qlist_t * list)
> =C2=A0{
> + =C2=A0 =C2=A0 =C2=A0 cl_qmap_t mgrp_sw_map;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_qmap_t *p_sw_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0osm_switch_t *p_sw, *p_best_sw =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0float hops =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0float best_hops =3D 10000; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* any big # will do */
> -#ifdef OSM_VENDOR_INTF_ANAFA
> - =C2=A0 =C2=A0 =C2=A0 boolean_t use_avg_hops =3D TRUE; =C2=A0/* anaf=
a2 - bug hca on switch *//* use max hops for root */
> -#else
> - =C2=A0 =C2=A0 =C2=A0 boolean_t use_avg_hops =3D FALSE; /* use max h=
ops for root */
> -#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_ENTER(sm->p_log);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_sw_tbl =3D &sm->p_subn->sw_guid_tbl;
>
> + =C2=A0 =C2=A0 =C2=A0 mcast_mgr_build_switch_map(sm, list, &mgrp_sw_=
map);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (p_sw =3D (osm_switch_t *) cl_qmap_hea=
d(p_sw_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw !=3D (osm_switch_t *) =
cl_qmap_end(p_sw_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw =3D (osm_switch_t *) c=
l_qmap_next(&p_sw->map_item)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!osm_switc=
h_supports_mcast(p_sw))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (use_avg_hops)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 hops =3D osm_mcast_mgr_compute_avg_hops(sm, list, p_sw);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 hops =3D osm_mcast_mgr_compute_max_hops(sm, list, p_sw);
> +#ifdef OSM_VENDOR_INTF_ANAFA
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D osm_mcast=
_mgr_compute_avg_hops(sm, &mgrp_sw_map, p_sw);
> +#else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D osm_mcast=
_mgr_compute_max_hops(sm, &mgrp_sw_map, p_sw);
> +#endif
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG(sm->p_=
log, OSM_LOG_DEBUG,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0"Switch 0x%016" PRIx64 ", hops =3D %f\n",
> @@ -276,6 +346,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switc=
h(osm_sm_t * sm,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG(sm->p_=
log, OSM_LOG_VERBOSE,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0"No multicast capable switches detected\n");
>
> + =C2=A0 =C2=A0 =C2=A0 mcast_mgr_destroy_switch_map(sm, &mgrp_sw_map)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OSM_LOG_EXIT(sm->p_log);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return p_best_sw;
> =C2=A0}
> --
> 1.6.6.1
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

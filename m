From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Multicast root switch calculation
Date: Wed, 3 Feb 2010 12:34:28 +0200
Message-ID: <20100203103428.GW26338@me>
References: <4B17C712.9010109@Voltaire.COM>
 <20100120102703.GB25576@me>
 <39C75744D164D948A170E9792AF8E7CA01F6FA8A@exil.voltaire.com>
 <20100120115936.GC25576@me>
 <20100127104503.GM26338@me>
 <f0e08f231001280739m31dae78cj5ab7bd78621dcbfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001280739m31dae78cj5ab7bd78621dcbfc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:39 Thu 28 Jan     , Hal Rosenstock wrote:
> On Wed, Jan 27, 2010 at 5:45 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> > On 13:59 Wed 20 Jan =A0 =A0 , Sasha Khapyorsky wrote:
> >> On 13:32 Wed 20 Jan =A0 =A0 , Slava Strebkov wrote:
> >> > "average hops" was chosen instead of "max hops" because in root =
weight
> >> > calculation the number of ports is also important, not only the =
distance
> >> > (hops).
> >>
> >> But this patch is declared as root switch calculation optimization=
, not
> >> as algorithm change (actually I even missed this part in V1).
> >
> > I reworked this patch preserving original ("max hops") calculation
> > method. Please look at this.
> >
> > The next step is to evaluate "max hops" -> "average hops" switch an=
d to
> > cleanup OSM_VENDOR_INTF_ANAFA macro.
> >
> > Sasha
> >
> >
> > From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
> > Date: Thu, 3 Dec 2009 16:11:30 +0200
> > Subject: [PATCH] opensm: Multicast root switch calculation
> >
> > Proposed new algorithm for calculation of root switch for multicast
> > spanning tree. Only edge switches(those connected to hosts)
>=20
> What about switches whose peer port is a router ? Shouldn't they be
> included here ?

Yes.

>=20
> > and
> > switches - multicast members themselves are involved in root calcul=
ation.
> > This gives improvement, especially on large fabrics, since number o=
f
> > switches usually much less then the number of ports, shared same mc=
ast
> > group.
> >
> > Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > ---
> > =A0opensm/include/opensm/osm_switch.h | =A0 12 +++
> > =A0opensm/opensm/osm_mcast_mgr.c =A0 =A0 =A0| =A0149 ++++++++++++++=
++++++++++++---------
> > =A02 files changed, 122 insertions(+), 39 deletions(-)
> >
> > diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/op=
ensm/osm_switch.h
> > index 205896d..cb6e5ac 100644
> > --- a/opensm/include/opensm/osm_switch.h
> > +++ b/opensm/include/opensm/osm_switch.h
> > @@ -109,6 +109,9 @@ typedef struct osm_switch {
> > =A0 =A0 =A0 =A0unsigned endport_links;
> > =A0 =A0 =A0 =A0unsigned need_update;
> > =A0 =A0 =A0 =A0void *priv;
> > + =A0 =A0 =A0 cl_map_item_t mgrp_item;
> > + =A0 =A0 =A0 uint32_t num_of_mcm;
> > + =A0 =A0 =A0 uint8_t is_mc_member;
> > =A0} osm_switch_t;
> > =A0/*
> > =A0* FIELDS
> > @@ -151,6 +154,15 @@ typedef struct osm_switch {
> > =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0When set indicates that switch was =
probably reset, so
> > =A0* =A0 =A0 =A0 =A0 =A0 =A0 =A0fwd tables and rest cached data sho=
uld be flushed
> > =A0*
> > +* =A0 =A0 =A0mgrp_item
> > +* =A0 =A0 =A0 =A0 =A0 =A0 =A0map item for switch in building mcast=
 tree
> > +*
> > +* =A0 =A0 =A0num_of_mcm
> > +* =A0 =A0 =A0 =A0 =A0 =A0 =A0number of mcast members(ports) connec=
ted to switch
> > +*
> > +* =A0 =A0 =A0is_mc_member
> > +* =A0 =A0 =A0 =A0 =A0 =A0 =A0whether switch is a mcast member itse=
lf
> > +*
> > =A0* SEE ALSO
> > =A0* =A0 =A0 =A0Switch object
> > =A0*********/
> > diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcas=
t_mgr.c
> > index dce9f2b..5c9d0bc 100644
> > --- a/opensm/opensm/osm_mcast_mgr.c
> > +++ b/opensm/opensm/osm_mcast_mgr.c
> > @@ -157,50 +157,119 @@ static void mcast_mgr_purge_tree(osm_sm_t * =
sm, IN osm_mgrp_box_t * mbox)
> > =A0 =A0 =A0 =A0OSM_LOG_EXIT(sm->p_log);
> > =A0}
> >
> > -static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qlis=
t_t * l,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 const osm_switch_t * p_sw)
> > +static void mcast_mgr_build_switch_map(osm_sm_t * sm,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0const cl_qlist_t * port_list,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cl_qmap_t * p_mcast_member_sw_tbl)
> > =A0{
> > - =A0 =A0 =A0 float avg_hops =3D 0;
> > - =A0 =A0 =A0 uint32_t hops =3D 0;
> > - =A0 =A0 =A0 uint32_t num_ports =3D 0;
> > - =A0 =A0 =A0 cl_list_item_t *i;
> > + =A0 =A0 =A0 osm_switch_t *remote_sw;
> > + =A0 =A0 =A0 cl_list_item_t *list_item;
> > + =A0 =A0 =A0 osm_port_t *p_port;
> > + =A0 =A0 =A0 ib_net64_t port_guid;
> > + =A0 =A0 =A0 osm_physp_t *p_physp_remote;
> > + =A0 =A0 =A0 osm_node_t *remote_node;
> > =A0 =A0 =A0 =A0osm_mcast_work_obj_t *wobj;
> >
> > =A0 =A0 =A0 =A0OSM_LOG_ENTER(sm->p_log);
> >
> > - =A0 =A0 =A0 /*
> > - =A0 =A0 =A0 =A0 =A0For each member of the multicast group, comput=
e the
> > - =A0 =A0 =A0 =A0 =A0number of hops to its base LID.
> > - =A0 =A0 =A0 =A0*/
> > - =A0 =A0 =A0 for (i =3D cl_qlist_head(l); i !=3D cl_qlist_end(l); =
i =3D cl_qlist_next(i)) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wobj =3D cl_item_obj(i, wobj, list_it=
em);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 hops +=3D osm_switch_get_port_least_h=
ops(p_sw, wobj->p_port);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_ports++;
> > + =A0 =A0 =A0 cl_qmap_init(p_mcast_member_sw_tbl);
> > + =A0 =A0 =A0 for (list_item =3D cl_qlist_head(port_list);
> > + =A0 =A0 =A0 =A0 =A0 =A0list_item !=3D cl_qlist_end(port_list);
> > + =A0 =A0 =A0 =A0 =A0 =A0list_item =3D cl_qlist_next(list_item)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wobj =3D cl_item_obj(list_item, wobj,=
 list_item);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_port =3D wobj->p_port;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!p_port)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (p_port->p_node->sw) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* for switches - rem=
ote switch would be the switch itself */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 remote_node =3D osm_p=
hysp_get_node_ptr(p_port->p_physp);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_physp_remote =3D os=
m_physp_get_remote(p_port->p_physp);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 remote_node =3D osm_p=
hysp_get_node_ptr(p_physp_remote);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* get the remote switch of the mcmem=
ber */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 remote_sw =3D remote_node->sw;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_guid =3D osm_node_get_node_guid(=
remote_node);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cl_qmap_get(p_mcast_member_sw_tbl=
, port_guid) =3D=3D
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_qmap_end(p_mcast_m=
ember_sw_tbl)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* in=
sert switch to table */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_qm=
ap_insert(p_mcast_member_sw_tbl, port_guid, &remote_sw->mgrp_item);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Ne=
w element in the table */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (o=
sm_node_get_type(p_port->p_node) =3D=3D IB_NODE_TYPE_CA)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* for HCA update the MC count on the remote switch */
>=20
> Should this be !=3D IB_NODE_TYPE_SWITCH so that both CAs and routers =
are
> included here ?

Yes, obviously.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

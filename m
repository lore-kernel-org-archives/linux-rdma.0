From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_trap_rcv.c: In trap_rcv_process_request, no
 need to sweep on trap 145 and certain trap 144s
Date: Sun, 1 Nov 2009 17:49:29 +0200
Message-ID: <20091101154929.GC29434@me>
References: <20090805222737.GA8523@comcast.net>
 <20091030015711.GS20136@me>
 <f0e08f230910300823j56edb800nf88efca23165bf5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910300823j56edb800nf88efca23165bf5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:23 Fri 30 Oct     , Hal Rosenstock wrote:
> >
> > In general: function trap_rcv_process_request() already has 400 lin=
es of
> > code and adding there more lines without simplifying flows makes me
> > nervous.
>=20
> Are you going to block this change until such restructure ?

I would prefer to improve it at least in a part where patch adds even
more flows. Also there are many issues yet without restructuring.

>=20
> >> - =A0 =A0 /* Check for node description update. IB Spec v1.2.1 pg =
823 */
> >> - =A0 =A0 if (ib_notice_is_generic(p_ntci) &&
> >> - =A0 =A0 =A0 =A0 cl_ntoh16(p_ntci->g_or_v.generic.trap_num) =3D=3D=
 144 &&
> >> - =A0 =A0 =A0 =A0 p_ntci->data_details.ntc_144.local_changes & TRA=
P_144_MASK_OTHER_LOCAL_CHANGES &&
> >> - =A0 =A0 =A0 =A0 p_ntci->data_details.ntc_144.change_flgs & TRAP_=
144_MASK_NODE_DESCRIPTION_CHANGE) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_INFO, "Trap 1=
44 Node description update\n");
> >> -
> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (p_physp) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_PLOCK_ACQUIRE(sm->p_l=
ock);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 osm_req_get_node_desc(sm=
, p_physp);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_PLOCK_RELEASE(sm->p_l=
ock);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 } else
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_L=
OG_ERROR,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ERR 381=
2: No physical port found for "
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "trap 14=
4: \"node description update\"\n");
> >> - =A0 =A0 }
> >> + =A0 =A0 if (ib_notice_is_generic(p_ntci)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* Check for node description update. IB=
 Spec v1.2.1 pg 823 */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (cl_ntoh16(p_ntci->g_or_v.generic.tra=
p_num) =3D=3D 144) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update port's capabil=
ity mask (in PortInfo) */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_physp->port_info.capab=
ility_mask =3D p_ntci->data_details.ntc_144.new_cap_mask;
> >
> > Hmm, could this introduce some issues?
>=20
> Like what ?

Like ignoring isSM bit and maybe some other "problematic" bits which
required SM DB update.

>=20
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (p_ntci->data_details=
=2Entc_144.local_changes & TRAP_144_MASK_OTHER_LOCAL_CHANGES) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (p_nt=
ci->data_details.ntc_144.change_flgs & TRAP_144_MASK_NODE_DESCRIPTION_C=
HANGE) {
> >
> > =A0 =A0 =A0 =A0if ((p_ntci->data_details.ntc_144.local_changes &
> > =A0 =A0 =A0 =A0 =A0 =A0 TRAP_144_MASK_OTHER_LOCAL_CHANGES) &&
> > =A0 =A0 =A0 =A0 =A0 =A0(p_ntci->data_details.ntc_144.change_flgs &
> > =A0 =A0 =A0 =A0 =A0 =A0 TRAP_144_MASK_NODE_DESCRIPTION_CHANGE)) {
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_INFO,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 "Trap 144 Node description update\n");
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 if (p_physp) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 CL_PLOCK_ACQUIRE(sm->p_lock);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 osm_req_get_node_desc(sm, p_physp);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 CL_PLOCK_RELEASE(sm->p_lock);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_ERROR,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ERR 3812: No physical port fou=
nd for "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "trap 144: \"node description u=
pdate\"\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (p_ntci->data_details=
=2Entc_144.change_flgs & TRAP_144_MASK_LINK_WIDTH_ENABLE_CHANGE ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_ntci->data_det=
ails.ntc_144.change_flgs & TRAP_144_MASK_LINK_SPEED_ENABLE_CHANGE ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_ntci->data_det=
ails.ntc_144.change_flgs & TRAP_144_MASK_SM_PRIORITY_CHANGE)
> >
> > =A0 =A0 =A0 =A0if ((p_ntci->data_details.ntc_144.change_flgs &
> > =A0 =A0 =A0 =A0 =A0 =A0 (TRAP_144_MASK_LINK_WIDTH_ENABLE_CHANGE |
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0TRAP_144_MASK_LINK_SPEED_ENABLE_CHANGE |
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0TRAP_144_MASK_SM_PRIORITY_CHANGE)))
> >
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_trap1=
44_sweep =3D TRUE;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 /* do a sweep if we received a trap */
> >> - =A0 =A0 if (sm->p_subn->opt.sweep_on_trap) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 /* if this is trap number 128 or run_hea=
vy_sweep is TRUE -
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0update the force_heavy_sweep flag=
 of the subnet.
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Sweep also on traps 144/145 - the=
se traps signal a change of
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0certain port capabilities/system =
image guid.
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TODO: In the future this can be c=
hanged to just getting
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PortInfo on this port instead of =
sweeping the entire subnet. */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (ib_notice_is_generic(p_ntci) &&
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cl_ntoh16(p_ntci->g_or_v.generi=
c.trap_num) =3D=3D 128 ||
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cl_ntoh16(p_ntci->g_or_v.gene=
ric.trap_num) =3D=3D 144 ||
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cl_ntoh16(p_ntci->g_or_v.gene=
ric.trap_num) =3D=3D 145 ||
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0run_heavy_sweep)) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_L=
OG_VERBOSE,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Forcing=
 heavy sweep. Received trap:%u\n",
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh1=
6(p_ntci->g_or_v.generic.trap_num));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (cl_ntoh16(p_ntci->g_or_v.generic.tra=
p_num) =3D=3D 145) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update system image g=
uid (in NodeInfo) */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_node =3D osm_physp_get=
_node_ptr(p_physp);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (p_node)
> >
> > When 'p_node' could be NULL?
>=20
> It's just a possible return from osm_physp_get_node_ptr and wanted to
> be sure this was not the case before setting node_info. Should this b=
e
> eliminated ?

If p_physp->p_node cannot be NULL legally, then the check should be
eliminated in order to not hide an errors and to not eat cpu cycles.

>=20
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_node->=
node_info.node_guid =3D p_ntci->data_details.ntc_145.new_sys_guid;
> >
> > Didn't you mean 'node_info.sys_guid' and 'node_info.node_guid'?
>=20
> Just sys_guid.

Sorry typo, I tried to ask: shouldn't be:

	p_node->node_info.sys_guid =3D p_ntci->data_details.ntc_145.new_sys_gu=
id;

, instead?

>=20
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* do a sweep if we received a trap */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (sm->p_subn->opt.sweep_on_trap) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if this is trap numbe=
r 128 or run_heavy_sweep is
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TRUE - update the=
 force_heavy_sweep flag of the
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0subnet. Also, swe=
ep on certain types of trap 144.
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TODO: In the futu=
re this can be changed to just
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0getting PortInfo =
on this port instead of sweeping
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the entire subnet=
=2E */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cl_ntoh16(p_ntci->g_=
or_v.generic.trap_num) =3D=3D 128 ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_trap144_sweep=
 || run_heavy_sweep) {
> >
> > It looks that prevents sweeping on PortInfo:CapMask change which
> > is effectively breaks at least SM handover - new SM will be undetec=
ted.
>=20
> Yes, CapMask change should be included along with the other local
> changes to cause sweep.

So this should change the patch.=20

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

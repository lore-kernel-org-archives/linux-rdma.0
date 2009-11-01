From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add initial support for optimized
 SLtoVLMappingTable programming
Date: Sun, 1 Nov 2009 17:19:57 +0200
Message-ID: <20091101151957.GB29434@me>
References: <20090804131836.GA15226@comcast.net>
 <20091030022324.GT20136@me>
 <f0e08f230910300840t2902ea50ye20420694fd7ef7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910300840t2902ea50ye20420694fd7ef7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:40 Fri 30 Oct     , Hal Rosenstock wrote:
> >> @@ -150,7 +151,7 @@ static ib_api_status_t vlarb_update(osm_sm_t *=
 sm, osm_physp_t * p,
> >>
> >> =A0static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_ph=
ysp_t * p,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 uint8_t in_port, uint8_t out_port,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 unsigned force_update,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 unsigned optimize, unsigned force_update,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 const ib_slvl_table_t * sl2vl_table)
> >> =A0{
> >> =A0 =A0 =A0 osm_madw_context_t context;
> >> @@ -177,10 +178,18 @@ static ib_api_status_t sl2vl_update_table(os=
m_sm_t * sm, osm_physp_t * p,
> >> =A0 =A0 =A0 =A0 =A0 !memcmp(p_tbl, &tbl, sizeof(tbl)))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IB_SUCCESS;
> >>
> >> + =A0 =A0 /* both input port and output port wildcarded */
> >> + =A0 =A0 if (optimize && (in_port !=3D 1 || out_port !=3D 1))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return IB_SUCCESS;
> >> +
> >
> > This function (sl2vl_update_table()) is called for each in and out =
ports
> > combination. I think that instead of calling it N * N times and
> > filtering out the case 'in =3D=3D out =3D=3D 1' you just need it on=
ce somewhere
> > at higher layer.
>=20
> I was trying to minimize the changes to the current code flow. It can
> be done the way you propose but that will cause larger changes. Are
> you sure about this direction ?

I'm sure that that we don't need a bunch of empty loops. Also I think
that doing this on an appropriate layer will not complicate things more=
=2E

> >> @@ -72,7 +73,9 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
> >> =A0 =A0 =A0 osm_slvl_context_t *p_context;
> >> =A0 =A0 =A0 ib_net64_t port_guid;
> >> =A0 =A0 =A0 ib_net64_t node_guid;
> >> - =A0 =A0 uint8_t out_port_num, in_port_num;
> >> + =A0 =A0 uint32_t attr_mod;
> >> + =A0 =A0 uint8_t out_port_num, in_port_num, startinport, startout=
port,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 endinport, endoutport;
> >>
> >> =A0 =A0 =A0 CL_ASSERT(sm);
> >>
> >> @@ -111,6 +114,9 @@ void osm_slvl_rcv_process(IN void *context, IN=
 void *p_data)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (uint8_t) cl_ntoh32(p_smp->att=
r_mod & 0xFF000000);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 in_port_num =3D
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (uint8_t) cl_ntoh32((p_smp->at=
tr_mod & 0x00FF0000) << 8);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 attr_mod =3D cl_ntoh32(p_smp->attr_mod);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (attr_mod & 0x30000)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto opt_sl2vl;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_physp =3D osm_node_get_physp_ptr(p_n=
ode, out_port_num);
> >> =A0 =A0 =A0 } else {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_physp =3D p_port->p_physp;
> >> @@ -123,7 +129,7 @@ void osm_slvl_rcv_process(IN void *context, IN=
 void *p_data)
> >> =A0 =A0 =A0 =A0 =A0all we want is to update the subnet.
> >> =A0 =A0 =A0 =A0*/
> >> =A0 =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 "Got SLtoVL get response in_port_num %u =
out_port_num %u with "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 "Received SLtoVL GetResp in_port_num %u =
out_port_num %u with "
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "GUID 0x%" PRIx64 " for parent node GU=
ID 0x%" PRIx64 ", TID 0x%"
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 PRIx64 "\n", in_port_num, out_port_num=
, cl_ntoh64(port_guid),
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh64(node_guid), cl_ntoh64(p_smp-=
>trans_id));
> >> @@ -142,6 +148,39 @@ void osm_slvl_rcv_process(IN void *context, I=
N void *p_data)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_po=
rt_num, p_slvl_tbl, OSM_LOG_DEBUG);
> >>
> >> =A0 =A0 =A0 osm_physp_set_slvl_tbl(p_physp, p_slvl_tbl, in_port_nu=
m);
> >> + =A0 =A0 goto Exit;
> >> +
> >> +opt_sl2vl:
> >
> > I think that you need to use functions here.
>=20
> Where is here ? To what are you referring ?

When your function becomes to form of:

	if (cond1)
		goto do1;
=09
	do_else();

	goto exit;

do1:
	do_1();

exit:
	return;

I'm suggesting to improve flows, for example by using functions (or
another way if applicable and achieves the simplification goal).

>=20
> >> + =A0 =A0 OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 "Got optimized SLtoVL get response in_po=
rt_num %u out_port_num "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 "%u with GUID 0x%" PRIx64 " for parent n=
ode GUID 0x%" PRIx64
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ", TID 0x%" PRIx64 "\n", in_port_num, ou=
t_port_num,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh64(port_guid), cl_ntoh64(node_gui=
d),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh64(p_smp->trans_id));
> >> +
> >> + =A0 =A0 osm_dump_slvl_map_table(sm->p_log, port_guid, in_port_nu=
m,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_port=
_num, p_slvl_tbl, OSM_LOG_DEBUG);
> >> +
> >> + =A0 =A0 if (attr_mod & 0x10000) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 startoutport =3D ib_switch_info_is_enhan=
ced_port0(&p_node->sw->switch_info) ? 0 : 1;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 endoutport =3D osm_node_get_num_physp(p_=
node);
> >> + =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 endoutport =3D startoutport =3D out_port=
_num;
> >> + =A0 =A0 if (attr_mod & 0x20000) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 startinport =3D ib_switch_info_is_enhanc=
ed_port0(&p_node->sw->switch_info) ? 0 : 1;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 endinport =3D osm_node_get_num_physp(p_n=
ode);
> >> + =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 endinport =3D startinport =3D in_port_nu=
m;
> >> +
> >> + =A0 =A0 for (out_port_num =3D startoutport; out_port_num < endou=
tport;
> >> + =A0 =A0 =A0 =A0 =A0out_port_num++) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_physp =3D osm_node_get_physp_ptr(p_nod=
e, out_port_num);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!p_physp)
> >
> > When could this be NULL?
>=20
> It was just defensive. Should it be removed ?

I wasn't sure, so asked. If it is "just defensive" please remove it.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

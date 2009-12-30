From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
 received from network
Date: Wed, 30 Dec 2009 18:27:45 +0200
Message-ID: <20091230162745.GZ26940@me>
References: <20091201194110.GA26753@comcast.net>
 <20091229150528.GV26940@me>
 <20091229150735.GX26940@me>
 <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912300809l7c794daat9490c64a2cf63525-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:09 Wed 30 Dec     , Hal Rosenstock wrote:
> On Tue, Dec 29, 2009 at 10:07 AM, Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
> >
> > Verify that port number values received from network are in range a=
nd
> > valid for access. Report error otherwise.
>=20
> Won't this spam the OpenSM log ?

Yes, unfortunately. But unlike SA queries, etc., this is response to
OpenSM originated request and messing attribute modifier there is more
critical there than just invalid query from some client.

However basically I am sharing your concerns. Maybe we need a separate
log level for things like that (OSM_LOG_WARNING or so).

> > Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > ---
> > =A0opensm/opensm/osm_slvl_map_rcv.c | =A0 =A09 +++++++++
> > =A01 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_s=
lvl_map_rcv.c
> > index b35d867..6229db9 100644
> > --- a/opensm/opensm/osm_slvl_map_rcv.c
> > +++ b/opensm/opensm/osm_slvl_map_rcv.c
> > @@ -104,8 +104,17 @@ void osm_slvl_rcv_process(IN void *context, IN=
 void *p_data)
> >
> > =A0 =A0 =A0 =A0/* in case of a non switch node the attr modifier sh=
ould be ignored */
> > =A0 =A0 =A0 =A0if (osm_node_get_type(p_node) =3D=3D IB_NODE_TYPE_SW=
ITCH) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned num_ports =3D osm_node_get_n=
um_physp(p_node) - 1;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out_port_num =3D cl_ntoh32(p_smp->at=
tr_mod) & 0xff;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_port_num =3D (cl_ntoh32(p_smp->at=
tr_mod) >> 8) & 0xff;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (in_port_num > num_ports || out_po=
rt_num > num_ports) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(sm->p_log, OS=
M_LOG_ERROR, "ERR 2C07"
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Inva=
lid attribute modifier 0x%x reveived in"
>=20
>            ^^^^^^^^
>=20
>             typo

Thanks for finding. I'm fixing this.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

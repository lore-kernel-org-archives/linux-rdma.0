From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_link_mgr.c: In link_mgr_set_physp_pi, only
 call link_mgr_get_smsl when LID valid
Date: Sat, 31 Oct 2009 14:12:12 +0200
Message-ID: <20091031121212.GA9479@me>
References: <20091030004732.GP20136@me>
 <1830724148.4221541256937456735.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
 <f0e08f230910301631x639a6670x8fbe184580964f9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910301631x639a6670x8fbe184580964f9a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 19:31 Fri 30 Oct     , Hal Rosenstock wrote:
> Hi Sasha,
>=20
> On Fri, Oct 30, 2009 at 5:17 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> >
> > Hi Hal,
> >
> > On 09:27 Wed 23 Sep =A0 =A0 , Hal Rosenstock wrote:
> >>
> >> Fix seg fault which occurs when get_osm_switch_from_port is
> >> called with NULL port (which in this case was caused by calling
> >> cl_ptr_vector_get on port LID table with LID 0)
> >
> > Would be really useful to describe when and why this (LID =3D 0) ca=
n
> > happen.
>=20
> Thought we resolved this in "osm_link_mgr.c:link_mgr_get_smsl questio=
n" thread.

It is not for me. It is a change log and people which can read this
over years may not follow any mailing thread on the list.

> > diff --git a/opensm/opensm/osm_link_mgr.c b/opensm/opensm/osm_link_=
mgr.c
> > index 4d4be56..217f51e 100644
> > --- a/opensm/opensm/osm_link_mgr.c
> > +++ b/opensm/opensm/osm_link_mgr.c
> > @@ -68,7 +68,8 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm=
, IN
> > osm_physp_t * p_physp)
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0OSM_LOG_ENTER(sm->p_log);
> >
> > -=A0=A0=A0=A0=A0=A0=A0=A0if (p_osm->routing_engine_used !=3D OSM_RO=
UTING_ENGINE_TYPE_LASH) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0if (p_osm->routing_engine_used !=3D OSM_RO=
UTING_ENGINE_TYPE_LASH
> > +=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0|| !(slid =3D osm_physp_get_base_l=
id(p_physp))) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Use default S=
L if lash routing is not used */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0OSM_LOG_EXIT(sm-=
>p_log);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return (sm->p_su=
bn->opt.sm_sl);
> > @@ -80,7 +81,6 @@ static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm=
, IN
> > osm_physp_t * p_physp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0cl_ptr_vector_get(&sm->p_subn->p=
ort_lid_tbl, cl_ntoh16(smlid));
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0/* Find osm_port of the source =3D p_phy=
sp */
> > -=A0=A0=A0=A0=A0=A0=A0=A0slid =3D osm_physp_get_base_lid(p_physp);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0p_src_port =3D
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0cl_ptr_vector_get(&sm->p_subn->p=
ort_lid_tbl, cl_ntoh16(slid));
> >
> >
> > Wouldn't it be the same functionally?
>=20
> Yes,
>=20
> Do you want an updated patch ?

No need, I have it already.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/qos.c: Revert port ranges for calls to
 sl2vl_update_table().
Date: Mon, 31 May 2010 02:56:16 +0300
Message-ID: <20100530235616.GK28549@me>
References: <1851_1274473140_o4LKDZ3n001852_1274473115-3153-1-git-send-email-jaschut@sandia.gov>
 <1274473795.4773.43.camel@sale659.sandia.gov>
 <AANLkTimzCMA8sdpT7W7bpBnb0fqdEhA5I3j-6Vqc7S2L@mail.gmail.com>
 <1274737321.4773.68.camel@sale659.sandia.gov>
 <AANLkTimrixibqJWr4zIeSYRUH4-Y1_BOqOGCvuEMNOmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimrixibqJWr4zIeSYRUH4-Y1_BOqOGCvuEMNOmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 11:57 Tue 25 May     , Hal Rosenstock wrote:
>=20
> > --- a/opensm/opensm/osm_qos.c
> > +++ b/opensm/opensm/osm_qos.c
> > @@ -233,7 +233,8 @@ static int qos_extports_setup(osm_sm_t * sm, os=
m_node_t *node,
> > =A0 =A0 =A0 =A0for (i =3D 0; i < num_ports; i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p =3D osm_node_get_physp_ptr(node, i=
);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0force_update =3D p->need_update || s=
m->p_subn->need_update;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 1; j < num_ports; j++)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 j =3D ib_switch_info_is_enhanced_port=
0(&node->sw->switch_info) ? 0 : 1;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; j < num_ports; j++)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sl2vl_update_tab=
le(sm, p, i, i << 8 | j,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 force_update, &qcfg->sl2vl))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =
=3D -1;
> >
> > Does that look OK to you?
>=20
> Yes.

Could you repost up to date version of the patch? Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

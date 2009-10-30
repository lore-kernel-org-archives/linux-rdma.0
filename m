From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually
 configured mlid
Date: Fri, 30 Oct 2009 23:31:25 +0200
Message-ID: <20091030213125.GE5829@me>
References: <4AEAEA86.8080309@systemfabricworks.com>
 <f0e08f230910300648m4d802f57w2910cea678a3cd1f@mail.gmail.com>
 <20091030200620.GB5829@me>
 <f0e08f230910301344j5b9564a5k9b77fd4e43e48376@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910301344j5b9564a5k9b77fd4e43e48376-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16:44 Fri 30 Oct     , Hal Rosenstock wrote:
> >
> > diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcas=
t_tbl.c
> > index 0a45904..a599e56 100644
> > --- a/opensm/opensm/osm_mcast_tbl.c
> > +++ b/opensm/opensm/osm_mcast_tbl.c
> > @@ -245,8 +245,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_=
t * p_tbl, IN uint16_t mlid_ho)
> > =A0 =A0 =A0 =A0CL_ASSERT(p_tbl);
> > =A0 =A0 =A0 =A0CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_HO);
> >
> > - =A0 =A0 =A0 if (p_tbl->p_mask_tbl && mlid_ho <=3D p_tbl->max_mlid=
_ho) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAS=
T_START_HO;
> > + =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAST_START_HO;
> > + =A0 =A0 =A0 if (p_tbl->p_mask_tbl && mlid_offset < p_tbl->mft_dep=
th) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i <=3D p_tbl->max_posi=
tion; i++)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(*p_tbl->p_mask_tbl)=
[mlid_offset][i] =3D 0;
> > =A0 =A0 =A0 =A0}
> >
> > Does it make sense?
>=20
> Yes, that fixes the removal issue.
>=20
> Tested-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks I will apply the patch.

Yet another (likely even more efficient) approach would be memset()ing
MFTs in realloc function above requested mlid_offset, then we will be
able to remove osm_mcast_tbl_clear_mlid() completely.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

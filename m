From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by multicast routing
 tables (MFTs)
Date: Fri, 16 Oct 2009 14:24:06 +0200
Message-ID: <20091016122406.GQ20210@me>
References: <20091014213546.GA32163@comcast.net>
 <20091015204233.GG20210@me>
 <f0e08f230910151535p4aed8827p29f7887d0161dbf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910151535p4aed8827p29f7887d0161dbf-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18:35 Thu 15 Oct     , Hal Rosenstock wrote:
> >> @@ -138,6 +122,51 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p=
_tbl, IN uint16_t mlid_ho,
> >>
> >> =A0/**************************************************************=
********
> >> =A0 **************************************************************=
********/
> >> +void
> >> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IN osm_su=
bn_t * p_subn, IN uintn_t mlid_offset)
> >
> > I would suggest to simplify the function name to something like
> > 'osm_mcast_tbl_realloc()' - osm_mcast_tbl API doesn't have any
> > information about a buffer internal structure.
> >
> >
> >> +{
> >> + =A0 =A0 size_t mft_size, size;
> >> + =A0 =A0 uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
> >> +
> >> + =A0 =A0 if (mlid_offset < p_tbl->mft_size)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return;
> >> +
> >> + =A0 =A0 /*
> >> + =A0 =A0 =A0 =A0The number of bytes needed in the mask table is:
> >> + =A0 =A0 =A0 =A0The (maximum bit mask 'position' + 1) times the
> >> + =A0 =A0 =A0 =A0number of bytes in each bit mask times the
> >> + =A0 =A0 =A0 =A0number of MLIDs supported by the table.
> >> +
> >> + =A0 =A0 =A0 =A0We must always allocate the array with the maximu=
m position
> >> + =A0 =A0 =A0 =A0since it is (and must be) defined that way the ta=
ble structure
> >> + =A0 =A0 =A0 =A0in order to create a pointer to a two dimensional=
 array.
> >> + =A0 =A0 =A0*/
> >> + =A0 =A0 mft_size =3D (mlid_offset + IB_MCAST_BLOCK_SIZE) /
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IB_MCAST_BLOCK_SIZE * IB_MCAST_B=
LOCK_SIZE;
> >> + =A0 =A0 if (mft_size > (p_tbl->max_block + 1) * IB_MCAST_BLOCK_S=
IZE)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 mft_size =3D (p_tbl->max_block + 1) * IB=
_MCAST_BLOCK_SIZE;
> >
> > Hmm, wouldn't this:
> >
> > =A0 =A0 =A0 =A0mft_size =3D (mlid_offset / IB_MCAST_BLOCK_SIZE + 1)=
 * IB_MCAST_BLOCK_SIZE;
> >
> > do the same as lines above?
>=20
> What about the limit (max_block) check ?

If passed mlid_offset can exceed this then it is likely needed, but I'm
not sure that this is the case - then we are asking for more mlids than
a subnet is capable to handle and probably it is blocked somewhere
already (but I didn't check really).

> >> @@ -154,6 +183,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_m=
cast_tbl_t * p_tbl,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid=
_ho);
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAST=
_START_HO;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (mlid_offset >=3D p_tbl->mft_size)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FALSE;
> >
> > If you are introducing new field mft_size, I would also suggest to =
change
> > the meaning of max_mlid_ho field to be max configured mlid for this
> > table and not max capability mlid (which is almost duplicated by
> > num_entries field).
>=20
> Yes, almost duplicated.
>=20
> > I suppose that this can be done as separate patch.
> >
> > Then all such and similar (many below) checks should be performed a=
gainst
> > this actually configured max mlid and not against table size. As we
> > discussed already this prevents some bugs for 'max_mlid < table_siz=
e - 1'
> > case.
>=20
> I'll look at this subsequent to this patch.

I would suggest to make it first (guess that it is possible without
relation to MFT reallocation), so we will need to change all those
lines only once.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

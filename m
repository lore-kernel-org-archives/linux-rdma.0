From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv5] opensm: Reduce heap consumption by multicast routing
 tables (MFTs)
Date: Fri, 30 Oct 2009 21:55:45 +0200
Message-ID: <20091030195545.GA5829@me>
References: <20091023234856.GA1482@comcast.net>
 <20091029191732.GB20136@me>
 <f0e08f230910300647q274e4e76v70c60a978f84309c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910300647q274e4e76v70c60a978f84309c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 09:47 Fri 30 Oct     , Hal Rosenstock wrote:
> >> @@ -152,10 +166,11 @@ boolean_t osm_mcast_tbl_is_port(IN const osm=
_mcast_tbl_t * p_tbl,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(port_num <=3D
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (p_tbl->max_positi=
on + 1) * IB_MCAST_MASK_SIZE);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_ST=
ART_HO);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho <=3D (uint16_t) (IB_LI=
D_MCAST_START_HO +
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0p_tbl->num_entries - 1));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_h=
o);
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAST=
_START_HO;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (mlid_offset >=3D p_tbl->mft_depth)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FALSE;
> >
> > This duplicates CL_ASSERT() above.
>=20
> Not quite. There's a difference between max_mlid_ho and mft_depth.

And 'max_mlid_ho <=3D mft_depth + IB_LID_MCAST_START_HO - 1', isn't it?

> > Looking on how this function is used
> > I don't see why we this check should be introduced. Do you?
>=20
> It's needed for group removal to work properly.

Could you elaborate? osm_mcast_tbl_is_port() is called only from
osm_switch_recommend_mcast_path(), how is it related to group removal?

>=20
>=20
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mask_offset =3D port_num / IB_MCAST_MA=
SK_SIZE;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bit_mask =3D cl_ntoh16((uint16_t)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0(1 << (port_num % IB_MCAST_MASK_SIZE)));
> >> @@ -180,10 +195,11 @@ boolean_t osm_mcast_tbl_is_any_port(IN const=
 osm_mcast_tbl_t * p_tbl,
> >>
> >> =A0 =A0 =A0 if (p_tbl->p_mask_tbl) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_ST=
ART_HO);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho <=3D (uint16_t) (IB_LI=
D_MCAST_START_HO +
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0p_tbl->num_entries - 1));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_h=
o);
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAST=
_START_HO;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (mlid_offset >=3D p_tbl->mft_depth)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FALSE;
> >
> > Ditto.
>=20
> See above.

And this function osm_mcast_tbl_is_any_port() is not called at all. Is
it?

> >> @@ -223,9 +238,6 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm=
_mcast_tbl_t * p_tbl,
> >> =A0 =A0 =A0 if (block_num > p_tbl->max_block_in_use)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_tbl->max_block_in_use =3D (uint16_t)=
 block_num;
> >>
> >> - =A0 =A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max=
_mlid_ho)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 p_tbl->max_mlid_ho =3D mlid_start_ho + I=
B_MCAST_BLOCK_SIZE - 1;
> >> -
> >> =A0 =A0 =A0 return IB_SUCCESS;
> >> =A0}
> >>
> >> @@ -241,6 +253,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl=
_t * p_tbl, IN uint16_t mlid_ho)
> >>
> >> =A0 =A0 =A0 if (p_tbl->p_mask_tbl && (mlid_ho <=3D p_tbl->max_mlid=
_ho)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlid_offset =3D mlid_ho - IB_LID_MCAST=
_START_HO;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (mlid_offset >=3D p_tbl->mft_depth)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> >
> > This seems redundant for me after 'mlid_ho <=3D p_tbl->max_mlid_ho'=
 check
> > above.
>=20
> See above.

I see nothing related above. Again:

This is what we will have after your patch:

	if (p_tbl->p_mask_tbl && (mlid_ho <=3D p_tbl->max_mlid_ho)) {
		mlid_offset =3D mlid_ho - IB_LID_MCAST_START_HO;
		if (mlid_offset >=3D p_tbl->mft_depth)
			return;

, and assuming that:

	p_tbl->max_mlid_ho =3D p_tbl->mft_depth + IB_LID_MCAST_START_HO - 1

, how the second if () condition could be true?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_tbl.(h c): Change max_mlid_ho to be
	maximum MLID configured
Date: Fri, 16 Oct 2009 14:04:15 -0400
Message-ID: <f0e08f230910161104t571a6170ta2f209beff3cf395@mail.gmail.com>
References: <20091016145713.GA19268@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091016145713.GA19268-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 16, 2009 at 10:57 AM, Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org> w=
rote:
>
> rather than max table size

Please ignore this version. There's a problem I found with it which
I'm working on fixing.

-- Hal

>
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/o=
pensm/osm_mcast_tbl.h
> index 710d199..276b7f7 100644
> --- a/opensm/include/opensm/osm_mcast_tbl.h
> +++ b/opensm/include/opensm/osm_mcast_tbl.h
> @@ -2,6 +2,7 @@
> =C2=A0* Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
> =C2=A0* Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights=
 reserved.
> =C2=A0* Copyright (c) 1996-2003 Intel Corporation. All rights reserve=
d.
> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
> =C2=A0*
> =C2=A0* This software is available to you under a choice of one of tw=
o
> =C2=A0* licenses. =C2=A0You may choose to be licensed under the terms=
 of the GNU
> @@ -95,7 +96,8 @@ typedef struct osm_mcast_fwdbl {
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of ent=
ries in the table (aka number of MLIDs supported).
> =C2=A0*
> =C2=A0* =C2=A0 =C2=A0 =C2=A0max_mlid_ho
> -* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum MLID value=
 (host order).
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum MLID (host=
 order) configured in the multicast port mask
> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0table.
> =C2=A0*
> =C2=A0* =C2=A0 =C2=A0 =C2=A0pp_mask_tbl
> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pointer to a =
two dimensional array of port_masks for this switch.
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_=
tbl.c
> index d7c9529..bdea416 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -81,8 +81,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl=
_t * p_tbl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0IB_MCAST_BLOCK_SIZE) /
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0I=
B_MCAST_BLOCK_SIZE) - 1);
>
> - =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D (uint16_t) (IB_LID_MCAS=
T_START_HO + capacity - 1);
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The number of bytes needed in the =
mask table is:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The (maximum bit mask 'position' +=
 1) times the
> @@ -122,7 +120,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl=
, IN uint16_t mlid_ho,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(p_tbl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_=
HO);
> - =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_ho);
> + =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D (uint16_t) (IB_LID_MCAS=
T_START_HO +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=
_tbl->num_entries - 1));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(p_tbl->p_mask_tbl);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D mlid_ho - IB_LID_MCAST_STA=
RT_HO;
> @@ -134,6 +133,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl=
, IN uint16_t mlid_ho,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (block_num > p_tbl->max_block_in_use)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->max_blo=
ck_in_use =3D (uint16_t) block_num;
> + =C2=A0 =C2=A0 =C2=A0 if (mlid_ho > p_tbl->max_mlid_ho)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho=
 =3D mlid_ho;
> =C2=A0}
>
> =C2=A0/**************************************************************=
********
> @@ -151,7 +152,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcas=
t_tbl_t * p_tbl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(port=
_num <=3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0(p_tbl->max_position + 1) * IB_MCAST_MASK_SIZE);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid=
_ho >=3D IB_LID_MCAST_START_HO);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho =
<=3D p_tbl->max_mlid_ho);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho =
<=3D (uint16_t) (IB_LID_MCAST_START_HO +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->num_entries - 1));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D=
 mlid_ho - IB_LID_MCAST_START_HO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mask_offset =3D=
 port_num / IB_MCAST_MASK_SIZE;
> @@ -178,7 +180,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_=
mcast_tbl_t * p_tbl,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (p_tbl->p_mask_tbl) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CL_ASSERT(mlid=
_ho >=3D IB_LID_MCAST_START_HO);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho =
<=3D p_tbl->max_mlid_ho);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho =
<=3D (uint16_t) (IB_LID_MCAST_START_HO +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->num_entries - 1));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_offset =3D=
 mlid_ho - IB_LID_MCAST_START_HO;
>
> @@ -210,7 +213,8 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mc=
ast_tbl_t * p_tbl,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mlid_start_ho =3D (uint16_t) (block_num * =
IB_MCAST_BLOCK_SIZE);
>
> - =C2=A0 =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > =
p_tbl->max_mlid_ho)
> + =C2=A0 =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 >
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->num_entries + IB_LID_MCAS=
T_START_HO - 1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IB_INVA=
LID_PARAMETER;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < IB_MCAST_BLOCK_SIZE; i++=
)
> @@ -219,6 +223,9 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mc=
ast_tbl_t * p_tbl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (block_num > p_tbl->max_block_in_use)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->max_blo=
ck_in_use =3D (uint16_t) block_num;
>
> + =C2=A0 =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > =
p_tbl->max_mlid_ho)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho=
 =3D mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return IB_SUCCESS;
> =C2=A0}
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

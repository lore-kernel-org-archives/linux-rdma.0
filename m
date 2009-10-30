From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_mcast_tbl.c: Fix multicast group removal
Date: Fri, 30 Oct 2009 13:33:51 -0400
Message-ID: <f0e08f230910301033w2814ef9dje6164d9652fb624a@mail.gmail.com>
References: <20091030144919.GA26847@comcast.net>
	 <20091030102649.fa06e288.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030102649.fa06e288.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2009 at 1:26 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> This patch causes this assert again...
>
> OpenSM $ opensm: osm_mcast_tbl.c:104: osm_mcast_tbl_set: Assertion `m=
lid_ho <=3D p_tbl->max_mlid_ho' failed.
> Aborted (core dumped)
>
> I thought the -1 was required...

I didn't mean to change that.. New version shortly...

>
> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_=
tbl.c
> index da106c6..67f083e 100644
> --- a/opensm/opensm/osm_mcast_tbl.c
> +++ b/opensm/opensm/osm_mcast_tbl.c
> @@ -144,7 +144,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_=
tbl, IN uintn_t mlid_offset)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size - p_tbl->mft_de=
pth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->p_mask_tbl =3D p_mask_tbl;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl->mft_depth =3D mft_depth;
> - =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mlid_offset + IB_LID_MC=
AST_START_HO;
> + =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mlid_offset + IB_LID_MC=
AST_START_HO - 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> But this did not fix it... =C2=A0I would dig further but I am kind of=
 busy today, sorry.
>
> Ira
>
>
> On Fri, 30 Oct 2009 09:49:19 -0500
> Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org> wrote:
>
>>
>> Revert de3171043b3cbe078e410351a00e5756509bd514 and
>> some of 537d67b19a4b72d72341e529f611e4e30754f8fc
>>
>> In osm_mcast_tbl_realloc, don't change max_mlid_ho when mlid_offset =
< p_tbl->mft_depth
>> Also, restore some checks when mlid_offset >=3D p_tbl->mft_depth
>> These changes are needed for proper group removal
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast=
_tbl.c
>> index 0a45904..da106c6 100644
>> --- a/opensm/opensm/osm_mcast_tbl.c
>> +++ b/opensm/opensm/osm_mcast_tbl.c
>> @@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p=
_tbl, IN uintn_t mlid_offset)
>> =C2=A0 =C2=A0 =C2=A0 uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX]=
;
>>
>> =C2=A0 =C2=A0 =C2=A0 if (mlid_offset < p_tbl->mft_depth)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto done;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of bytes needed in the =
mask table is:
>> @@ -144,7 +144,6 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p=
_tbl, IN uintn_t mlid_offset)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size - p_tbl->mft_de=
pth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D p_mask_tbl;
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->mft_depth =3D mft_depth;
>> -done:
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mlid_offset + IB_LID_MCA=
ST_START_HO;
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>> @@ -167,6 +166,9 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mca=
st_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=
=3D p_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>> +
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask_offset =3D por=
t_num / IB_MCAST_MASK_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bit_mask =3D cl_nto=
h16((uint16_t)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(1 << (port_num=
 % IB_MCAST_MASK_SIZE)));
>> @@ -194,6 +196,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm=
_mcast_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=
=3D p_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (position =3D 0=
; position <=3D p_tbl->max_position; position++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 result |=3D (*p_tbl->p_mask_tbl)[mlid_offset][position];
>> @@ -247,6 +251,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t=
 * p_tbl, IN uint16_t mlid_ho)
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && mlid_ho <=3D p_tbl->ma=
x_mlid_ho) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D=
 p_tbl->max_position; i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (*p_tbl->p_mask_tbl)[mlid_offset][i] =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://*vger.kernel.org/majordomo-info.=
html
>>
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
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

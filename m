From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_updn.c: Reduce temporary allocation of
	cas_per_sw
Date: Wed, 14 Oct 2009 09:33:55 -0400
Message-ID: <f0e08f230910140633i43bd7648w1feba7c2be6c0d11@mail.gmail.com>
References: <20091014131435.GA23890@comcast.net> <20091014132911.GB13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091014132911.GB13830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 9:29 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 09:14 Wed 14 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Also, combine malloc/memset into calloc
>
> Any special reason for malloc/calloc change?

It's a little more concise and efficient to calloc rather than
malloc/memset. Any reason not to do this ?

> Please don't mix two things in one patch.

I thought this was minor. I'll resubmit if you prefer.

-- Hal

> Sasha
>
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucas=
t_updn.c
>> index bb9ccda..a2acdbd 100644
>> --- a/opensm/opensm/osm_ucast_updn.c
>> +++ b/opensm/opensm/osm_ucast_updn.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2006 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -431,13 +432,12 @@ static void updn_find_root_nodes_by_min_hop(OU=
T updn_t * p_updn)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Current number of =
ports in the subnet is %d\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_qmap_count(&p_os=
m->subn.port_guid_tbl));
>>
>> - =C2=A0 =C2=A0 cas_per_sw =3D malloc((IB_LID_UCAST_END_HO + 1) * si=
zeof(*cas_per_sw));
>> + =C2=A0 =C2=A0 cas_per_sw =3D calloc(p_osm->subn.max_ucast_lid_ho, =
sizeof(*cas_per_sw));
>> =C2=A0 =C2=A0 =C2=A0 if (!cas_per_sw) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(&p_osm->log=
, OSM_LOG_ERROR, "ERR AA14: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "cannot alloc mem for CAs per switch counter array\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto _exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 memset(cas_per_sw, 0, (IB_LID_UCAST_END_HO + 1) * si=
zeof(*cas_per_sw));
>>
>> =C2=A0 =C2=A0 =C2=A0 /* Find the Maximum number of CAs (and routers)=
 for histogram normalization */
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
>>
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

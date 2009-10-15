From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Thu, 15 Oct 2009 18:35:12 -0400
Message-ID: <f0e08f230910151535p4aed8827p29f7887d0161dbf@mail.gmail.com>
References: <20091014213546.GA32163@comcast.net> <20091015204233.GG20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015204233.GG20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2009 at 4:42 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 17:35 Wed 14 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Heap memory consumption by the unicast and multicast routing tables =
can be
>> reduced.
>>
>> This patch is analagous to the previous patch doing this for the uni=
cast
>> routing tables (LFTs).
>>
>> Using valgrind --tool=3Dmassif (for heap profiling), there are coupl=
e of place
>> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
>> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:=
96)
>>
>> osm_mcast_tbl_init (osm_mcast_tbl.c:96):
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D malloc(p_tbl->num_=
entries *
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(IB_MCAST_POSIT=
ION_MAX +
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1) * IB_MCAST_=
MASK_SIZE / 8);
>>
>> num_entries above is set based on the switch's MulticastFDBCap
>> (indicated in it's SM class SwitchInfo attribute).
>>
>> MFTs are only be increased in size and are never reduced in size. If=
 a realloc
>> for MFT fails, it is treated as a fatal error and OpenSM is exited.
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> Changes since v2:
>> MFT allocation during routing preparation rather than on table acces=
s
>> Changes since v1:
>> MFT allocation based on actual MLID requests
>>
>> diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/=
opensm/osm_mcast_tbl.h
>> index 710d199..85730e6 100644
>> --- a/opensm/include/opensm/osm_mcast_tbl.h
>> +++ b/opensm/include/opensm/osm_mcast_tbl.h
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved=
=2E
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -46,6 +46,7 @@
>> =C2=A0#include <iba/ib_types.h>
>> =C2=A0#include <complib/cl_qmap.h>
>> =C2=A0#include <opensm/osm_base.h>
>> +#include <opensm/osm_subnet.h>
>>
>> =C2=A0#ifdef __cplusplus
>> =C2=A0# =C2=A0define BEGIN_C_DECLS extern "C" {
>> @@ -74,6 +75,7 @@ typedef struct osm_mcast_fwdbl {
>> =C2=A0 =C2=A0 =C2=A0 int16_t max_block_in_use;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t num_entries;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t max_mlid_ho;
>> + =C2=A0 =C2=A0 uint16_t mft_size;
>
> Description for this newly introduced field would be helpful - I had =
to
> spend some time realizing about which units are used here.
>
>> =C2=A0 =C2=A0 =C2=A0 uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>> =C2=A0} osm_mcast_tbl_t;
>> =C2=A0/*
>> @@ -97,7 +99,7 @@ typedef struct osm_mcast_fwdbl {
>> =C2=A0* =C2=A0 =C2=A0max_mlid_ho
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum MLID value =
(host order).
>> =C2=A0*
>> -* =C2=A0 =C2=A0pp_mask_tbl
>> +* =C2=A0 =C2=A0p_mask_tbl
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pointer to a two di=
mensional array of port_masks for this switch.
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The first dimension=
 is MLID, the second dimension is mask position.
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This pointer is nul=
l for switches that do not support multicast.
>> @@ -114,8 +116,8 @@ typedef struct osm_mcast_fwdbl {
>> =C2=A0*
>> =C2=A0* SYNOPSIS
>> =C2=A0*/
>> -ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IN uint8_t num_ports, IN u=
int16_t capacity);
>> +void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_=
ports,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 IN uint16_t capacity);
>> =C2=A0/*
>> =C2=A0* PARAMETERS
>> =C2=A0* =C2=A0 =C2=A0num_ports
>> @@ -126,7 +128,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_=
tbl_t * p_tbl,
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0by this switch.
>> =C2=A0*
>> =C2=A0* RETURN VALUE
>> -* =C2=A0 =C2=A0IB_SUCCESS on success.
>> +* =C2=A0 =C2=A0None.
>> =C2=A0*
>> =C2=A0* NOTES
>> =C2=A0*
>> @@ -158,6 +160,38 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t **=
 pp_tbl);
>> =C2=A0* SEE ALSO
>> =C2=A0*********/
>>
>> +/****f* OpenSM: Forwarding Table/osm_mcast_tbl_realloc_mask_tbl
>> +* NAME
>> +* =C2=A0 =C2=A0osm_mcast_tbl_realloc_mask_tbl
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0This function reallocates the port mask table if nec=
essary.
>> +*
>> +* SYNOPSIS
>> +*/
>> +void
>> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IN osm_subn_t * p_subn, IN uintn_t mlid_=
offset);
>> +/*
>> +* PARAMETERS
>> +*
>> +* =C2=A0 =C2=A0p_tbl
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to the Mult=
icast Forwarding Table object.
>> +*
>> +* =C2=A0 =C2=A0p_subn
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to the subn=
et object.
>> +*
>> +* =C2=A0 =C2=A0mlid_offset
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Offset of MLID bein=
g accessed.
>> +*
>> +* RETURN VALUE
>> +* =C2=A0 =C2=A0None
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*/
>> +
>> =C2=A0/****f* OpenSM: Forwarding Table/osm_mcast_tbl_destroy
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 =C2=A0osm_mcast_tbl_destroy
>> diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
>> index 08b3156..c004b6c 100644
>> --- a/opensm/opensm/osm_dump.c
>> +++ b/opensm/opensm/osm_dump.c
>> @@ -1,7 +1,7 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserv=
ed.
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> @@ -232,6 +232,7 @@ static void dump_ucast_routes(cl_map_item_t * it=
em, FILE * file, void *cxt)
>> =C2=A0static void dump_mcast_routes(cl_map_item_t * item, FILE * fil=
e, void *cxt)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 osm_switch_t *p_sw =3D (osm_switch_t *) item;
>> + =C2=A0 =C2=A0 osm_opensm_t *p_osm =3D cxt;
>> =C2=A0 =C2=A0 =C2=A0 osm_mcast_tbl_t *p_tbl;
>> =C2=A0 =C2=A0 =C2=A0 int16_t mlid_ho =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 int16_t mlid_start_ho;
>> @@ -261,6 +262,9 @@ static void dump_mcast_routes(cl_map_item_t * it=
em, FILE * file, void *cxt)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sprintf(mlid_hdr, "0x%04X :",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_ho + IB_LID_MCAST_START_HO);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 while (position <=3D p_tbl->max_position) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_mcast_tbl_realloc_mask_tbl(p_tbl,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&=
p_osm->subn,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0m=
lid_ho);
>
> Hmm, why to realloc here?
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask_entry =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh16((*p_tbl->
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0p_mask_tbl)[mlid_ho][position]);
>> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast=
_mgr.c
>> index 0ee689c..e6da7f6 100644
>> --- a/opensm/opensm/osm_mcast_mgr.c
>> +++ b/opensm/opensm/osm_mcast_mgr.c
>> @@ -1043,6 +1043,34 @@ static int mcast_mgr_set_mftables(osm_sm_t * =
sm)
>> =C2=A0 =C2=A0 =C2=A0 return ret;
>> =C2=A0}
>>
>> +static void alloc_mfts(osm_sm_t * sm)
>> +{
>> + =C2=A0 =C2=A0 int i;
>> + =C2=A0 =C2=A0 cl_map_item_t *item;
>> + =C2=A0 =C2=A0 osm_switch_t *p_sw;
>> + =C2=A0 =C2=A0 int max_mlid =3D 0;
>> +
>> + =C2=A0 =C2=A0 for (i =3D sm->p_subn->max_mcast_lid_ho - IB_LID_MCA=
ST_START_HO; i >=3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i--) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sm->p_subn->mgroups=
[i])
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_mlid =3D i + IB_LID_=
MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>
> Something simpler like:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sm->p_subn=
->mgroups[i]) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0max_mlid =3D i + IB_LID_MCAST_START_HO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> would make more sense.
>
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 if (max_mlid =3D=3D 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 /* Now, walk switches and (re)allocate multicast tab=
les */
>> + =C2=A0 =C2=A0 for (item =3D cl_qmap_head(&sm->p_subn->sw_guid_tbl)=
;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0item !=3D cl_qmap_end(&sm->p_sub=
n->sw_guid_tbl);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0item =3D cl_qmap_next(item)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw =3D (osm_switch_t *=
)item;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_mcast_tbl_realloc_ma=
sk_tbl(&p_sw->mcast_tbl, sm->p_subn,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0max_mlid - IB_LID_MCAST_START_HO);
>
> I would suggest to have a return value here and...
>
>> + =C2=A0 =C2=A0 }
>> +}
>> +
>> =C2=A0/*************************************************************=
*********
>> =C2=A0 *************************************************************=
*********/
>> =C2=A0int osm_mcast_mgr_process(osm_sm_t * sm)
>> @@ -1063,6 +1091,8 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 alloc_mfts(sm);
>
> to verify allocation status and break multicast routing calculation
> when there is no room for MFTs.
>
>> +
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D sm->p_subn->max_mcast_lid_=
ho - IB_LID_MCAST_START_HO;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sm->p_subn->mgr=
oups[i] || sm->mlids_req[i])
>> @@ -1101,6 +1131,8 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * s=
m)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 alloc_mfts(sm);
>> +
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D sm->mlids_req_max; i++) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sm->mlids_req[=
i])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast=
_tbl.c
>> index d7c9529..11070b1 100644
>> --- a/opensm/opensm/osm_mcast_tbl.c
>> +++ b/opensm/opensm/osm_mcast_tbl.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2006 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -50,11 +50,13 @@
>> =C2=A0#include <complib/cl_math.h>
>> =C2=A0#include <iba/ib_types.h>
>> =C2=A0#include <opensm/osm_mcast_tbl.h>
>> +#include <opensm/osm_log.h>
>> +#include <opensm/osm_opensm.h>
>>
>> =C2=A0/*************************************************************=
*********
>> =C2=A0 *************************************************************=
*********/
>> -ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IN uint8_t num_ports, IN u=
int16_t capacity)
>> +void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_=
ports,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 IN uint16_t capacity)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(num_ports);
>> @@ -68,7 +70,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tb=
l_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This s=
witch apparently doesn't support multicast.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Everyt=
hing is initialized to zero already, so return.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->num_entries =3D capacity;
>> @@ -82,25 +84,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_t=
bl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_MCAS=
T_BLOCK_SIZE) - 1);
>>
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D (uint16_t) (IB_LID_MCAST=
_START_HO + capacity - 1);
>> -
>> - =C2=A0 =C2=A0 /*
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of bytes needed in the mask =
table is:
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0The (maximum bit mask 'position' + 1) t=
imes the
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0number of bytes in each bit mask times =
the
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0number of MLIDs supported by the table.
>> -
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0We must always allocate the array with =
the maximum position
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0since it is (and must be) defined that =
way the table structure
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0in order to create a pointer to a two d=
imensional array.
>> - =C2=A0 =C2=A0 =C2=A0*/
>> - =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D calloc(p_tbl->num_entries,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(IB_MCAST_POSITION_MAX +
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1) * IB_MCAST_MASK_SIZE /=
 8);
>> -
>> - =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl =3D=3D NULL)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INSUFFICIENT_M=
EMORY;
>> -
>> - =C2=A0 =C2=A0 return IB_SUCCESS;
>> =C2=A0}
>>
>> =C2=A0/*************************************************************=
*********
>> @@ -123,6 +106,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tb=
l, IN uint16_t mlid_ho,
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_HO);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_ho);
>> + =C2=A0 =C2=A0 CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_tbl->m=
ft_size);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl->p_mask_tbl);
>>
>> =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mlid_ho - IB_LID_MCAST_START_HO=
;
>> @@ -138,6 +122,51 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_t=
bl, IN uint16_t mlid_ho,
>>
>> =C2=A0/*************************************************************=
*********
>> =C2=A0 *************************************************************=
*********/
>> +void
>> +osm_mcast_tbl_realloc_mask_tbl(IN osm_mcast_tbl_t * p_tbl,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IN osm_subn_t * p_subn, IN uintn_t mlid_=
offset)
>
> I would suggest to simplify the function name to something like
> 'osm_mcast_tbl_realloc()' - osm_mcast_tbl API doesn't have any
> information about a buffer internal structure.
>
>
>> +{
>> + =C2=A0 =C2=A0 size_t mft_size, size;
>> + =C2=A0 =C2=A0 uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>> +
>> + =C2=A0 =C2=A0 if (mlid_offset < p_tbl->mft_size)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0The number of bytes needed in the mask =
table is:
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0The (maximum bit mask 'position' + 1) t=
imes the
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0number of bytes in each bit mask times =
the
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0number of MLIDs supported by the table.
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0We must always allocate the array with =
the maximum position
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0since it is (and must be) defined that =
way the table structure
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0in order to create a pointer to a two d=
imensional array.
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 mft_size =3D (mlid_offset + IB_MCAST_BLOCK_SIZE) /
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_MCAST_B=
LOCK_SIZE * IB_MCAST_BLOCK_SIZE;
>> + =C2=A0 =C2=A0 if (mft_size > (p_tbl->max_block + 1) * IB_MCAST_BLO=
CK_SIZE)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mft_size =3D (p_tbl->max=
_block + 1) * IB_MCAST_BLOCK_SIZE;
>
> Hmm, wouldn't this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mft_size =3D (mlid_offset / IB_MCAST_BLOCK=
_SIZE + 1) * IB_MCAST_BLOCK_SIZE;
>
> do the same as lines above?

What about the limit (max_block) check ?

>> + =C2=A0 =C2=A0 size =3D mft_size * (IB_MCAST_POSITION_MAX + 1) * IB=
_MCAST_MASK_SIZE / 8;
>> + =C2=A0 =C2=A0 p_mask_tbl =3D realloc(p_tbl->p_mask_tbl, size);
>> + =C2=A0 =C2=A0 if (!p_mask_tbl)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error;
>> + =C2=A0 =C2=A0 memset((uint8_t *)p_mask_tbl + p_tbl->mft_size * (IB=
_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size - p_tbl->mft_size * =
(IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
>> + =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D p_mask_tbl;
>> + =C2=A0 =C2=A0 p_tbl->mft_size =3D mft_size;
>> + =C2=A0 =C2=A0 return;
>> +
>> +error:
>> + =C2=A0 =C2=A0 OSM_LOG(&p_subn->p_osm->log, OSM_LOG_SYS,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Reallocation of multica=
st mask table failed - exiting\n");
>> + =C2=A0 =C2=A0 OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, " ERR 64=
01: "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Reallocation of multica=
st mask table failed - exiting\n");
>> + =C2=A0 =C2=A0 exit(1);
>
> Why to break whole OpenSM execution (print syslog errors, etc.)? Just
> return -1 to the caller.
>
>> +}
>> +
>> +/******************************************************************=
****
>> + ******************************************************************=
****/
>> =C2=A0boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_t=
bl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IN uint16_t mlid_ho, IN uint8_t por=
t_num)
>> =C2=A0{
>> @@ -154,6 +183,8 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mca=
st_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=
=3D p_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_size)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>
> If you are introducing new field mft_size, I would also suggest to ch=
ange
> the meaning of max_mlid_ho field to be max configured mlid for this
> table and not max capability mlid (which is almost duplicated by
> num_entries field).

Yes, almost duplicated.

> I suppose that this can be done as separate patch.
>
> Then all such and similar (many below) checks should be performed aga=
inst
> this actually configured max mlid and not against table size. As we
> discussed already this prevents some bugs for 'max_mlid < table_size =
- 1'
> case.

I'll look at this subsequent to this patch.

-- Hal

> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask_offset =3D por=
t_num / IB_MCAST_MASK_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bit_mask =3D cl_nto=
h16((uint16_t)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(1 << (port_num=
 % IB_MCAST_MASK_SIZE)));
>> @@ -181,6 +212,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm=
_mcast_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=
=3D p_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_size)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (position =3D 0=
; position <=3D p_tbl->max_position; position++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 result |=3D (*p_tbl->p_mask_tbl)[mlid_offset][position];
>> @@ -210,7 +243,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_m=
cast_tbl_t * p_tbl,
>>
>> =C2=A0 =C2=A0 =C2=A0 mlid_start_ho =3D (uint16_t) (block_num * IB_MC=
AST_BLOCK_SIZE);
>>
>> - =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl-=
>max_mlid_ho)
>> + =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl-=
>mft_size)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INVALID_P=
ARAMETER;
>>
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < IB_MCAST_BLOCK_SIZE; i++)
>> @@ -234,6 +267,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t=
 * p_tbl, IN uint16_t mlid_ho)
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && (mlid_ho <=3D p_tbl->m=
ax_mlid_ho)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_size)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D=
 p_tbl->max_position; i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (*p_tbl->p_mask_tbl)[mlid_offset][i] =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 }
>> @@ -250,6 +285,7 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_t=
bl_t * p_tbl,
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_block);
>> + =C2=A0 =C2=A0 CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <=3D p_tbl=
->mft_size);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (block_num > p_tbl->max_block_in_use)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return FALSE;
>> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
>> index ed0bc66..223791c 100644
>> --- a/opensm/opensm/osm_switch.c
>> +++ b/opensm/opensm/osm_switch.c
>> @@ -136,9 +136,8 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_n=
ode,
>>
>> =C2=A0 =C2=A0 =C2=A0 memset(p_sw->p_prof, 0, sizeof(*p_sw->p_prof) *=
 num_ports);
>>
>> - =C2=A0 =C2=A0 if (osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_ge=
t_num_physp(p_node),
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cl_ntoh16(p_si->mcast_cap)))
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;
>> + =C2=A0 =C2=A0 osm_mcast_tbl_init(&p_sw->mcast_tbl, osm_node_get_nu=
m_physp(p_node),
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0cl_ntoh16(p_si->mcast_cap));
>>
>> =C2=A0 =C2=A0 =C2=A0 for (port_num =3D 0; port_num < num_ports; port=
_num++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_port_prof_const=
ruct(&p_sw->p_prof[port_num]);
>> @@ -508,7 +507,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uin=
t16_t lids)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft =3D new_l=
ft;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft_size =3D =
lft_size;
>> =C2=A0 =C2=A0 =C2=A0 }
>> -
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>>
>> @@ -549,7 +547,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switc=
h_t * p_sw, IN uint16_t max_lids
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->num_hops =3D =
max_lids + 1;
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 p_sw->max_lid_ho =3D max_lids;
>> -
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
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

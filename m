From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv5] opensm: Reduce heap consumption by multicast routing
	tables (MFTs)
Date: Fri, 30 Oct 2009 09:47:04 -0400
Message-ID: <f0e08f230910300647q274e4e76v70c60a978f84309c@mail.gmail.com>
References: <20091023234856.GA1482@comcast.net> <20091029191732.GB20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091029191732.GB20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 29, 2009 at 3:17 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 19:48 Fri 23 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
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
>
> Applied. Thanks.
>
> I have some comments (see below) and will send the fixes as subsequen=
t
> patch(es). Please reply over comments and/or patches if needed.
>
>> ---
>> Changes since v4:
>> Incorporated osm_mcast_tbl change to make max_mlid_ho be maximum MLI=
D
>> configured rather than max table size
>>
>> Changes since v3:
>> Renamed mft_size to mft_depth and added description in osm_mcast_tbl=
=2Eh
>> Removed vestigial realloc mask tbl call in osm_dump.c
>> Simplified max_mlid determination in alloc_mfts
>> Added return value to osm_mcast_tbl_realloc_mask_tbl
>> Added return value to alloc_mfts
>> Handle alloc_mfts failure in osm_mcast_mgr_process/process_mgroups
>> Renamed osm_mcast_tbl_realloc_mask_tbl to osm_mcast_tbl_realloc
>> In osm_mcast_tbl_realloc, simplified mft_depth calculation
>>
>> Changes since v2:
>> MFT allocation during routing preparation rather than on table acces=
s
>>
>> Changes since v1:
>> MFT allocation based on actual MLID requests
>>
>> diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/=
opensm/osm_mcast_tbl.h
>> index 276b7f7..5c36f2a 100644
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
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -75,6 +75,7 @@ typedef struct osm_mcast_fwdbl {
>> =C2=A0 =C2=A0 =C2=A0 int16_t max_block_in_use;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t num_entries;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t max_mlid_ho;
>> + =C2=A0 =C2=A0 uint16_t mft_depth;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>> =C2=A0} osm_mcast_tbl_t;
>> =C2=A0/*
>> @@ -96,10 +97,14 @@ typedef struct osm_mcast_fwdbl {
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of entries i=
n the table (aka number of MLIDs supported).
>> =C2=A0*
>> =C2=A0* =C2=A0 =C2=A0max_mlid_ho
>> -* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum MLID (host order=
) configured in the multicast port mask
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Maximum MLID (host order=
) for the currently allocated multicast
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port mask table.
>> +*
>> +* =C2=A0 =C2=A0mft_depth
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of MLIDs in the c=
urrently allocated multicast port mask
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0table.
>> =C2=A0*
>> -* =C2=A0 =C2=A0pp_mask_tbl
>> +* =C2=A0 =C2=A0p_mask_tbl
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pointer to a two di=
mensional array of port_masks for this switch.
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The first dimension=
 is MLID, the second dimension is mask position.
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0This pointer is nul=
l for switches that do not support multicast.
>> @@ -116,8 +121,8 @@ typedef struct osm_mcast_fwdbl {
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
>> @@ -128,7 +133,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_=
tbl_t * p_tbl,
>> =C2=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0by this switch.
>> =C2=A0*
>> =C2=A0* RETURN VALUE
>> -* =C2=A0 =C2=A0IB_SUCCESS on success.
>> +* =C2=A0 =C2=A0None.
>> =C2=A0*
>> =C2=A0* NOTES
>> =C2=A0*
>> @@ -160,6 +165,34 @@ void osm_mcast_tbl_delete(IN osm_mcast_tbl_t **=
 pp_tbl);
>> =C2=A0* SEE ALSO
>> =C2=A0*********/
>>
>> +/****f* OpenSM: Forwarding Table/osm_mcast_tbl_realloc
>> +* NAME
>> +* =C2=A0 =C2=A0osm_mcast_tbl_realloc
>> +*
>> +* DESCRIPTION
>> +* =C2=A0 =C2=A0This function reallocates the multicast port mask ta=
ble if necessary.
>> +*
>> +* SYNOPSIS
>> +*/
>> +int
>> +osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_o=
ffset);
>> +/*
>> +* PARAMETERS
>> +*
>> +* =C2=A0 =C2=A0p_tbl
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Pointer to the Mult=
icast Forwarding Table object.
>> +*
>> +* =C2=A0 =C2=A0mlid_offset
>> +* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[in] Offset of MLID bein=
g accessed.
>> +*
>> +* RETURN VALUE
>> +* =C2=A0 =C2=A0Returns 0 on success and non-zero value otherwise.
>> +*
>> +* NOTES
>> +*
>> +* SEE ALSO
>> +*/
>> +
>> =C2=A0/****f* OpenSM: Forwarding Table/osm_mcast_tbl_destroy
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 =C2=A0osm_mcast_tbl_destroy
>> diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast=
_mgr.c
>> index 0ee689c..a5e9758 100644
>> --- a/opensm/opensm/osm_mcast_mgr.c
>> +++ b/opensm/opensm/osm_mcast_mgr.c
>> @@ -1043,6 +1043,36 @@ static int mcast_mgr_set_mftables(osm_sm_t * =
sm)
>> =C2=A0 =C2=A0 =C2=A0 return ret;
>> =C2=A0}
>>
>> +static int alloc_mfts(osm_sm_t * sm)
>> +{
>> + =C2=A0 =C2=A0 int i;
>> + =C2=A0 =C2=A0 cl_map_item_t *item;
>> + =C2=A0 =C2=A0 osm_switch_t *p_sw;
>> + =C2=A0 =C2=A0 int max_mlid =3D 0;
>> +
>> + =C2=A0 =C2=A0 for (i =3D sm->p_subn->max_mcast_lid_ho - IB_LID_MCA=
ST_START_HO; i >=3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i--) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sm->p_subn->mgroups[=
i]) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 max_mlid =3D i + IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 if (max_mlid =3D=3D 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
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
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (osm_mcast_tbl_reallo=
c(&p_sw->mcast_tbl,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_=
mlid - IB_LID_MCAST_START_HO))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -1;
>> + =C2=A0 =C2=A0 }
>
> A variable 'max_mlid' is not actually needed in this function - you a=
re
> initializing this as 'mlid_max =3D i + IB_LID_MCAST_START_NO' and the=
n
> using as 'mlid_max - IB_LID_MCAST_START_HO'. Instead you could just u=
se
> 'i' as it is.
>
>> + =C2=A0 =C2=A0 return 0;
>> +}
>> +
>> =C2=A0/*************************************************************=
*********
>> =C2=A0 *************************************************************=
*********/
>> =C2=A0int osm_mcast_mgr_process(osm_sm_t * sm)
>> @@ -1063,6 +1093,12 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 if (alloc_mfts(sm)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_L=
OG_ERROR,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "ERR 0A07: alloc_mfts failed\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D sm->p_subn->max_mcast_lid_=
ho - IB_LID_MCAST_START_HO;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sm->p_subn->mgr=
oups[i] || sm->mlids_req[i])
>> @@ -1101,6 +1137,12 @@ int osm_mcast_mgr_process_mgroups(osm_sm_t * =
sm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 if (alloc_mfts(sm)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sm->p_log, OSM_L=
OG_ERROR,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "ERR 0A09: alloc_mfts failed\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto exit;
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D sm->mlids_req_max; i++) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sm->mlids_req[=
i])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
>> diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast=
_tbl.c
>> index bdea416..be2181d 100644
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
>> @@ -53,8 +53,8 @@
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
>> @@ -68,7 +68,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tb=
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
>> @@ -80,25 +80,6 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_t=
bl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 p_tbl->max_block =3D (uint16_t) ((ROUNDUP(p_tbl=
->num_entries,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 IB_MCAST_BLOCK_SIZE) /
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_MCAS=
T_BLOCK_SIZE) - 1);
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
>> @@ -120,8 +101,8 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tb=
l, IN uint16_t mlid_ho,
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho >=3D IB_LID_MCAST_START_HO);
>> - =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D (uint16_t) (IB_LID_MCAST_STAR=
T_HO +
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_tbl=
->num_entries - 1));
>> + =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D p_tbl->max_mlid_ho);
>> + =C2=A0 =C2=A0 CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_tbl->m=
ft_depth);
>
>
> Isn't it the same check since
> 'p_tbl->max_mlid_ho =3D p_tbl->mft_depth + IB_LID_MCAST_START_HO - 1'=
?
>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl->p_mask_tbl);
>>
>> =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mlid_ho - IB_LID_MCAST_START_HO=
;
>> @@ -133,8 +114,41 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_t=
bl, IN uint16_t mlid_ho,
>>
>> =C2=A0 =C2=A0 =C2=A0 if (block_num > p_tbl->max_block_in_use)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_block_in=
_use =3D (uint16_t) block_num;
>> - =C2=A0 =C2=A0 if (mlid_ho > p_tbl->max_mlid_ho)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D m=
lid_ho;
>> +}
>> +
>> +/******************************************************************=
****
>> + ******************************************************************=
****/
>> +int
>> +osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_o=
ffset)
>> +{
>> + =C2=A0 =C2=A0 size_t mft_depth, size;
>> + =C2=A0 =C2=A0 uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
>> +
>> + =C2=A0 =C2=A0 if (mlid_offset < p_tbl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
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
>> + =C2=A0 =C2=A0 mft_depth =3D (mlid_offset / IB_MCAST_BLOCK_SIZE + 1=
) * IB_MCAST_BLOCK_SIZE;
>> + =C2=A0 =C2=A0 size =3D mft_depth * (IB_MCAST_POSITION_MAX + 1) * I=
B_MCAST_MASK_SIZE / 8;
>> + =C2=A0 =C2=A0 p_mask_tbl =3D realloc(p_tbl->p_mask_tbl, size);
>> + =C2=A0 =C2=A0 if (!p_mask_tbl)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
>> + =C2=A0 =C2=A0 memset((uint8_t *)p_mask_tbl + p_tbl->mft_depth * (I=
B_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size - p_tbl->mft_depth *=
 (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
>> + =C2=A0 =C2=A0 p_tbl->p_mask_tbl =3D p_mask_tbl;
>> + =C2=A0 =C2=A0 p_tbl->mft_depth =3D mft_depth;
>> + =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D mft_depth + IB_LID_MCAST_STAR=
T_HO - 1;
>
> Wouldn't it be more accurate/efficient to set max_mlid_ho as
> 'mlid_offset + IB_LID_MCAST_START_HO - 1'?
>
>> + =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>>
>> =C2=A0/*************************************************************=
*********
>> @@ -152,10 +166,11 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_m=
cast_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(port_num =
<=3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (p_tbl->max_position + 1) * IB_MCAST_MASK_SIZE);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho >=
=3D IB_LID_MCAST_START_HO);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D (=
uint16_t) (IB_LID_MCAST_START_HO +
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0p_tbl->num_entries - 1));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D p=
_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>
> This duplicates CL_ASSERT() above.

Not quite. There's a difference between max_mlid_ho and mft_depth.

> Looking on how this function is used
> I don't see why we this check should be introduced. Do you?

It's needed for group removal to work properly.


>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mask_offset =3D por=
t_num / IB_MCAST_MASK_SIZE;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bit_mask =3D cl_nto=
h16((uint16_t)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(1 << (port_num=
 % IB_MCAST_MASK_SIZE)));
>> @@ -180,10 +195,11 @@ boolean_t osm_mcast_tbl_is_any_port(IN const o=
sm_mcast_tbl_t * p_tbl,
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho >=
=3D IB_LID_MCAST_START_HO);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D (=
uint16_t) (IB_LID_MCAST_START_HO +
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0p_tbl->num_entries - 1));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(mlid_ho <=3D p=
_tbl->max_mlid_ho);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return FALSE;
>
> Ditto.

See above.

>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (position =3D 0=
; position <=3D p_tbl->max_position; position++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 result |=3D (*p_tbl->p_mask_tbl)[mlid_offset][position];
>> @@ -213,8 +229,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_m=
cast_tbl_t * p_tbl,
>>
>> =C2=A0 =C2=A0 =C2=A0 mlid_start_ho =3D (uint16_t) (block_num * IB_MC=
AST_BLOCK_SIZE);
>>
>> - =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 >
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->num_entries + IB_LID_MCAST_STAR=
T_HO - 1)
>> + =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl-=
>mft_depth)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INVALID_P=
ARAMETER;
>
> I see that 'mlid_start_ho' is actually a mlid offset. Was a previous
> check wrong?

This check ensures the whole MFT block (in terms of SM attribute use)
is allocated.
It isn't needed as the table allocation is done in these units. Prior
to this, I think there was a potential boundary condition so it was
needed.

>>
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < IB_MCAST_BLOCK_SIZE; i++)
>> @@ -223,9 +238,6 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_m=
cast_tbl_t * p_tbl,
>> =C2=A0 =C2=A0 =C2=A0 if (block_num > p_tbl->max_block_in_use)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_block_in=
_use =3D (uint16_t) block_num;
>>
>> - =C2=A0 =C2=A0 if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl-=
>max_mlid_ho)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_tbl->max_mlid_ho =3D m=
lid_start_ho + IB_MCAST_BLOCK_SIZE - 1;
>> -
>> =C2=A0 =C2=A0 =C2=A0 return IB_SUCCESS;
>> =C2=A0}
>>
>> @@ -241,6 +253,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t=
 * p_tbl, IN uint16_t mlid_ho)
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_tbl->p_mask_tbl && (mlid_ho <=3D p_tbl->m=
ax_mlid_ho)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlid_offset =3D mli=
d_ho - IB_LID_MCAST_START_HO;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mlid_offset >=3D p_t=
bl->mft_depth)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>
> This seems redundant for me after 'mlid_ho <=3D p_tbl->max_mlid_ho' c=
heck
> above.

See above.

-- Hal

> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=3D=
 p_tbl->max_position; i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (*p_tbl->p_mask_tbl)[mlid_offset][i] =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 }
>> @@ -257,6 +271,7 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_t=
bl_t * p_tbl,
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_tbl);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_block);
>> + =C2=A0 =C2=A0 CL_ASSERT(block_num * IB_MCAST_BLOCK_SIZE <=3D p_tbl=
->mft_depth);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (block_num > p_tbl->max_block_in_use)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return FALSE;
>> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
>> index d2123a4..c912b03 100644
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
>> @@ -507,7 +506,6 @@ static int alloc_lft(IN osm_switch_t * p_sw, uin=
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
>> @@ -548,7 +546,6 @@ int osm_switch_prepare_path_rebuild(IN osm_switc=
h_t * p_sw, IN uint16_t max_lids
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->num_hops =3D =
max_lids + 1;
>> =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 p_sw->max_lid_ho =3D max_lids;
>> -
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
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

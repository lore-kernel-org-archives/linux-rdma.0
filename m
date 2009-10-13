From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Reduce heap consumption by unicast routing
	tables (LFTs)
Date: Tue, 13 Oct 2009 08:59:14 -0400
Message-ID: <f0e08f230910130559y2eb965cfm7a2e26b05ad63c12@mail.gmail.com>
References: <20091004160541.GA28310@comcast.net> <20091012154629.GD31778@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012154629.GD31778@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Mon, Oct 12, 2009 at 11:46 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> Hi Hal,
>
> On 12:05 Sun 04 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Heap memory consumption by the unicast and multicast routing tables =
can be
>> reduced.
>>
>> Using valgrind --tool=3Dmassif (for heap profiling), there are coupl=
e of places that consume most of the heap memory:
>> ->38.75% (11,206,656B) 0x43267E: osm_switch_new (osm_switch.c:134)
>> ->12.89% (3,728,256B) 0x40F8C9: osm_mcast_tbl_init (osm_mcast_tbl.c:=
96)
>>
>> osm_switch_new (osm_switch.c:108):
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_sw->lft =3D malloc(IB_LID_UCAST_END_HO =
+ 1);
>>
>> From ib_types.h
>> =C2=A0#define IB_LID_UCAST_END_HO 0xBFFF
>>
>> The LFT can be allocated after LID assignment, once the number of LI=
Ds
>> assigned is known.
>>
>> So it looks like for cluster of 2-4K with an LMC of 0 about 40% (!!!=
) of the
>> heap memory can be saved:
>>
>> =C2=A0- 39% used by LFTs, each with 48K entries - SM can allocate 4K=
 entries instead.
>>
>> A similar subsequent change will do this for MFTs.
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> Changes since v2:
>> Fixed alloc_lft handling of an existing lft
>> Moved alloc_lft into osm_switch_prepare_path_rebuild
>>
>> Changes since v1:
>> Basic approach changed to not do in chunks but rather allocate
>> LFT once LID assignment is completed
>>
>> diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/ope=
nsm/osm_switch.h
>> index 502e5a7..d881576 100644
>> --- a/opensm/include/opensm/osm_switch.h
>> +++ b/opensm/include/opensm/osm_switch.h
>> @@ -102,6 +102,7 @@ typedef struct osm_switch {
>> =C2=A0 =C2=A0 =C2=A0 osm_port_profile_t *p_prof;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t *lft;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t *new_lft;
>> + =C2=A0 =C2=A0 uint16_t lft_size;
>> =C2=A0 =C2=A0 =C2=A0 osm_mcast_tbl_t mcast_tbl;
>> =C2=A0 =C2=A0 =C2=A0 int32_t mft_block_num;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t mft_position;
>> @@ -253,7 +254,7 @@ static inline uint8_t osm_switch_get_hop_count(I=
N const osm_switch_t * p_sw,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0IN uint16_t lid_ho,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0IN uint8_t port_num)
>> =C2=A0{
>> - =C2=A0 =C2=A0 return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid=
_ho]) ?
>> + =C2=A0 =C2=A0 return (lid_ho >=3D p_sw->lft_size || !p_sw->hops[li=
d_ho]) ?
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_NO_PATH : p_sw->hops[lid_ho][=
port_num];
>> =C2=A0}
>> =C2=A0/*
>> @@ -341,7 +342,7 @@ void osm_switch_clear_hops(IN osm_switch_t * p_s=
w);
>> =C2=A0static inline uint8_t osm_switch_get_least_hops(IN const osm_s=
witch_t * p_sw,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 IN uint16_t lid_ho)
>> =C2=A0{
>> - =C2=A0 =C2=A0 return (lid_ho > p_sw->max_lid_ho || !p_sw->hops[lid=
_ho]) ?
>> + =C2=A0 =C2=A0 return (lid_ho >=3D p_sw->lft_size || !p_sw->hops[li=
d_ho]) ?
>
> Now LFT buffer is only increased in size, so in cases then actual num=
ber
> of lids was decreased (and p_sw->max_lid_ho + 1 < p_sw->lft_size) suc=
h
> changed check may return garbage data from previous cycles. I think t=
he
> check:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0lid_ho > p_sw->max_lid_ho
>
> should be preserved rather than:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0lid_ho >=3D p_sw->lft_size
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_NO_PATH : p_sw->hops[lid_ho][=
0];
>> =C2=A0}
>> =C2=A0/*
>> @@ -405,7 +406,7 @@ uint8_t osm_switch_get_port_least_hops(IN const =
osm_switch_t * p_sw,
>> =C2=A0static inline uint8_t osm_switch_get_port_by_lid(IN const osm_=
switch_t * p_sw,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0IN uint16_t lid_ho)
>> =C2=A0{
>> - =C2=A0 =C2=A0 if (lid_ho =3D=3D 0 || lid_ho > IB_LID_UCAST_END_HO)
>> + =C2=A0 =C2=A0 if (lid_ho =3D=3D 0 || lid_ho >=3D p_sw->lft_size)
>
> Similar story? Shouldn't this be checked against p_sw->max_lid_ho?

Yes and this change could be considered independent as I think is a
minor optimization even with the LFT heap changes.

-- Hal

>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return OSM_NO_PATH;
>> =C2=A0 =C2=A0 =C2=A0 return p_sw->lft[lid_ho];
>> =C2=A0}
>> @@ -711,7 +712,7 @@ osm_switch_set_lft_block(IN osm_switch_t * p_sw,=
 IN const uint8_t * p_block,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint16_t) (block_n=
um * IB_SMP_DATA_SIZE);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_sw);
>>
>> - =C2=A0 =C2=A0 if (lid_start + IB_SMP_DATA_SIZE > IB_LID_UCAST_END_=
HO)
>> + =C2=A0 =C2=A0 if (lid_start + IB_SMP_DATA_SIZE > p_sw->lft_size)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INVALID_P=
ARAMETER;
>>
>> =C2=A0 =C2=A0 =C2=A0 memcpy(&p_sw->lft[lid_start], p_block, IB_SMP_D=
ATA_SIZE);
>> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state=
_mgr.c
>> index 185c700..c40c9d3 100644
>> --- a/opensm/opensm/osm_state_mgr.c
>> +++ b/opensm/opensm/osm_state_mgr.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -1011,9 +1011,9 @@ static void cleanup_switch(cl_map_item_t * ite=
m, void *log)
>> =C2=A0 =C2=A0 =C2=A0 if (!sw->new_lft)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>>
>> - =C2=A0 =C2=A0 if (memcmp(sw->lft, sw->new_lft, IB_LID_UCAST_END_HO=
 + 1))
>> + =C2=A0 =C2=A0 if (memcmp(sw->lft, sw->new_lft, sw->lft_size))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_log(log, OSM_LO=
G_ERROR, "ERR 331D: "
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "LFT of switch 0x%016" PRIx64 " is not up to date.\n",
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "LFT of switch 0x%016" PRIx64 " is not up to date\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cl_ntoh64(sw->p_node->node_info.node_guid));
>> =C2=A0 =C2=A0 =C2=A0 else {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(sw->new_lft);
>> diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
>> index ad1018f..7d51c05 100644
>> --- a/opensm/opensm/osm_switch.c
>> +++ b/opensm/opensm/osm_switch.c
>> @@ -1,6 +1,6 @@
>> =C2=A0/*
>> =C2=A0 * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
>> - * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights re=
served.
>> + * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights re=
served.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> =C2=A0 * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> @@ -130,12 +130,6 @@ osm_switch_t *osm_switch_new(IN osm_node_t * p_=
node,
>> =C2=A0 =C2=A0 =C2=A0 p_sw->num_ports =3D num_ports;
>> =C2=A0 =C2=A0 =C2=A0 p_sw->need_update =3D 2;
>>
>> - =C2=A0 =C2=A0 p_sw->lft =3D malloc(IB_LID_UCAST_END_HO + 1);
>> - =C2=A0 =C2=A0 if (!p_sw->lft)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;
>> -
>> - =C2=A0 =C2=A0 memset(p_sw->lft, OSM_NO_PATH, IB_LID_UCAST_END_HO +=
 1);
>> -
>> =C2=A0 =C2=A0 =C2=A0 p_sw->p_prof =3D malloc(sizeof(*p_sw->p_prof) *=
 num_ports);
>> =C2=A0 =C2=A0 =C2=A0 if (!p_sw->p_prof)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err;
>> @@ -166,7 +160,7 @@ boolean_t osm_switch_get_lft_block(IN const osm_=
switch_t * p_sw,
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_sw);
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_block);
>>
>> - =C2=A0 =C2=A0 if (base_lid_ho > p_sw->max_lid_ho)
>> + =C2=A0 =C2=A0 if (base_lid_ho >=3D p_sw->lft_size)
>
> Ditto.
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return FALSE;
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D I=
B_LID_UCAST_END_HO);
>> @@ -498,21 +492,54 @@ void osm_switch_clear_hops(IN osm_switch_t * p=
_sw)
>>
>> =C2=A0/*************************************************************=
*********
>> =C2=A0 *************************************************************=
*********/
>> +static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
>> +{
>> + =C2=A0 =C2=A0 uint16_t lft_size;
>> + =C2=A0 =C2=A0 uint8_t *new_lft;
>> +
>> + =C2=A0 =C2=A0 lft_size =3D lids;
>> + =C2=A0 =C2=A0 /* Ensure LFT is in units of LFT block size */
>> + =C2=A0 =C2=A0 if (lids % IB_SMP_DATA_SIZE)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lft_size =3D (lids + IB_=
SMP_DATA_SIZE) / IB_SMP_DATA_SIZE * IB_SMP_DATA_SIZE;
>
> Could be slightly faster:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0lft_size =3D (lids + IB_SMP_DATA_SIZE - 1)=
 / IB_SMP_DATA_SIZE * IB_SMP_DATA_SIZE;
>
>> +
>> + =C2=A0 =C2=A0 if (!p_sw->lft) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 new_lft =3D malloc(lft_s=
ize);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!new_lft)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(new_lft, OSM_NO_P=
ATH, lft_size);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft =3D new_lft;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft_size =3D lft_s=
ize;
>> + =C2=A0 =C2=A0 } else if (lft_size > p_sw->lft_size) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 new_lft =3D realloc(p_sw=
->lft, lft_size);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!new_lft)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(new_lft + p_sw->l=
ft_size, OSM_NO_PATH,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0lft_size - p_sw->lft_size);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft =3D new_lft;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw->lft_size =3D lft_s=
ize;
>> + =C2=A0 =C2=A0 }
>
> I think that this if/else if can be merged since initially p_sw->lft_=
size
> is zero.
>
> Sasha
>
>> + =C2=A0 =C2=A0 return 0;
>> +}
>> +
>> +/******************************************************************=
****
>> + ******************************************************************=
****/
>> =C2=A0int osm_switch_prepare_path_rebuild(IN osm_switch_t * p_sw, IN=
 uint16_t max_lids)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 uint8_t **hops;
>> =C2=A0 =C2=A0 =C2=A0 unsigned i;
>>
>> + =C2=A0 =C2=A0 if (alloc_lft(p_sw, max_lids))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
>> +
>> =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < p_sw->num_ports; i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_port_prof_const=
ruct(&p_sw->p_prof[i]);
>>
>> =C2=A0 =C2=A0 =C2=A0 osm_switch_clear_hops(p_sw);
>>
>> - =C2=A0 =C2=A0 if (!p_sw->new_lft &&
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 !(p_sw->new_lft =3D malloc(IB_LID_UCAS=
T_END_HO + 1)))
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INSUFFICIENT_M=
EMORY;
>> + =C2=A0 =C2=A0 if (!(p_sw->new_lft =3D realloc(p_sw->new_lft, p_sw-=
>lft_size)))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
>>
>> - =C2=A0 =C2=A0 memset(p_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_=
HO + 1);
>> + =C2=A0 =C2=A0 memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (!p_sw->hops) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hops =3D malloc((ma=
x_lids + 1) * sizeof(hops[0]));
>> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_uca=
st_cache.c
>> index 6d3c53e..31a5333 100644
>> --- a/opensm/opensm/osm_ucast_cache.c
>> +++ b/opensm/opensm/osm_ucast_cache.c
>> @@ -1079,10 +1079,10 @@ int osm_ucast_cache_process(osm_ucast_mgr_t =
* p_mgr)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* no new routing was recently calculated for this
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0switch, but the LFT needs to be updated anyway */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p_sw->new_lft =3D p_sw->lft;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_sw->lft =3D malloc(IB_LID_UCAST_END_HO + 1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_sw->lft =3D malloc(p_sw->lft_size);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!p_sw->lft)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IB_INSUFFICIENT_MEMORY;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 memset(p_sw->lft, OSM_NO_PATH, IB_LID_UCAST_END_HO + 1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 memset(p_sw->lft, OSM_NO_PATH, p_sw->lft_size);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 }
>> diff --git a/opensm/opensm/osm_ucast_file.c b/opensm/opensm/osm_ucas=
t_file.c
>> index 5b73ca5..7c1b5ba 100644
>> --- a/opensm/opensm/osm_ucast_file.c
>> +++ b/opensm/opensm/osm_ucast_file.c
>> @@ -193,8 +193,7 @@ static int do_ucast_file_load(void *context)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh=
64(sw_guid));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 memset(p_sw->new_lft, OSM_NO_PATH,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_LID_UCAST_END_HO + 1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 memset(p_sw->new_lft, OSM_NO_PATH, p_sw->lft_size);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (p_sw && =
!strncmp(p, "0x", 2)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 p +=3D 2;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 lid =3D (uint16_t) strtoul(p, &q, 16);
>> diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_uca=
st_ftree.c
>> index 1defd95..885c834 100644
>> --- a/opensm/opensm/osm_ucast_ftree.c
>> +++ b/opensm/opensm/osm_ucast_ftree.c
>> @@ -566,7 +566,7 @@ static ftree_sw_t *sw_create(IN ftree_fabric_t *=
 p_ftree,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
>>
>> =C2=A0 =C2=A0 =C2=A0 /* initialize lft buffer */
>> - =C2=A0 =C2=A0 memset(p_osm_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_=
END_HO + 1);
>> + =C2=A0 =C2=A0 memset(p_osm_sw->new_lft, OSM_NO_PATH, p_osm_sw->lft=
_size);
>> =C2=A0 =C2=A0 =C2=A0 p_sw->hops =3D malloc((p_osm_sw->max_lid_ho + 1=
) * sizeof(*(p_sw->hops)));
>> =C2=A0 =C2=A0 =C2=A0 if (p_sw->hops =3D=3D NULL)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
>> diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucas=
t_lash.c
>> index 8b0a190..8015226 100644
>> --- a/opensm/opensm/osm_ucast_lash.c
>> +++ b/opensm/opensm/osm_ucast_lash.c
>> @@ -994,7 +994,7 @@ static void populate_fwd_tbls(lash_t * p_lash)
>>
>> =C2=A0 =C2=A0 =C2=A0 p_next_sw =3D (osm_switch_t *) cl_qmap_head(&p_=
subn->sw_guid_tbl);
>>
>> - =C2=A0 =C2=A0 /* Go through each swtich individually */
>> + =C2=A0 =C2=A0 /* Go through each switch individually */
>> =C2=A0 =C2=A0 =C2=A0 while (p_next_sw !=3D (osm_switch_t *) cl_qmap_=
end(&p_subn->sw_guid_tbl)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uint64_t current_gu=
id;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch_t *sw;
>> @@ -1005,7 +1005,7 @@ static void populate_fwd_tbls(lash_t * p_lash)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current_guid =3D p_=
sw->p_node->node_info.port_guid;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sw =3D p_sw->priv;
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_sw->new_lft, OS=
M_NO_PATH, IB_LID_UCAST_END_HO + 1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(p_sw->new_lft, OS=
M_NO_PATH, p_sw->lft_size);
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (lid =3D 1; lid=
 <=3D max_lid_ho; lid++) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 port =3D cl_ptr_vector_get(&p_subn->port_lid_tbl, lid);
>> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast=
_mgr.c
>> index be37df9..d0e85b1 100644
>> --- a/opensm/opensm/osm_ucast_mgr.c
>> +++ b/opensm/opensm/osm_ucast_mgr.c
>> @@ -372,7 +372,7 @@ static void ucast_mgr_process_tbl(IN cl_map_item=
_t * p_map_item,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(osm_node_=
get_node_guid(p_sw->p_node)));
>>
>> =C2=A0 =C2=A0 =C2=A0 /* Initialize LIDs in buffer to invalid port nu=
mber. */
>> - =C2=A0 =C2=A0 memset(p_sw->new_lft, OSM_NO_PATH, IB_LID_UCAST_END_=
HO + 1);
>> + =C2=A0 =C2=A0 memset(p_sw->new_lft, OSM_NO_PATH, p_sw->max_lid_ho =
+ 1);
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_mgr->p_subn->opt.lmc)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 alloc_ports_priv(p_=
mgr);
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

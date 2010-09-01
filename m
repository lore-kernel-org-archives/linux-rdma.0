From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] osmtest/SA client: Only set attribute offset for RMPP operations
Date: Wed, 1 Sep 2010 15:29:59 -0400
Message-ID: <AANLkTik2cNm2uMA=Z_+zfmnQYpWfxES+DsctaO9omn7m@mail.gmail.com>
References: <20100827123717.GA15888@comcast.net>
	<20100901192722.GH12172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100901192722.GH12172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 1, 2010 at 3:27 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> Hi Hal,
>
> On 08:37 Fri 27 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>
> The patch description would be very useful.

I thought the subject line was sufficiently descriptive but I guess not=
=2E

> What is motivation for such changes?

Most of what the SA client is doing is not RMPP (for example, a
GetTable is not RMPP but is requesting RMPP). SA AttributeOffset only
needs to be set in RMPP DATA packets.

-- Hal

> Sasha
>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libven=
dor/osm_vendor_ibumad_sa.c
>> index 3a7d54a..a81a6b7 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad_sa.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
>> @@ -2,7 +2,7 @@
>> =C2=A0 * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2007,2009 Mellanox Technologies LTD. All=
 rights reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> - * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> + * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -342,6 +342,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bi=
nd,
>> =C2=A0 =C2=A0 =C2=A0 static atomic32_t trans_id;
>> =C2=A0 =C2=A0 =C2=A0 boolean_t sync;
>> =C2=A0 =C2=A0 =C2=A0 osmv_query_req_t *p_query_req_copy;
>> + =C2=A0 =C2=A0 uint32_t sa_size;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(p_log);
>>
>> @@ -401,8 +402,8 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bi=
nd,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sa_mad->rmpp_flag=
s =3D IB_RMPP_FLAG_ACTIVE;
>> =C2=A0#endif
>> =C2=A0 =C2=A0 =C2=A0 if (p_sa_mad->comp_mask) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(p_sa_mad->data, p=
_sa_mad_data->p_attr,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0ib_get_attr_size(p_sa_mad_data->attr_offset));
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sa_mad_data->attr_offs=
et ? (sa_size =3D ib_get_attr_size(p_sa_mad_data->attr_offset)) : (sa_s=
ize =3D IB_SA_DATA_SIZE);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(p_sa_mad->data, p=
_sa_mad_data->p_attr, sa_size);
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 /*
>> @@ -488,6 +489,7 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 /* Set the request information. */
>> =C2=A0 =C2=A0 =C2=A0 sa_mad_data.method =3D IB_MAD_METHOD_GETTABLE;
>> =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_mod =3D 0;
>> + =C2=A0 =C2=A0 sa_mad_data.attr_offset =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 /* Set the MAD attributes and component mask co=
rrectly. */
>> =C2=A0 =C2=A0 =C2=A0 switch (p_query_req->query_type) {
>> @@ -497,7 +499,11 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_user_query->m=
ethod)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sa_mad_data.method =3D p_user_query->method;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D p_user_query->attr_offset;
>> +#ifdef DUAL_SIDED_RMPP
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sa_mad_data.method =3D=
=3D IB_MAD_METHOD_GETMULTI ||
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_dat=
a.method =3D=3D IB_MAD_METHOD_GETTRACETABLE)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sa_mad_data.attr_offset =3D p_user_query->attr_offset;
>> +#endif
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D p_user_query->attr_id;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_mo=
d =3D p_user_query->attr_mod;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D p_user_query->comp_mask;
>> @@ -507,8 +513,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 case OSMV_QUERY_ALL_SVC_RECS:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 SVC_REC_BY_NAME\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_SERVICE_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_service_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.svc_rec;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> @@ -518,8 +522,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.method =
=3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D IB_SR_COMPMASK_SNAME;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_service_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.svc_rec;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(u.svc_rec.se=
rvice_name, p_query_req->p_query_input,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sizeof(ib_svc_name_t));
>> @@ -529,8 +531,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 SVC_REC_BY_ID\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D IB_SR_COMPMASK_SID;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_service_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.svc_rec;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u.svc_rec.service_i=
d =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *(ib_=
net64_t *) (p_query_req->p_query_input);
>> @@ -540,8 +540,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 CLASS_PORT_INFO\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.method =
=3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_CLASS_PORT_INFO;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_class_port_info_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.class_port_info;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> @@ -549,8 +547,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 case OSMV_QUERY_NODE_REC_BY_NODE_GUID:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 NODE_REC_BY_NODE_GUID\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_NODE_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_node_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D IB_NR_COMPMASK_NODEGUID;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.node_rec;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u.node_rec.node_inf=
o.node_guid =3D
>> @@ -560,8 +556,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 case OSMV_QUERY_PORT_REC_BY_LID:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 PORT_REC_BY_LID\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_PORTINFO_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_portinfo_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D IB_PIR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.port_info;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u.port_info.lid =3D=
 *(ib_net16_t *) (p_query_req->p_query_input);
>> @@ -572,8 +566,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 PORT_REC_BY_LID_AND_NUM\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_PORTINFO_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_portinfo_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_PI=
R_COMPMASK_LID | IB_PIR_COMPMASK_PORTNUM;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D p_user_query->p_attr;
>> @@ -584,8 +576,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_VLARB_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_vl_arb_table_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_VL=
A_COMPMASK_LID | IB_VLA_COMPMASK_OUT_PORT |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_VL=
A_COMPMASK_BLOCK;
>> @@ -597,8 +587,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_SLVL_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_slvl_table_record_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SL=
VL_COMPMASK_LID | IB_SLVL_COMPMASK_OUT_PORT |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SL=
VL_COMPMASK_IN_PORT;
>> @@ -609,8 +597,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 PATH_REC_BY_PORT_GUIDS\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&u.path_rec,=
 0, sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_PATH_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (IB_P=
R_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u.path_rec.num_path=
 =3D 0x7f;
>> @@ -629,8 +615,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 PATH_REC_BY_GIDS\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&u.path_rec,=
 0, sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_PATH_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (IB_P=
R_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u.path_rec.num_path=
 =3D 0x7f;
>> @@ -648,8 +632,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&u.path_rec,=
 0, sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.method =
=3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_PATH_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_path_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (IB_P=
R_COMPMASK_DLID | IB_PR_COMPMASK_SLID);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D &u.path_rec;
>> @@ -665,8 +647,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_SET\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_member_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D p_user_query->comp_mask;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D p_user_query->p_attr;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> @@ -676,8 +656,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_user_query =3D (o=
smv_user_query_t *) p_query_req->p_query_input;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_log, OSM_=
LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_DELETE\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_id=
 =3D IB_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.attr_offset =
=3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_get_att=
r_offset(sizeof(ib_member_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.comp_ma=
sk =3D p_user_query->comp_mask;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sa_mad_data.p_attr =
=3D p_user_query->p_attr;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>> diff --git a/opensm/osmtest/osmt_multicast.c b/opensm/osmtest/osmt_m=
ulticast.c
>> index 34422b7..5c938b5 100644
>> --- a/opensm/osmtest/osmt_multicast.c
>> +++ b/opensm/osmtest/osmt_multicast.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All=
 rights reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2010 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -65,7 +66,6 @@ static void __osmt_print_all_multicast_records(IN =
osmtest_t * const p_osmt)
>> =C2=A0 =C2=A0 =C2=A0 memset(&user, 0, sizeof(user));
>>
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(*mcas=
t_record));
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> =C2=A0 =C2=A0 =C2=A0 req.timeout_ms =3D p_osmt->opt.transaction_time=
out;
>> @@ -167,7 +167,6 @@ ib_api_status_t osmt_query_mcast(IN osmtest_t * =
const p_osmt)
>>
>> =C2=A0 =C2=A0 =C2=A0 context.p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_me=
mber_rec_t));
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> =C2=A0 =C2=A0 =C2=A0 req.timeout_ms =3D p_osmt->opt.transaction_time=
out;
>> @@ -303,14 +302,12 @@ osmt_send_mcast_request(IN osmtest_t * const p=
_osmt,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.query_type =3D =
OSMV_QUERY_USER_DEFINED;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_=
MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB=
_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_offset =3D ib_=
get_attr_offset(sizeof(ib_member_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 } else if (is_set =3D=3D 0xff) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(&p_osmt->lo=
g, OSM_LOG_VERBOSE,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "Set USER DEFINED QUERY\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.query_type =3D =
OSMV_QUERY_USER_DEFINED;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_=
MAD_METHOD_SET;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB=
_MAD_ATTR_MCMEMBER_RECORD;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_offset =3D ib_=
get_attr_offset(sizeof(ib_member_rec_t));
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 /* TODO : Check the validity of all user fields=
 in order to use
>> diff --git a/opensm/osmtest/osmt_service.c b/opensm/osmtest/osmt_ser=
vice.c
>> index a203b0c..6f27109 100644
>> --- a/opensm/osmtest/osmt_service.c
>> +++ b/opensm/osmtest/osmt_service.c
>> @@ -2,6 +2,7 @@
>> =C2=A0 * Copyright (c) 2006-2008 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2006 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> + * Copyright (c) 2010 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -121,7 +122,6 @@ osmt_register_service(IN osmtest_t * const p_osm=
t,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SLEASE |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SKEY | IB_SR_COMPMASK_SNAME;
>> =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> @@ -226,7 +226,6 @@ osmt_register_service_with_full_key(IN osmtest_t=
 * const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SLEASE |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SKEY | IB_SR_COMPMASK_SNAME;
>> =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> @@ -373,7 +372,6 @@ osmt_register_service_with_data(IN osmtest_t * c=
onst p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SDATA32_1 |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IB_SR=
_COMPMASK_SDATA64_0 | IB_SR_COMPMASK_SDATA64_1;
>> =C2=A0 =C2=A0 =C2=A0 }
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 /* =C2=A0Dump to Service Data b4 send */
>> @@ -486,7 +484,6 @@ osmt_get_service_by_id_and_name(IN osmtest_t * c=
onst p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_SR_COMPMASK_SID | IB_SR_C=
OMPMASK_SNAME;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> @@ -607,7 +604,6 @@ osmt_get_service_by_id(IN osmtest_t * const p_os=
mt,
>> =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_SR_COMPMASK_SID;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> @@ -739,7 +735,6 @@ osmt_get_service_by_name_and_key(IN osmtest_t * =
const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_MAD_METHOD_GET;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_SR_COMPMASK_SNAME | IB_SR=
_COMPMASK_SKEY;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS) {
>> @@ -1092,7 +1087,6 @@ osmt_delete_service_by_name(IN osmtest_t * con=
st p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 user.method =3D IB_MAD_METHOD_DELETE;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SERVICE_RECORD;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_SR_COMPMASK_SNAME;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset(sizeof(ib_se=
rvice_record_t));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &svc_rec;
>>
>> =C2=A0 =C2=A0 =C2=A0 status =3D osmv_query_sa(p_osmt->h_bind, &req);
>> diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
>> index d96fb28..af17d15 100644
>> --- a/opensm/osmtest/osmtest.c
>> +++ b/opensm/osmtest/osmtest.c
>> @@ -2,7 +2,7 @@
>> =C2=A0 * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
>> =C2=A0 * Copyright (c) 2002-2007 Mellanox Technologies LTD. All righ=
ts reserved.
>> =C2=A0 * Copyright (c) 1996-2003 Intel Corporation. All rights reser=
ved.
>> - * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> + * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
>> =C2=A0 *
>> =C2=A0 * This software is available to you under a choice of one of =
two
>> =C2=A0 * licenses. =C2=A0You may choose to be licensed under the ter=
ms of the GNU
>> @@ -563,7 +563,6 @@ osmtest_get_all_recs(IN osmtest_t * const p_osmt=
,
>>
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D attr_id;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) a=
ttr_size);
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> =C2=A0 =C2=A0 =C2=A0 req.timeout_ms =3D p_osmt->opt.transaction_time=
out;
>> @@ -719,7 +718,6 @@ osmtest_get_node_rec(IN osmtest_t * const p_osmt=
,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_NR_COMPMASK_NODEGUID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_NODE_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -793,7 +791,6 @@ osmtest_get_node_rec_by_lid(IN osmtest_t * const=
 p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_NR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_NODE_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -1057,7 +1054,6 @@ osmtest_get_port_rec(IN osmtest_t * const p_os=
mt,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_PIR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_PORTINFO_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4171,7 +4167,6 @@ osmtest_get_link_rec_by_lid(IN osmtest_t * con=
st p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 if (to_lid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask |=3D=
 IB_LR_COMPMASK_TO_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_LINK_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4249,7 +4244,6 @@ osmtest_get_guidinfo_rec_by_lid(IN osmtest_t *=
 const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_GIR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_GUIDINFO_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4328,7 +4322,6 @@ osmtest_get_pkeytbl_rec_by_lid(IN osmtest_t * =
const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_PKEY_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_PKEY_TBL_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4407,7 +4400,6 @@ osmtest_get_sw_info_rec_by_lid(IN osmtest_t * =
const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 if (lid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D =
IB_SWIR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SWITCH_INFO_RECORD=
;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4486,7 +4478,6 @@ osmtest_get_lft_rec_by_lid(IN osmtest_t * cons=
t p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 if (lid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D =
IB_LFTR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_LFT_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4565,7 +4556,6 @@ osmtest_get_mft_rec_by_lid(IN osmtest_t * cons=
t p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 if (lid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D =
IB_MFTR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_MFT_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
>> @@ -4637,7 +4627,6 @@ osmtest_sminfo_record_request(IN osmtest_t * c=
onst p_osmt,
>>
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_SMINFO_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 p_sm_info_opt =3D p_options;
>> =C2=A0 =C2=A0 =C2=A0 if (p_sm_info_opt->sm_guid !=3D 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 record.sm_info.guid=
 =3D p_sm_info_opt->sm_guid;
>> @@ -4737,7 +4726,6 @@ osmtest_informinfo_request(IN osmtest_t * cons=
t p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 p_context->p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D attr_id;
>> =C2=A0 =C2=A0 =C2=A0 if (attr_id =3D=3D IB_MAD_ATTR_INFORM_INFO_RECO=
RD) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_offset =3D ib_=
get_attr_offset((uint16_t) sizeof(record));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_inform_info_rec_o=
pt =3D p_options;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_inform_info_r=
ec_opt->subscriber_gid.unicast.prefix !=3D 0 &&
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_inf=
orm_info_rec_opt->subscriber_gid.unicast.
>> @@ -4751,7 +4739,6 @@ osmtest_informinfo_request(IN osmtest_t * cons=
t p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask |=3D=
 IB_IIR_COMPMASK_ENUM;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &re=
cord;
>> =C2=A0 =C2=A0 =C2=A0 } else {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.attr_offset =3D ib_=
get_attr_offset((uint16_t) sizeof(rec));
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* comp mask bits b=
elow are for InformInfoRecord rather than InformInfo */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* as currently no =
comp mask bits defined for InformInfo!!! */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D =
IB_IIR_COMPMASK_SUBSCRIBE;
>> @@ -4900,7 +4887,6 @@ osmtest_validate_single_node_rec_lid(IN osmtes=
t_t * const p_osmt,
>> =C2=A0 =C2=A0 =C2=A0 context.p_osmt =3D p_osmt;
>> =C2=A0 =C2=A0 =C2=A0 user.comp_mask =3D IB_NR_COMPMASK_LID;
>> =C2=A0 =C2=A0 =C2=A0 user.attr_id =3D IB_MAD_ATTR_NODE_RECORD;
>> - =C2=A0 =C2=A0 user.attr_offset =3D ib_get_attr_offset((uint16_t) s=
izeof(record));
>> =C2=A0 =C2=A0 =C2=A0 user.p_attr =3D &record;
>>
>> =C2=A0 =C2=A0 =C2=A0 req.query_type =3D OSMV_QUERY_USER_DEFINED;
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

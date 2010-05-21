From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm/libvendor Reduce stack consumption
Date: Fri, 21 May 2010 10:37:54 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBBCE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Reduce stack consumption by using a union of structs instead of individual struct allocations.
Code borrowed from osm_vendor_ibumad_sa.c

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/libvendor/osm_vendor_mlx_sa.c b/opensm/libvendor/osm_vendor_mlx_sa.c
index 91f82fa..0cc3f19 100644
--- a/opensm/libvendor/osm_vendor_mlx_sa.c
+++ b/opensm/libvendor/osm_vendor_mlx_sa.c
@@ -576,14 +576,19 @@ ib_api_status_t
 osmv_query_sa(IN osm_bind_handle_t h_bind,
              IN const osmv_query_req_t * const p_query_req)
 {
-       osmv_sa_bind_info_t *p_bind = (osmv_sa_bind_info_t *) h_bind;
+       union {
+               ib_service_record_t svc_rec;
+               ib_node_record_t node_rec;
+               ib_portinfo_record_t port_info;
+               ib_path_rec_t path_rec;
+#ifdef DUAL_SIDED_RMPP
+               ib_multipath_rec_t multipath_rec;
+#endif
+               ib_class_port_info_t class_port_info;
+       } u;
        osmv_sa_mad_data_t sa_mad_data;
+       osmv_sa_bind_info_t *p_bind = (osmv_sa_bind_info_t *) h_bind;
        osmv_user_query_t *p_user_query;
-       ib_service_record_t svc_rec;
-       ib_node_record_t node_rec;
-       ib_portinfo_record_t port_info;
-       ib_path_rec_t path_rec;
-       ib_class_port_info_t class_port_info;
        osm_log_t *p_log = p_bind->p_log;
        ib_api_status_t status;

@@ -617,7 +622,7 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_service_record_t));
                sa_mad_data.comp_mask = 0;
-               sa_mad_data.p_attr = &svc_rec;
+               sa_mad_data.p_attr = &u.svc_rec;
                break;

        case OSMV_QUERY_SVC_REC_BY_NAME:
@@ -628,8 +633,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.comp_mask = IB_SR_COMPMASK_SNAME;
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_service_record_t));
-               sa_mad_data.p_attr = &svc_rec;
-               memcpy(svc_rec.service_name, p_query_req->p_query_input,
+               sa_mad_data.p_attr = &u.svc_rec;
+               memcpy(u.svc_rec.service_name, p_query_req->p_query_input,
                       sizeof(ib_svc_name_t));
                break;

@@ -640,8 +645,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.comp_mask = IB_SR_COMPMASK_SID;
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_service_record_t));
-               sa_mad_data.p_attr = &svc_rec;
-               svc_rec.service_id =
+               sa_mad_data.p_attr = &u.svc_rec;
+               u.svc_rec.service_id =
                    *(ib_net64_t *) (p_query_req->p_query_input);
                break;

@@ -653,7 +658,7 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_class_port_info_t));
                sa_mad_data.comp_mask = 0;
-               sa_mad_data.p_attr = &class_port_info;
+               sa_mad_data.p_attr = &u.class_port_info;

                break;

@@ -665,8 +670,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_node_record_t));
                sa_mad_data.comp_mask = IB_NR_COMPMASK_NODEGUID;
-               sa_mad_data.p_attr = &node_rec;
-               node_rec.node_info.node_guid =
+               sa_mad_data.p_attr = &u.node_rec;
+               u.node_rec.node_info.node_guid =
                    *(ib_net64_t *) (p_query_req->p_query_input);

                break;
@@ -678,8 +683,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_portinfo_record_t));
                sa_mad_data.comp_mask = IB_PIR_COMPMASK_LID;
-               sa_mad_data.p_attr = &port_info;
-               port_info.lid = *(ib_net16_t *) (p_query_req->p_query_input);
+               sa_mad_data.p_attr = &u.port_info;
+               u.port_info.lid = *(ib_net16_t *) (p_query_req->p_query_input);
                break;

        case OSMV_QUERY_PORT_REC_BY_LID_AND_NUM:
@@ -729,19 +734,19 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
        case OSMV_QUERY_PATH_REC_BY_PORT_GUIDS:
                osm_log(p_log, OSM_LOG_DEBUG,
                        "osmv_query_sa DBG:001 %s", "PATH_REC_BY_PORT_GUIDS\n");
-               memset(&path_rec, 0, sizeof(ib_path_rec_t));
+               memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
                sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_path_rec_t));
                sa_mad_data.comp_mask =
                    (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
-               path_rec.num_path = 0x7f;
-               sa_mad_data.p_attr = &path_rec;
-               ib_gid_set_default(&path_rec.dgid,
+               u.path_rec.num_path = 0x7f;
+               sa_mad_data.p_attr = &u.path_rec;
+               ib_gid_set_default(&u.path_rec.dgid,
                                   ((osmv_guid_pair_t *) (p_query_req->
                                                          p_query_input))->
                                   dest_guid);
-               ib_gid_set_default(&path_rec.sgid,
+               ib_gid_set_default(&u.path_rec.sgid,
                                   ((osmv_guid_pair_t *) (p_query_req->
                                                          p_query_input))->
                                   src_guid);
@@ -750,18 +755,18 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
        case OSMV_QUERY_PATH_REC_BY_GIDS:
                osm_log(p_log, OSM_LOG_DEBUG,
                        "osmv_query_sa DBG:001 %s", "PATH_REC_BY_GIDS\n");
-               memset(&path_rec, 0, sizeof(ib_path_rec_t));
+               memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
                sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_path_rec_t));
                sa_mad_data.comp_mask =
-                   (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
-               path_rec.num_path = 0x7f;
-               sa_mad_data.p_attr = &path_rec;
-               memcpy(&path_rec.dgid,
+                 (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
+               u.path_rec.num_path = 0x7f;
+               sa_mad_data.p_attr = &u.path_rec;
+               memcpy(&u.path_rec.dgid,
                       &((osmv_gid_pair_t *) (p_query_req->p_query_input))->
                       dest_gid, sizeof(ib_gid_t));
-               memcpy(&path_rec.sgid,
+               memcpy(&u.path_rec.sgid,
                       &((osmv_gid_pair_t *) (p_query_req->p_query_input))->
                       src_gid, sizeof(ib_gid_t));
                break;
@@ -769,18 +774,18 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
        case OSMV_QUERY_PATH_REC_BY_LIDS:
                osm_log(p_log, OSM_LOG_DEBUG,
                        "osmv_query_sa DBG:001 %s", "PATH_REC_BY_LIDS\n");
-               memset(&path_rec, 0, sizeof(ib_path_rec_t));
+               memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
                sa_mad_data.method = IB_MAD_METHOD_GET;
                sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
                sa_mad_data.attr_offset =
                    ib_get_attr_offset(sizeof(ib_path_rec_t));
                sa_mad_data.comp_mask =
                    (IB_PR_COMPMASK_DLID | IB_PR_COMPMASK_SLID);
-               sa_mad_data.p_attr = &path_rec;
-               path_rec.dlid =
+               sa_mad_data.p_attr = &u.path_rec;
+               u.path_rec.dlid =
                    ((osmv_lid_pair_t *) (p_query_req->p_query_input))->
                    dest_lid;
-               path_rec.slid =
+               u.path_rec.slid =
                    ((osmv_lid_pair_t *) (p_query_req->p_query_input))->src_lid;
                break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

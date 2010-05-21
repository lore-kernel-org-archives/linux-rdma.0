From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] osmtest - use helper function
Date: Fri, 21 May 2010 10:23:26 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBB95@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use defined inline helper function instead of actual implementation.
Separate implementation from use.

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index 50f94db..5d9c54c 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -719,7 +719,7 @@ osmtest_get_node_rec(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.comp_mask = IB_NR_COMPMASK_NODEGUID;
        user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -793,7 +793,7 @@ osmtest_get_node_rec_by_lid(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.comp_mask = IB_NR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -1057,7 +1057,7 @@ osmtest_get_port_rec(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.comp_mask = IB_PIR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4171,7 +4171,7 @@ osmtest_get_link_rec_by_lid(IN osmtest_t * const p_osmt,
        if (to_lid)
                user.comp_mask |= IB_LR_COMPMASK_TO_LID;
        user.attr_id = IB_MAD_ATTR_LINK_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4249,7 +4249,7 @@ osmtest_get_guidinfo_rec_by_lid(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.comp_mask = IB_GIR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_GUIDINFO_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4328,7 +4328,7 @@ osmtest_get_pkeytbl_rec_by_lid(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.comp_mask = IB_PKEY_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_PKEY_TBL_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4407,7 +4407,7 @@ osmtest_get_sw_info_rec_by_lid(IN osmtest_t * const p_osmt,
        if (lid)
                user.comp_mask = IB_SWIR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_SWITCH_INFO_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4486,7 +4486,7 @@ osmtest_get_lft_rec_by_lid(IN osmtest_t * const p_osmt,
        if (lid)
                user.comp_mask = IB_LFTR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_LFT_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4565,7 +4565,7 @@ osmtest_get_mft_rec_by_lid(IN osmtest_t * const p_osmt,
        if (lid)
                user.comp_mask = IB_MFTR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_MFT_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4637,7 +4637,7 @@ osmtest_sminfo_record_request(IN osmtest_t * const p_osmt,

        p_context->p_osmt = p_osmt;
        user.attr_id = IB_MAD_ATTR_SMINFO_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
        p_sm_info_opt = p_options;
        if (p_sm_info_opt->sm_guid != 0) {
                record.sm_info.guid = p_sm_info_opt->sm_guid;
@@ -4737,7 +4737,7 @@ osmtest_informinfo_request(IN osmtest_t * const p_osmt,
        p_context->p_osmt = p_osmt;
        user.attr_id = attr_id;
        if (attr_id == IB_MAD_ATTR_INFORM_INFO_RECORD) {
-               user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+               user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
                p_inform_info_rec_opt = p_options;
                if (p_inform_info_rec_opt->subscriber_gid.unicast.prefix != 0 &&
                    p_inform_info_rec_opt->subscriber_gid.unicast.
@@ -4751,7 +4751,7 @@ osmtest_informinfo_request(IN osmtest_t * const p_osmt,
                user.comp_mask |= IB_IIR_COMPMASK_ENUM;
                user.p_attr = &record;
        } else {
-               user.attr_offset = cl_ntoh16((uint16_t) (sizeof(rec) >> 3));
+               user.attr_offset = ib_get_attr_offset((uint16_t) (sizeof(record)));
                /* comp mask bits below are for InformInfoRecord rather than InformInfo */
                /* as currently no comp mask bits defined for InformInfo!!! */
                user.comp_mask = IB_IIR_COMPMASK_SUBSCRIBE;
@@ -4900,7 +4900,7 @@ osmtest_validate_single_node_rec_lid(IN osmtest_t * const p_osmt,
        context.p_osmt = p_osmt;
        user.comp_mask = IB_NR_COMPMASK_LID;
        user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-       user.attr_offset = cl_ntoh16((uint16_t) (sizeof(record) >> 3));
+       user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
        user.p_attr = &record;

        req.query_type = OSMV_QUERY_USER_DEFINED;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

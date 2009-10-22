From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC] osmtest/osmt_multicast.c: fix strict aliasing breakage
 warning
Date: Thu, 22 Oct 2009 14:00:02 +0200
Message-ID: <20091022120002.GY20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This eliminates compile warning (with >=3D gcc-4.4.0 and -O2 -Wall flag=
s):

warning: dereferencing pointer =E2=80=98p_mc_res=E2=80=99 does break st=
rict-aliasing rules

resulted by assignment (and later pointer use) like:

	ib_sa_mad_t res_sa_mad;
	ib_member_rec_t *p_mc_res;

	p_mc_res =3D ib_sa_mad_get_payload_ptr(&res_sa_mad);

ib_mad_t structure doesn't match p_mc_res pointer type and seems that
this violates gcc-4.4 strict aliasing rule.

After some googling around such and similar issues I found nothing
smarter than to shut this up by aggregating ib_mad_t structure into an
union where one of its members would match 'p_mc_res' pointer type.

Thoughts and/or any better ideas?

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/osmtest/osmt_multicast.c |  311 ++++++++++++++++++++-----------=
--------
 1 files changed, 156 insertions(+), 155 deletions(-)

diff --git a/opensm/osmtest/osmt_multicast.c b/opensm/osmtest/osmt_mult=
icast.c
index 2c6480f..e1a1899 100644
--- a/opensm/osmtest/osmt_multicast.c
+++ b/opensm/osmtest/osmt_multicast.c
@@ -464,8 +464,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t *=
 const p_osmt)
 	char gid_str2[INET6_ADDRSTRLEN];
 	ib_api_status_t status;
 	ib_member_rec_t mc_req_rec;
+	union {
+		ib_sa_mad_t sa_mad;
+		ib_member_rec_t mcmr;
+	} res;
+	ib_sa_mad_t *sa_mad;
 	ib_member_rec_t *p_mc_res;
-	ib_sa_mad_t res_sa_mad;
 	uint64_t comp_mask =3D 0;
 	ib_net64_t remote_port_guid =3D 0x0;
 	cl_qmap_t *p_mgrp_mlid_tbl;
@@ -545,7 +549,8 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * =
const p_osmt)
 	p_mgrp_mlid_tbl =3D &p_osmt->exp_subn.mgrp_mlid_tbl;
 	osmt_init_mc_query_rec(p_osmt, &mc_req_rec);
=20
-	p_mc_res =3D ib_sa_mad_get_payload_ptr(&res_sa_mad);
+	sa_mad =3D &res.sa_mad;
+	p_mc_res =3D ib_sa_mad_get_payload_ptr(sa_mad);
=20
 	/* Only when we are on single mode check flow - do the count comparis=
on, otherwise skip */
 	if (p_osmt->opt.mmode =3D=3D 1 || p_osmt->opt.mmode =3D=3D 3) {
@@ -603,7 +608,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * =
const p_osmt)
=20
 		status =3D osmt_send_mcast_request(p_osmt, 0xff,	/* User Defined que=
ry Set */
 						 &mc_req_rec, comp_mask,
-						 &res_sa_mad);
+						 sa_mad);
=20
 		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 			"Joining an existing IPoIB multicast group\n");
@@ -659,7 +664,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * =
const p_osmt)
 			mc_req_rec.mtu, mc_req_rec.rate);
 		status =3D osmt_send_mcast_request(p_osmt, 0xff,	/* User Defined que=
ry */
 						 &mc_req_rec, comp_mask,
-						 &res_sa_mad);
+						 sa_mad);
 		OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 			"Sent Join request using response values, response is : %s\n",
 			ib_get_err_str(status));
@@ -686,7 +691,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * =
const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 0xee,	/* User Defined quer=
y Get */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status =3D=3D IB_SUCCESS) {
@@ -715,7 +720,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * =
const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 0xee,	/* User Defined quer=
y Get */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status =3D=3D IB_SUCCESS) {
@@ -748,16 +753,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EE: "
 			"Expectedd REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -779,16 +784,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02ED: "
 			"Expectedd REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -814,16 +819,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EC: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -845,16 +850,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EA: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -878,16 +883,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E9: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -906,15 +911,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0207: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -932,15 +937,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0208: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -958,15 +963,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AB: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -984,15 +989,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AC: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1010,15 +1015,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AD: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1034,15 +1039,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AE: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1060,15 +1065,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
+	    sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AF: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_REQ_INVALID got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1097,16 +1102,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A8: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1117,7 +1122,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02AA: "
 			"Could not get all MC Records in subnet, got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1152,16 +1157,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A7: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1190,16 +1195,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR ||
-	    ((ib_net16_t) (res_sa_mad.status & IB_SMP_STATUS_MASK)) !=3D
+	    ((ib_net16_t) (sa_mad->status & IB_SMP_STATUS_MASK)) !=3D
 	    IB_SA_MAD_STATUS_INSUF_COMPS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A6: "
 			"Expected REMOTE ERROR IB_SA_MAD_STATUS_INSUF_COMPS got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1220,12 +1225,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02A5: "
 			"Failed to create MCG for MGID=3D0 with higher than minimum RATE - =
got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1244,12 +1249,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0211: "
 			"Failed to create MCG for MGID=3D0 with less than highest RATE - go=
t %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1267,12 +1272,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0238: "
 			"Failed to create MCG for MGID=3D0 with less than highest MTU - got=
 %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1289,12 +1294,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0239: "
 			"Failed to create MCG for MGID=3D0 with higher than lowest MTU - go=
t %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1320,12 +1325,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0240: "
 			"Failed to create MCG for MGID=3D0 with exact MTU & RATE - got %s/%=
s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1347,12 +1352,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0241: "
 			"Failed to create MCG for MGID=3D0 with exact RATE - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1374,12 +1379,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0242: "
 			"Failed to create MCG for MGID=3D0 with exact MTU - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1428,12 +1433,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_LIFE | IB_MCR_COMPMASK_LIFE_SEL;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0210: "
 			"Failed to create MCG for MGID=3D0 - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1461,15 +1466,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1,	/* join */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0301: "
 			"Tried joining group that shouldn't have existed - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1483,13 +1488,13 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 			  sizeof gid_str));
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0211: "
 			"Failed to create MCG for MGID=3D%s (o15.0.1.6) - got %s/%s\n",
 			inet_ntop(AF_INET6, good_mgid.raw, gid_str,
 				  sizeof gid_str), ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1521,15 +1526,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	mc_req_rec.mgid.raw[0] =3D 0xFA;
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0213: "
 			"Failed to recognize MGID error for MGID=3D0xFA - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1544,15 +1549,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D mc_req_rec.scope_state & 0x2F;	/* local sc=
ope */
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0214: "
 			"Failed to recognize MGID error for A01B with link-local bit (statu=
s %s) (rem status %s)\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1567,15 +1572,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0215: "
 			"Failed to recognize MGID PREFIX error for MGID=3D0xEF - got %s/%s\=
n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1592,13 +1597,13 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.mgid.raw[1] =3D 0x1F;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0216: "
 			"Failed to create MCG for MGID=3D%s - got %s/%s\n",
 			inet_ntop(AF_INET6, good_mgid.raw, gid_str,
 				  sizeof gid_str), ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1619,16 +1624,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.mgid.raw[1] =3D 0x22;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0217: "
 			"Failed to recognize create with invalid flags value 0x2 - got %s/%=
s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1641,12 +1646,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.mgid =3D osm_link_local_mgid;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0218: "
 			"Failed to create MCG for MGID=3D0xFF02:0:0:0:0:0:0:1 - got %s/%s\n=
",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1672,15 +1677,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x22;	/* link-local scope, non-member stat=
e */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0219: "
 			"Failed to recognize create with JoinState !=3D FullMember - got %s=
/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1693,12 +1698,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x23;	/* link-local scope, non member and =
full member */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0220: "
 			"Failed to create MCG with valid join state 0x3 - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1720,15 +1725,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x24;	/* link-local scope, send only membe=
r */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0221: "
 			"Failed to recognize create with JoinState !=3D FullMember - got %s=
/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1743,12 +1748,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x2F;	/* link-local scope, Full member wit=
h all other bits turned on */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0222: "
 			"Failed to create MCG with valid join state 0xF - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1771,11 +1776,11 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_JOIN_STATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 0x1,	/* SubnAdmSet */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02CC: "
 			"Failed to join MCG with valid req, returned status =3D %s\n",
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1798,23 +1803,23 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	/* first, make sure  that the group exists */
 	mc_req_rec.scope_state =3D 0x21;
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02CD: "
 			"Failed to create/join as full member - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
 	mc_req_rec.scope_state =3D 0x22;	/* link-local scope, non-member */
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02D1: "
 			"Failed to update existing MGID - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1845,7 +1850,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 	mc_req_rec.scope_state =3D 0x26;
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 0, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR) {
@@ -1859,12 +1864,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	/* link-local scope, NonMember bit, the FullMember bit should stay */
 	mc_req_rec.scope_state =3D 0x22;
 	status =3D osmt_send_mcast_request(p_osmt, 0, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02D3: "
 			"Failed to partially update JoinState : %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -1883,12 +1888,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x24;	/* link-local scope, send only  memb=
er */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C0: "
 			"Failed to update existing MCG - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1906,12 +1911,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x21;	/* link-local scope, full member */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C2: "
 			"Failed to update existing MGID - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -1931,12 +1936,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x22;	/* link-local scope,non member */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C4: "
 			"Failed to update existing MGID - got %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
@@ -1976,15 +1981,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_RATE_SEL | IB_MCR_COMPMASK_RATE;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C6: "
 			"Failed to catch BAD RATE joining an existing MGID: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2001,15 +2006,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C7: "
 			"Failed to catch BAD RATE (higher than max) joining an existing MGI=
D: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2026,15 +2031,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C8: "
 			"Failed to catch BAD RATE (less than min) joining an existing MGID:=
 %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2055,12 +2060,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x22;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 0, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02C9: "
 			"Fail to partially update JoinState during delete: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2079,12 +2084,12 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	mc_req_rec.scope_state =3D 0x25;
 	status =3D osmt_send_mcast_request(p_osmt, 0, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02CB: "
 			"Failed to update JoinState during delete: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2108,14 +2113,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1,	/* join */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status !=3D IB_REMOTE_ERROR) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02BC: "
 			"Succeeded Joining Deleted Group: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2131,15 +2136,15 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x21;	/* delete full member */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02BD: "
 			"Failed to catch BAD delete from IPoIB: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2158,13 +2163,13 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	    IB_MCR_COMPMASK_LIFE | IB_MCR_COMPMASK_LIFE_SEL;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02BE: "
 			"Failed to create MCG for %s - got %s/%s\n",
 			inet_ntop(AF_INET6, good_mgid.raw, gid_str,
 				  sizeof gid_str), ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		goto Exit;
 	}
=20
@@ -2173,7 +2178,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 		"Checking Full Delete of a group (o15.0.1.14)...\n");
 	mc_req_rec.scope_state =3D 0x21;	/* the FullMember is the current Joi=
nState */
 	status =3D osmt_send_mcast_request(p_osmt, 0, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS)
 		goto Exit;
=20
@@ -2189,16 +2194,16 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 	mc_req_rec.scope_state =3D 0x21;	/* delete full member */
=20
 	status =3D osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
-					 &mc_req_rec, comp_mask, &res_sa_mad);
+					 &mc_req_rec, comp_mask, sa_mad);
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if ((status !=3D IB_REMOTE_ERROR) ||
-	    (res_sa_mad.status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
+	    (sa_mad->status !=3D IB_SA_MAD_STATUS_REQ_INVALID)) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0223: "
 			"Failed to catch BAD delete from IPoIB: %s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2219,7 +2224,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 	    IB_MCR_COMPMASK_MTU_SEL | IB_MCR_COMPMASK_MTU;
=20
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	if (status !=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02EB: "
 			"Failed to create new mgrp\n");
@@ -2240,14 +2245,14 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
=20
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec, comp_mask,
-					 &res_sa_mad);
+					 sa_mad);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
 	if (status =3D=3D IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02E4: "
 			"Expected REMOTE ERROR got:%s/%s\n",
 			ib_get_err_str(status),
-			ib_get_mad_status_str((ib_mad_t *) (&res_sa_mad)));
+			ib_get_mad_status_str((ib_mad_t *) sa_mad));
 		status =3D IB_ERROR;
 		goto Exit;
 	}
@@ -2306,14 +2311,13 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_=
t * const p_osmt)
 		comp_mask =3D IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_M=
CR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_C=
OMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS;	/* =
all above are required */
=20
 		status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec,
-						 comp_mask, &res_sa_mad);
+						 comp_mask, sa_mad);
 		if (status !=3D IB_SUCCESS) {
 			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02B4: "
 				"Could not join on behalf of remote port 0x%016"
 				PRIx64 " remote status: %s\n",
 				cl_ntoh64(remote_port_guid),
-				ib_get_mad_status_str((ib_mad_t
-						       *) (&res_sa_mad)));
+				ib_get_mad_status_str((ib_mad_t *) sa_mad));
 			status =3D IB_ERROR;
 			goto Exit;
 		}
@@ -2336,7 +2340,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
=20
 		status =3D osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
 						 &mc_req_rec,
-						 comp_mask, &res_sa_mad);
+						 comp_mask, sa_mad);
=20
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
=20
@@ -2348,8 +2352,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 					  p_mgrp->mcmember_rec.mgid.raw,
 					  gid_str, sizeof gid_str),
 				ib_get_err_str(status),
-				ib_get_mad_status_str((ib_mad_t
-						       *) (&res_sa_mad)));
+				ib_get_mad_status_str((ib_mad_t *) sa_mad));
 			status =3D IB_ERROR;
 			goto Exit;
 		}
@@ -2367,7 +2370,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 		    IB_MCR_COMPMASK_PORT_GID | IB_MCR_COMPMASK_JOIN_STATE;
 		status =3D osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
 						 &mc_req_rec,
-						 comp_mask, &res_sa_mad);
+						 comp_mask, sa_mad);
 		if (status !=3D IB_SUCCESS) {
 			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 02B0: "
 				"Failed to delete mgid with remote port guid MGID : "
@@ -2376,8 +2379,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 					  p_mgrp->mcmember_rec.mgid.raw,
 					  gid_str, sizeof gid_str),
 				ib_get_err_str(status),
-				ib_get_mad_status_str((ib_mad_t
-						       *) (&res_sa_mad)));
+				ib_get_mad_status_str((ib_mad_t *) sa_mad));
 			goto Exit;
 		}
 	} else
@@ -2412,8 +2414,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 			comp_mask =3D IB_MCR_COMPMASK_MGID | IB_MCR_COMPMASK_PORT_GID | IB_=
MCR_COMPMASK_QKEY | IB_MCR_COMPMASK_PKEY | IB_MCR_COMPMASK_SL | IB_MCR_=
COMPMASK_FLOW | IB_MCR_COMPMASK_JOIN_STATE | IB_MCR_COMPMASK_TCLASS |	/=
* all above are required */
 			    IB_MCR_COMPMASK_MLID;
 			status =3D osmt_send_mcast_request(p_osmt, 1, &mc_req_rec,
-							 comp_mask,
-							 &res_sa_mad);
+							 comp_mask, sa_mad);
 			if (status =3D=3D IB_SUCCESS) {
 				cur_mlid =3D cl_ntoh16(p_mc_res->mlid);
 				/* Save the mlid created in test_created_mlids map */
@@ -2433,7 +2434,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 				osm_dump_mc_record(&p_osmt->log, p_mc_res,
 						   OSM_LOG_VERBOSE);
 				goto Exit;
-			} else if ((res_sa_mad.status & IB_SMP_STATUS_MASK) =3D=3D
+			} else if ((sa_mad->status & IB_SMP_STATUS_MASK) =3D=3D
 				   IB_SA_MAD_STATUS_NO_RESOURCES)
 				/* You can quietly exit the loop since no available mlid in SA DB
 				   i.e. reached the maximum valid avalable mlid */
@@ -2492,7 +2493,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 				mc_req_rec.scope_state);
 			status =3D osmt_send_mcast_request(p_osmt, 0,	/* delete flag */
 							 &mc_req_rec, comp_mask,
-							 &res_sa_mad);
+							 sa_mad);
 			if (status !=3D IB_SUCCESS) {
 				OSM_LOG(&p_osmt->log, OSM_LOG_ERROR,
 					"ERR 02FF: Failed to delete MGID : %s"
@@ -2502,7 +2503,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t =
* const p_osmt)
 						  gid_str, sizeof gid_str),
 					ib_get_err_str(status),
 					ib_get_mad_status_str((ib_mad_t *)
-							      (&res_sa_mad)));
+							      sa_mad));
 				fail_to_delete_mcg++;
 			}
 		} else
--=20
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

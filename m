From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 10/12] IB/srpt: Introduce srpt_format_guid()
Date: Mon,  8 Jan 2018 11:00:49 -0800
Message-ID: <20180108190051.32008-11-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce a function for converting a GUID into an ASCII string. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6f5a4d66eacc..e4c1446699a9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -524,6 +524,15 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 	ib_free_recv_mad(mad_wc);
 }
 
+static int srpt_format_guid(char *buf, unsigned int size, const __be64 *guid)
+{
+	const __be16 *g = (const __be16 *)guid;
+
+	return snprintf(buf, size, "%04x:%04x:%04x:%04x",
+			be16_to_cpu(g[0]), be16_to_cpu(g[1]),
+			be16_to_cpu(g[2]), be16_to_cpu(g[3]));
+}
+
 /**
  * srpt_refresh_port - configure a HCA port
  * @sport: SRPT HCA port.
@@ -539,7 +548,6 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	struct ib_mad_reg_req reg_req;
 	struct ib_port_modify port_modify;
 	struct ib_port_attr port_attr;
-	__be16 *guid;
 	int ret;
 
 	memset(&port_modify, 0, sizeof(port_modify));
@@ -563,11 +571,8 @@ static int srpt_refresh_port(struct srpt_port *sport)
 		goto err_query_port;
 
 	sport->port_guid_wwn.priv = sport;
-	guid = (__be16 *)&sport->gid.global.interface_id;
-	snprintf(sport->port_guid, sizeof(sport->port_guid),
-		 "%04x:%04x:%04x:%04x",
-		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
-		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
+	srpt_format_guid(sport->port_guid, sizeof(sport->port_guid),
+			 &sport->gid.global.interface_id);
 	sport->port_gid_wwn.priv = sport;
 	snprintf(sport->port_gid, sizeof(sport->port_gid),
 		 "0x%016llx%016llx",
@@ -1998,7 +2003,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
-	__be16 *guid;
 	u32 it_iu_len;
 	int i, ret = 0;
 
@@ -2150,10 +2154,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	guid = (__be16 *)&param->primary_path->dgid.global.interface_id;
-	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
-		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
-		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
+	srpt_format_guid(ch->ini_guid, sizeof(ch->ini_guid),
+			 &param->primary_path->dgid.global.interface_id);
 	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

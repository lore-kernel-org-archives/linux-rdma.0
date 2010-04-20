From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] support diffing nodedesc on remoteports in
	ibnetdiscover
Date: Tue, 20 Apr 2010 15:30:40 -0700
Message-ID: <1271802640.17987.230.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-jUu0odnCzJLaYYPK1mFN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jUu0odnCzJLaYYPK1mFN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

This patch supports diffing node descriptions on remote ports
(previously diffing of just the "local" node description was supported).

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-jUu0odnCzJLaYYPK1mFN
Content-Disposition: attachment; filename*0=0001-support-diffing-nodedesc-on-remoteports-in-ibnetdisc.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-support-diffing-nodedesc-on-remoteports-in-ibnetdisc.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 20 Apr 2010 15:09:59 -0700
Subject: [PATCH] support diffing nodedesc on remoteports in ibnetdiscover
Message-Id: <1271802596.17987.229.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibnetdiscover.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 57f9625..eeb1b9f 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -720,6 +720,17 @@ static void diff_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 			fabric2_out++;
 		}
 
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    && data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
+		    && fabric1_port && fabric2_port
+		    && fabric1_port->remoteport && fabric2_port->remoteport
+		    && memcmp(fabric1_port->remoteport->node->nodedesc,
+			      fabric2_port->remoteport->node->nodedesc,
+			      IB_SMP_DATA_SIZE)) {
+			fabric1_out++;
+			fabric2_out++;
+		}
+
 		if (fabric1_out) {
 			diff_iter_out_header(fabric1_node, data,
 					     out_header_flag);
-- 
1.5.4.5


--=-jUu0odnCzJLaYYPK1mFN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

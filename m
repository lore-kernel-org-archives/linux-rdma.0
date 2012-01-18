From: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 03:43:11 -0500
Message-ID: <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118084255.18560.40844.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Setup a response with appropriate error status and
send it for the MADs that are not supported by a
specific class/version.
Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/mad.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2fe428b..734d846 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1963,6 +1963,16 @@ local:
 		 * or via recv_handler in ib_mad_complete_recv()
 		 */
 		recv = NULL;
+	} else {
+		memcpy(response, recv, sizeof(*response));
+		response->header.recv_wc.wc = &response->header.wc;
+		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
+		response->header.recv_wc.recv_buf.grh = &response->grh;
+		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
+		response->mad.mad.mad_hdr.status =
+				__be16_to_cpu(IB_MGMT_MAD_STATUS_BAD_VERSION);
+		agent_send_response(&response->mad.mad, &recv->grh, wc,
+			port_priv->device, port_num, qp_info->qp->qp_num);
 	}
 
 out:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

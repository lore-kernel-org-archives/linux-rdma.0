From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Sat, 09 Apr 2011 11:21:39 -0400
Message-ID: <4DA07983.8060308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add error field like errno to ib_rpc_t structure
In mad_rpc code, make sure error is cleared and
in _do_madrpc, set ETIMEDOUT.

error field could also be used to distinguish other errors if needed.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index 5d18ec3..0ccdd36 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -233,6 +233,7 @@ typedef struct {
 	unsigned recsz;		/* for sa mads (attribute offset) */
 	int timeout;
 	uint32_t oui;		/* for vendor range 2 mads */
+	int error;		/* errno */
 } ib_rpc_t;
 
 typedef struct portid {
diff --git a/src/rpc.c b/src/rpc.c
index a702046..557a33b 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -127,7 +127,7 @@ int mad_rpc_class_agent(struct ibmad_port *port, int class)
 
 static int
 _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
-	   int timeout, int max_retries)
+	   int timeout, int max_retries, int *p_error)
 {
 	uint32_t trid;		/* only low 32 bits */
 	int retries;
@@ -182,6 +182,8 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int agentid, int len,
 			return length;
 	}
 
+	if (p_error)
+		*p_error = ETIMEDOUT;
 	ERRS("timeout after %d retries, %d ms", retries, timeout * retries);
 	return -1;
 }
@@ -214,6 +216,7 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
 	uint8_t sndbuf[1024], rcvbuf[1024], *mad;
 	int redirect = 1;
 
+	rpc->error = 0;
 	while (redirect) {
 		len = 0;
 		memset(sndbuf, 0, umad_size() + IB_MAD_SIZE);
@@ -224,7 +227,7 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
 		if ((len = _do_madrpc(port->port_id, sndbuf, rcvbuf,
 				      port->class_agents[rpc->mgtclass],
 				      len, mad_get_timeout(port, rpc->timeout),
-				      mad_get_retries(port))) < 0) {
+				      mad_get_retries(port), &rpc->error)) < 0) {
 			IBWARN("_do_madrpc failed; dport (%s)",
 			       portid2str(dport));
 			return NULL;
@@ -273,13 +276,14 @@ void *mad_rpc_rmpp(const struct ibmad_port *port, ib_rpc_t * rpc,
 
 	DEBUG("rmpp %p data %p", rmpp, data);
 
+	rpc->error = 0;
 	if ((len = mad_build_pkt(sndbuf, rpc, dport, rmpp, data)) < 0)
 		return NULL;
 
 	if ((len = _do_madrpc(port->port_id, sndbuf, rcvbuf,
 			      port->class_agents[rpc->mgtclass],
 			      len, mad_get_timeout(port, rpc->timeout),
-			      mad_get_retries(port))) < 0) {
+			      mad_get_retries(port), &rpc->error)) < 0) {
 		IBWARN("_do_madrpc failed; dport (%s)", portid2str(dport));
 		return NULL;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

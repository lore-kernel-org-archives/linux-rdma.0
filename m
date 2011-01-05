From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] uDAPL v2.0: scm: retry socket connect on ECONNREFUSED
 under heavy load
Date: Tue, 4 Jan 2011 20:27:40 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011F10C450@orsmsx506.amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C983011F10C355@orsmsx506.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25C19AEE76@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C19AEE76-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> +		if ((err == ETIMEDOUT) || (ECONNREFUSED && --cm_ptr->retry)) {
>
>This is missing 'err ==' on the right-hand side.

Just making sure you are paying attention. Thanks!

---
with large scale workloads a linux server starts rejecting
socket connect requests. Add retry logic for connection refused
errors.

increasing net.ipv4.tcp_max_syn_backlog to 2048 will also reduce the
chance of these errors when scaling up.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c           |    6 ++++--
 dapl/openib_scm/dapl_ib_util.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index f82d0ff..c638663 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -390,6 +390,7 @@ static dp_ib_cm_handle_t dapli_cm_alloc(DAPL_EP *ep_ptr)
 
 	cm_ptr->msg.ver = htons(DCM_VER);
 	cm_ptr->socket = DAPL_INVALID_SOCKET;
+	cm_ptr->retry = SCM_CR_RETRY;
 	dapls_cm_acquire(cm_ptr);
 		
 	/* Link EP and CM */
@@ -507,10 +508,11 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 				&cm_ptr->addr)->sin_addr), 
 			 ntohs(((struct sockaddr_in *)
 				&cm_ptr->addr)->sin_port),
-			 err == ETIMEDOUT ? "RETRYING...":"ABORTING");
+			 (err == ETIMEDOUT || err == ECONNREFUSED) ? 
+			 "RETRYING...":"ABORTING");
 
 		/* retry a timeout */
-		if (err == ETIMEDOUT) {
+		if ((err == ETIMEDOUT) || (err == ECONNREFUSED && --cm_ptr->retry)) {
 			closesocket(cm_ptr->socket);
 			cm_ptr->socket = DAPL_INVALID_SOCKET;
 			dapli_socket_connect(cm_ptr->ep, (DAT_IA_ADDRESS_PTR)&cm_ptr->addr, 
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index 4bb1a4a..5f9fb43 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -40,6 +40,7 @@ struct ib_cm_handle
 	DAPL_OS_LOCK		lock;
 	int			ref_count;
 	int			state;
+	int 			retry;
 	DAPL_SOCKET		socket;
 	struct dapl_hca		*hca;
 	struct dapl_sp		*sp;	
@@ -63,6 +64,7 @@ typedef dp_ib_cm_handle_t	ib_cm_srvc_handle_t;
 #define SCM_ACK_RETRY 7  /* 3 bits, 7 * 268ms = 1.8 seconds */
 #define SCM_RNR_TIMER 12 /* 5 bits, 12 =.64ms, 28 =163ms, 31 =491ms */
 #define SCM_RNR_RETRY 7  /* 3 bits, 7 == infinite */
+#define SCM_CR_RETRY  5  /* retries for busy server, connect refused */
 #define SCM_IB_MTU    2048
 
 /* Global routing defaults */
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98003274B4A
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 16:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780589339; cv=none; b=Eex6fML3ijZtyq02KZTOhAvxcD8NhbiqlinVjCL6uC008/xS8qEKXGBZBLobKy4M/q/PTWrrDZCmEKUBsj0TYiejoC52U45VXEhAopnwIcOubE2DCkuAeqHxXCKZ5Vb4e2QME6X8gPCC5Gu/Qk1j4opAGLjAxd7EeFA/s0QYO7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780589339; c=relaxed/simple;
	bh=TCRzvQt7ohKQaWYJZxIA3vd/LUwfw28eHxpXPyCm/lE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gL00fIuLtDJ08moqhC/P/7hXgVtd0qFnqb14JO5Q6UlnygWWpLYh9H7zDW6VuKLfHwd7VD36+BK7Tgx6YM6PJIBSdjL2xhoFST5aQtovQgrcIIFCzmgbd8zfdcgPJisR3J6qcePXZPDJmn8WRoZSmiHqaNSL/XIe0dCvipBoTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bWKf7v6v; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bWKf7v6v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780589335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bn6zw735ltpEmMfMUoJjWv5x2cFueJuoIKiTR8INrrI=;
	b=bWKf7v6vn4JW+TPWSYImx4BC6O9Ze+z8iIycVjCNmvHc+31CjIVTAoOrbd3ux63ScO1uOr
	S7z9w8i1tkQFOdOfskUBY7j2HxSOpl1TowWaZj7/H/6uH8rvKveJL7iP4l+N8TlURxFR/2
	3NAcY+0t5CoAIlS+acifmRJFMhsDxtE=
From: bernard.metzler@linux.dev
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] RDMA/siw: Fix endpoint/socket association handling.
Date: Thu,  4 Jun 2026 18:08:08 +0200
Message-ID: <20260604160808.30948-1-bernard.metzler@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bernard Metzler <bernard.metzler@linux.dev>

Disassociating a socket from an endpoint via
siw_socket_disassoc() may release the last reference on that
endpoint and free it. Therefore, don't clear the endpoints
socket pointer after calling that function, but within.

This fixes a

BUG: KASAN: slab-use-after-free in siw_cm_work_handler (drivers/infiniband/sw/siw/siw_cm.c:1053 drivers/infiniband/sw/siw/siw_cm.c:1075)

which occurred after processing a malformed MPA request
during connection establishment, causing the new endpoint
to be closed.

Fixes: 6c52fdc244b5c ("rdma/siw: connection management")
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Bernard Metzler <bernard.metzler@linux.dev>
---
 drivers/infiniband/sw/siw/siw_cm.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index f7ac81c0f267..87c79527ac09 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -138,6 +138,7 @@ static void siw_socket_disassoc(struct socket *s)
 		cep = sk_to_cep(sk);
 		if (cep) {
 			siw_sk_restore_upcalls(sk, cep);
+			cep->sock = NULL;
 			siw_cep_put(cep);
 		} else {
 			pr_warn("siw: cannot restore sk callbacks: no ep\n");
@@ -418,10 +419,11 @@ static void siw_free_cm_id(struct siw_cep *cep)
 
 static void siw_destroy_cep_sock(struct siw_cep *cep)
 {
-	if (cep->sock) {
-		siw_socket_disassoc(cep->sock);
-		sock_release(cep->sock);
-		cep->sock = NULL;
+	struct socket *s = cep->sock;
+
+	if (s) {
+		siw_socket_disassoc(s);
+		sock_release(s);
 	}
 }
 
@@ -1050,7 +1052,6 @@ static void siw_accept_newconn(struct siw_cep *cep)
 	if (new_s) {
 		siw_socket_disassoc(new_s);
 		sock_release(new_s);
-		new_cep->sock = NULL;
 	}
 	siw_dbg_cep(cep, "error %d\n", rv);
 }
@@ -1202,6 +1203,8 @@ static void siw_cm_work_handler(struct work_struct *w)
 		WARN(1, "Undefined CM work type: %d\n", work->type);
 	}
 	if (release_cep) {
+		struct socket *s = cep->sock;
+
 		siw_dbg_cep(cep,
 			    "release: timer=%s, QP[%u]\n",
 			    cep->mpa_timer ? "y" : "n",
@@ -1227,10 +1230,9 @@ static void siw_cm_work_handler(struct work_struct *w)
 			cep->qp = NULL;
 			siw_qp_put(qp);
 		}
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			sock_release(cep->sock);
-			cep->sock = NULL;
+		if (s) {
+			siw_socket_disassoc(s);
+			sock_release(s);
 		}
 		if (cep->cm_id) {
 			siw_free_cm_id(cep);
@@ -1561,7 +1563,6 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	if (cep) {
 		siw_socket_disassoc(s);
 		sock_release(s);
-		cep->sock = NULL;
 
 		cep->qp = NULL;
 
@@ -1937,7 +1938,6 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 		siw_cep_set_inuse(cep);
 
 		siw_free_cm_id(cep);
-		cep->sock = NULL;
 		siw_socket_disassoc(s);
 		cep->state = SIW_EPSTATE_CLOSED;
 
@@ -1959,6 +1959,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 	 */
 	list_for_each_safe(p, tmp, (struct list_head *)id->provider_data) {
 		struct siw_cep *cep = list_entry(p, struct siw_cep, listenq);
+		struct socket *s = cep->sock;
 
 		list_del(p);
 
@@ -1967,10 +1968,9 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 		siw_cep_set_inuse(cep);
 
 		siw_free_cm_id(cep);
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			sock_release(cep->sock);
-			cep->sock = NULL;
+		if (s) {
+			siw_socket_disassoc(s);
+			sock_release(s);
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
 		siw_cep_set_free_and_put(cep);
-- 
2.50.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510892;
	b=a4bui0r/r6iPyRHD2N/XR+T0K9HkJldjkFMFDivFoQrAUAKf9s6n3IcGHjHdE9r8vgog
	 43sDw+m0eZ+u2F4jIV+NPnbhX6ezu3QorHfcTxrTzhgrXyre+CXTj5n1bQQLg2KmUeeoz
	 q7OHDiQYQmMOFfFJVE0FSE8Xk4TiP3pI56M9obblTsFA8Zm8nwn8hp4cRxU6IcouhCGJF
	 t/GYMr9IH8fSWdPguUwqwCdyUkWpCVx2LCyETg1FNm4OQeSeuKBIJm8ljrO2NAzkf0ttV
	 8BH+ngOsdf0i9yXbB6yv6QEBQ5J1A4GhA/LeZTtCJ0rbunH/M6Jq1yqRZyQ8LyxxWVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510892;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xshIw2ltDpH8Fa2+b6L6mvxHTuXNivgj14RbIHd51to=;
	b=oD6sa2dH5p4jUUk/goOGwywz1oaFKTvZ7cx15NRel7OCMh4QQ4W/fNlkZ4QtxhGVRb16
	 m+hQmIU0oTRFfM1BWo7ueDALO7wQ7rQVZbzs7hbI6mDJdvAjzmgLQEikXYBUdQLSIJEzd
	 FZK1Dulgt75+icoOEQuU8Lr1SzqJWbdPII16jDnE/FerKx1qnZTH/qX2pVoeAi+Lf29Ju
	 8X1o4duWKziJ1lhFOBBcJ0c8I2fYH80fsYwyvgpyIR7sad1l10Fm679YDkNoG//kQERr1
	 s8+dWcw0+rGXCJc/YCektC2K5bmA8+xDvL8GcI5X0iBYBrmK+CBYkuVq0PbD1FyeRkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sDLdwhuT;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12020606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 09:01:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12020606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sDLdwhuT
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b4166b78b7so515060a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 01:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795510891; x=1796115691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xshIw2ltDpH8Fa2+b6L6mvxHTuXNivgj14RbIHd51to=;
        b=sDLdwhuTdzBhSx7WY+SeNxNzmejDkf7A+0fk1CekbyAdrw/wDE1HDvlEJsfhLb1p5x
         Y0whgxulwu0JP2uphVmBAqPlNtFl1nguE+B2qnmxLBcTw++EIY4jBxaH71Gr9Suw/yxf
         nNVADz0/xxhp6IFsU2EGy5m17d3oXJoDr412WdUl+fCVFE9SOVawSWIatF7nFyz90Emz
         unbI8xf351P9qehnhNuObb09PJHZILdi0RwdzaY/PP6uD8l8yh0zogzUrZ7HlKVb/U2F
         5WB0+oIGmYUwKRQQWDhTqxVJySYQJvdv1gA4q8rEXKsuEFXNt+8lPLjrkqT+ORMNswVR
         6uUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510891; x=1796115691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xshIw2ltDpH8Fa2+b6L6mvxHTuXNivgj14RbIHd51to=;
        b=pncblAQTgt0D+YWof0zPjykeHZY8YS5cIwEaXUc6yuDzVvB1aMKQBdMGAuj2GgsxcB
         R4WFVnTaw1MQPVytXKPHJvqeKEJYVx1qkfNyj8clEt78oB6Yx+er9FmvkAvKmkYR2eCE
         y23a0175Qt1F1n/w/gH4Cv1Hp8UHLgAOKtShyG0PMfkoHmg4lI01bRT28XbkqKcov+pf
         Qfo1d/4ZiVDRPEXSbnxgwuiEKE5/1JWoP0yiq3vV7FrOH+29agu8/ZphvL61m61qCnc6
         Y0gB3S/nMIVt4IfTACV7J2KQ15O3FTp9/cG68HecjlTU/KDmryE2d7iWJUZeMa6iDanw
         PhuQ==
X-Gm-Message-State: APuU4Z/ZcwBbtqr3Ey1ZyHANrCNHeiHu3mzFwn3nEZxOOACLfZgkz6/F
	mfEEtOgyz4jX73WJ6MEJOv4jrSS7FtKS2ngpVmREyVB6mYC9pXh5vRz4
X-Gm-Gg: AZFdTZcSRXhhXEADpm2+DcmcI3nqpMY9ipX7vnwDj6Kkk0RChBD8AvQOluaZQfaFUUp
	LAX725dj6GQxkJI+Rpwu6BLxShYZwV5ndJkBSVTKX5nPSt9kFmyp4NCVhmCkw/5YZzKKShgGPPl
	R4Urkhu+vN641A2iEb1Yzm+MvVe097Q7jiRjot2KgB4QgLakatP1bz76+JNiDF48xXQpY7kje7P
	vOc8onV5lnuFbqhht6crN0s7AeIES89W4eOKlX0RL3s2qkE26P2jwuG57yvjbXH0NYPBddcSvzO
	xtxdyM72p8ZjrfeEGWUKw6ftJ71P/P7miNPwOuZo0JyDygpVb3Murv8IsSRHfNWwPTp81VlI38O
	QdvMoO/DvVi8lVbIs5g35H0FSN9X3vaGHL4Lpx7oKJT7AqiXLjXp3vKYSmDV4mGeAN2CLzVjGkv
	S/SHDgvAOIMEpeJ7efB/ZimB1KLpcl75KjZ1b+Y2lnc1FsfqulRmE79pwt5sgCdUCat7sohPeRi
	0gIkV5yavMQ6s6Sj3ZwOWWovT4svgZvVCuNYeHt2g1sFbfjmtlQ/gTTkpyOYa+lNn1n61sdqMAb
	HoIhEyIyxJyUd/YKO2RzqhPeu7T7HBTB8HkSsCtm
X-Received: by 2002:a17:90b:39a3:b0:3a4:c895:570 with SMTP id 98e67ed59e1d1-3b41c91f7b1mr22760547a91.4.1795510891163;
        Tue, 24 Nov 2026 01:01:31 -0800 (PST)
Received: from gmail.com ([124.127.65.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dc4f2sm68086245ad.30.2026.11.24.01.01.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Nov 2026 01:01:30 -0800 (PST)
From: Ziyu Zhang <ziyuzhang201@gmail.com>
To: sagi@grimberg.me,
	mgurtovoy@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	ziyuzhang201@gmail.com
Subject: [PATCH v2] IB/iser: Fix blocking connect hang and endpoint double free
Date: Tue, 24 Nov 2026 17:01:21 +0800
Message-Id: <20261124090121.77115-1-ziyuzhang201@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iser_connect() waits for up_completion while holding
iser_conn->state_mutex.  The RDMA CM callback that advances the
connection state machine needs the same mutex, so a blocking connect
can never finish establishing and the wait only returns when a signal
arrives.  The caller then sits there with rx_queue_mutex held, which
stalls the iscsi netlink path for the whole daemon.

Dropping the mutex around the wait is not enough on its own:
up_completion is only completed on RDMA_CM_EVENT_ESTABLISHED, so an
address, route, connect or reject error still leaves the waiter asleep
forever; complete it from iser_connect_error() as well.  The cleanup
events are the other way an attempt can end without an establishment:
DISCONNECTED, ADDR_CHANGE, TIMEWAIT_EXIT and DEVICE_REMOVAL reach
iser_cleanup_handler() with the connection still ISER_CONN_PENDING,
where iser_conn_terminate() does nothing because it only acts on an
established connection.  Terminate a PENDING connection there and wake
the waiter, leaving the established-connection cleanup unchanged.
iscsi_iser_ep_poll() must then look at the connection state when the
completion fires, otherwise a failed attempt is reported as a
successful connection.

Finally, the failure paths left the connection in ISER_CONN_PENDING or
ISER_CONN_TERMINATING.  iser_conn_release() destroys iser_conn->ep when
the state is not DOWN, and iscsi_iser_ep_connect() destroys the same
endpoint again on the error return, so the endpoint was freed twice.
Terminate the connection and mark it DOWN under the state mutex instead,
so the endpoint keeps a single owner, and so that no handler can keep
operating on a connection that is being torn down.

DOWN is terminal: iser_connect() drops state_mutex before the cma_id is
destroyed, so a late CM error event can still reach iser_connect_error().
That handler used to move the state to TERMINATING unconditionally, so
iser_conn_release() destroyed the endpoint first and
iscsi_iser_ep_connect() destroyed it again when iser_connect() returned.
Leave a DOWN connection alone there.

Fixes: 504130c039f9 ("IB/iser: Protect iser state machine with a mutex")
Fixes: 9a3119e4b787 ("IB/iser: Release the iscsi endpoint if ep_disconnect wasn't called")
Cc: stable@vger.kernel.org
Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>

---
Changes in v2:
- Wake up the blocking waiter on connection errors and on cleanup events
  received while the connection is PENDING, including device removal.
- Check the return value of wait_for_completion_interruptible() and
  propagate signal interruption errors.
- Terminate the connection and set its state to DOWN under state_mutex
  on connect failure, leaving endpoint destruction to the caller.
- Keep DOWN terminal in iser_connect_error() so a late CM error cannot
  trigger endpoint destruction in iser_conn_release().
- Check the connection state after a positive completion result in
  iscsi_iser_ep_poll() to distinguish successful and failed connections.
- Expand the commit message to explain the failure wakeups and endpoint
  cleanup ordering.

v1: https://lore.kernel.org/linux-rdma/20261123144440.65441-1-ziyuzhang201@gmail.com/

 drivers/infiniband/ulp/iser/iscsi_iser.c | 11 +++++-
 drivers/infiniband/ulp/iser/iser_verbs.c | 50 +++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7df441685780..47c264cb9aff 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -843,7 +843,16 @@ static int iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	rc = wait_for_completion_interruptible_timeout(&iser_conn->up_completion,
 						       msecs_to_jiffies(timeout_ms));
 	/* if conn establishment failed, return error code to iscsi */
-	if (rc == 0) {
+	if (rc > 0) {
+		/*
+		 * up_completion is also signalled when the connection attempt
+		 * failed, don't report that as a successful connection.
+		 */
+		mutex_lock(&iser_conn->state_mutex);
+		if (iser_conn->state != ISER_CONN_UP)
+			rc = -1;
+		mutex_unlock(&iser_conn->state_mutex);
+	} else if (rc == 0) {
 		mutex_lock(&iser_conn->state_mutex);
 		if (iser_conn->state == ISER_CONN_TERMINATING ||
 		    iser_conn->state == ISER_CONN_DOWN)
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 55fe68e5b837..f57d71e3d448 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -480,7 +480,18 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 
 	lockdep_assert_held(&iser_conn->state_mutex);
 
+	/*
+	 * A failed iser_connect() moves the connection to DOWN and drops
+	 * state_mutex before the cma_id is destroyed.  A late error event
+	 * must not move it back: iser_conn_release() would then destroy
+	 * the endpoint that iscsi_iser_ep_connect() destroys as well.
+	 */
+	if (iser_conn->state == ISER_CONN_DOWN)
+		return;
+
 	iser_conn->state = ISER_CONN_TERMINATING;
+	/* Wake up a blocking iser_connect() waiting for the result */
+	complete(&iser_conn->up_completion);
 }
 
 static void iser_calc_scsi_params(struct iser_conn *iser_conn,
@@ -652,6 +663,19 @@ static void iser_cleanup_handler(struct rdma_cm_id *cma_id,
 	struct iser_conn *iser_conn = cma_id->context;
 
 	lockdep_assert_held(&iser_conn->state_mutex);
+
+	/*
+	 * A cleanup event during connection setup ends the attempt before
+	 * it reaches ISER_CONN_UP.  iser_conn_terminate() only acts on an
+	 * established connection, so wake up iser_connect() and
+	 * iscsi_iser_ep_poll() here.  A late event after a failed connect()
+	 * finds the connection DOWN and leaves it alone.
+	 */
+	if (iser_conn->state == ISER_CONN_PENDING) {
+		iser_conn->state = ISER_CONN_TERMINATING;
+		complete(&iser_conn->up_completion);
+	}
+
 	/*
 	 * We are not guaranteed that we visited disconnected_handler
 	 * by now, call it here to be safe that we handle CM drep
@@ -778,7 +802,21 @@ int iser_connect(struct iser_conn *iser_conn, struct sockaddr *src_addr,
 	}
 
 	if (!non_blocking) {
-		wait_for_completion_interruptible(&iser_conn->up_completion);
+		int ret;
+
+		/*
+		 * The connection state machine is driven from the RDMA CM
+		 * callback, which needs state_mutex: don't hold it while
+		 * waiting for the connection to be established or to fail.
+		 */
+		mutex_unlock(&iser_conn->state_mutex);
+		ret = wait_for_completion_interruptible(&iser_conn->up_completion);
+		mutex_lock(&iser_conn->state_mutex);
+
+		if (ret) {
+			err = ret;
+			goto connect_failure;
+		}
 
 		if (iser_conn->state != ISER_CONN_UP) {
 			err =  -EIO;
@@ -795,8 +833,16 @@ int iser_connect(struct iser_conn *iser_conn, struct sockaddr *src_addr,
 id_failure:
 	ib_conn->cma_id = NULL;
 addr_failure:
-	iser_conn->state = ISER_CONN_DOWN;
 connect_failure:
+	/*
+	 * The connection never made it to ISER_CONN_UP.  Terminate it in
+	 * case the wait raced with a successful establishment, and mark it
+	 * DOWN so iser_conn_release() leaves iser_conn->ep alone: on this
+	 * path the endpoint is still owned by iscsi_iser_ep_connect(),
+	 * which destroys it when we return an error.
+	 */
+	iser_conn_terminate(iser_conn);
+	iser_conn->state = ISER_CONN_DOWN;
 	mutex_unlock(&iser_conn->state_mutex);
 	iser_conn_release(iser_conn);
 	return err;
-- 
2.34.1


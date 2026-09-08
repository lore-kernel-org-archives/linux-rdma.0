Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18027568FB4
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882330; cv=none; b=uT9+ZjoJ68UrVqAPMbINmpQ2vZZ4PY+IdqUpzGFfP5p7B56wgh7K3TWNm+us/V9mkd0Fg+RK4hQxTG4eFMly0T89H5NVKSstTthFH+PmC4Y9LEaQAXcN0bt6v6t7EjqteA0iU1NgPP+DxOQQ1jKg/MbApqFpVUcqYJ8wd/8b7sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882330; c=relaxed/simple;
	bh=dFKB6M5FKojpRsZt+gYTvbAvCaAVxlex6m2PzwZrubI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6nBfd0yl1BmVLJnwYM/lLCBltIg5QV/aekLwUX0hIceFR9wTZ3EKEU5U9UR/mxqYqJcF5bKnsG/DEg7Ub9kFFQVjGvvry4Wyv8LVu3AuI5vNMZwkEFnzco6DGnsx2ixTjA1BYeVXoB1F9fhc/IxwLC4ug1M5bMqSSDGw5Z/8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2xelVBp; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2xelVBp"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-90cd8e45460so67454146d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788882327; x=1789487127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J2h+q2CPO6RUOr1bTBHq2Gab7Sy0CjwyXjSNQkF67CI=;
        b=U2xelVBpPfi+FR92iBF3ElR1ZsNVeRFFgFWo1aOfKXbt0F8xE34wDo1yih0tOF5/25
         8munbgqTHw38BTWjhYu8S3kjEJ8gkFZ/x9ARycZLwygXx1H9rUYawxaYMuijLjuWhap+
         VdwvZE2VCvoCAH1VJ7e81R7w2owF27YO58s1pzalWxc76qOPAA2FWPUrvzE4x+dBdKtl
         m6IXrx29mgpgfmtSbawijFdfjwfrz9HFBC2uExiDrLj7hk3SliZhP12JngjIG2v6rOfC
         hgtViL/1wauXBHDxVx5ukxGWdOQy1lzOGPMnzBZpFysGFL76arx3NjtX2tPr5V74WMaW
         Z5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788882327; x=1789487127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2h+q2CPO6RUOr1bTBHq2Gab7Sy0CjwyXjSNQkF67CI=;
        b=mShdhXrRo1wc6124cjBuwl6YWz+ThloaGQ7tlwMolw4yJ4OLkxlJAHv76en32NLJLx
         wWUZ0tI/7TQBpG2bHvEDXCzDH21IReJatIz1WLKl3Vxxx4Pkl5EZ5egPlZgdg0ZX56W9
         Il/6pyEng6BUmwFcCSiVm7uMpBW8f+yK0e63MtFLWVEShXtF9bgzY2MDb9UEkpQZttOE
         dLpVW+6TQFi8b3Sp0AAojXuExKxuuD/DNfBM9z4utgVr7ws+95Iy7yM9PIVarXDMzIco
         LWZ+57G0sm9zaqvkdaIItKecVipV5fGbipoEh0A+D/yjOYVrNXiIUepVrK/OQKVUQcsi
         n4Dw==
X-Gm-Message-State: AFuF++mNUzrTlyWuWhzGIumULT0daDGxirHLcEj1faV/YINAHiLMr3Vd
	UOJPyHN5c0WWjZG81my6CYvhdq6gMYHjxtyh26lj0rqCLZh2KO73E0WJ8rMjmRQZatE=
X-Gm-Gg: AYBFou1Va2W2RgZ4PfrhqjDH9NXO/K3LwhoOKBz1OCeMBxGjhAe4FcTMu9k/uHIujgn
	PaP7fCkA1DT1PkLaCQKqxG6Z2eVDdWzKKQoeUbct5+48HEI7hcp1GtdAljItb9HI3qlVpMwMzZC
	ll2S6MdpM64qgSg0DigyzO54ufiCghY/+0/ssGDUxIFz2R81H7coO61hN8RFZ4X+VYh28p/jkGM
	gtRNDbogciYMkvEf25GsgU2cAHeq0nmhqWJNzXO08fbL34b+pws4z33FAShFQEPBVT4dGOmHVuv
	nUlMl+j6w0/O9qM6ZIieOnn4xwtA9nsXqDmpB5Re0W+P9Fv8F2glyUBWa3BxDuE0MTi3R9rtHaJ
	QuFMQ/pHr01UmR4fXwS7uKAnBdymsTP7s+12FdzCAfTFvCnXooW1mF1VbcZqCnmXxf7Ynm04E1E
	LNQ0l2wMqvno2O0Dai+PWvsy/EndL0ItDKiYBX4WnrpXy1hw0mkzM8Jv5CCYptCLosak0Akhwns
	Zta07t9kpjF/CVd5rp/wG5nPaebFGDcoKMrs+wlwVxpPJ03vXgfYeylb1QOF+Q=
X-Received: by 2002:a05:6214:202b:b0:910:345b:4dea with SMTP id 6a1803df08f44-9103f086aa0mr381765736d6.36.1788882325436;
        Tue, 08 Sep 2026 08:45:25 -0700 (PDT)
Received: from Ammar-PC-Fedora.tail72f32.ts.net ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104049d30asm120779386d6.0.2026.09.08.08.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:45:24 -0700 (PDT)
From: Ammar Ratnani <ammrat13@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: Ammar Ratnani <ammrat13@gmail.com>,
	Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH 1/2] infiniband: force disconnect if DREP and DREQ fail
Date: Tue,  8 Sep 2026 08:44:26 -0700
Message-ID: <20260908154454.10966-2-ammrat13@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908154454.10966-1-ammrat13@gmail.com>
References: <20260908154454.10966-1-ammrat13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we call `rdma_disconnect`, it's possible that we fail to send both
a DREQ and a DREP. In that case, we currently either do nothing or move
into the `IB_CM_TIMEWAIT` state. Either way, we remain in the
`RDMA_CM_CONNECT` state. Anyone waiting for us to disconnect hangs.

Instead, while we're connected, when we call `rdma_disconnect`, and fail
to send both a DREQ and a DREP, mark the connection as disconnected.
Call the upper layer's handler for the disconnect, and destroy the
connection if instructed.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ammar Ratnani <ammrat13@gmail.com>
---
 drivers/infiniband/core/cma.c | 39 +++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 73170b15fc3d..1f1a8b4e160a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4823,6 +4823,34 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 }
 EXPORT_SYMBOL(rdma_reject);
 
+/*
+ * Called from rdma_disconnect() when we know we're not receiving a callback.
+ * Emulate what that callback (in cma_ib_handler()) would have done.
+ *
+ * NOTE: Despite the name, this function will only actually disconnect when
+ * we're in the RDMA_CM_CONNECT state. Else, it does nothing.
+ */
+static int cma_force_disconnect(struct rdma_id_private *id_priv)
+{
+	struct cma_work *work;
+
+	work = kzalloc_obj(*work);
+	if (!work)
+		return -ENOMEM;
+
+	INIT_WORK(&work->work, cma_work_handler);
+	work->old_state = RDMA_CM_CONNECT;
+	work->new_state = RDMA_CM_DISCONNECT;
+	work->event.event = RDMA_CM_EVENT_DISCONNECTED;
+	work->event.status = -ECONNABORTED;
+
+	cma_id_get(id_priv);
+	work->id = id_priv;
+
+	queue_work(cma_wq, &work->work);
+	return 0;
+}
+
 int rdma_disconnect(struct rdma_cm_id *id)
 {
 	struct rdma_id_private *id_priv;
@@ -4838,12 +4866,15 @@ int rdma_disconnect(struct rdma_cm_id *id)
 			goto out;
 		/* Initiate or respond to a disconnect. */
 		trace_cm_disconnect(id_priv);
-		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0)) {
-			if (!ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0))
-				trace_cm_sent_drep(id_priv);
-		} else {
+		if (!ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0)) {
 			trace_cm_sent_dreq(id_priv);
+			goto out;
+		}
+		if (!ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0)) {
+			trace_cm_sent_drep(id_priv);
+			goto out;
 		}
+		ret = cma_force_disconnect(id_priv);
 	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
 		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
 	} else
-- 
2.55.0


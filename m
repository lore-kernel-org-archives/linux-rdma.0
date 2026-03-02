Received: from mail-yx1-f74.google.com (mail-yx1-f74.google.com [74.125.224.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6BC175A8F
	for <linux-rdma@vger.kernel.org>; Mon,  2 Mar 2026 00:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772410553; cv=none; b=lDviq9V0Ofq/Gb/hCBRR4kBL0xIKDT6/MLyclaG5gGP5kB1MH64LvkUp1v72vYirDlah41v1v4a/tv6psn7Duh34PEAtz++k//lcGGoPhGz88v49TUc+/wihTuqovSapnKtAQ8+4wcIrQmuBTnXPYepD96peQ0JAwec6hhU3SZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772410553; c=relaxed/simple;
	bh=jC4oGrrlJSAlJOV2255SqDK+gYmXBtyjI6+zixJN700=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZ4S2SdjEkWDG6sOWJDjGOi1UGERjbkc7OoLwi0gSwnPSVLJ+yilp2IOhA+9pS6uxSUUSbgI4ter04t6Q7p+HWTIlqatZeBH976pSIb69j9nH9rLcMtltDnNNIfiH72qBboetKW+wcjUoNh6wW2+SZIVoekQPDPXliDTIpigmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uljas3LQ; arc=none smtp.client-ip=74.125.224.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uljas3LQ"
Received: by mail-yx1-f74.google.com with SMTP id 956f58d0204a3-64ca6895833so5573748d50.2
        for <linux-rdma@vger.kernel.org>; Sun, 01 Mar 2026 16:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772410552; x=1773015352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EtSF34BrdcNBnnjyLsvCjtmRiBxrqSGHgwNPpC60LzU=;
        b=Uljas3LQ+oEYV2dJdqgjKTDtgxW7+HNzC35UOUux8JKOmZhsJUc4il8WIqTNI5VCEI
         Y50mGb6goU7ejvPE8WKanHzq6S+CgG4VRF85EzQg8Vbj3GNo4FIEgciDk59vaUTtBdOX
         tYUfvDdJPCGExXivqRPL+IqLxpaUwPgjPzW9AdgshpxY1uW7r1lME4dWSGjXSvoB1vwV
         l/+h7vdTdvNMcoomEqQVZBJ3POzgKsJoMhWumSgms9+LKc0wAxKeJgCQJ/pjl4mDLC/v
         fkZJ0NJIdXeGiYEytkklCbEn1duCPPNabQCIZRl7PDh6LjvWBMPM83TuxVXoVxnVVO2J
         kgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772410552; x=1773015352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EtSF34BrdcNBnnjyLsvCjtmRiBxrqSGHgwNPpC60LzU=;
        b=DQk4L4NVuKRP52ml7fneAQanlCl5b0M5Gr5FIqQnPGjye2b3DDpxs16ClYLCnwUhTV
         xIFvqIxWSJNHC/N+AR07ol3Vj8DqMjHzGV9EBujCRgO1JzQzsdk0BD2X5t3zEeeel8PT
         IBKPgtAT8FKLecPLlkdsNDngEF6Uo4DPCBpV0uyoSTIPjfG/3Wdx9d4Hez/ojX/k0ekn
         Ye80l15WmOStB7nmWmFKMmZlDPS3DWKOqS4XkF3jfvVD7fGlA+NuvKr9/6RylKb/xLpw
         L7ti9vp5At+uxqy0e4T4xCfBWwtYDatgSHppGXqkH+1f+ZnZC9VTS7WWqxb6P43VzcmP
         HL2g==
X-Gm-Message-State: AOJu0Yw+qvLSvSxI1rbE50BBV+mFLnk73mkvRpjC6avAe6fd4lvD7cG7
	LkQ2pP2yQonWKDPmrrDRBpCcSQj1LStztvUb1mEdzQwSZpdJ1yIuWcU6T2Jm7ZmgrQbSe0tPInP
	TqcmAn8Sbjw==
X-Received: from yxi7.prod.google.com ([2002:a05:690e:687:b0:64a:e658:d3b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a53:c38c:0:b0:64c:a909:70cf
 with SMTP id 956f58d0204a3-64cc22c5c20mr6789218d50.70.1772410551804; Sun, 01
 Mar 2026 16:15:51 -0800 (PST)
Date: Mon,  2 Mar 2026 00:15:38 +0000
In-Reply-To: <20260302001539.2275303-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302001539.2275303-1-jmoroni@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302001539.2275303-5-jmoroni@google.com>
Subject: [PATCH rdma-next v2 4/5] RDMA/umem: Add helpers for umem dmabuf
 revoke lock
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, krzysztof.czurylo@intel.com, jgg@ziepe.ca, 
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Added helpers to acquire and release the umem dmabuf revoke
lock. The intent is to avoid the need for drivers to peek
into the ib_umem_dmabuf internals to get the dma_resv_lock
and bring us one step closer to abstracting ib_umem_dmabuf
away from drivers in general.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/core/umem_dmabuf.c | 16 ++++++++++++++++
 include/rdma/ib_umem.h                |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 7892e33be..4c21191dd 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -334,6 +334,22 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned);
 
+void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+
+	dma_resv_lock(dmabuf->resv, NULL);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_revoke_lock);
+
+void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
+
+	dma_resv_unlock(dmabuf->resv);
+}
+EXPORT_SYMBOL(ib_umem_dmabuf_revoke_unlock);
+
 void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf)
 {
 	struct dma_buf *dmabuf = umem_dmabuf->attach->dmabuf;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0fed9435d..8cc48ec4c 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -152,6 +152,8 @@ ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf);
+void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf);
+void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf);
 
 #else /* CONFIG_INFINIBAND_USER_MEM */
@@ -224,6 +226,8 @@ static inline int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 }
 static inline void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf) { }
 static inline void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf) { }
+static inline void ib_umem_dmabuf_revoke_lock(struct ib_umem_dmabuf *umem_dmabuf) {}
+static inline void ib_umem_dmabuf_revoke_unlock(struct ib_umem_dmabuf *umem_dmabuf) {}
 static inline void ib_umem_dmabuf_revoke(struct ib_umem_dmabuf *umem_dmabuf) {}
 
 #endif /* CONFIG_INFINIBAND_USER_MEM */
-- 
2.53.0.473.g4a7958ca14-goog


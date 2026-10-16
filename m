Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71B13B14A9
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792126767; cv=none; b=mtRZqzu/Qy3AXewqnPzfhQy7ZQZCZKFhcVwmMUJyX+7qIWXKsiwxLhJ+lfOf54FJ4kpwiKTpgLL8UNaPnSgjhAarOK9GKmniwGuWMhFBWvf1z0PIzDQx8KV2o+E7Uq3BKeJjbJ+G9OHzC9Gi8COtoF9Hea88yA2WUh4BHxLSvPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792126767; c=relaxed/simple;
	bh=IO4m2zMuyhW0KS0Jvv/07DF2IaAt20vkVzoV253KRQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD25i6VyI3QzKDLjO9Z6zV+ePKK50MlTG4aqUS3DTiWDOLxmob0cNq5TUp3rkkPk+kaTz8ezdAx7rb6+J3bs15GORETqEPRPlJGvcQz2w6hv5++Eg56bVLVT3/FJXC8qUz46yNM0YhRXrq3ysTd0AgJ1fWE8Qxn6eOK43YOuza0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iyof34RX; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iyof34RX"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-533778ab0bdso68683221cf.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792126765; x=1792731565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KkExTl4ImtT/SqRzjGR9HGgwzVDT2pgqDXXqm237AHQ=;
        b=iyof34RXGtg4l5AjvSLE7DmExggufR7Eol7Tyd7AsCfGHJUO/TlwZmhcoP7UM2XW9s
         tO4zj6MUVuJsWKLWqFy3TrN2ZLLYz/0v/zDaLYKO/vYzXS5UkD+IikbKtH7nMEGti17o
         6Betkzsvm2MPxU4O+E7cg4iUKbIijt98rhAKKGDQnVf+aQpDC8sR1ezcVrXMjZCFGaGF
         bIVoNdnT/xbCGWYZB+TeO8fj1aozO+aqYcQ4QEeJ9OSlIC8wYOAuXF46EFDCZqOsyQ6j
         bXa3Ed/wxZ4CEQlAQUgUMQNjGjV6h+ycW+sC3pU0T2j3s7i8HLNLlmnLw3VLx6k/uHi0
         9iTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792126765; x=1792731565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KkExTl4ImtT/SqRzjGR9HGgwzVDT2pgqDXXqm237AHQ=;
        b=n/K/vQkGDlicnjjPcmbZNsyze068tmyul6umT+Luf76GtMd7nquqo3nkPy8WJR15f+
         xEKbKdhDcaSpsbgWvRszjOhUuZ5ca5A5+YxxiQJ7zkdW9ckg+Xth4ty0l22B3GvDzfHm
         +jGnRyHmmya6qgmHEpHMPmyCUsbGEvHfKTGZsd1PivWaTa3G+TFQk15P7WmVOnu94Gj3
         Z6attaftlgg04iUgb1AIuDIRTCnPElGUH0oIo/zdA4d/cuHwBvvhodncBZx0FGllBb9D
         llpFWqNG7C5GcxsazVctKtNF6Zrvse93hP0kU3htFIolzWenxixySvHbHmwy9hZa/dXz
         toNg==
X-Forwarded-Encrypted: i=1; AKwUvBxXHlMe3HY2AKbDz1VFJqlPhzwdAK/2YW1U5n8zcn1LNBJD5cVxSbZmHfEYfhMLWrWOW2QG0X/UJI6H@vger.kernel.org
X-Gm-Message-State: AFq9FYJp1qz76Iyo1Sb5GEs05w4qKQqskrn03k5kSojn+exxraoVy4Yp
	zHE/3I9atyffrI144K2OmOYe9kXY+DVdxiOu/V2qYq/jF35RqDGPsoqYQjbXAw==
X-Gm-Gg: AYBFou0HmNgyoLhzvBUv6Et9w6w5XMM7xWigIuuPHumLsZQxegG039gYs1SjYgE4hYu
	APHk0np9r6YUS5ERMuHznlWxOCfogAZ99jSoKnOD/WEXtwC+VACF4i6htmTlCe3qPMop5J4Hwz+
	+4tBMvGTVe12zf3U4isPACCupveKVeU8jqRvN/mIiwTj7BlPZ17y1+SqWLBP6gpmrfU146Mrpnv
	GXAeEAB1o8B+20Kv7A6Yt3KujCttaQaKhDeELi7W5HvzncAmlwBUVvxQpHWNToy+107E5MX1Tdj
	YHj+7tGsE2zexYtq4nINIMO1THwYm4gHwEdIn6OfcEbaiFlR9at1IyceTUPczl1a/am18e+eYmm
	7QGci7EySDoqlyYyy3WUYF2l13Fy3IQnZ/X8tDOmaZq2O7+IHOn2DIYI2cIw7Boj6EvWhAfbX78
	9eHtPuogniV0AY1d3xUquMwbX12av97vMz/EEHmNPjhd7tLV0/zVPc7FsnDfuGeofHTlnJ1gpvd
	LksNzvrZznQEZzxO7tMlfo=
X-Received: by 2002:a05:620a:2911:b0:93e:6100:6c1e with SMTP id af79cd13be357-93ebd2448d3mr3640455885a.30.1792126765586;
        Thu, 15 Oct 2026 21:59:25 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a198372sm118038685a.27.2026.10.15.21.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:59:24 -0700 (PDT)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <oss.patchbox@gmail.com>
Subject: [PATCH net-next v1 4/4] net/mlx5: HWS, Don't free the send ring CQ buffer if destroying the CQ fails
Date: Fri, 16 Oct 2026 00:57:49 -0400
Message-ID: <20261016045849.813696-10-oss.patchbox@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016045849.813696-6-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hws_send_ring_close_cq() ignores the result of mlx5_core_destroy_cq()
and frees the CQ buffer and doorbell record with mlx5_wq_destroy()
anyway. If DESTROY_CQ fails, the CQ may still exist in firmware and
retain access to that memory after it has been returned to the
allocator.

Leak the buffer instead when the CQ cannot be destroyed. A device in
internal error is not affected, since the mlx5 core reports success for
DESTROY_CQ in that state.

Fixes: 2ca62599aa0b ("net/mlx5: HWS, added send engine and context handling")
Assisted-by: LLM
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
---
This was found with a static analysis tool from ongoing, not yet
published research, and confirmed by code inspection. It has not been
reproduced on hardware.

 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index df3b93499eebb..21e2d0a26e88a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1005,7 +1005,9 @@ static int hws_send_ring_open_cq(struct mlx5_core_dev *mdev,
 
 static void hws_send_ring_close_cq(struct mlx5hws_send_ring_cq *cq)
 {
-	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
+	/* A CQ that was not destroyed can still access its buffer, leak it */
+	if (mlx5_core_destroy_cq(cq->mdev, &cq->mcq))
+		return;
 	mlx5_wq_destroy(&cq->wq_ctrl);
 }
 
-- 
2.43.0


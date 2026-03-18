Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1783B3E95B8
	for <linux-rdma@vger.kernel.org>; Wed, 18 Mar 2026 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773846209; cv=none; b=AsB9wWyTtMjTs4O5VOM/4KmWJNbMEeK9sxeF0+fRK4MvF5bXk8z2rlnwXuGqKYnTacoIbJHYuE7MK/bSsq7TxrU64xSD7X58/5R/RKaJjYNQZlmy1CF9TRqxjRPJ3tpirBxOcAqTub77ejVQ8W2cTRFFgEACsLbesJ3jt1mLsQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773846209; c=relaxed/simple;
	bh=FkE3aEmYq3JFi5GpqJgM6OBmxi48BQXX3kwNVt8fzXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFv5Bt3TpndmueABMsiiei3t8/gTN1fmmtRU+NTjtyxXkKm8/o9iRXex8St5+cwt7BhDCOYtsQA23Qt9fEgsdBv7sFnR/1S/zgY3vXoAMu7pKvLjG5o2C6BRyPFjBbDJMaeJqwM038qZq6fFpHPUkpX/7GNn+wGZdFt5vYajWSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-126ea4e9694so2428528c88.1
        for <linux-rdma@vger.kernel.org>; Wed, 18 Mar 2026 08:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773846205; x=1774451005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RnwqqwAxnRG8s2vaRYDrbUdfVznpcDcr1raRDlnvaSE=;
        b=ZTRTELSJKXJ8TdWplsLu7A9Ca7QyE8Q1WbR+rupB3s3y9bXQAS8hX8CD3impW5puJN
         a7v+gAeUqxbPsHOzx5tXw234+dA74Mm+UaTzVBz/wOOOb/LIEWj42o751H2PXxln74OT
         3Tq396Rr5IJDBLj9LXi0xT+S2U7+wat1zEkGyAPlsl5wYZ5hhfHPXPC9PORvzl3cDe6I
         3cvcZ6LXyQooRbFpKzNeD6K30a9um0+Nx43JyxVxQPv2pyK0OGASWlG753SxVpg1a3GK
         mKb4+9mdxsBot+cOrI0cvsRI50R7Hgp90XIiOy7yXwrFJG+MtUEtq2s53wXHtDRWyWh2
         uplA==
X-Forwarded-Encrypted: i=1; AJvYcCWV0ZoncqTgYwu0xtl+gEFLSVe7kAryZcfwFFHtmStmS2PkMobQUDAMm9wtjdj6t8Lq2rMjK9yDlu0I@vger.kernel.org
X-Gm-Message-State: AOJu0YzYfkaHn52N9XCN6RJGXiQuZUQCEGKKR1FbdrdH7nSOuCkcGr6V
	734jUONfcuhEV/HTA8QyPAP9T6Amcr4qTUcZZs9NFQGQXeUv/jJXixM=
X-Gm-Gg: ATEYQzx3BLBsP9xWZ/TyGaMsXVJYhckpcNKcGALy3YVL9JmqRTNLpQ58vPXJLGEBfYw
	+WYUJzMdiWk3RJ2+bbRz36cuXVbzoQ7v5biCGg7Xt49IKjAOfIhjngPhRvlaaQhEnXncDxqSKOK
	Tzdy4RcC/Lr8OsCcQkBId3zjZibwi1Zytv0Bpj/m07/JpMMu82u3WQIJf599hskHzcnHApYkZFh
	Pj5Qqdn1/tJzMHNq03b/Uts8oyF09HFvcBDOZ2sWi09AolAG7oS9vHdugRp8ncmvfu/bXkclpb2
	Rzah0mEr0UOGrkpd7wEUOy62sEFQa8Bs3jBeplYSNmEjBo5RVJcxVtdscH1C6dzgdPI8hn0vbL2
	KRIhGJ/TJcYgNdyPHJ/tF3xkwoGsD0xSTtVLhOJQfx6mmT61wdXWqsnC4HhezIKFJSothxVS3Tf
	5XiMeZd9Jn8IHULhE7mGLmRGLZBtss1SSKyBFI/iha8kMqrMp8K1vuWDrZhoYVkB1H8flx2uxcf
	6Ze1edF/URLeX2wt7FRD7nIXClK
X-Received: by 2002:a05:7022:61a:b0:128:cf5c:5362 with SMTP id a92af1059eb24-129a70e0ccbmr2203458c88.12.1773846204437;
        Wed, 18 Mar 2026 08:03:24 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-129b3e8d34dsm3689514c88.7.2026.03.18.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 08:03:24 -0700 (PDT)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	andrew+netdev@lunn.ch,
	michael.chan@broadcom.com,
	pavan.chebbi@broadcom.com,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	johannes@sipsolutions.net,
	sd@queasysnail.net,
	jianbol@nvidia.com,
	dtatulea@nvidia.com,
	sdf@fomichev.me,
	mohsin.bashr@gmail.com,
	jacob.e.keller@intel.com,
	willemb@google.com,
	skhawaja@google.com,
	bestswngs@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net-next v2 10/13] netdevsim: convert to ndo_set_rx_mode_async
Date: Wed, 18 Mar 2026 08:03:02 -0700
Message-ID: <20260318150305.123900-11-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318150305.123900-1-sdf@fomichev.me>
References: <20260318150305.123900-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert netdevsim from ndo_set_rx_mode to ndo_set_rx_mode_async.
The callback is a no-op stub so just update the signature and
ops struct wiring.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/netdevsim/netdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 5ec028a00c62..9c9217792125 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -182,7 +182,9 @@ static netdev_tx_t nsim_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void nsim_set_rx_mode(struct net_device *dev)
+static void nsim_set_rx_mode(struct net_device *dev,
+			     struct netdev_hw_addr_list *uc,
+			     struct netdev_hw_addr_list *mc)
 {
 }
 
@@ -641,7 +643,7 @@ static const struct net_shaper_ops nsim_shaper_ops = {
 
 static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_start_xmit		= nsim_start_xmit,
-	.ndo_set_rx_mode	= nsim_set_rx_mode,
+	.ndo_set_rx_mode_async	= nsim_set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= nsim_change_mtu,
@@ -664,7 +666,7 @@ static const struct net_device_ops nsim_netdev_ops = {
 
 static const struct net_device_ops nsim_vf_netdev_ops = {
 	.ndo_start_xmit		= nsim_start_xmit,
-	.ndo_set_rx_mode	= nsim_set_rx_mode,
+	.ndo_set_rx_mode_async	= nsim_set_rx_mode,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= nsim_change_mtu,
-- 
2.53.0


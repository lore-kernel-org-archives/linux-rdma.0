Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030422749E6
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 03:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046955; cv=none; b=AwTqrAY1X4cXJN7hEa+rAkd+IqSHp70ArziFHe6gMFICluj2gzpb8Ug0s5rfZGLoEQleRVtzbISX6NgkWMvvw0OyeIA5tqOjtMYvh8xVQOqtQK1S6AjhoHfTUh7JSiPSYUQxOet4fW0xTpHav+nomb5UkCMifmhF/Ft297/wzKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046955; c=relaxed/simple;
	bh=iSmmkgyOikY+CwgD/N7u04Ao1UfAh/QWnDwyIjtT3rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OrEvfYUg+80B/myL6azq5uXVHlDbyrYPTNyC27mzttBKv5Vg3f6DRcriDdgALgRZZqLDNXEP4xjbweuZvnWMKWU+GPdBsrMFC5+25MQhW0gHlH5ZQ8/2sWa2+0nEGT2nezQtSd4Cu7mlPp/uSFdMGG60UuBTRTv+ue5AL9/B2W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BoytIRsp; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BoytIRsp"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f0135fso35344465ad.0
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 20:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790046953; x=1790651753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uvk79jd+WkOqoSsKYqTDa1SfAv/OPPokbPe5GWlulBo=;
        b=BoytIRspLzHOGgFvPKbFZ8AuNmWz6hbkuY/d//8pfnmUlFz787w1Lr8tHMMRDE7PVh
         kO+k06SdRarVJ94t/06HYAc0kTNCtZIbXupY5aPxE2OrLjgYKuyxurZ2n8VC4jxG6TXS
         TAZiL9509jCUbNsdHunNSR7KXh5mE7q29p8IT4i91djM62Owt2grIbNzxlzU/1zn0eIE
         Laoz+ndT2e780Qm19WlzIIK28GzclL0ZyJ2o3ZywUjNC9oTAtx7Ca7AR1p5SJlfNfVTm
         +zfn+WFxlfuXTZuS52UbyIokIElZiU2igCCZrMR6UnnHOqyFXDRc/wZr2a8YPgM7syhn
         CwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790046953; x=1790651753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uvk79jd+WkOqoSsKYqTDa1SfAv/OPPokbPe5GWlulBo=;
        b=rAMilDbnJokuf5Q5UbdU+608E2BvUroVj8Sk0wiI/U2QanIrlZGokFC9G8+fQZQ7qy
         L2TahSNhsiqAbw30flt7p0jjcxg8lJ2qhvHpyyPYXElUDXht3ExFhsslWY3ztBLcI0XB
         xHIpI65IatqzybvI4GW5Mg5AqZ7S3sp57cMNv/xP2VidKp7k7sAuJ/26C8azMk1BmXjj
         EIZKQQNYvRnh52nQUNk++rUkxE1mrtsjUOWmr5/LTih9arOryszVW2cBmjC1ZTcxnRNk
         3KIJIERVnYbyRcJq4tr+UeGTCMWn1anU3WW/I3MEJ5p/S20XZiajnwHOlH7pdbirZbbs
         ScJw==
X-Forwarded-Encrypted: i=1; AKwUvBxvj5LVBbjr3J/Uaj/SlEFe4kc1Z3ogXqqWPZBt3Ak2SB0dCf6d4A9iHtbOG/CWa/YhSaqt4npZ8xjl@vger.kernel.org
X-Gm-Message-State: AFuF++mywRiqkauHpY0ij1BQSfeCmEEYLU1kWLxEA4vu2PMj/dkTsp5u
	gOQrxzUMeKlJ4HAWaACAkRDWf8MvpFyTrNReg9KTd/jFQTX45VYJKm49
X-Gm-Gg: AYBFou3oZ8rZy/yreMaCD3kjNQ1HpQvJBUMG48cgGKoILuliwJKgUlpskrumHIsxSik
	Uf16yi6pgfS1FwzgHJZ1V73mkKy1T7a00zWIIceGHtjXqKUbbaRuexgYg0mhPYZYv3TIQtfFWhu
	RpgZnC2NNaE341gO3bB6ALEBClFmEKI9QrWx+cRBrwgxwkuxnYYglbxEbITaNyDCNfz742Zb2EN
	hhSlmMn8aJUT276nbX2yPnYgvIbzKjiiF4PPlWH1PJZPd+j/ev/5QT9xWyrq0CpdtCDxoLFbrGO
	mwTmQacWXUbRelG09nV5RyjQ06KP9eTGemzsONfytZ6YnpZxbHSjJ9F2VOUmN+KLho3JpLFQBpH
	vdShO6jwWJc4ztIIuHG6cIbayRAOHM97KWwH1gXGf3Kh0PF6X/IZOjnNfOnFrxRnUw9A4t1J5Ea
	RVLhhYzWbEwZvRANPvWLjCIFty3D5LXPnraHXVmU3qX6sZRDnVqY9C9ZHo2yxJzGAspwEgkspZI
	JvlTFmTyLIHxPP5fMhbum2z
X-Received: by 2002:a17:903:8c6:b0:2df:42de:f71 with SMTP id d9443c01a7336-2df42de1624mr79060165ad.19.1790046953165;
        Mon, 21 Sep 2026 20:15:53 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5cf84221sm1893045ad.10.2026.09.21.20.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:15:52 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: netdev@vger.kernel.org
Cc: achender@kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Dongliang Qin <cccccccccccc777777@gmail.com>
Subject: [PATCH net v2] rds: ib: Clear the sg list when mapping an MR fails
Date: Tue, 22 Sep 2026 11:15:45 +0800
Message-ID: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
mapping and registration can fail. On failure, __rds_rdma_map() unpins
the pages and frees the scatterlist, but rds_ib_free_frmr() can still
return the MR to the pool with the stale pointer set.

This leaves the pool with a dangling scatterlist and can lead to local
privilege escalation. KASAN detects the resulting use-after-free when the
MR is later torn down:

BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
Read of size 8

Call Trace:
 __rds_ib_teardown_mr
 rds_ib_unreg_frmr
 rds_ib_flush_mr_pool
 rds_ib_flush_mrs
 rds_free_mr
 rds_setsockopt

Store the scatterlist in the MR only after DMA mapping succeeds. If DMA
mapping fails, return directly while the MR fields remain clear; the caller
keeps ownership of the scatterlist and its pinned pages. If a later
registration step fails, unmap the scatterlist and clear the MR fields
before returning.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
---
Changes in v2:
- Store the scatterlist in the MR only after DMA mapping succeeds.
- Return directly if DMA mapping fails, leaving the MR fields clear.
- Link to v1: https://lore.kernel.org/netdev/20260920063449.1594203-1-cccccccccccc777777@gmail.com/

net/rds/ib_frmr.c | 11 +++++------
1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index bd8611911..8397aa4a1 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -204,19 +204,16 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 	 */
 	rds_ib_teardown_mr(ibmr);
 
-	ibmr->sg = sg;
-	ibmr->sg_len = sg_len;
-	ibmr->sg_dma_len = 0;
 	frmr->sg_byte_len = 0;
-	WARN_ON(ibmr->sg_dma_len);
-	ibmr->sg_dma_len = ib_dma_map_sg(dev, ibmr->sg, ibmr->sg_len,
+	ibmr->sg_dma_len = ib_dma_map_sg(dev, sg, sg_len,
 					 DMA_BIDIRECTIONAL);
 	if (unlikely(!ibmr->sg_dma_len)) {
 		pr_warn("RDS/IB: %s failed!\n", __func__);
 		return -EBUSY;
 	}
 
-	frmr->sg_byte_len = 0;
+	ibmr->sg = sg;
+	ibmr->sg_len = sg_len;
 	frmr->dma_npages = 0;
 	len = 0;
 
@@ -264,6 +261,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_ibdev,
 	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
 			DMA_BIDIRECTIONAL);
 	ibmr->sg_dma_len = 0;
+	ibmr->sg = NULL;
+	ibmr->sg_len = 0;
 	return ret;
 }
 
-- 
2.43.0

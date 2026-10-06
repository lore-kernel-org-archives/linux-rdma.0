Received: from mail-yx1-f100.google.com (mail-yx1-f100.google.com [74.125.224.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6564A347BD4
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303853; cv=none; b=l+5ipiz3lcHfFcFDJk12V134s3prCZz3t5oZDdSdI1iJwOd2Ewo8XYL1pJn62BDpdbEHVdxTXwXLj4ZxZ+UKOCeuZ5av0LtqvJdf3ipS7Y82uzUP6G7gMHnN+Xr4lo3cUzAb1xTVT2pd7DhLlak5mvxEnF43+a746uxquuACxG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303853; c=relaxed/simple;
	bh=RcbvBXG/6lrsdkpqL8g9IxIvet2V3+6WRbvHO5gAYgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM7SshFJxtnbp5sRlpkT9Bv6a4QwbYdmcMwBwJgeNIWzKUTCAaGjTV/kODq9bUJ+X9Hlqorux0NJRJtYBdIP6CA9F2iaRg00e1MrJIAAB55qHwZaafPJJJ+tUtIADZqu6+CM1pX2Gm4Die6mG/WI3w0FzxdRiS582fvaUu7pZBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=h3gxBz3D; arc=none smtp.client-ip=74.125.224.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="h3gxBz3D"
Received: by mail-yx1-f100.google.com with SMTP id 956f58d0204a3-6767d92cde6so808073d50.0
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791303842; x=1791908642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F8p9gZ6dHUeXfr9Ect+sOuLZTX6uktr9z7PwXXUBPJY=;
        b=nImh9MrLGzM9F3zBHiqLbnIUkJ9l5nNPtZDXj0viSHxuasknhnY5O2dRZUsb16fYBb
         z41VhnPQmpbtYw7r1+/nPL+GpDWFcV5XdDpLDP6+hDs/j2TdT8pi0uf5gEJVLrMBorzU
         M1L4xkDvJxEvdebeATet8ytrgWRUBdpBRVOTkR2xtL8AkW0ty3WhSV2i3AtOD2g/euXx
         1m2OCvBZ+yx+SzTYGTh+BdoPfCI1JyGPDQ9VVnoQuSKIqd/H7+G/6Zb7lKPFVxTabaOT
         Vb7sjax6VS/j0Ft4paDABxOz1cvDTwrXVnpURy+H45eVc9zmmFTMkTchdJYE5wr0uCWq
         Vwog==
X-Forwarded-Encrypted: i=1; AKwUvBxA3EyhkehPcW4SIOIMIyhATuHmsBch980b93lwh5+19vmISzCaRr4DmzYbd/OsWTt7J6Q4XVljTWN+@vger.kernel.org
X-Gm-Message-State: AFq9FYL5TAONJHIcTydSX+MEruCFd0mrR5V20H10lQOy5ZWZaXcBrcGB
	a2sei0tw3F4+4B1guAbtpVrR3S6/oCGwsD6dF1kZJQVlVcla2m+wW64VCOQjaYZ14iWcgkW48oa
	OWtR2hl4fNzSHCDQ2B4SOBasGejAGTMWb7Veh5CiwSs1JnavkcsNHF7j5PSMNfw7R7WYDKr+T00
	TbI8eK9j8Xq9N4pjrudyFTXYTZjpjYmLYXFCu9CJIESgsht9VHH09kwi8K44f8gOQF0F63lLmP+
	xsFLQWQHCAjLl/UqA==
X-Gm-Gg: AYBFou0n3oMxFnG4Olcq6d5/hxLIAePUIm6CS8CxGLniJrvtxZ/uxKruXwIkIz3dANj
	RCKhRpPcnAEOGWyG7IGx47yyKk9dfl/LRL1KAJ++t/y2I4QQpS1iUxN5KbwuLvkTLyinuH+afU1
	sF4PdHRSWmpuHBPQUimGqJ8DEWMiBZxhGk/2MrRltqDQClM+oA3UIU4nPev4WLveQfTPO+ALug7
	iQOHJstqcuwRzidojWF3yuAdlmAhmi5epiT5om4KeUgNSCA7mWhkmf7F8jeXSASy2quW0HDTST5
	KkecqWtSwZRvqsBcN52TIviY300kzYzABWsbT0aV1hX4eYgRqIyylYG4SsVFM5RyR9GNMFKGAjr
	hY7ThX48gsZpPk1wDcXMtgKmrfrq1RA/U8sFg7gH9O63GbzxQVc/VG6EsBBVB72pR0tZuJ47emO
	aBQnqNaDPZQx4reMfsCXYNoWMWdHiZHOdBb+HQ
X-Received: by 2002:a05:690e:bc7:b0:677:ce61:dd3 with SMTP id 956f58d0204a3-678fcea34d6mr1019439d50.93.1791303842312;
        Tue, 06 Oct 2026 09:24:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-677c1bd060esm1787304d50.33.2026.10.06.09.24.02
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 09:24:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-53397b6e05aso58563451cf.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791303841; x=1791908641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F8p9gZ6dHUeXfr9Ect+sOuLZTX6uktr9z7PwXXUBPJY=;
        b=h3gxBz3D6k97B+mQI3Oex6nh50F8IZvF7hZoEmLHknu9f77Hi3+guupWPYkngMZxe+
         1ezv2YEWoepQziuvDsbVvqJ2EXGC4oFG9ud8p1q5KLxzC+22DtaW23c6WzhadgTAOVbN
         NHRGIGTprNn+kvTlynKT16c82xbEQ8Q0ksO0E=
X-Forwarded-Encrypted: i=1; AKwUvBw9LqRKp0Bb2Pstuq82dDe/p5l83lvzgotpT2ICbg5fRGCSaNaNIPeW3yEVwXQj6bUVck2mZG5vW0Fc@vger.kernel.org
X-Received: by 2002:a05:622a:312:b0:535:2283:20a3 with SMTP id d75a77b69052e-53566b24b6fmr31828941cf.33.1791303841397;
        Tue, 06 Oct 2026 09:24:01 -0700 (PDT)
X-Received: by 2002:a05:622a:312:b0:535:2283:20a3 with SMTP id d75a77b69052e-53566b24b6fmr31828551cf.33.1791303840787;
        Tue, 06 Oct 2026 09:24:00 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5356b860df8sm9020961cf.14.2026.10.06.09.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:24:00 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Sachin Holla <sachin.holla@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>
Subject: [net-next v2 3/3] bnge: reserve TX/completion rings for the RoCE MPC channel
Date: Tue,  6 Oct 2026 09:12:56 -0700
Message-ID: <20261006161256.1493672-4-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20261006161256.1493672-1-siva.kallam@broadcom.com>
References: <20261006161256.1493672-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Sachin Holla <sachin.holla@broadcom.com>

When RoCE is enabled, the bng_re driver allocates its own TX/CQ rings
for the MPC control channel out of the same per-function FW ring pool.
Enhanced bnge_reserve_rings() to account for this extra ring count to
avoid pool overflow while allocating netdev rings.

Signed-off-by: Sachin Holla <sachin.holla@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
---
 .../net/ethernet/broadcom/bnge/bnge_resc.c    | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
index 4711dd4945ff..9dfb22b7c7c7 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
@@ -110,9 +110,24 @@ static u16 bnge_nqs_demand(struct bnge_dev *bd)
 	return bd->nq_nr_rings + bnge_aux_get_msix(bd);
 }
 
+static u16 bnge_tx_rings_demand(struct bnge_dev *bd)
+{
+	u16 tx_rings = bd->tx_nr_rings;
+
+	if (bnge_is_roce_en(bd))
+		tx_rings += 1; /* For MPC TX ring */
+
+	return tx_rings;
+}
+
 static u16 bnge_cprs_demand(struct bnge_dev *bd)
 {
-	return bd->tx_nr_rings + bd->rx_nr_rings;
+	u16 cprs = bd->tx_nr_rings + bd->rx_nr_rings;
+
+	if (bnge_is_roce_en(bd))
+		cprs += 1; /* For MPC CQ ring */
+
+	return cprs;
 }
 
 static u16 bnge_get_avail_msix(struct bnge_dev *bd, int num)
@@ -250,7 +265,7 @@ static bool bnge_need_reserve_rings(struct bnge_dev *bd)
 	u16 nqs = bnge_nqs_demand(bd);
 	u16 vnic;
 
-	if (hw_resc->resv_tx_rings != bd->tx_nr_rings)
+	if (hw_resc->resv_tx_rings != bnge_tx_rings_demand(bd))
 		return true;
 
 	vnic = bnge_get_total_vnics(bd, rx);
@@ -275,6 +290,7 @@ int bnge_reserve_rings(struct bnge_dev *bd)
 	u16 nq = bd->nq_nr_rings;
 	u16 aux_msix = 0;
 	bool sh = false;
+	u16 tx_demand;
 	u16 tx_cp;
 	int rc;
 
@@ -293,11 +309,12 @@ int bnge_reserve_rings(struct bnge_dev *bd)
 		hwr.nq = bnge_nqs_demand(bd);
 	}
 
-	hwr.tx = bd->tx_nr_rings;
+	tx_demand = bnge_tx_rings_demand(bd);
+	hwr.tx = tx_demand;
 	hwr.rx = bd->rx_nr_rings;
 	if (bd->flags & BNGE_EN_SHARED_CHNL)
 		sh = true;
-	hwr.cmpl = hwr.rx + hwr.tx;
+	hwr.cmpl = bnge_cprs_demand(bd);
 
 	hwr.vnic = bnge_get_total_vnics(bd, hwr.rx);
 
@@ -327,6 +344,13 @@ int bnge_reserve_rings(struct bnge_dev *bd)
 	if (hwr.stat > bnge_aux_get_stat_ctxs(bd))
 		hwr.stat -= bnge_aux_get_stat_ctxs(bd);
 	hwr.nq = min_t(u16, hwr.nq, hwr.stat);
+	/* Drop MPC TX ring from L2 TX ring count; it is owned by RoCE driver */
+	if (bnge_is_roce_en(bd)) {
+		if (hwr.tx >= tx_demand)
+			hwr.tx -= 1;
+		else
+			return -ENOMEM;
+	}
 
 	/* Adjust the rings */
 	rc = bnge_adjust_rings(bd, &rx_rings, &hwr.tx, hwr.nq, sh);
-- 
2.43.5


Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7F63AAF76
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881022; cv=none; b=N6QbU1T1HaozYswSTHer7RhIw9tVtOlmKvn3RppMDbOKJIUjEAvEyyXtU00Ly6TMTVwt1KsM0GBfi3F1Jdokb9hCF/BEFD5hmEHI+FVEYMKO6mv1s7tbal31Q2PY7r8t9VyjHPvM0tDIJj5YfEpQ1vf8SORQCFHUd0Xv2AeUIpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881022; c=relaxed/simple;
	bh=wKiZ/RCyo1VFZfv6tvxp9iEOL9Er+CgjVaYdD4Z1XiE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BZf2Mvcyqu7M2upMLDgZKdWwiRViKgDMcDu4SWZMkDMswFV7ejBpScEE/dVLgEQSX1utRpOug5IMfn8oFFETxTZuPAep+moFWNzIjhwZ/d90aKFFyP6X3IJavaZOcAzJavRBLNBDmY5v6qJE/8SM3WZcDB+CxoS13qMZPUvo3Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=N7m0+IvS; arc=none smtp.client-ip=209.85.222.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N7m0+IvS"
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-93e027da22eso183498585a.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791881019; x=1792485819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfnO8pg542hJIiehOxpVwgv6diZ6xdftt6CjElXSOj4=;
        b=KBVapu+bL/8QLOCSlQLmnyi3lASWwswJU0sOa7gzY4cxSfv0mBSie6fuzr1azpsQoi
         2a/gDvMdoQohqe9c4XbmSdXq4js0eqHAuOcA5rXMrX9ECmIkwb49HZUdzQLbJnSj7tyt
         tuSg5offINdIqg+5oP0zs/66tLdyEQQmyoFAwb6kafNiBxq2wpzov+DTe51zjhCDcN9P
         40wAtC6iDCMGhH+d11KmHHujcLQGD1jQZ5u8PgjYyjyYK3HUpzCkuyIWD/9Zt28u1U87
         G6jRLLJDRwvI7Sgvk6fnXdHVp2HYo/A7rIb7LmT0vcRiODtHoFZvtXZOS9dT4fa+FAb3
         iMWg==
X-Gm-Message-State: AFq9FYKcLgu5TDVNNOofVt/kSHZZBBoacABy4k5GLaaLvRuW/NmiUlh6
	C8YiFZ0LglRDFzbM9mZXQ+bLe1waG54h7LiROdLK391qUP8jieauQCR4RjyDqJl1xc8tF139kCX
	UGeoE1ZVRy3DbqTcIzu12O8pKbYrLfJ9sLwxd6vrxJfi5QjfIvHl8jNUVz6Jtfu8/rfmV+bmPCl
	55dTcXxtnkoUC+WcjfMtgqsarXRa2FVoNHd6WSDcDak1fEi48rvjZg1KSId4Jq3sA1DBO7X662y
	G5OaR+0zgjEcUCKJQ==
X-Gm-Gg: AYBFou2GlQnhX/I/z9VlM+9KnBdUZK9z4473Nl249UgUwn8SaeMqqHo8peCtmApAY86
	JXdBTSBN1JVHLHoPdeNBxSSmYzEwIxqh3dXEWVETQq5yFm+wuBOQIyHy7bstCCGZA1oaMh8n6MJ
	wb9Qqzec6/Zo5oU/E38qlueDk3eGT4JfoqvPM3p/4qdwSgtlwaOaIf7ws2PhyRHIHivQ0DOih2n
	CaiqJGNIB3TyvHSMjmqJQwCNCBHRhKXoYfIE1+e3X+FLndCB2lBkf01AvmEfQ5xKeavXSPbj6Dr
	T/odzNFy8Qe0px9yqPdEDmT/yKQZTilZiNlyE9MZ8D8hC93EuMTuXKO1kVaH/S1zylSDcpmQhAs
	odxD0ZlPBzq3mCI6wgyf0a0lyk1rnWm6UcUDhXQwNKo2Fw3wVzJZOxJ+POvdrP+hJjsO4dAAsLc
	QxiDzPTw4nXzD63E6nEN4BpaOXf+bn6/34tS5iVvI=
X-Received: by 2002:a05:620a:2b4e:b0:939:a003:7127 with SMTP id af79cd13be357-93ebd23f5c7mr1880737385a.52.1791881019436;
        Tue, 13 Oct 2026 01:43:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93ef50b457esm49224085a.15.2026.10.13.01.43.39
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2026 01:43:39 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-147be78cd56so10919740c88.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791881018; x=1792485818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gfnO8pg542hJIiehOxpVwgv6diZ6xdftt6CjElXSOj4=;
        b=N7m0+IvS6uDoEjDl583FOOPmNnTnbUsW/pcFDS5lpHFnvkeZiIWqwl2AQGPs1o8JTK
         EVRlw7xzPzO8/hPktQ3rfbucgngvL8AsInXlP2rKf8wtafUZDBFIBlRCRKjV2dAS0hSi
         yBrQF3xQFUyRb+ynhAfEuoq9W2jOFdxA3nPI4=
X-Received: by 2002:a05:701b:2612:b0:143:868a:20c1 with SMTP id a92af1059eb24-16a65c0ad23mr13921693c88.46.1791881017971;
        Tue, 13 Oct 2026 01:43:37 -0700 (PDT)
X-Received: by 2002:a05:701b:2612:b0:143:868a:20c1 with SMTP id a92af1059eb24-16a65c0ad23mr13921659c88.46.1791881017219;
        Tue, 13 Oct 2026 01:43:37 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1698de65af7sm40209556c88.0.2026.10.13.01.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:43:36 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 1/2] RDMA/bnxt_re: Use kvzalloc for QP table allocation
Date: Tue, 13 Oct 2026 07:04:26 -0700
Message-Id: <20261013140427.256612-2-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261013140427.256612-1-selvin.xavier@broadcom.com>
References: <20261013140427.256612-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>

The QP table size depends on the firmware reported max_qp, so it can
be large and a physically contiguous kzalloc may fail. Use kvzalloc_objs()
and free it with kvfree().

Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
Signed-off-by: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 756f8b5f042a..086cf9fe3920 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -909,7 +909,7 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
 void bnxt_qplib_free_res(struct bnxt_qplib_res *res)
 {
-	kfree(res->rcfw->qp_tbl);
+	kvfree(res->rcfw->qp_tbl);
 	bnxt_qplib_free_sgid_tbl(res, &res->sgid_tbl);
 	bnxt_qplib_free_pd_tbl(&res->pd_tbl);
 	bnxt_qplib_free_dpi_tbl(res, &res->dpi_tbl);
@@ -926,8 +926,8 @@ int bnxt_qplib_alloc_res(struct bnxt_qplib_res *res, struct net_device *netdev)
 
 	/* Allocate one extra to hold the QP1 entries */
 	rcfw->qp_tbl_size = max_t(u32, BNXT_RE_MAX_QPC_COUNT + 1, dev_attr->max_qp);
-	rcfw->qp_tbl = kzalloc_objs(struct bnxt_qplib_qp_node,
-				    rcfw->qp_tbl_size);
+	rcfw->qp_tbl = kvzalloc_objs(struct bnxt_qplib_qp_node,
+				     rcfw->qp_tbl_size);
 	if (!rcfw->qp_tbl)
 		return -ENOMEM;
 
-- 
2.39.3


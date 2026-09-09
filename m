Received: from mail-vs1-f97.google.com (mail-vs1-f97.google.com [209.85.217.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41A84A13A4
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942690; cv=none; b=RsI+1rI7kYFLIDKk6tmLDhGjsJk72Xe1sZTW69N7QHpjzqxXCc4q53+RTFdZwYoxmRloihQq+7gjt+vFbb+yK01l0ePWnwCllrh8AAizunZochTaturNHxsJbCHwtgmpG8aCiIYhcktEh7IrMh+KjdGigXG9LAW/5htQ/GCsFRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942690; c=relaxed/simple;
	bh=2/aBtjCtgwHkSTRchE33zscncUn9TLwF4MTEk20GFUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gTWhBoWScLSsjRGRogocPb34XzVF1G2dKmyWr0zZDxxY1Rn2PYkJ+3PRvaI2hg+zjs45Ph06TnG01ZD3xzzlDIQBCXzAcxEPibUtz42U+7O1pIzWlZJbOmWPbpIvFZO0zfiIK5agazLtYTKaeEV9767q0syMQzXd1seJwzfPqs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LOpKCBU0; arc=none smtp.client-ip=209.85.217.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LOpKCBU0"
Received: by mail-vs1-f97.google.com with SMTP id ada2fe7eead31-784980b88acso1877466137.0
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942687; x=1789547487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tTAVNA9zZdlUXulNOcemvkvl3tNByjAr33dGHdVw2y0=;
        b=bPopsTisQrOLo0cbVJnr/X2mIfwwgwbYtzqlCWuwLawbQKQuwic7qHg7XMuTdw3uSt
         i1HZpKRLEeAB1OZEdMInXG7zEykWd9OOIMPZQTyyVURf1BAVSSquJJcn/vUV70Ah/eoy
         uygwIaCirPlXQHLOT3h5WwsFREA1lcq8kkHYaPZwhms5RGg14lMlcpLIqWBjTNKsBUuc
         7rU62bRsb0kvgCCcUcgkTSe8ZEPzU0QvvXz4X4ft22EJGv1WP0Xf5QndKKLPXQm7UAye
         zr81u7+QSwVMjatT/fenB+z573FR8H8PRDpGdU1ynNMns2fwLXl8gKC1QyoVAvQjqywJ
         LpcQ==
X-Gm-Message-State: AFuF++n1IYS7SNmLOpZYtdHe4rUpgnRksmCkdhIdVw+rd6vI7PQ6HsCo
	rjin29ThC1WMbnk0kj5N0CG4gT2H3yFGYW4AovmNRdoxG6FwsJBHrEOqLFrk0ElyXqSYs7o52jg
	X8xrA84UwW2CsibAds/26QPQIkBdXOsq+THNVvQc4UVxJaU/p3oGYtIfyE5+i+lE/TZ7vhbXNWX
	S4uqfH9O4ATf5+meFjI/DbukRR0FDoyo3E7TIDuFg75GJG8dYr3pu2R7GWlw4SNgNjo5jC40ztN
	e2h7zGaIS420UtmYA==
X-Gm-Gg: AYBFou3id3K5o0fN5SsV8PA4/Pp67/+fPXc/JOlUXVZ/n3tcy65o3NzljB1o0vs/9dD
	3FVAFwjUZZP2YdDgch7TalaqZ6ON4PEQQ/hZoiVdB9S0isJx4wOWR+bvCvVagWS8TU0Ydr+rUwn
	OjbxvtK7fK3mm45yDG3lDYmqJ8dg80BfDuUe9T2QvA/QIFhvQ3RXlULuADEDV1fcotocAvhk07I
	Jkg9Y+L0NftaovFKprlxj17hAH56KXIezQgAuR1j7FauzJZEMGW3SmUTDm4u3SxeoOUNSwnTnUO
	S+xnu7sYpI3OBJVGTUROYLh8piZb49T/A8jOGRiIry1PP+8e3+iTmj6VXSliIep4vr4mvF4Ddg9
	cmKejSsX0vC3C0ck5htj5NpQPNtnUZWWnDefY/ROb3sHrJ9fPWucYKpVow0kzIpXk50pKsTATAF
	hG0F/3Ho+O/Jqv9JjC6SeKZQpzN2uBbyY5QLy6w+8=
X-Received: by 2002:a05:6102:5091:b0:78a:8a0:7126 with SMTP id ada2fe7eead31-78a4aa97d5bmr12068513137.10.1788942687454;
        Wed, 09 Sep 2026 01:31:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-116.dlp.protect.broadcom.com. [144.49.247.116])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-9808ed4f53csm4515067241.6.2026.09.09.01.31.26
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6b3619f264eso5701401eaf.0
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942686; x=1789547486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTAVNA9zZdlUXulNOcemvkvl3tNByjAr33dGHdVw2y0=;
        b=LOpKCBU0bE6ifhFgb7TyJBO68i36FxaBfH1z75rMvY7/v9Up5QxM7wC4ycQ9jACoMX
         cSNqUcfmnxf24vp7vP+RWHgqCXOpJfVp3qHFwjdkQiUMai0JuF7NuzTtiIZTt25fZM6n
         TnpvZpWGKwH/sM+wh2FUbv95pnQhIym3Z6a4E=
X-Received: by 2002:a05:6820:907:b0:6b7:46fc:1d5 with SMTP id 006d021491bc7-6b746fc0309mr18724462eaf.52.1788942686371;
        Wed, 09 Sep 2026 01:31:26 -0700 (PDT)
X-Received: by 2002:a05:6820:907:b0:6b7:46fc:1d5 with SMTP id 006d021491bc7-6b746fc0309mr18724411eaf.52.1788942685719;
        Wed, 09 Sep 2026 01:31:25 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:25 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 4/8] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Wed,  9 Sep 2026 06:52:40 -0700
Message-Id: <20260909135244.122747-4-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_create_srq() validates attr.max_wr but copies attr.max_sge
into srq->qplib_srq.max_sge unvalidated. This lets an unprivileged
user request an arbitrarily large max_sge, defeating the num_sge
check added in bnxt_re_post_srq_recv() and overflowing the fixed
13-entry (BNXT_VAR_MAX_SGE) sg_list[] array in bnxt_re_build_sgl().

Reject max_sge > dev_attr->max_srq_sges at create time, as create_qp
already does for QP send/recv SGEs. Also clamp max_srq_sges itself in
bnxt_qplib_get_dev_attr() to BNXT_STATIC_MAX_SGE (6), the actual max
SGEs an SRQ ring entry supports, since it was taken straight from
firmware with no bound.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ab9d4d6bf5b0..72c098b48826 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2235,6 +2235,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf..9aaa2b5204b8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -160,7 +160,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.39.3


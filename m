Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7246A3B42C6;
	Tue, 15 Sep 2026 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477760; cv=none; b=B9ipyAwcivElmKSZQBu8N7q/TbIKiihSUIRw49j1ySOQGG5IbIuMe9Bi/5/c/Q2c3uA9Byt+kTDTsisYYQomvFuoTbfbH4oyn6WICob5+MhUIx/vUQwmbuAhJ40UvH5p0Txcwxf75Qpsp3/WhV9Fu3UdL0tuEk6/3FxxcQHWei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477760; c=relaxed/simple;
	bh=+qUh6fasgwRc7Vsuew6TapD8CkKSediEhZVKjK3W+sA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QHRsxxOKx3GA550/lZ1hzbf2USLnRs1LIZo3zN+gSvG+b8ew0RDgmkgYSY9r7Xqz9osx7/w2+kYyMq8YRKsXYuIAVbWlJnQMCmdCrFNQN9z9nRAwvj7qhVYlxKqM/wDEyQTqa7MSaXSq31sqUxcJXVXfQUe36xzrATMnp+UWrns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTTls6qE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTTls6qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED421F00893;
	Tue, 15 Sep 2026 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789477759;
	bh=lAexU2F58ncYg4n/wbz5EAbRz3rhuDpKo8r2YS1HMpA=;
	h=From:To:Cc:Subject:Date;
	b=YTTls6qEyd+SaTauKEBqc9LWw4Vuha3EvHqBQAOB32uqJAC9x4xVZT4bOHsje+gX+
	 qcP+GnVWDVqEsgbr0RHaZXSkXzf9t6AvjX9RnA2zI/IpjbAOiziKArSshso5JJfLNs
	 Bc+HMKAuG2C2UYuzzWCKzJcPHryYLpzCpspdqI1R/TpJmFUl/76VFo4bJ//ksHno5C
	 OhTCSdFY4iJb+26kALL8lqdzHNoX5h1FSW6/8OfMjo/DnXhAq0zXBRmqrvh2mdRN0f
	 w4B5QTlCAdo0KTquJgWJGB/SNsHUkGJDEgi1Fr6ejwi02lFQsXcpwdBAXnPHXUGtzp
	 S4ph1n5k1UlrA==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	Devesh Sharma <devesh.sharma@broadcom.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/bnxt_re: Limit SRQ depth to the firmware command field
Date: Tue, 15 Sep 2026 16:09:11 +0300
Message-ID: <20260915-silent-16-bit-truncation-of-srq-size-v1-1-3199f8fe94bc@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260915-silent-16-bit-truncation-of-srq-size-a1495f0bf133
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Firmware can report an SRQ depth above 16 bits, but CREATE_SRQ carries the
allocated depth in a 16-bit field. Requests near the advertised limit can
therefore truncate the command value and make firmware use a different
depth than the allocated queue.

Cap usable work requests so the reserved empty-ring entry still fits in the
command field. Accept the capped maximum and correct the associated
diagnostic.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 4 ++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ef08d42f377e..43ff3e7a459f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2229,8 +2229,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	dev_attr = rdev->dev_attr;
 	srq = container_of(ib_srq, struct bnxt_re_srq, ib_srq);
 
-	if (srq_init_attr->attr.max_wr >= dev_attr->max_srq_wqes) {
-		ibdev_err(&rdev->ibdev, "Create CQ failed - max exceeded");
+	if (srq_init_attr->attr.max_wr > dev_attr->max_srq_wqes) {
+		ibdev_err(&rdev->ibdev, "Create SRQ failed - max exceeded");
 		rc = -EINVAL;
 		goto exit;
 	}
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf..63dcbb9d80f4 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -159,7 +159,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 	attr->max_ah = le32_to_cpu(sb->max_ah);
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
-	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
+	attr->max_srq_wqes = min_t(u32, le32_to_cpu(sb->max_srq_wr),
+				   U16_MAX) - 1;
 	attr->max_srq_sges = sb->max_srq_sge;
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);

---
base-commit: f7d28791433d373ecdab7b00f60ddb504e858e0a
change-id: 20260915-silent-16-bit-truncation-of-srq-size-a1495f0bf133

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


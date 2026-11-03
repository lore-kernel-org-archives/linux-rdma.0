Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698934;
	b=pcGAeCyYWq62zXLVUNuYnB+J3Ps0OFNstdkdMyMB4fTKAeQ3tckuiITZid1SlaYBfFZq
	 GP7eODkeQIqoOzqrFtzR5jfFVI/CdftyBUE2MA7jCI0rDKn11++nt0KROFm72h/bsJLt9
	 OvUhbnB+ft62uE3p+yb406m+T943CrdpHslube40paTbUvsVQITWgef96w8l7CebhP3/N
	 D1Ef/mDGf0R0516YlqCx2SDPNYFP8qSUw/thHhceaV7AxqwOMNNtS/TXf1F+DVp9dBJgI
	 OxnPfu1uMyJVgkMpINX8XUW8R73oq/DZsF+0KpBjiscNnvByzz8RYCscTlWsVItvmdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=D41fnnFYq1W7c9caRbcxsvH282QipdwGAgcdsw9/aac=;
	b=ePSH3jtFjEJRxLjxJb7GJUwX/iHNS0XXxa9WTdLmpWp9xdYLQhbdFY7JfIrSuO9u7CFv
	 3t0nJTXZq06TIHW91+JEQl0qf8tGjVMLNae7UgVM+NDIpRfMYZa+VJQjm8oLvjvb02+Ll
	 O/iRrRhIB2iBEPsPG5UHxNVrRkRGQ+Yz7c1FWxLI/UB8KSeYcPhlw3VdWiQAMG28M8Kyb
	 cyrPgx8972zjUCOjCpog0hvXVRfdFEXfl6LOO7ki1u8SF3vsI+AYMKd8rcW15afXYDdQ9
	 U6/4Cy8LlGgwG6fNPeX0bNf8QxpKkyuOmr40ZcZuizMNHhUrHyve3pm3bfrjfXFWjyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1zSafbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DF8606A326;
	Tue,  3 Nov 2026 09:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1zSafbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7130E1F000C1;
	Tue,  3 Nov 2026 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698934;
	bh=D41fnnFYq1W7c9caRbcxsvH282QipdwGAgcdsw9/aac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1zSafbrkoVpxMIzuUasWV0geJWs4uuUvbBJU9g2JQtSZnLSvTRGtcUvui37cX0mw
	 gkcHy6yzicHT4dk49/bDnCcqnTJmD4S+de48sb3qrb+b7GLHVdE1vk+gNrMPwD3/GE
	 E4M66Fvv0UAjrv+MHHDGAZXs9QFYg9M/18CoR0JENR/NcSjCX0C2QaXUqfnB3ZN2RA
	 vzfqYyaiDxumPRDjtpc25EoaRnSyIpA3ElPIR8Wiu1S3yvH4M3rLUdL4or75J4i9bk
	 8qSoK+7tYKZ0nC2Rpq3FANbdAppSg0O2lriNt9zV2mcMQg1e59OzZFtzVpLjgvLMDV
	 Nd/rbzJSyH8ug==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc 2/4] RDMA: Add missing UAPI files
Date: Tue,  3 Nov 2026 11:41:58 +0200
Message-ID: <20261103-rdma-branches-v1-2-763c07cc14aa@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
References: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add the missing UAPI files to the relevant entries.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ececae180352..d49552a59692 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11821,6 +11821,7 @@ M:	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/hfi1
+F:	include/uapi/rdma/hfi
 
 HFS FILESYSTEM
 M:	Viacheslav Dubeyko <slava@dubeyko.com>
@@ -12146,6 +12147,7 @@ L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
 F:	drivers/infiniband/hw/hns/
+F:	include/uapi/rdma/hns-abi.h
 
 HISILICON SAS Controller
 M:	Xingui Yang <yangxingui@huawei.com>
@@ -23440,6 +23442,7 @@ M:	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/sw/rdmavt
+F:	include/uapi/rdma/rvt-abi.h
 
 RDS - RELIABLE DATAGRAM SOCKETS
 M:	Allison Henderson <achender@kernel.org>
@@ -29905,10 +29908,10 @@ F:	arch/x86/kernel/cpu/vmware.c
 VMWARE PVRDMA DRIVER
 M:	Bryan Tan <bryan-bt.tan@broadcom.com>
 M:	Vishnu Dasa <vishnu.dasa@broadcom.com>
-R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/vmw_pvrdma/
+F:	include/uapi/rdma/vmw_pvrdma-abi.h
 
 VMWARE PVSCSI DRIVER
 M:	Vishal Bhakta <vishal.bhakta@broadcom.com>

-- 
2.56.0


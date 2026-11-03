Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698944;
	b=lVTIHeoR26aYbRGR6ACqQMs4pkNjr1M8dJl14m6uGCFHcCupiwcEu1kgiS41fHWeLGY/
	 lNi7ttyPwaPCmlYEt/DdVSGXQQ+1g1Fm282S1My2/1/Oly3Bric5BL8jm4uoAeyPixOvP
	 fc8s7ZaxtPmVs+lUlW2kKk/EzVW+fqAr7LuWgdINcTXEq7nvxiTgDvGdoPAmNg/r+mKQo
	 MoKlNUjgvT+ubaGCyDATWm1r+OEkLviCsi21dLZLjZx7sdrwj2aq/n6+4uqetmmu0jnfp
	 cnAWVW+8siiJMhYVVDwQgxiKSFg9cgalrRyzE7LLbHcuKLM1OzTZVYek5pVI0ndg9Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=vVZw9R8RIfvxlhxDuHSHzu20mAMzOHZdwLo39yrD/qI=;
	b=je77L9Q9kQ/IXSny9XnVrfj6UMvDQorD8WvBDEXnQzTKIsXHYS6iGfFkAvFH47BOiLcJ
	 GX46rEdHWCLETN6kW8rAP53/KGXCSFEgC44MdFbFJPZy4/5OlNBzYAfPP+9jB0mpoOXqN
	 Dp8ev/sVAyvnFNU+g34AjkWI41H4B9bDdc9CLkvDnKN0fv9BngO6BAzef+Oo04g5ePbzf
	 MnRQlk8HD5OFxlxYeF3OtM1pgH3hbPGySkkjo/uvOaxPwEBxwBqTxZ0aBJqe0k1FjT/Xt
	 qCTg0RNkJnvmRtKVXQHbxme8xpt5vKi2+3K58Cho57/XMtToL5vqEuWphuPtms2iMuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IFZMKQig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AADB606A33D;
	Tue,  3 Nov 2026 09:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IFZMKQig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0FA1F00A02;
	Tue,  3 Nov 2026 09:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698944;
	bh=vVZw9R8RIfvxlhxDuHSHzu20mAMzOHZdwLo39yrD/qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFZMKQig9C2zQfezTJDINGHwID8tGr5XdRMRYby0np3pnAL4lboxf5qIhG+2bMNDd
	 O38MbzpwlElh/9O+GJT4vZr+P0DNMwzHWhZ/cHcYSj1I4BdZnFOqbOrNTLEFm/zXqr
	 8ApKz3ZkRRyhe0gGAMm1Nx07ws5iGC7+YZZyk0lurcqC5UcsSpfbN444dE8fo2Samc
	 pn+n52M0PVqfHa5GafV6NzrOSCNOPhyspIxaz7d3zxCgjcB+IM3NguXBTWg3uG8mMS
	 t/cBP9gXC7cIRbM8pfskD189fpdgsi4Os3vadcgSuDin/X0vM5xHX4yRjVQckG4sb9
	 3iu47OLvxTCBg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc 4/4] RDMA: Remove pointless links
Date: Tue,  3 Nov 2026 11:42:00 +0200
Message-ID: <20261103-rdma-branches-v1-4-763c07cc14aa@nvidia.com>
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

These links either no longer exist, point to stale tree, or provide no
useful information. Remove them.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 54df71bd7d65..6004ff7ed8af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14192,8 +14192,6 @@ M:	Sagi Grimberg <sagi@grimberg.me>
 M:	Max Gurtovoy <mgurtovoy@nvidia.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-W:	http://www.openfabrics.org
-W:	www.open-iscsi.org
 F:	drivers/infiniband/ulp/iser/
 
 ISCSI EXTENSIONS FOR RDMA (ISER) TARGET
@@ -14201,7 +14199,6 @@ M:	Sagi Grimberg <sagi@grimberg.me>
 L:	linux-rdma@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
 F:	drivers/infiniband/ulp/isert
 
 ISL28022 HARDWARE MONITORING DRIVER

-- 
2.56.0


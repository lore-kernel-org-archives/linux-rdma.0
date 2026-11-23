Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795394607;
	b=jZtQ+s5g8NGuvSkBqV+r4mKO2JLYeCCw1cHiwu18XdSet0uDLXuQtR1o9yeWb8EhtwMB
	 D/cXwBrS7fM/SvTEKaVExZDmQ4vm7C07I4AZgC9NvhFTNBzCYY8A1CPMvC60Fj2Zw51Zk
	 G7s9SoDCre4JR5mmvHly/NaSuVjDGH4RL0POCt6tzg5f4rTKPkIvW3M8KPcAvbBm3K4V9
	 tbRxb+rQU6ieIwP87PQH1k63CSZ05czy3ESJ7pWgZsgKDu3SYvFpuN1ZfgRkgcDlIwiD2
	 rNba6B1hMcCuvZY7/iYB4EmCdvnAn+Tgya0NQEGSyg6wMn5VyRTopm5beLwMrOmQfSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394607;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=7RaFfDowDDHtzxYlO4vBT53fBYjb+jNKJQ2d6Vz4AwQ=;
	b=DyfuwACWPVfikwL4LwtgaT8ffiPBb77s2cxDEKQtKj1fXi+9hSKTF1+UfAk/4/mGXT4A
	 RjcqPZAePSJnZQIeWcKqgWcs65MzLCtV1xsOKtORIkqsDOfZz4zma2g9bdpntcaj/OG7P
	 8UGkGakkKPvN97hfT7gbdq9qgvltT3tjz59pLsZMuWStM0kX6CoKD/LexS8tFngkWLRFw
	 LxCaZBngkj4wNwCgMdvhlxwiO0MvmqdmnOk5FPNugYsbhQeW+8t2QS7qqvjwOtSyv/GeL
	 QlyFuSwlPMgOAJ22g2NNpAp9Kk6bLPKnHlNwyShKlMhfIlabowNsrYKVEM2Bz2azHZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rk0KeU2i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691FD606A33D;
	Mon, 23 Nov 2026 00:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rk0KeU2i
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795394607;
	b=cVtw13huFvNp7MDRcIfKsznuoXU4mWLjwhWbvFlrgwJv1CbNXCDfCYfBD4rGBlmzbLQF
	 Yu/l8m2ORlBysUM8dLj656TverAtpXkmycbm2RfvsyRgInTzXgwFETt7WZHJdJSbRrJLG
	 ZTgvYEaY2Sm+qe9HljeG5tzjAzfMVop1r+XtwDVcn8qnvCIZtMZfLPdWaQnrQRR0Wh8We
	 Lecoi8qHRq6ymRnn8CkFI8fispAFC86TRSWazsLbpORxGah17e9QTZxd7EKkpUwLcwE9B
	 stZXtvezrbOD28LmGd7yrmFK2w467EDlE/S9b2KUPxS6PyWuPyc3XuUxyzgSRFZNgjg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795394607;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=7RaFfDowDDHtzxYlO4vBT53fBYjb+jNKJQ2d6Vz4AwQ=;
	b=Xa30P7ZWeXbRK3ECzeMWccfTIRUrwbxbxvPwp7zZ0USwq3jKPQrS7rBdi2xF8Fg/np8Q
	 aczhiQYepao9t51PIBN+fPFJsbqabVHzZPAxwSlg1P0YIG3z1P12dbaezu1rYLUvSSAts
	 cFw8MsVh7QN/CPnBBsgba946ij8N7ah+Pg9APS2Kz0NMceuaFyR8DHAWQbCJgEDWu9ZED
	 ULzkNp2ZV3O7++Ahmfu0dHVKM6t7UoOoqE9R5uHTn/0GSfVKT/YhindyDVqHr+DX79rnm
	 88NBzQyakeg7yYqFwbfr2InexnWgDl4k/7IiwlWsojlSfIOaoSE4LxcgD1L3WstJ2mw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4C46A1F000D2;
	Mon, 23 Nov 2026 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394607;
	bh=7RaFfDowDDHtzxYlO4vBT53fBYjb+jNKJQ2d6Vz4AwQ=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Rk0KeU2iS6aPGVCD9aBVzPgHALNr6n8LTzIvfZBFeRamJ3/Q+3OJzXBlSzrbJSV2O
	 OP7RAN4GzUBs7m9ksjTm0Bz+3J0+IpwLr8cplO6Y7kyFp1Y2sTNdQempRoJQxqW2Sa
	 gaVDHWf/EYtkEPLJgVz79ANrcsptRtEAL41zNRufI9RKdTHiH+5YRkaPs3RtLhhjgU
	 HKt7lP3OtXOT8AJKIMIh/Pji2OiHPvD7vU9HxsAsF5Ty//9iLxT1eGf0VUGlccCL/4
	 Ws3pxM24TOCxwLYdqy4LR709S6HcOsxplxueimELr99DzQpKTvtqVTnlOHZUY00QBk
	 FRyJFj7d26BeA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A10E04C261;
	Mon, 23 Nov 2026 00:43:23 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Mon, 23 Nov 2026 00:43:23 +0000
Subject: [PATCH] RDMA/mthca: Free the AV table index if kmalloc fails in
 create_ah
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-mthca-v1-1-506d3c3a7d4e@gmail.com>
X-B4-Tracking: v=1; b=H4sIACqMA2sC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQyNj3dySjOREXTMDS0NToyTDZIvURCWg2oKi1LTMCrA50bEQfnFpUlZ
 qcglIs1JtLQB5iu6DaQAAAA==
X-Change-ID: 20261123-mthca-609152b1c8ea
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795394602; l=1724;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=EGEqNSPKVCYN2FXlRYLvj7sqk9iwm3B+WQLsdldjfns=;
 b=ASVARoyNrqVBrE8R6tcfCPwQRJvOWtp5Zi1GUUtLlCmd50LmskhKkZ0IXzfCmqdomYPJkTMkD
 PaDonl9iNTBB6I8otZvtfJyEC5GOPinti6Lu8Na4b0//bL4F+FrQYP6
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

When an address handle can be stored in HCA memory, mthca_create_ah()
first takes an index from the AV table and then allocates a temporary
AV buffer:

	index = mthca_alloc(&dev->av_table.alloc);
	...
	av = kmalloc_obj(*av, GFP_ATOMIC);
	if (!av)
		goto on_hca_fail;

If the allocation fails, the code falls back to the PCI pool and
ah->type stays MTHCA_AH_PCI_POOL. mthca_destroy_ah() then frees the
pool entry but never the AV table index, so the index is lost for
good. The allocation is GFP_ATOMIC, so it can fail under memory
pressure, and repeated failures can exhaust the free on-HCA AV indices
until no new on-HCA address handle can be created.

Return the index to the allocator before falling back.

Found with a static analysis tool and checked by hand.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
Compile tested on x86_64 (W=1). I don't have the hardware.
---
 drivers/infiniband/hw/mthca/mthca_av.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 83a7ba41fa04..a90b3e75cf00 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -176,8 +176,10 @@ int mthca_create_ah(struct mthca_dev *dev,
 			goto on_hca_fail;
 
 		av = kmalloc_obj(*av, GFP_ATOMIC);
-		if (!av)
+		if (!av) {
+			mthca_free(&dev->av_table.alloc, index);
 			goto on_hca_fail;
+		}
 
 		ah->type = MTHCA_AH_ON_HCA;
 		ah->avdma  = dev->av_table.ddr_av_base +





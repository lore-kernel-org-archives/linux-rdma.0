Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC26A4A4824;
	Mon, 28 Sep 2026 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594465; cv=none; b=e0TZ9Zn4y+fIz1Y4tGfJY6y5S8QTivJBZYtGaBLDR9e3qylYXtKTYG03vX4yHaH/9Y1vYhuhALYV61AfYbNlzuDDZvhmSs4KWbDtT0ZjJA/3mxeR4/7dINHGey5dVIO85Vdhi45aufuaxFbOl6O8sOAtE6PLncBDsWa7AFog0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594465; c=relaxed/simple;
	bh=5xjUEmJHIrwDr/jWN/dMBJqofDzgpEevyqEk+J5ypYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XEMHkuvj1OfKdSwGcXctE0kjIaW6pXOmxbOvY9Y2Qpqu4NGHN22wCSiI6TpUMFUgY8sXlXuNHuxiMJiLyffpnkmMHFUmqq0ZlFlfS0GCNSxcbu+bEEKFmqg2HPCbqYZ25hdmWMEC7jZ8DZp+dQIQHxvgRGzWzrbAl5oEMduli9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIsEuhBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIsEuhBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EE31F00893;
	Mon, 28 Sep 2026 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594463;
	bh=LpkC/LmM+yKvvfA+t3CNU0fBQxqnJxtpH59jGwykX2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIsEuhBG7XNvu6OT6rBf2xDIeAQrOIGWAK4Uffb37GTs+P4XLxWtHwZQPv6aqFCYu
	 8TNE44t9qyMXTAK47myr9Px6h0XHRXv16x6GiKyfs7bvL1UF50YTWxWz9ULiITdU0U
	 Nl3NCNExjfae0+Y8iNg0Ppeh+toNwtQhVHTlh/yQkzAckATObh+oKeydglNm45T6DK
	 WtB72knS22H1WUpjqDPT2cB8DqkwFfSqOMcTfyT44vUNwYPJkXZaU3bHIp9ekcMiJ8
	 f1z9TzrpP05q6zf/7YYBh/HiyVhLKmVjWsBvdJpfRhZvFz0JP8MQkO8hFA5AMH9C5X
	 WrJ1VUmc7MG4w==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v8 21/23] RDMA/mlx5: Declare to P2PDMA that ATS is selected per memory key
Date: Mon, 28 Sep 2026 14:19:25 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-21-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

An mlx5 function issues Translated Requests only through memory keys
created with ATS. Enabling ATS in its PCIe configuration therefore does
not make it translate every address it is handed.

Declare that where the function's P2PDMA state is set up, before P2PDMA
starts treating clients with ATS enabled as translating everything.
Without the declaration, mlx5 would lose bus addressing for peer-to-peer
DMA whenever the IOMMU enables its ATS.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 373ee1f42d4a..dcf659beaba0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4561,6 +4561,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	if (err && err != -EOPNOTSUPP)
 		goto err_dd;
 
+	pcim_p2pdma_set_ats_per_mapping(mdev->pdev);
+
 	mlx5_cmd_init_async_ctx(mdev, &dev->async_ctx);
 
 	return 0;

-- 
2.55.0


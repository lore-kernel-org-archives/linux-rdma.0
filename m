Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A081235EDBD
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655966; cv=none; b=Wbz0S/lHKYQ8mBdIEwR2nyaA1CiC2UOvKtFawHop7yqQncDfUKEvVEh1zBo0TB17QJeXQojSO9El3KfNRmaQiwRrWxko5slY41Ez9tZUi8a30wOAytiJYlHaFBb9cEVxeEKOdrU+rt3XD1BNBaBB7nWy/XXsUsQkScUL4rVJdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655966; c=relaxed/simple;
	bh=QTEEwhMU6/s8xKt2ATytvlDpVE5PLdhRSGF9tXAdxU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9Ys2ie7H9rXDMhud+HSrVAPr88kSH/OczVnVVnvbEb2Aq34ptSbSpsjqHKmwzkcFO2kDiVdvNl4PPeHm1pAfsn0PDNIRB5PTxZqyz8Yisr2Pt3sOOlgFYye0VRJuYkeJKT8ErveLB58CdUhz/fnhb1hl3N/zlbE0R5iN3pHoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=MLkjMsOh; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="MLkjMsOh"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49550ec592cso16970695e9.0
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655962; x=1785260762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lWWll8LWGk4bgXbjsNFMGQ+aIu0e9z5vmcW+zxQ0akc=;
        b=MLkjMsOhQH7N0szfn2gTOcCyGLg12//O35Ej/epe1NTKRgdPQCXcPBUJY69Ey+iVqJ
         LITQzakR5POxUVVOM/EIJ8JzoK6upAcVKclrjC70JpJDI5wl5x71RlaENfLxNWfnqcJ2
         6S0toSdX6VJzk65MI2zrUIoVZZAmQBo1LayPJrQPmpqVRVOwDnahQgv9sr3UURzY4Ob+
         Oy6c3kUd7s4C5Kqxr6MnH3Ji2nc7a0fCodmkEYPx/KLVElqkPkpoif1WEfKeYvx+bc0X
         Sb53mCPYK/JLLvo/cdYm2HgyxGrHgf7vkVO1nx6DMuKi0c6DBLvprqbqhk2n7tefAeg0
         7y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655962; x=1785260762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lWWll8LWGk4bgXbjsNFMGQ+aIu0e9z5vmcW+zxQ0akc=;
        b=qiFbIGzJ5azzdFqnzedGRlCFlGjYbogZm2oJYZeisMEBZFXWBVV6TeHTIEAeC7+pUs
         EF+YTQCGjPGoxDLTr/x6lLw522HTby736TXHt1kaGJiI8DTZnXaXxe3X+EKgsIO+9zZW
         8UHbich+wa56pBqe8kmn98Ixm6Y84ecBUPeZ7qnjx/UqtoBlwIMHr9sRHNEvykoJP652
         vwRR8r+1supOuOEfDvF3DWxz8b5tiwpfY1fsnf2NUEBYOtfhi4IAZ7S6RUBuL2V0VJWV
         ryv3nSsYsUOAuD8Jwvp3ViDd+6ktCGakHtz5W+pOZKQiMYV5hHiP/qzz/EAfVsZB4lSi
         jMSA==
X-Forwarded-Encrypted: i=1; AHgh+Rqb2r5oDcxNYk70Sm9TvQsieA6X/CMjDD5qxINWY/0GUL3AJhWS0yOhSjz8ZNOZ3VSr3A6utB4FTc2Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyyJYBtJ72ywmeidJh4c5cdcOipnR0tu0fAFp16iTtxBdg7dwn1
	3TxB2WBidvRP1TAezFBaNBqYXtrCL20QtlWyx+Y9lqFMmswbR/gE/ja1i42H/TovrQ==
X-Gm-Gg: AfdE7cm1zVPtKsrvk5U0a1b64z8gx89qtSn55vC+rHqD1S00cCZ0OjhnHfasQcVFeoZ
	VjKksfx5OJ0QhKtRADYboxoFXCMT+ujsYDx3QSenakPH4eZACUqrxfU/ZX/iGk2e4MB+aTWrjrp
	E6tYoKMWd3Kos9kxmvRXq8GvmrF+qafBJfjBpyyCUq+msfq+RCWQ6St/V2Q/nKiNuzQm7cbSMah
	IyXgCNSuUR27TSHbl+aesiRplcV4A7APWCrukmi9YZqcGBZVB4yU0IN2kpy6M4eIKLlrGiiLdyZ
	GoTHpfPYuKSiG2DJOdKIGRJNsxsExVi182KlVsw+FMe46DlFNnMSqqga25qgWA+Oi8cXkIdFQ9+
	7KyxLAY/+hFZKbsAohOacYibcFFzR4IrpWeqmBTErcYimBEU2s5m0/tiVayL/QGv1TLqTXmQGcC
	f7ptYJb1lB2MlCs/eFZYRj+2Y6Xxkfj4c+sEOFLcls6w+VFoearT0xsFrkvA==
X-Received: by 2002:a05:600c:4747:b0:495:5d6d:9cc1 with SMTP id 5b1f17b1804b1-4956a4a14ecmr8642615e9.0.1784655961748;
        Tue, 21 Jul 2026 10:46:01 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:01 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 1/8] blk-mq-dma: restore BLK_STS_TARGET for unsupported P2P transfers
Date: Tue, 21 Jul 2026 19:44:55 +0200
Message-ID: <20260721174502.111503-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260721174502.111503-1-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unsupported P2P transfers used to fail with BLK_STS_TARGET, chosen
by commit 91fb2b6052f7 ("nvme-pci: convert to using
dma_map_sgtable()") for dma_map_sgtable()'s -EREMOTEIO: an I/O that
can never succeed on this device must not be retried.  The
blk_rq_dma_map conversion changed it to BLK_STS_INVAL, which
blk_path_error() treats as retryable and md deliberately ignores
for member failures -- a P2P write to a member the peer cannot
reach is counted as written and the mirrors silently diverge.

Restore BLK_STS_TARGET.  Hit e.g. with CMB memory of one NVMe
device used as the data buffer for I/O to a second one behind a
different host bridge.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org # v6.17
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-mq-dma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..c17e4c49900c 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -190,7 +190,11 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	case PCI_P2PDMA_MAP_NONE:
 		break;
 	default:
-		iter->status = BLK_STS_INVAL;
+		/*
+		 * Match dma_map_sgtable()'s -EREMOTEIO: this transfer
+		 * can never succeed, so don't let it be retried.
+		 */
+		iter->status = BLK_STS_TARGET;
 		return false;
 	}
 
-- 
2.52.0


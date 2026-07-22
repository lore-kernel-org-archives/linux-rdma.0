Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D5388E4D
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746761; cv=none; b=GNqi3pJ5tnjJ2xrXyoWqwHdSUZw6tGCgEgiWx4TmidXSX4vZfjdMqUYzEJ5l7HeJvylsC5Q/LBQdE6W/LHYrgMWE/BhUNFryUiwZeDebeQjXG4jQbmEnydW0uWWiLeTc5QWR1lsTj44IHO3Ey08Ux0zld7Gj+4I0SnZsJMdUps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746761; c=relaxed/simple;
	bh=6JUXonkvhqCluPq91YNslI6Xc6PHhaJJ82TMx9QRo24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhGWnuEN3CbBWsHScsflFpTWn6jddfU9FXhNx+Hz5AWktYz+jj7DQFKrQ6m+GAEbgb6qABnHBgygXHZNoMcftcX105Sm8psY2VaZVbuynT6gT6w+x4eUtWT8V+yLRblH82joN1VX3NExRQgR5ZuwBdjhOyWYmJUlecci+pJeaxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Ai0g5NKB; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Ai0g5NKB"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49557167508so44945945e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746751; x=1785351551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=Ai0g5NKBb/WoSwM4WCinC9gL5DuAa88xLuEC4hRIs96ghwRQmvDlMLh5VL8zWotpFo
         JLjmRiIu37BjI3rhd4Ubw4snBPwDFxkD6abowchkrUjNFOey/CJUVv59O8K2o34bXApT
         4wCOv64ZNQn2gEcUXAlJfmTzBq/ChFOvz0KDkCMfXy+BPORDQH/yJVd8q4o1hH5eyKUb
         S/BWDDtTklXRRcmxmHW3gZoCTvjMSA7HKGVHZyrsR6bfdDbQLne1R7K151Fu6TuNRAWt
         gNTwsano4qKf9TqettAQaDaizTf9HGlyParu20USjlWCEDbIz720Sk/FeTdSzuha7whc
         pl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746751; x=1785351551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=InzNp2nHOOp7QQLn15Ay7fcFkfBNFGx8C4/KxQQFD2c=;
        b=FBtuCqV0dbaICLp9FzOw0MYw5WwCm349aezQcbh6WYD6TSVjEFBjGID+OMkVDR5e1p
         Q4BXd9jEuyQJahXXg/MnqaCa8AYkh9Q6ApdqoYn3Z4c67+ETK2kwv4xJFBBQJKYqdyiM
         hjvgB44PhToHYZ423L1CjaJ00DaGRsmMqgKgCUU8zRPE9x1FX19EUwzIFLWlzOv5OIbK
         K3q4NOUoYkyMOW9xE9iE4gM4mRsgNBOQt6sU9c13HS4itwaM1TXWz83JVXLVvEDOH08c
         cvpN8H+Y0Imcg2KEhKonLxcxzEsib5pJhNVADCWLOrmih7QPGqkLO6YBsc8h+rptzmt3
         4hEg==
X-Forwarded-Encrypted: i=1; AHgh+Rq5n+I9hpay9lanuKjwP9l+ozn69f+AHFT493KuvZM1vYAh2prBj05xNKvc8NCfx6hT/LbQwQhVPVLi@vger.kernel.org
X-Gm-Message-State: AOJu0YyVlw1ZeLctu3kTZmc3CHcUt0XWCAqLtfU/w+xef9dnaAz5k6eT
	LOFjzprTWQA9Q+mMe0fZdEVPaFqGCE/vV+bdS1ecrBMzP1Pe/4DFldk+a5xZ51k7pg==
X-Gm-Gg: AR+sD10NNw+HKU5Baykt03ELm5w8TxauASxKoep212AKrlQxZTsuuN9Jp15QnwqzKTC
	y+zgSAstGQp78Hnhlr9dyoZv02xz+83JHfoKbBaAnjKSHBfvaKcbIDg3FEnaqJuFmsVCALH4p42
	M+hCtRIrIt9MBeCFnJibCg2XlfUQf7fXFrYmP94JjxXDWZBHhpBmUjDBirjILmJQrdyRpiwC3vM
	xgRJsfKZNLPMhwShNRFcGPIBHXWCtmDEVUCO+QJsBkUIc4+qotCMcgACHdOK9mfDvh87bIBoPN6
	iLUdXQhs7oK/1hnwSY7+rA3Ar/NhHnhjOmAMhOSA1GNDUCCPUOVbRg8SpcxSpLnqfAKtUhcFkEs
	o/nkUB3ORYrAk/FCiJZ2JVyYC+LMlR8qnpwsQkNrW1VMxHNeYtIfSGrdT9vG9B5DXk/MhvpAReL
	Lh+wcbJLShicVCfCBe7+eLy/w0tsKbF/susjAKvxq0rVzmNmc=
X-Received: by 2002:a05:600c:1551:b0:495:5858:e163 with SMTP id 5b1f17b1804b1-4955858e1damr203016475e9.27.1784746751519;
        Wed, 22 Jul 2026 11:59:11 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:11 -0700 (PDT)
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
Subject: [PATCH v4 6/9] md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
Date: Wed, 22 Jul 2026 20:58:38 +0200
Message-ID: <20260722185841.449934-7-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722185841.449934-1-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

narrow_write_error() re-issues a failed write in badblock-granularity
chunks, cloning from the master bio and resetting bi_opf to a bare
REQ_OP_WRITE. For a P2PDMA bio that reset drops REQ_NOMERGE, which is
the only request-level protection against the member queue merging
P2PDMA segments across pgmaps or with host memory (see the preceding
md_submit_bio() fix): the retry path would quietly reopen the hole
the submission path closes. Restore the flag on P2PDMA retry clones.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c  | 3 +++
 drivers/md/raid10.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f07edeac6e5a..19c4dec450de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b63175fb382..428bddddfe71 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio->bi_iter.bi_sector = wsector +
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
+		/* Keep P2PDMA retry bios unmergeable, like the original */
+		if (md_bio_is_p2pdma(wbio))
+			wbio->bi_opf |= REQ_NOMERGE;
 
 		if (submit_bio_wait(wbio) &&
 		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-- 
2.52.0


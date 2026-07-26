Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1A3AEB35
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065582; cv=none; b=mLYwOfFRnrnoVKjhLWzO83ib7NYBOeWU0/7ScAfkksA4enyqQf2GyvIqOQmTEfcsyG3mozvrTlWCKtHLhJD1hLafA8OK6c+8L9TZxtYksO0Z1foxqsHW9AG2d3PJR4MxCTm7UGpDpf/gqJuU9pAGnjshQcscQ2cn5+aKZhVXTHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065582; c=relaxed/simple;
	bh=zFBDec2TRFEalsjq0AVcfDV7Wl85mnPHWjbfYz706rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0XaqTezILfTMmpMZEJPql2S2uMFhqP3dPyUEAxoEzkapa5IJBF98OnfFAtyR3e9URTj2hGw6xBAH63DToFaFj8lNHgsHGMRVlJ4I/fUFIPheqBoQ5Z+j8EY44mWzHONsjBobDiyWGq17BSJ/RBH3TjafXBUxPj2A/Z/RE4Kn2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=iATe8DHP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="iATe8DHP"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so19407535e9.0
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 04:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065579; x=1785670379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q14+SU3ApPQKeuQJQq5srmD2x1GZ50vyxARH6EmniXo=;
        b=iATe8DHPHsEM5s3ocUncNSL6Nw/3pJ3sBRQoDcQDMvhQEndIEXKmHcC5HiRfyBr+S5
         wVye1TLuoMAJWPoKi7jxbcztOt1HybUlDvmQZntEURXL8hZVjYUFm/vD7njk0BfJM84h
         YHyMmA9iwBebLQIxQlDIsBmiqe//2z7dPzMW2eDlNfB44yEtjc/qUPxkN3x8R/suBpe+
         u9639UuTLzAdwem5dd7RW4F45JA2dok5+zZx/r75SuiRg6yebB4fU/maVC/3MuTlYgd1
         gm4Ao2w39D80itQyIB/ETTn4lmbChoFTsXdRzoBDxwK+IByQUijEzhrTvA5kxUAiJ+D2
         YNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065579; x=1785670379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q14+SU3ApPQKeuQJQq5srmD2x1GZ50vyxARH6EmniXo=;
        b=RmMmJeVmqstzWMGJpme6BbgqGUiyATtzjVchIbibGEuSdauiBHkR9ExPg6ig7JRNpv
         6H83Q2x46dX3HBNc6brRFbAF0ukNjDN2yjnFiMk3qjGLgfaxpp+Wgaz+YiNMud7xQE2G
         RJ9aRqN5iue2GEDuIFaBG9wfgfTEuth14qWkq1oxf/+18ZRUdIojMB9H8BqXYxW9zwLF
         smYwTLyXXtZ3OgRN443SnO7drGRi2OFjRQkbvhnvXKo07381tlRrGGJxVmQAN5TrcR4g
         d0rg9nGlOSVfTlHn4BKUMnlCxbJVl/7jfcNJL6qWZqWsOWsyCIArOmIg+YpVZBjHlu0A
         K8yA==
X-Forwarded-Encrypted: i=1; AHgh+Rp6xrYuSBaGLsmUjftFWEbvqAA4+P8lhTTZx9TRyOKLNH0ohTuTMQLou1Ti4GzBJTvxVAr8FSal3m9D@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4zrFtF/OfBFosdAb+v02nmZL4i4uBkrqPzWSE6GLurkOYSo4M
	ZldjTWk7ck0uXS2WHOStTEXFDIBIZAeIfurSk4toXa9s08ohhPHjzzeAhmvvPtPEfA==
X-Gm-Gg: AR+sD10agN5xmyQZw1b6oAl1gWfWC4MWy84boXfSwFnaqb/vn1R44ZNX1daSRD3/Ftc
	23p9INo1Df7Ev4o2jkuEeC+/GxveUg5mfFu7dNPqjpSmTad0UGfvHvATAC+c6rMi+MgtC35URc/
	Qn4hSjEqtn5alp1hdHcfM6Gle5kupNYu55CDMzeg8nm0I1e5yOe9PHoaKzm+y2NhUowPGOnRlKr
	kpXRBO9HDKki2kvIAZOjGXUhOd05gPMteHGaq6N+qUdbFfnn3zh3WT4H81ea+W7v4ADCnqktS4R
	aSvavkX5iqrTMG8eNXat9mZstCYlHz4/SVHe5tgwDTLoIgcB4Bpu/or2+KmNJH0U1OHuJFe3m/i
	to3R+6UX8wtdVZ83kYl0V9I0r7LD88f1zw8n1fs4lP8/kyizAt2F3Ki6pAHIawdrfSXxgab54Fz
	Rpms5kYNeSu0vIlGRG4lXFx8gq4s/TDcCaRz+26jdjQwoyf4YOeMJHLjpqoj32y/flAgMwfLek0
	l2ILxQuxD0LZlMf93gzT1V9aDB9EgfsgGj8y3So3A==
X-Received: by 2002:a05:600c:c87:b0:495:69eb:27fe with SMTP id 5b1f17b1804b1-496b56c58bfmr55527435e9.11.1785065579344;
        Sun, 26 Jul 2026 04:32:59 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:58 -0700 (PDT)
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
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 11/12] nvme-rdma: ratelimit the map-failure error message
Date: Sun, 26 Jul 2026 13:32:28 +0200
Message-ID: <20260726113229.2154269-12-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A mapping failure is per-request and, for an unroutable P2P transfer,
deterministic: a workload that keeps issuing one turns this into a
log line per I/O.  Ratelimit it, as nvme's per-I/O error logging
(nvme_log_error()) already is.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index c38d949502b7..2f50509a7a61 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2040,8 +2040,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	err = nvme_rdma_map_data(queue, rq, c);
 	if (unlikely(err < 0)) {
-		dev_err(queue->ctrl->ctrl.device,
-			     "Failed to map data (%d)\n", err);
+		dev_err_ratelimited(queue->ctrl->ctrl.device,
+				    "Failed to map data (%d)\n", err);
 		goto err;
 	}
 
-- 
2.52.0


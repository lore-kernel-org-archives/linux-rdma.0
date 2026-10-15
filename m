Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584CD48CD64
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053403; cv=none; b=uzeUS0myGFdyE5ZofePhW7qf4xyJOQU5oXkcBoG6Mm+CIdNDKsz0r71+o+cH3BaLaS/daUNytsK5LaWDt7+WPZAEy3OVRxqr4K/DwPjeBtgi+LJASw56Krs0AWcTVDP/2dFRC0WlKBGmVUTT0/CbzNKYxhAxDS7SuLpADQXZd6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053403; c=relaxed/simple;
	bh=pzrGaXr2vc7AK2dHic6Dxs3t4dtTkJgIvsCv45uqoO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9mdngB2Vk5Zq2CVNN7rtKPyDu+z+DyIfh+vZniYMRcjlA5MR+g5VYtQuo0FzhgmzqKtt5hRd1B1cCCUMPbtHwFjWyKEpK1dPDFsDYpYKq8xLIXoFaIS9Z40BjbvC5Zw5uch+T8m2wP1u0pTq3DxfsCfdHdeA8SNaeYl6I5d9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lOJY+fIX; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lOJY+fIX"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93cb9e9405fso69876485a.2
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792053400; x=1792658200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aHz/bzikXk8pek8hRSIu9eCONXczI/isD7IKkwfqttA=;
        b=lOJY+fIX7fKTPd5JoHrz///6LH8QPt7T+9J2luCNr8/+KfEmBcpIVYWIyq05ANTSio
         GhthWLK93vM2BFCfb2XEeMTiFc3xYnWbuSfQ6AqNOYPXB0PbY72jM2bL1nrMOiSWDnv8
         +HhVDF9uabAePRl15s8iO1zlH0UFZpT25DoS3qeOjWQBIJoiUESbK4pKXXxMBzBBeZc0
         Fz9b3QPYmXz6ewoHTiX7zzcAeAa90o5RW60lDa5FxpP0U8L+E/01ZdHRR5MIfsqvCWvP
         25fk3q6Fgb5E1Xy+CT4QOcFuY55qQSI+NMsONEfk4mAMaoU5ha0JL5/2oQHLMkxggo8h
         Hlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792053400; x=1792658200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aHz/bzikXk8pek8hRSIu9eCONXczI/isD7IKkwfqttA=;
        b=GdRR0FYaetRRV61n5IuNfWR7rvC6gdIjPninupubfVkst/K/QilaAWgwyWrc/xab4o
         m2C1AqCtNexBKkDdqH7eyaEQ3v0C24JUdTVgmbCLrYNQM01LrapTqYdIuItonBHFhO59
         gYa9zI5cqg6X7lujZgUfpxXZpUi4ltlIhx+Qn+/FfUbDnZEedLuGkK9zDqq7LE7A/tR7
         y3q095lLbWh7doaiknWJL0g2vjDPJ2fkH1YfPuHB5U8duKubzL4TedXLPyaeKzy1d0w4
         wrFqTqPa7sFHYGAuympie3HSnaUZkgSh2IjaF0UvITRM22P/jBxBBDZQ3BlZl8Fj8Asm
         TpRg==
X-Gm-Message-State: AFq9FYKoqjzDsezCfN5k96c2Jnk3fBJKcElEfmXjq/jZxNBc0Jsme14Q
	3XqdjdoDGhVWWBID1k+jM42MqZ/Lcb2Zh86Vgh4PI4gB8kcqYN0f/hzN
X-Gm-Gg: AYBFou1nJJpenKHDGZm/bgTVjBgygroB/yl5kB4EgSap/QtCxmkCwszH/Sw0Zx3jyo9
	LyFXjjT2L2H0H4dKa2vogstuTN50EAH+rfctfcWfAwghluFG+k8yldMJbuvgCI1SWnuiyeCpIJU
	WY0t1zBqafC/Jx6XcrBOSZ9+TScvdhyRKid4vcyShba10jFCPHyE+YGAf1shFyp+y4HAqLcz8uP
	UioI6sc8RsmUp9wQuXE0zbTPvESbBsiWZygcYxsROpOzplsCHrxm18a6re3bt6lmhla4Drn8xLB
	bY6qU8BidM3pWi+5SfxaWh0CMVVFh1EDTkinkG3eLgN2NBGcAm9sldDvUXc+BvLlrnVhhw/+39r
	PW7Y4Ma+WKLnDP8wK35Cc1G23MiENfMQNL5Rp2JJSjjf1VOT4QBuQgTHGDyg0b2pZJI+zLzg2Mk
	rQctKEcA6kRuLIrRT+EO9p+gVYO6WUCs181k6WbH+4Q9X47z76ggcGFkTEsv1/nLoK0qFmcI3bu
	V7jWB1qQkyYgcOG64pA+hOvqqnaFTjaJIhj145SiSVwJpzjcvmGQdIWcyCoAzKUX+WutcevsLYn
	ipnkYgi826/U7I+4NOUh2wg=
X-Received: by 2002:a05:620a:6081:b0:93a:1fa7:1afb with SMTP id af79cd13be357-93ebd24d180mr2908976185a.42.1792053400267;
        Thu, 15 Oct 2026 01:36:40 -0700 (PDT)
Received: from ip-172-31-15-253.ec2.internal (ec2-44-200-54-59.compute-1.amazonaws.com. [44.200.54.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5090050sm711843985a.40.2026.10.15.01.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:36:39 -0700 (PDT)
From: Deep Shah <deepshah146@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Deep Shah <deepshah146@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rdma-rc 1/2] RDMA/uverbs: Fix uobject leak in DMABUF release
Date: Thu, 15 Oct 2026 08:36:36 +0000
Message-ID: <20261015083637.200958-2-deepshah146@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015083637.200958-1-deepshah146@gmail.com>
References: <20261015083637.200958-1-deepshah146@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uverbs_dmabuf_release() treats a NULL uobj->context as an aborted
allocation, but normal ufile cleanup also clears it. Closing the uverbs
FD before the dma-buf FD therefore skips uverbs_uobject_release() and
leaks the uobject and ufile references.

Clear dmabuf->priv before dma_buf_put() on allocation failure and use
that NULL pointer to identify an abort. Otherwise, always call
uverbs_uobject_release(). This also avoids reading a freed uobject if
release is deferred until after the allocation has been aborted.

Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Deep Shah <deepshah146@gmail.com>
---
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 2411ebee69e2..d88d30f1e42f 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -68,9 +68,10 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
 
 	/*
-	 * This can only happen if the fput came from alloc_abort_fd_uobject()
+	 * This can only happen if the fput came from the error unwind of
+	 * UVERBS_METHOD_DMABUF_ALLOC. The abort cleans up the uobject.
 	 */
-	if (!priv->uobj.context)
+	if (!priv)
 		return;
 
 	uverbs_uobject_release(&priv->uobj);
@@ -141,6 +142,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
 	return 0;
 
 err_revoked:
+	/* Tell uverbs_dmabuf_release() that the uobject is being aborted */
+	uverbs_dmabuf->dmabuf->priv = NULL;
 	dma_buf_put(uverbs_dmabuf->dmabuf);
 err:
 	rdma_user_mmap_entry_put(mmap_entry);

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68046344025;
	Thu,  4 Jun 2026 10:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780568577; cv=none; b=M4YTNlBFMQpRFoTn/MQUMh29UdlYRztCGfHewX7nvGHj9pkhVcIDj2V7Qv6udsbWdYnSB7uPLvoe9Z+3z2JPLCTOg8tpjRuN8CbJ2tFC0y94XseEXV8sDaua1APkGstNrnjGuQEOtoEe9s8nI79QPrRZJIexUFMv2j5P6COJZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780568577; c=relaxed/simple;
	bh=8RmZYb1pXYEn2wiOpi8FDcyZxFk1G6ZD+2CdQjQrsEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rORq2D5a6BtsUYX5kcGJMdXP81IAHcJHfadWnnv8dLpu06gR79MYtJ07HtdSQBIY4XArwAc71H4Sljk0VTPxf9GJeOHIm1J0BS01p+0w7HHh8xN4dbYg3Zne6KV7cjT0mow/8reJ5S1eFWXA5mMljNQBOcgCSdyI4reUt8idwN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIsGHYA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIsGHYA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03D61F00893;
	Thu,  4 Jun 2026 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780568569;
	bh=mLduu1BN8oVDlsMVXW9d1+2kTVCOlPEKY23vvFbWsFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QIsGHYA0WcZE3oERGImpnuJVLx6AJq73KcO/q7CliE8Dn98sagksNM4BE5LaEAEjO
	 EZwBYc3p4tra7JCHhXHwNr0vf6sthuDgV9MwbMhggawYqGrnkUuhF9DN9OvjwRDIUQ
	 47d7dqDxFHPmX/GNRqJ5deQsn/+A8LVnQs6XqX23RWV8Zp141Hs5O4W3nN7dSiGwIl
	 iMHqEVmOBQrzZOfIKq6Smay+Ku+gZWs8cwnf1aiHB6dVjahlXbOqUtBQbGZFEkZW2I
	 AZibZ+pj/iNXwNAyVIkRm5NOkVIN/6gkyDTWwD/bdWjqO+JqhUeR75C27eFmlw+0D6
	 nzgoHmFtU4+dg==
Date: Thu, 4 Jun 2026 11:22:43 +0100
From: Keith Busch <kbusch@kernel.org>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org,
	linux-rdma@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] nvmet-rdma: reject inline data with a nonzero offset
Message-ID: <aiFR81yE9_BIsNbM@kbusch-mbp>
References: <LM21QIR-1-qJb7PViyJKCnGBnUzizeiNJVWQ3wb7ZwGezodjgKg3f-iobqOyequ-sT1jFCKJImfqNO_BKU3KO80xFITnaI5GTV_GxLUNDDc=@proton.me>
 <ahm6Ksr3rfGdnOsN@kbusch-mbp>
 <20260604084624.120032-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604084624.120032-1-hexlabsecurity@proton.me>

On Thu, Jun 04, 2026 at 08:46:33AM +0000, Bryam Vargas wrote:
> It does stop the u64 overflow, but while testing it I found it is still
> incomplete when a port is configured with inline_data_size > PAGE_SIZE
> (it is settable up to max(SZ_16K, PAGE_SIZE)): an offset in
> (PAGE_SIZE, inline_data_size] passes that bound and then "PAGE_SIZE - off"
> in nvmet_rdma_use_inline_sg() underflows, leaving scatterlist::length at
> ~4 GiB pointing past the first inline page.

Then the use_inline_sg() should find the appropriate index and offset
accordingly.

---
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 1234567..abcdefg 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -821,22 +821,29 @@ static void nvmet_rdma_use_inline_sg(struct nvmet_rdma_rsp *rsp, u32 len,
 		u64 off)
 {
-	int sg_count = num_pages(len);
+	u64 page_off = off % PAGE_SIZE;
+	u64 page_idx = off / PAGE_SIZE;
+	int sg_count = num_pages(page_off + len);
 	struct scatterlist *sg;
 	int i;
 
-	sg = rsp->cmd->inline_sg;
+	sg = &rsp->cmd->inline_sg[page_idx];
 	for (i = 0; i < sg_count; i++, sg++) {
 		if (i < sg_count - 1)
 			sg_unmark_end(sg);
 		else
 			sg_mark_end(sg);
-		sg->offset = off;
-		sg->length = min_t(int, len, PAGE_SIZE - off);
+		sg->offset = page_off;
+		sg->length = min_t(u64, len, PAGE_SIZE - page_off);
 		len -= sg->length;
-		if (!i)
-			off = 0;
+		page_off = 0;
 	}
 
-	rsp->req.sg = rsp->cmd->inline_sg;
+	rsp->req.sg = &rsp->cmd->inline_sg[page_idx];
 	rsp->req.sg_cnt = sg_count;
 }
 
@@ -857,7 +864,8 @@ static u16 nvmet_rdma_map_sgl_inline(struct nvmet_rdma_rsp *rsp)
 			return NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 	}
 
-	if (off + len > rsp->queue->dev->inline_data_size) {
+	if (off > rsp->queue->dev->inline_data_size ||
+	    len > rsp->queue->dev->inline_data_size - off) {
 		pr_err("invalid inline data offset!\n");
 		return NVME_SC_SGL_INVALID_OFFSET | NVME_STATUS_DNR;
 	}
--

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374692;
	b=DGGaCevnPXYHD1A1uVKNhPnX0B7ZNvxXVf9bg7uvh8zcJ4K0HUm3eivF/4UtVbc8Tm4C
	 QrsjlsUXLy5Rx2IZ/tdkVjebEwpB7l91c0Qlz5n8MhNCVpZ1q1FAwe2H2ZkpcFGuuhk0q
	 vZYNBM6rFRZFVg8ArCY53krfMChNfqtFbkI16nGepmEsguXAs1JbbmZaB/w/LMbJIp2Of
	 QJtaUFsc3QJzUhfr5nPIfe7iTZ/ryIwjhi78uVEAhWzpf/A7rQQeOVXBMV9SaT4su1WQY
	 v0RUYOk2IcS9oZCUPfY7OaKXk6OXeOhJXFi83wrsg9FXT/VE0W9lfFcWsds+8KlXXow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374692;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BLMOrirVdVfgpFu7VbhfP1f6o8xzMhqagEEBKwlrCTE=;
	b=gB+O5wuw0rwSEu7zWWs/55DcP3+EX0OnpIUYx+r1o9suPbmzXuHL0MgDXXBM4af6LtTJ
	 ZdBmAqP5ApFBXlmgiW3Izhyh8sa4KDuWMreJsuoqGJupHb+mKIKaaxckdoiiedv24mvo0
	 ijWvoTWSq2xthx2rhm6t7i7oXh0JvgvBxfJghz2nR3sM/a8tzfbDy1IvsqcJ5GK6bEd8P
	 4IANgAWd+NGmXShELeccwt6UWFyS9XKfGICGFEA+BigLI44OalVVhMhjxwk6cZ9zC1HbB
	 qvsH5zv5v2PZWGkK5yWh5YSluvl9176NO2a7rJ1VngBSuvu9loU0s3G2mHcrUU5Tzgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ec/zu+/2";
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42A606A33E
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E42A606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ec/zu+/2
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-921276742e3so25716396d6.2
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 11:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795374690; x=1795979490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLMOrirVdVfgpFu7VbhfP1f6o8xzMhqagEEBKwlrCTE=;
        b=Ec/zu+/28aNR+Jmkmpfi972q3/iefgyRWgW9fea3gSMpxOh3slLP+/s+70+4fq3Ley
         aNGtw0FPJYguYbLCIR7S6iJG2EYyqdxlKSgaUpV3LaENN7Y7GXF+uS6jrl/CW0sloW9P
         f+/nf+GPZLak6au/beTmRykoa3MEnDyg8mNuht4PM3lfKFgHLXVNCPLNyphjUs6CmoPd
         VOmtk9hEXiUFgeT4ROM/n8mGbWdyx9DQ9wOsneLWNEpy6uQdK0Li7Zit6fttBNEx0dOT
         rbGGG2ql/AqiV/+HZBj0jWJFdqAjGpxAVkIw+hVdzamMoscUASLagqgs9qJqIiV/nvWv
         d2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374690; x=1795979490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BLMOrirVdVfgpFu7VbhfP1f6o8xzMhqagEEBKwlrCTE=;
        b=Zi5Nuo+2z0jy9EXu2I9A7oirgXycYAgFM/8O1OtqFy9f8bk8AOGhvQKvG3hXpA1eH4
         qItRTfOIv5msdzxKUOcaJ5AmbcF55mI3TyUHX+g+54QIijsFeenm41Int4gHc4ZvJ6zG
         7Se706FaqVhHSp4njpIHeSNLF50KzQvrWVh8AA48/ZBpE9Bvf3niyAjhN1tt5kQ7OYT5
         jwgHZXAy/+/jlbmIP6cok4eyvGZVW+u/gsIHk/O6uZOyLjpiKDRNnzd8Llk+d/o8IeKc
         NF8htQ13IOMX4IS3XZCWPFaHXYkn+QBwrSA8Vjom8YGrMaa4GqE/aMORm6aqb8tG6gDc
         AekQ==
X-Forwarded-Encrypted: i=1; AL+hErFLqclWViaJXMw/JFKBcV3HbXZjk3uJfterOc0vJUEuVmS/iJkLn6bW2fw7zJ7M3Wol0sxI0sLIfP8L@vger.kernel.org
X-Gm-Message-State: APuU4Z9yNkPBPlIiemGUKknJfSKweA85LdoSoT6fSBfAPYSceLXMd+/o
	+SYDrm7tQ67DVnUXVZdEHoMqR8GqQWInpKVr9YNmBXMn1rjUxv8FXtSXTaFGgs4G
X-Gm-Gg: AZFdTZc3FcmrMJiSQxvHNrB9gCgL2sPwS8jqf4aUKteT4s1ze3gxLW1dhhRF0tWRnVC
	yDBuEpbJu9VqT1z4tohTIXL7R3RHZXVkgZH0C+Ct5mGx2mpPqTkDQY+n1UcTvi9kn6skNGi0GmP
	caFs0hYwL0dGjwfzSbk43uoPjEYqoceCbKHe6tZQcyJLcZK1/bW2Kq9sZtsZhvrWx+fjUkY33ha
	2a0UMSUIZ7qBqBn9LqXANfjARrQmTBVOheCPpPhYj2j5p1Eh2GWfZ1d9STPX2amkoftxKnNmlL7
	d3U2tvZkzQUKQrIJEK6kg6sA6vScRasx9qA7uTr2mPV4z26uJGXFjJ6C2o2Gixxmmy3z3OaJOKG
	8hEetVbQYXENaIKA1Q2jkDZYWSg4DlPHOvcssWIBhXpKKLDWGtcKgENOVI4Df27T/T+RRlrC8Jz
	t3duLJU6XVhRqPwoJ7CaiECpTjCTdqL79wtkOhZmI38JH8MWCc3ZKsApnpMW+XBAoDdRn8z8kPz
	AMA4w9lYZOg6AlnBJxRTggL9dlv/vDe4PyhpEv/B+yi27an4Q/v5haBugvdYP6iRUnGMJQEzLHc
	2V7dzUNOd85ZfppgCZyx6hhtx0IM6O3ud745SbCIq8JqtYMIIr74VJs5NyMFi1DwsBPomMon/nb
	T8tfXQySG//tpUhb7DBZ3dYsFQGMGKkuSyjvrl5tZBDMjPfYjxIjqGFJGLjGP+ITdqrVY3kolyx
	I4v7/kUPLW54RgVqQ8ko/VKExdU8d3asXJXPdnzx/51D+Xhis=
X-Received: by 2002:a05:6214:dc7:b0:921:38d7:3aee with SMTP id 6a1803df08f44-92138d73c1cmr153157236d6.28.1795374690225;
        Sun, 22 Nov 2026 11:11:30 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c8ee:a73:9097:862f])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm85852186d6.21.2026.11.22.11.11.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 11:11:29 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Honor the sg_offset in siw_map_mr_sg()
Date: Sun, 22 Nov 2026 14:11:28 -0500
Message-ID: <20261122191128.65369-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

siw_map_mr_sg() builds the first PBL entry from sg_dma_address() and
sg_dma_len() of the first scatterlist entry and ignores *sg_off.
ib_sg_to_pages() includes *sg_off in mr->iova, which siw stores as
mem->va, so siw_pbl_get_buffer() resolves an address in the MR to a
location *sg_off bytes before it. rdma_rw_ctx_init() passes its
sg_offset to ib_map_mr_sg(), and isert can pass a nonzero offset.

A test module registered a one page buffer on siw with ib_map_mr_sg()
and sg_offset 0x200, which gave mr->iova at page offset 0x200 and
mr->length 3584. A user space client then wrote 16 bytes with an RDMA
WRITE at mr->iova. The bytes landed at page offset 0x000 of the buffer
instead of 0x200. With sg_offset 0 they landed at page offset 0x000,
as expected.

Start the first PBL entry *sg_off bytes into the first scatterlist
entry, and reject an offset past the end of that entry, as
ib_sg_to_pages() does. With this change the bytes land at page offset
0x200.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Opus 5.5 and
reviewed by me.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
Tested in QEMU on v7.4-rc3 with KASAN, with an in-kernel test module
and a librdmacm client over siw. A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_verbs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 80ef4cb95fc..c5f67c8e7ce 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1505,8 +1505,15 @@ int siw_map_mr_sg(struct ib_mr *base_mr, struct scatterlist *sl, int num_sle,
 			return -EINVAL;
 		}
 		if (i == 0) {
-			pble->addr = sg_dma_address(slp);
-			pble->size = sg_dma_len(slp);
+			unsigned int off = sg_off ? *sg_off : 0;
+
+			/* The MR starts *sg_off bytes into the first entry */
+			if (off > sg_dma_len(slp)) {
+				siw_dbg_mem(mem, "sg_off %u beyond first SGE\n", off);
+				return -EINVAL;
+			}
+			pble->addr = sg_dma_address(slp) + off;
+			pble->size = sg_dma_len(slp) - off;
 			pble->pbl_off = 0;
 			pbl_size = pble->size;
 			pbl->num_buf = 1;
-- 
2.43.0


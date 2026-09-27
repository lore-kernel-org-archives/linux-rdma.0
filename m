Received: from mail-wr2-f8.google.com (mail-wr2-f8.google.com [74.125.225.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387822E2663
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790510200; cv=none; b=uaoKTInT3hpbjhGRklvitDB8hsDq5+1ccf2JkdHd8CE/neind0fjPjBdnSd27ZSGmJahMRttbBktyiIqqrCQSJhcmlyYE5YYsvOVxPhnAalVYUZZ0SrBQxj3QOP9KZMGqCbZlgMBcxQboz7ZpjoBSaQn2ieNhPW4afcEu1tKkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790510200; c=relaxed/simple;
	bh=l6K/sFQv3ASRbSDCtexMzkpOqNFTR/2cH63ptPimFf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bUjPZ+6WkbwZ+PLwIzkv5ybE6jjU+uTVpfuGwmETISWgqkDYdpesJoSKHWHmiar09G4wy9kQ0cy6HvjE9l3PhmgrolVCQC0POoP+0TGVwTvsFdpO2ZrP5kcgrsQbzl932f3ejwWB+o0xgyuMqmPtxUkbubJwkEU7IyUvQecLEWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMPwLFFK; arc=none smtp.client-ip=74.125.225.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMPwLFFK"
Received: by mail-wr2-f8.google.com with SMTP id ffacd0b85a97d-485ac0c75b9so988760f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 04:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790510196; x=1791114996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=msADhsoRTGj1IyLzsyfhlBSSlDWgsH8eeKkmP39j+1U=;
        b=gMPwLFFKSRIzpRhyLea1d22A5fof9BcM1j2MHW55Wm17/qvxSHat/jXmuYvWNwluHa
         QChFb5tq1L8OCfymfu+1KyyffrQlY/WMiPEWhg4fd7hLgaEBoFIfdDNPoUaPBAkB9RCd
         RwuHoFLEiv2e11M18nmYxBfhs++ZMTwi3KQvPBVovIX48JZUgD+MDL7tuCdwCOJBeU1L
         S34cMhIRwnjFY11KXz7gawn3YwrmI43FuNchTe29BeCtjZskCw/EpG/MtaZRrDbTuJ6F
         5xTTteFxtHBI4rcjoxN1G2v/MDxIw4aO47OQ6P8qfSzspHReDjg1Kxb+FJS1ZQec1erY
         Te5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790510196; x=1791114996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=msADhsoRTGj1IyLzsyfhlBSSlDWgsH8eeKkmP39j+1U=;
        b=qSTaZNLzgJrlR4Lf27Y0MzxUsKgPk1rpz2v1qjfUl8Sn6OBuDvxWM8B7TM2tXlWZzH
         xLKOwQVxO84OqtoTMLqIWb/zWLSNH6mVSOSeOpmSZER5HYIdS3bqA4xjzHMIe0oX/0xi
         SDURkkAJoDM3p/dbut34SlsN8wmR85BXVVBCKyVfyjOHdLaiSumDj26W56Csw32GF7nZ
         mI2MclNIE35QwUMZSesnCYetj1e+k0VRdG5Ew5EsUMRE2aXIlwUeoc8r0NpiSFD7NDoV
         YicDe9Ahj+a7HIsZmJ6WsIQ9JeD+Vt8LzU7HqEaiYdd7XyAKWUAfQpde9RZX3Ig0zYiN
         cK2A==
X-Gm-Message-State: AFq9FYLMa8bQaock3JG1yBSfEhDAPZMtM5A9qFloseCQ5GTtVloSs5pd
	rkupUcL8ny9xT/uq1spscrLhL2tqsp2zOot6IXoAbMr4N/bC0I1rcmj4
X-Gm-Gg: AYBFou2O4+lT+6c2gyAsiQAjhbjqqSWQOwsSecJcDEhYlW29BRiMB0JXxXugynETn5g
	YnpxcfyZ0Kph5d0MZR92g5ikp3gy8+j2vtcpmkRCwWvzsDzoIrcyFwBm8kWwpfmmHLHYuSUP8W7
	RL6mk/L/OV3pIAd4G9pfD0HOT/0BPjZ0Bo0vRt1LXw7DM1PWY8Fd6kg6kW3hMhuJQz+1prFzgc8
	Ghx/+v7LUjMfvopGlnvSMKBumoGTmoPAoFEyHD3cQ9gdvBTgvddaAJ7mEgay71x2N050Tfw78p8
	9a6NasKPR/u4eqmcHluHxczImn3V7WOXRN/cBqIqstXS+aPceKnHN3UmUbf0zRL9pyxde+zPBXI
	Ho0a+4IBDk70IUcVSfWzgiDqnHK5Frn4lMVF8DrHj0pxqCjkO0paO5wP7oeFJ7MpBVfil2n9N1t
	RW4H1QrTbg7zfflY6ewIo7bfD2vaJd+u0dlieIR/AGAP7eZdugoevp3wvL4mWcDcnCuYwTzYxf6
	JPzu0mMhN6ij2aCiNEcyaitfA==
X-Received: by 2002:a05:6000:4684:b0:488:764c:7a17 with SMTP id ffacd0b85a97d-488764c80c7mr11867759f8f.1.1790510196208;
        Sun, 27 Sep 2026 04:56:36 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a64ed6esm21926084f8f.29.2026.09.27.04.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 04:56:35 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Sun, 27 Sep 2026 14:53:51 +0300
Message-ID: <20260927115351.12245-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a short-single SGE payload crosses a page boundary, siw_try_1seg()
computes the length of the first chunk as the amount that spills into
the second page instead of the amount left in the first page

	part = bytes - (PAGE_SIZE - off);

Use the remaining length of the first page as the first chunk.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Assisted-by: LLM
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index f7dd32c6e5ba..54c9d97015e8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -85,7 +85,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
 			if (likely(PAGE_SIZE - off >= bytes)) {
 				memcpy(paddr, buffer + off, bytes);
 			} else {
-				unsigned long part = bytes - (PAGE_SIZE - off);
+				unsigned long part = PAGE_SIZE - off;
 
 				memcpy(paddr, buffer + off, part);
 				kunmap_local(buffer);
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559231;
	b=Sfc0dSI5cL37YPv8D7+ML39daZmTVRMLPDJYQZrTPjBEiS6Xcrzie9RZeh7LmyALwNjX
	 ztH7QEU/xNGuVO0hM2dtqURaNT2OCxKe1jgJ1gEGvgq6RxayegV+EfiiNIbnpi+fINaAH
	 xISe911+CjiTCHPvwt8/mALO4kEnVTWu/sWGSAsYjwI9CJ+ysZGHBSgWRgS/+LWpVzt15
	 bu1nfAi/wnegom6azvk0a4+5OFDdbXNV8nm/we+a4KFv4MZfrwbotukqhEIaaHzIW/s0T
	 0katuDX4LfHKnwkTpEqtc2PB/3DNu5og/X+CH+6ZGXc4NAxPZ5Xec5ETP9OE7hq2wdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
	b=oXtmAxHEj/y1Qtklwp00+BQNcQx0fWtvdEpACDIAQg65p4rCChRTAtSVBp71zZ3l+b5U
	 XRAs9cpfUT7XM+f962KM+mgi3U19jYrdyu8gciWGoGkWgWKxe0Wp2WdBTCI+ilycM//mr
	 HpAmFv3R4qaDWSRCwG0Lu+bYudArexdAw+XYs/Hl/IaL8mdAjpiDKJHKAFW/AFYbDh02O
	 vT5vGSrA5R+rnF/CcVcdb7oke04SCZh868nc2Ojpafpm031cW2B/4x22Tskt/AUv8w15U
	 sgwSq6XeAONca4p54E2K2vmMgljXeEwfE8MAakYIKwgwMzV20UklPxIlpYR6aGeYKzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C97606A8B4
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43C97606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdab6ae1ee9so298517a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 00:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559231; x=1795164031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=HFQ3NMFD/HeHqYJQZncUggUrOcMsaYsc6YJAUjDIsCZEZ99XBDbk8eKvWDF+Gnnrcd
         svJJ+NI70TLXlxc0n1QkUdGBFgOEAeAAGvKfgKVnZl+v92VHhDFwUFx4TBLOXVvLojUP
         LEeHLydP4SIxStMQasLl51rfhBqfGqbnVX/t31+VgC2V3srZjG78WS+xEx032q57Teu6
         Hwf4POH4kZXxDBFsy75EYAKphlXWF//aw+m68zUh5aRduOGg9nW4UfkfnUh2xIVQ42Nq
         UwxFv/yTP1Yf95db/kKvzRb8Yjd52tHxSyekeJBtDKAzgsZJobPigb34M/u+Vl2afuEP
         iaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559231; x=1795164031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=N0ceSFq4FcyyleZZoUF5zg7jNRTlIlVnYbidgcGMFJxhK837FOYt5L5N9B85WcuO9f
         MDVn3V9bdMIQMzhvF3ypKwi0GRcT+sBjVRlNk1L2nP/iBzOrHWanakFgCVrtPRCQcw0g
         g5Rrc6Y5VxqkbITsAcETpmCwsWegPLibW7Nc398FBDTOAeDp8jWnJ3X9dH+juof1lBBE
         FdcvNgHufgmrsx9cOzNHt2+XvkGba9kjTeFH2rhXdtkTBPBZVvPFSBcAoFhg9x9OyF+o
         Gww6Alvu4WfgOa+Dh11rVZyhgF2BRVq+RleeNaJjXV6ZVI8oFC3DKB0nvGEP8ux6Goc7
         TZ1A==
X-Forwarded-Encrypted: i=1; AL+hErGvEDZVASko6pU8OgACwGlgTnPBqpR/NINto7QbqKidxuoPaqkMloS5ydjz37IUip/cXfJDPLiOMcu1@vger.kernel.org
X-Gm-Message-State: APuU4Z+7w2d96Z0Mw5O3o9tG32uEU04zQEOTL9y1dxHFfdBi1bCnShVB
	U3PwgcX3f0BLNU1x736rH43JKkMWyjSDAjym73q2qeLqAhw0sNeNcrjK
X-Gm-Gg: AYBFou3PJ0cPQ177ABSPIUHLEJHPRIvlrBY9npZq+sZVrvSKdpC8ApVsf1PC36/4Csc
	78VJc+HNeQsbSzvaxBH3X9sx8i+oCl1pk/yf9GC1AUKlURJzhqT+s4+lhCmIPQe5QrjjtAC5nAa
	31G4lsEXpc4icVfk9+SwN/+F5Ecpsn29oQ/Ng73FZ+GNyQjkdfp1vLAzdf2NQ+vRJ9KXX+mVg8w
	ZQYTFwELqAvS7PhvcDNeAa72qe+qFuX4/aUMZ3cU+ky4eIyPSFr+AsRM8TsySDhVo6O5IYcStcG
	kAOQLy8WK+qpMaBR8PnoAGnX9mXGGPMvIWWrW+YggAGVU0sSMrBfUNO5a4g7A8pulnLREVBmIQI
	lLiQ6SaZKtMf6LnlA/dvAHbx4ULH1tP0j/9xR33qZihdW2sA/+HNJzRgw6AXBUnvgUHJjhGLkO1
	pEVq/KGr1OXy9otJn17vvJ6TuUC0mTepYYkqPrhs7k3OFpTAD3g3LPugFoh5HY8cxR8lmqanYjO
	JaQDKls4nn+MOGB9ljxlbEaQAcVRHOegCtGEzBxUazeh5qztYDrMkr7Cg5dMlsY+q9zbYhYHYRP
	/dbuWPbGgURRnmf7gS4Y0QLGjmv4ulw/LbgsvzzSnQ==
X-Received: by 2002:a17:90b:4410:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b1b0b9a342mr1279723a91.63.1794559230508;
        Fri, 13 Nov 2026 00:40:30 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:29 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 2/3] scsi: target: Clear all control read scatterlist entries
Date: Fri, 13 Nov 2026 16:38:41 +0800
Message-ID: <20261113083848.1517595-3-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

__target_submit() only clears the first scatterlist entry of a control
read buffer supplied by a fabric driver. Control CDB handlers can leave
response bytes untouched, so later entries can retain stale kernel data
that is returned to the initiator.

Clear every supplied scatterlist entry before command execution. Use
sg_zero_buffer() so entries spanning multiple pages are handled as well.
Keep clearing the full entries, including any part beyond data_length,
as the existing code does for the first entry.

Fixes: 944981c7e106 ("target: Add control CDB READ payload zero work-around")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/target/target_core_transport.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30a..267f5e2cc8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1633,23 +1633,16 @@ static int __target_submit(struct se_cmd *cmd)
 	core_alua_check_nonop_delay(cmd);
 
 	if (cmd->t_data_nents != 0) {
-		/*
-		 * This is primarily a hack for udev and tcm loop which sends
-		 * INQUIRYs with a single page and expects the data to be
-		 * cleared.
-		 */
+		/* Control CDB handlers may leave response bytes untouched. */
 		if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		    cmd->data_direction == DMA_FROM_DEVICE) {
-			struct scatterlist *sgl = cmd->t_data_sg;
-			unsigned char *buf = NULL;
+			struct scatterlist *sg;
+			unsigned int i;
 
-			BUG_ON(!sgl);
+			BUG_ON(!cmd->t_data_sg);
 
-			buf = kmap_local_page(sg_page(sgl));
-			if (buf) {
-				memset(buf + sgl->offset, 0, sgl->length);
-				kunmap_local(buf);
-			}
+			for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i)
+				sg_zero_buffer(sg, 1, sg->length, 0);
 		}
 	}
 
-- 
2.43.0


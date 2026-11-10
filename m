Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794280215;
	b=ATb73ZiazkOJXDCZwKFbCXJ14kv3LFLc7yJYtZH12xAYkEi8hAlIzB+dwsWVZV124ZWj
	 kNkFqE33Q8dFHu0nRwK+TP4xFG7sScV9Sb4iUzUoMQWTqndS02p2RjtDSKVvkTrXFFNB1
	 oxuebSRBuU1rV4oLMWNHL4TBHNFB/VIhcTayviFDFlG4Si3wmjkzK14TX++3OrUYHyTIS
	 NDc4IOQFX3uSsVo4bFXYs4ofqJ1437lK/tDeXf63Bi/8FzQi9JgK0QqyrL55g5dq05L/3
	 NZUS67fq4sUyTIT2uCmdijdmqHYoVzoSaSVm54zbnomxsWnlbzJuY7CJLt8ClSWLv6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
	b=oXWUBwq2nrnsDiBxD5YgtJSOXLhxVExhNH+4/WNNxnDbrDBzAkI9Z6xrDySiaYFb7LcT
	 nm4qglgPLKiLjocgaLloX6iTHS2CGL7hZ4t1Efwh9jM7DIisDWwhsnjb1o6EUQJueEn2d
	 SHwyn9uC1R2o6Rm15O9cEXQ3fvJeT09thNtSz+T7D7rH6NcDTbIZ6KyAAfEK7YC5DkL9d
	 DmznuyCQbeIn61ZdlWrV+3mj8VoYWC+MWNNHHUp3C8yGhJ2ZJ2kinbgZrKw7zUdvb7s6g
	 hd+g64lcQjb1ccQ8MAFWxytBasHfGQt28vTwd7JTSBloYlHCHUDhZOAgOsTVnUDWY5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L+yttUZi;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFB5606A33B
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 03:10:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BFB5606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L+yttUZi
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-89d6bd67045so783131b3a.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 19:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794280214; x=1794885014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
        b=L+yttUZiKSMf9NvCb+E1pLmj8OeGaaYw08dr2RAirE+Lz4npNIabN93ZWVbnQvBOmk
         L/yuJyZBJXk+gbkG3Ff9GbaY/UHwWlFTW80K5LASoZSSlGlA+HKK4+3kty5gpse5xRY4
         TI+pERF8HLHwUyjXVIkZqzQHRQNiZ+4a9ipfpMf/81jymsAP0aUBrdIzokuk4ZY/WnEu
         yxiBGwyFRYuoSKH4xpoBKm6g86uUhQq4pQbB86n6O8c6bHsYhFkKH+5rsFw6uBhO8JV8
         YWitWZAUHAoOpHd6BhxUuy673W5AKuYLbtmnvskoeROhohACc5FBdnN4+re4uTlbXTZ+
         3PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280214; x=1794885014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6QYJzw9Rr63XbTuPHrN4Cbad1UtYv7xxIdUtWOpl04I=;
        b=nNcByJ0FFfjtlxV6cExz+WdckIYxKNmhTkhl2sbQSH6NZ2bRSv8MVpXtVg5KuUBLWs
         E9gwNOs7B7qxIM5dLNFBcwFKfpkInKmqgmvEICGWUnf07FzTuR18KxgcYogDF7lb5MFm
         YIRcqkAB+L4V2ApDGIudBjdGNCyaWUsPIXicufqkLMIgOAWubOS9QVGRiujZbSkEoiCe
         5aUptw7MIazumqJDRVs+Zlh9lAhXzRUUyuvoue7Ofci1Z9h7vHWG5sb6gRMgLtw3KhlG
         UtAHsRgIBmyXlqyGOZVr7R2DftUkSB8C+a6f6zKZ5DS70Dd9MYiUvkkEsrbqOigUBCX5
         UQZw==
X-Forwarded-Encrypted: i=1; AL+hErEh/+js/ER2xYLB7/pwkH2GR1zOgKD+3odhVPcfTJyBbcxzLy6Fvsn8wqCGEW9td3vf9RoThTKYyVzS@vger.kernel.org
X-Gm-Message-State: APuU4Z8QQS7jH+aTLUR5xVy5p+kKwRP7nzLsaVrwYqgraSKu1v7o0zzq
	wnnACQSWUWv6DO/PJKenHPhgV55vHN0d49u03FxmTjyNJWZKchzhdDUQ
X-Gm-Gg: AYBFou3zuKniLJzu3u8CLdU0ofhItLh1boWgi9btucpakiszrUT/6NlLiRnGl8F7yDH
	c1Xy14lMkBHRFfy++MDqPFpnTyMmQemXZe1Doid8e8FzB1kGsGVOU6Bs1pfW2kYX5XDS5+E5pm3
	5k08rszPlGjnJ5Ilq1dIwpVmrQwYznC+tOSqpWhKKdbJcamQXl7Xwc7CbW1PwP2BHd+ujEWO83P
	VN9D/Bo/PXyM6TAG7XF969qgsuhfd/WRYrCkStNmSB8JidmWmJqXj+wJBwHChxEhbjZSHAh6P5j
	BBOF5rjnQh83jn0Lr1adOLh+g4XAIhwtQD3whLxCHcHCSTp2yVOwyBPmB5T8HIm4tVo5/qq7vZ7
	56NSuGb5M2RzydBqH5QGMcn2TZpNu0wB8Lj25lhXLnlR9DKJX1hfbXanMpgZNeWeLp/c/SdNx3A
	SWKQxFgCvMuvJsNUKVHzqHq5yiXkadqNo6MQhQjRODCh0J9MK9gVEq+jVJf2SzfMaY4qtXBBGYo
	TM61oSy0bEzIK5o+rLKpJKXhoR0Ik0TLsOWy56mbK/U+PCMQ4eBSWOxbwnXyiuIdmh653cm4g8t
	SdPnxjrLTCx7XpqVxvguFLy+8c1x3WMTGEqCfBECTQ==
X-Received: by 2002:a05:6a00:9287:b0:8a0:12ab:e29 with SMTP id d2e1a72fcca58-8ba97ac0667mr920272b3a.9.1794280213567;
        Mon, 09 Nov 2026 19:10:13 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dffb5sm308939b3a.55.2026.11.09.19.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:10:13 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 0/1] RDMA/srpt: Fix read underflow information disclosure
Date: Tue, 10 Nov 2026 11:08:05 +0800
Message-ID: <20261110030809.913063-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Hi,

This patch fixes an SRPT information disclosure that allows a remote
initiator with LUN access to read uninitialized target kernel memory,
potentially exposing sensitive data from previous uses of those pages.

SRPT creates RDMA contexts from the initiator's buffer descriptors before
parsing the CDB. For a READ underflow, target core reduces
cmd->data_length, and a backend such as rd_mcp fills only that length.
The prebuilt RDMA WRITE requests still send the full descriptor-sized
buffer, including the uninitialized tail. The underflow itself is valid;
the problem is transferring more data than the command provides.

The fix caps the data SGEs at cmd->data_length in srpt_queue_response().

The patch is based on Linux 7.4.0-rc1 commit
f66469d9905b39d2c260a15d7d6db450f4db67c1. The issue was reproduced on
the same commit using software RoCE and an rd_mcp RAMDISK with an explicit
ACL-LUN mapping. The triggering READ(10) requests one 512-byte block but
provides an 8192-byte data-in descriptor.

Relevant target kernel log excerpt:

[    7.496367] ib_srpt Received SRP_LOGIN_REQ with i_port_id 5352:502d:4556:494c:2d49:4e49:542d:3031, t_port_id 5054:00ff:fe12:3456:5054:00ff:fe12:3456 and it_iu_len 512 on port 1 (guid=fe80:0000:0000:0000:5054:00ff:fe12:3456); pkey 0xffff
[    7.528685] TARGET_CORE[srpt]: Expected Transfer Length: 8192 does not match SCSI CDB Length: 512 for SAM Opcode: 0x28

The patch has been compiled and verified to fix the reported issue.

A reproducer and additional reproduction materials are available.
Please contact me privately if you need them.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Regards,
liuyong
360 Vulnerability Research Institute

liuyong (1):
  RDMA/srpt: Limit read data transfers to the command length

 drivers/infiniband/ulp/srpt/ib_srpt.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


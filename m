Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542563;
	b=OqK+DO3E7t1+WHCiNikxWBqms7qoG6w43yTMbv050yvXxWlAJ3IucZETik/JsnPtvKkQ
	 qTDlf6RtGG8ZbkHCkQM+o85SrNbYjjOprllVSHfja1hHeiLl1zDOdWxkLdzqf7yr5QX0F
	 9xlV8GNrG3QYPokA0V9YGgFE3BdN89idUTYvBG7eevhY4dPveoBACcZLPmo/470XycuZT
	 1CqudDMcwmewTf9MRDpcaPV8boRaMQfvrKFAdKQAL9vWhxWFuS/dT0Gj7ODUPQ4LiCCHu
	 +gQ/S488m6xQzBm1PiD6dlnxfKVz4bslDZdcGkkW/7Ki0A/QkNC6O1Ls1CijWdR+t5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542563;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zTSVuTMGY6hfgrfBmT+2Qdu4gO1NY8TIBDQ9SeqIt/A=;
	b=F++WWMWcnzCY8Wbe6CjYSmXYX04c7pLLSDPuqe3ueV/SJtB9iXV9f6aranWhgo0iB8Vy
	 IYuN9tbRKeYt5Mzeueh6NfDgmWWlVWR2eTq4jQ1Hh0ry3qkXgQWCeacaNFxuO/4rywcqI
	 vLI4AmMAgiDiJ8/Ah78kUqCIbPDke8x42OVVGNxBu7PDO2y2LtF+v8Q3NPnMquDtbMVHq
	 UHMXkYVdsf/L+Cy/J5UwUNlPJzvYe8ljlyk5LWMqmEBzAiVa1u/m8qDrRNL4sliApKeOQ
	 oVUpLygSUdg9O9qChoRp4tcjZYlCsIbZGBoi4Pjyh2daEqpnjmtj5rxAm0Jd/iilVfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e6092uB4;
	arc=none smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43962606A32E
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 14:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43962606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e6092uB4
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bfbc25a76aso3468889e87.0
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 06:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793542561; x=1794147361; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zTSVuTMGY6hfgrfBmT+2Qdu4gO1NY8TIBDQ9SeqIt/A=;
        b=e6092uB4Ak7T1uNz+QgZeKrzME/g//SGNqTYgSs6btRriaKY45UA08mydcZ8ejIGnM
         sPy4jI7f4q6nke1H9Ol15P+1EwlzmGQU9DnRPEBj8GyFii4bmuQWfuiZPCPRkctjYyo+
         poELxYC0olmV9TQlzBII84NmLVNtoRw5SoAPVOcnF6kdZweMihvme3plholtCGNCWIM7
         X3T2OyYE8RE94OTsyA+SAFxVwrZKJ1U+1343Zrq8jbC/3jUxWvPBgmnEMQO4apiBC0h1
         X4JA/xQEzDaM/1VeYafm0AxaJPp6dfb/0OmgaV7yyXDX1U1/ntP1DHcc+UaKeP43DH+N
         i59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793542561; x=1794147361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zTSVuTMGY6hfgrfBmT+2Qdu4gO1NY8TIBDQ9SeqIt/A=;
        b=bg4VrecnLTXZScazanrnv6eiW1slUsoOYg4RvTWbMRyGjyBe58dZb7PkqPzHw01bkY
         6HyLbzvYkAmIHRVlqDL8fM4v8/p5DAVuen1gSTwc/y1s4WVSLkJVxKd45biJX4YyNlW7
         f55kQTKDAPRzBNU1zWvWFuQSVH2ChHozcKKj8PQh4reIx2rpvCGNUMFD9O+Ryer/CwJ+
         Lo1SbW8w571yRGG1+35w3aWT7dZNG4oNHwTitwdo1w03sO/rE5mL1DoRr2Bqgng9g3ym
         16z05jODyfPINKuXvY4yuvOVIXpqN3LCJcjY1eib3vVM3/XNf6uk4bWr8OSWfsR4sO1+
         Nxcw==
X-Gm-Message-State: AFq9FYKP/dFSLsTkYLXswk9o2wTrTniwnSt8+VTYma+fbk87XjMouDer
	5BCFlepShix6P7HhvZfpEJoHg4Ub7esCjp+UzG3Y8cVO2nFLksXBNcu/
X-Gm-Gg: AYBFou3/Qd44AWnPrFF6jAfg/9LXglnDPAeBlqfaO/UrJGz/kVx/U2udVNHjDZCoEJR
	fAclQApZdP2w3wWk6/vnzzws3O+OxQ9E223c+t5sMJvEptgKPQmHlxoPvAosXBHwvtBej5en6eX
	4SMJzntMpXfFHfNtLp1g7nLGLhgsDxEmuREWGXCD5DERX+VbSNIzvtlsKF9MA8yQyyjdsQhi97v
	npmlwKvuFlLGuuRAiTacyuzxax0l7eSvQuEfd17YK2Uj30GdUSAjbQfWt5dmnBSH9vyDCdLI0oJ
	1YdiJ5R/wwIJHD5LT3A6g833OgVteHA7P5iyrlh3edcnjrJTxSPYSRElkI6OEOrzk8SPISxEeur
	qLRKFrG382aLj11LKxcoYlyUzDBBgZdnLWLbu0SISFoNvBW1qyjuOjoP94942KO6gnt/+XZuTqy
	AN1IbA5BlJNNJz28zXxQDrnr+VWO3yHpLJl0F8tW9KyUwueU2ctpFmwJsu+fMksamnPOVfvlzA7
	yGCjbMbfHNKaX45oZS8FkGBrfQjmfCIcvDEnGLYNY3iWG5KDXc5VKjqfYKHoiDVrEZ1aCVcw/B4
	XfmxJ8SlFMKGb29oLJRHsZz86YQ4oMk2muHB7fgm6mS71NpBr3eeanUquD/ZJCe4RbKfyYnUrfd
	BIqx20NvCBhN2W2R2ypBCHi3w/bmzeAHAMU+wD7Ql0yjTTkr/gXxhgiSYaw==
X-Received: by 2002:a05:6512:3d93:b0:5bf:ac46:c5d6 with SMTP id 2adb3069b0e04-5bfd956d81cmr2363170e87.12.1793542561461;
        Sun, 01 Nov 2026 06:16:01 -0800 (PST)
Received: from xps.taila9902.ts.net ([2001:464e:6820:0:f43c:bf8:ce8f:65e6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe1791832sm1043672e87.23.2026.11.01.06.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 06:16:00 -0800 (PST)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH 1/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_PORT_GET with its own command
Date: Sun,  1 Nov 2026 15:15:20 +0100
Message-ID: <20261101141521.2426198-2-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261101141521.2426198-1-nickgarlis@gmail.com>
References: <20261101141521.2426198-1-nickgarlis@gmail.com>
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

nldev_port_get_doit() replies with RDMA_NLDEV_CMD_GET, while the dump
replies with RDMA_NLDEV_CMD_PORT_GET. Use RDMA_NLDEV_CMD_PORT_GET for
both.

Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
Assisted-by: LLM
Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
 drivers/infiniband/core/nldev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 849a5db54e1c..0602e4d38aa5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1304,7 +1304,8 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_GET),
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_PORT_GET),
 			0, 0);
 	if (!nlh) {
 		err = -EMSGSIZE;
-- 
2.55.0


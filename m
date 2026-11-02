Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600310;
	b=zWOb5aR5mX4V4jSG4TBd2giPQS04UNs11Q0eIa7E++LYN6MlaATS6Uy5qVZD5hTqzcec
	 yG0B41TTZvM+RDkhQEVLhNIi31xRW0mJagMgxw0CTXBvrH6YBIazLWI0H2RXkRSvlkR0W
	 s3r6sBmIgxlrLFBMdUkUfnJOhrhoV6YO4Oi2tKrB6dGr8ngn+5r0M5afGAXcW9u55SWvC
	 5A13YAZmLCjPkiNCnVVqNBMyP2ls+3Z9gyt10/4LNy2Z9HbD5zOzT6ip4BtlNrvVb9oLq
	 lhC7wZ73AM5GZYOPt7excUaSsq93ai9jwHLc1v4NhqhPj0vzTH+JuwKVisUgLa7L8mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600310;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
	b=UecgXW0xwjvEgKsxitUj7Lpl6lqXBpdJlbvZUIOXIzCE5gazo2pKGuxqqMR7P3heGtBx
	 tx3owxnydEz8i5FwWxJ+Tb/QPSxv1hMPUlS7FHkO3oRO7gISHN0Vf9/2W5BUmFx2SU3us
	 iRTcCiUlBWXC2BhxrhZj9Rgq/Nwmy1ncSQVqJe2MZuLaR9KKgA1Ar9sanuDwnTk3sHqrr
	 kvPtVf4OlymIgpI0rn9/W9yMJF/PKvs2kzApTnngi6QmzvUUCbPo3bcx8a96EhZ2hHirS
	 s4lmkOoxt9KjwmXKdIGK7G8pNmG27JRjrxE2OCxtdPUxa9AvVinemrZ7vJLVC3tWIVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Fp7ohFFT;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284E606A326
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:18:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6284E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Fp7ohFFT
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso94680a12.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600310; x=1794205110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
        b=Fp7ohFFTYx3vv3aTjSalkr6sHXZ0b4pV0DGR0eIjTY4elFQ03NCEMwX4xjjMbFXvVU
         Om0z2/vPLfSQ3WNb9YuqTbRAi17IGUEqhDIeQuE6nlx27sRpsn+ttImW0j6QG7XpZguW
         EMjNKSOGaRMxpfGmnUPREZskN17b9836h/9n8KXybQzAvZultF92AB+C0xmBR2W7xGHy
         G7dkTQnxtSuCKTaHstfIo8lpWKtbY5F5aP0qbUIGxIZz0Rb0DNJQI4qiIQSrSbO+wCaJ
         jmtuzBcdCgZw16ZEYLz9jPum+QUxtk9JjMZJMXctsGBAIDmT7icMZTB171lZ4Ai+y4GY
         hVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600310; x=1794205110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ycenU0fhaGH93WaGt+mAjBlNLFrb8RODmesa9fer8AQ=;
        b=LIJ/wQ81JrmUbHyLduxC1Ld1aCRklTq4xTAXvupUs/Gk2l3y/YMdrVjFqVRCjWXJZ7
         ALmTJuW4WzoUXCzRvmSQs6H5wVcdtpyDa5Nhno32y2xDNLTUVB9eJgGHWnOyvSXzxw/D
         3clkErbH8yy1ffhcmC467nCWMtl0+YV1Qz+2wsFlQnP2VFE9gxJYjkFRKMLBb7BNUSav
         Pes3rpUbvxLmYWcBiMDIo1F2HBBti9ItFW3XKWpX/t4/Om3yIs9hX6GD1lTGzWmNUdBG
         to8Snzeq4lEbE4ceCu/xlAC+84XK3lxiZZ5urDXyXhgzIyr7R8sP4aCt9o0Um0KX60yW
         2d3A==
X-Forwarded-Encrypted: i=1; AKwUvBw54ZzC4aafq6f2Dfi3ZNoXGx0QktOrUVpCCcZfB+zsSBY45YQA7jf1R1tNa+0sBdvAd7GEUIEvzLOl@vger.kernel.org
X-Gm-Message-State: APuU4Z9Tn/RC6pwzk7davXZ2Y02wZCXCc033V5ah6L3GBIjVITUn4+5P
	ImlYy8/yzM2B/3vvt1bfqVV+AiT2Mpq6z/ML2icFH+iWqrclYRgMAeDWlhw9ibmVHlM=
X-Gm-Gg: AYBFou3JdStj1JBq1QAhMAMJXqJNx2Cyh2rLbQkn9R27warTTtMZVTsT/9IfiX+iGHq
	n6JKycZlyQrVKGC8vZd9GPAEJ37sllhqOiisZMoigbJZXdNdiA99MoSgeJ2NNoQRNgPHt7aSwiK
	kMLoBYVeTJebFiMrv/JySv2bDLki/Ua7ioHhx9VEjy+i0Y3HFk9HsE0WUQ6ka6Ed9W2ENs0SMF1
	OC7ipl9eUz8n0IrFrWcu1834mBrs9sLNcegkcbooZsp+Pr/2RjxBsyDcZJntztLsRvaFR8BXgqm
	Ya3+7HcJkGnvW2wHymmUThA9IUw5Bt1J9381k0442697AnLrOacGpWhdGDA824ljOQig/c2cy4G
	V72lGZSzlZbKCFEshgRLHB9iQ8a1CyDy7PGCzRvJsSz3qYZIvlINUieX+eeiZuQjb0DT0EVFxVk
	/pdeRwhx6Z+kPr7dercAD2iHp9ULlk2GpzXN+T5a8yXd4JHZYubfHhNQHrxeD+12C/I7OrgsKra
	7pcvAvz5eVEPjL3Nz6hIc3I5GkZwWaYDgodj1tqorYiax0imUyWPKQ7naAKD51d04thrF96wxSR
	XwLn1hoso6epvA6iYk6gh5UQk2rkX5H98slpR4TuxxeqWLqru3RiKOALGwbKXYNl5U0H9tvliMO
	LtskolnLFeST73jseMNMdcvaoDl4ujDUMAGIsBmzotsEJCk1phyK5FgHRojM=
X-Received: by 2002:a17:90b:4f8a:b0:3a4:ca46:840f with SMTP id 98e67ed59e1d1-3ae896f8655mr7224057a91.8.1793600309684;
        Sun, 01 Nov 2026 22:18:29 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17211751a91.9.2026.11.01.22.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:18:29 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] IB/isert: tear connections down from an ib_client on device removal
Date: Mon,  2 Nov 2026 15:18:19 +0900
Message-ID: <20261102061819.617254-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-184744@kernel.org>
References: <20261026060505.409476-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-184744@kernel.org>
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

Thanks for the review.  All four are real.  v3 closes three of them and
most of the fourth; what is left of the fourth is below:

  https://lore.kernel.org/r/20261102061608.617186-1-yhlee@isslab.korea.ac.kr

The isert_free_np() race is a separate patch, 1/2, because it predates
this work.  Keeping isert_np->mutex over the release loop would have
brought back the deadlock commit 691b0480933f fixed, so 1/2 takes the
connections off isert_np one at a time, which empties isert_conn->node
before the mutex is dropped.

The isert_connected_handler() race was mine.  Both handlers used to be
reached only from isert_cma_handler(), which the CM serialises per cm_id,
so the two critical sections were safe until isert_remove_one() started
calling the teardown without that mutex.  2/2 now keeps isert_conn->mutex
across the state store and the list move.

ISER_CONN_INIT is marked by the teardown and released by
isert_connected_handler(), which refuses to promote a connection that is
already terminating.  Releasing it from the walk would race
isert_connect_error() for the single reference the connection holds.

For the racing connects I could reproduce the half where a connection the
walk has passed is promoted afterwards, and the same change closes it.  A
connect request arriving during the removal I could not reproduce on
soft-RoCE.  While isert_remove_one() is still running, the code refuses
it: isert_connect_request() now fills both lists in one isert_conn_mutex
section and returns -ENODEV when the device is already going away.

Your third ground stays open, and I should say so plainly rather than
claim the window is closed.  Once isert_remove_one() has returned the
isert_device is gone, so a connect request that arrives before
cma_remove_one() tears the listener down makes isert_device_get() create a
fresh one, with removing clear, and the connection stays in
ISER_CONN_INIT.  cma_process_remove() raises DEVICE_REMOVAL on that cm_id,
isert_teardown_conn() only marks the connection, and no further rdma_cm
event can reach it, because cma_send_device_removal_put() has set the id
to RDMA_CM_DEVICE_REMOVAL and cma_ib_handler() drops every non-timewait
event for an id that is not in RDMA_CM_CONNECT.
The cm_id is never destroyed, so cma_process_remove() blocks in
wait_for_completion(&cma_dev->comp).  The unpatched code blocks in the
same case, in wait_event_interruptible(), so this is not a regression and
not a memory-safety problem.  I have not reproduced it.  I would rather
leave it to a follow-up patch than widen this one.

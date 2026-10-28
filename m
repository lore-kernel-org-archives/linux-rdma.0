Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168004;
	b=BRK5t3sfup4nVQCZtGTAAotjJrf4QP4wXJ2qqGIEWhG0cKWEIWIAhlm+75PWHjs/b11C
	 y2ZXR7QSIUchHeDSD7vHbBphTVH05CF6OvKUVp/5Z1tiRiJRowDVhQN1z7U5yS3dQ/F4X
	 uwE7c1UO3BYRxJmeNagk+WG16E3wxLeq7/mQ0E49teR3ImeAcLau9Mp0Jhic6KdUZDZXT
	 bMsdZnr029YLDfiisVkPhYzWFg6PB2pwWVTo8vg9HpkKxqYKyKXN3ZbIqfOqaLNJIW3ar
	 NGpnQzVSz9Z106o/1bsZvw8zoIYdlp2JTUNUQEtf2NYKu8cSofRt4ftyxBd/zI7QZkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168004;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=IRjsDNZddjHeQux46dUH0hIMw+KGNp7wvDbgiBTkyPY=;
	b=YMD+WqJWij8uGvhK87KCMm9piGkT1XvDyXmQTm6wI6YRBLlm+pzHv6q1Zdp8fQJXgvPd
	 ti/nUiCswWP07FBUw7y9nBca70zZ9zGBN1cyDmvg/LEnu5dbpsKVJCHEJKLkok+0ZOcOn
	 YCFSObMAIo1R+Js3vcoId2g46KFJpSI92++ACcd7TsABOpbKzVqgbX25lnujpv0hicYgE
	 xXfmOtCOZJorT9Bm7CrO1Dx0O5z65l3P2Nk8sQahEibpNnHp5JaTOpevom3F8skrLAejt
	 TKyfkRbSEd4UPKmO+lMWTmvc/nNWTJSjGiQ4g/LHnm1POG+KojMM8h1zwoj/JuvXLrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EpEzGhg+;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E813F606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E813F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EpEzGhg+
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so447124a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168003; x=1793772803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IRjsDNZddjHeQux46dUH0hIMw+KGNp7wvDbgiBTkyPY=;
        b=D0Lpjxz0YNKFSsoMX+CzG3xpfvAX7/WrtrpmGKAGxbYHBR6gpoLCMXlKH9XvZ20RNI
         Zt3XTm2U0Gis8bXhPjzIW2mGDq+St8XkfL9NXLLzN0Wt8dqVEZLoB8XbXMF4/SMNUhl5
         z/8HLhUOF/NqoUZGPy+4+Tqmll6MjeTOdh3oy/lg4OyzjeGBPGBHKcIw0fiY1EG+xYHg
         6JaxrBAZk1KTOxeX7CjsbEJYRAYA4jSmaxOYX3QmShT+D+5TJGz/i+9A02WRaZ0C4QOO
         VhK3GbJcJ4zWOoJwM8ynZG4Dvz/kpOU5lI+2f3P5J/7u1CO+fXsmwkjUYG5zMsvHyPUB
         TgOQ==
X-Gm-Message-State: AFq9FYJAkZEZZSPhLRmdeJfSeiZ/gI2+acNgNwEr2RtQUtN/WGydt40Q
	nu2O6Ce7HVGredLiiTeoYzHmJQ0CUTknecEPo4iUkncF2EtDZ259EKJFg6VJDAT43G3j77pBUNP
	mKHsopY3qJSVMVt2UoEX8r9ZTC/pDrWaPbn+d8p+8kRaLoOfCOlpucEKMivFn6BA4Mm5+D8ZOmy
	7MM7vXf3r+BHqLY7qzbY7935pVzXP4sbgiQj1lEuqL2zOD+Gql5YrRYENjV/thjG4BbmpjVKqjv
	gAtbHGMogFia/NA5g==
X-Gm-Gg: AYBFou1z4o3/m0v+SQDkjN2U+XfElLehYa7TghoZxfBnK8TE5V8IlgCVi+43OtnrdoD
	vxp8Smk+IfM8s0NANQqzJ62cpe2NUYWlMuJuCxltWkIn0tqozt7jYgbtngo1LnyBw99om3xEhWk
	aTNDJHLanI1UGadIkgKtENkYWDtLUKVJIXzGgFwai+Af1/3JucchXAjvwXfFOTlGoDyqJh8hgWw
	snqgkhrZ9piOEqR9UYxUCrmucVoOb43+XDUyMve6sDycdHLrvjFqu8Zu+i5fwLQOybzdPvQ7ouZ
	J9owepGKbh/6rqQJR0evGBvjuSanKQ5yiT8kdSJB6NqfCW9DB9oKE0UxnIsCLJqMrnSmC3tABbq
	+EnwYC4yEe39DfXaWq6+iymI0ySOdtcpKeFUk/x+Psfc/cAS2PXJXx6U7D7dozSSIyIE1M45Fbw
	qFuPmd+LQEpR/bGG0IQp3+SlgAPjq65W7TAGNW
X-Received: by 2002:a17:90b:3b8c:b0:3ad:47ce:3876 with SMTP id 98e67ed59e1d1-3ae58268806mr871441a91.61.1793168003178;
        Tue, 27 Oct 2026 23:13:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cd8ccce9fd7sm164908a12.24.2026.10.27.23.13.22
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a0522cdaf3so541724b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168001; x=1793772801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IRjsDNZddjHeQux46dUH0hIMw+KGNp7wvDbgiBTkyPY=;
        b=EpEzGhg+vyrp9czSez+7xQmA7cUtULfns45u9OnXIZfTRmZsSJ1F20qX9TSe2clseW
         Y8QKyPcY+v1woNodxIBFpB4y3LwVexq3jRO7l86IUtjBhWZjCd5d/xdDswazzQhkmQ1R
         IoR4yk3xuF6o2uXgfJ4+JwX/PFs4hq8cGW6Bw=
X-Received: by 2002:a05:6a00:2304:b0:874:32d1:d3d8 with SMTP id d2e1a72fcca58-8a6e78d00bamr1202260b3a.21.1793168001304;
        Tue, 27 Oct 2026 23:13:21 -0700 (PDT)
X-Received: by 2002:a05:6a00:2304:b0:874:32d1:d3d8 with SMTP id d2e1a72fcca58-8a6e78d00bamr1202244b3a.21.1793168000841;
        Tue, 27 Oct 2026 23:13:20 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:20 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 0/7]  RDMA/bnxt_re: Bug fixes for RCFW completion handling and verbs
Date: Wed, 28 Oct 2026 04:33:57 -0700
Message-Id: <20261028113404.33289-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Hi,

This series contains a set of fixes for the bnxt_re driver.

Patches 1-4 harden the RCFW command path: they clear a stale response
pointer when a wait ends, honor a completion that races with a wait
timeout, ignore CQ error notifications that are not command completions,
and drop completions for cookies with no outstanding command.

Patches 5-7 are independent verbs fixes: reset the cqe pointer on each
poll_cq iteration, remove the shared page mmap entry when
alloc_ucontext fails, and bound the FRMR page list by max_num_sg.

Please review.

Thanks,
Selvin Xavier

Saravanan Vajravel (1):
  RDMA/bnxt_re: Drop RCFW completions for cookies with no outstanding
    command

Selvin Xavier (6):
  RDMA/bnxt_re: Clear stale RCFW resp pointer when wait ends
  RDMA/bnxt_re: Honor a completion that races with a wait timeout
  RDMA/bnxt_re: Do not treat CQ error notification as a command
    completion
  RDMA/bnxt_re: Reset cqe pointer each poll_cq iteration
  RDMA/bnxt_re: Remove shared page mmap entry on alloc_ucontext failure
  RDMA/bnxt_re: Bound FRMR page list by max_num_sg

 drivers/infiniband/hw/bnxt_re/ib_verbs.c   |  9 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h   |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 73 +++++++++++++++++-----
 3 files changed, 66 insertions(+), 17 deletions(-)

-- 
2.39.3


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994083;
	b=c7Fj5rmslvDHRIRWnLkSXO8mMcCPSxOVWowfTN8F+g+UPRqj2swug4guAwHQcmGmIl2X
	 8qVWXmF+oHqt+kT0H4KdS60bemcNxzgB6nAUbL9lGjLmVbUwz7oDEUG9SYo+g/0UbU/bZ
	 Q/1wDArGRE3AAfTLo4MJtEEna5ZRA0g6udmEO0EjCUHb8K1/ZiAw4jHOMhNe1OFhPQyVs
	 jBi2Rxfcp0uPIfLRBKYJuBFgOXhaRVP3aPF9x09PQ7HHC0ukz2K0sjALuNb90Z6nItnUv
	 C5sRGegceWmhFxeCFBilkcS5bTPS/DhuKLn2pCB5KaUBQeGRRKA4z9fHmgtrSqk62wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994083;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=csphFTdpMBTVxUq8xSOjb1glIePwWhBgc2G/OqCCfTU=;
	b=lGCmEGn/HgORabY4uDvu3/VqnGLhkKKvi3DwaOQdaUVR5GvW37PXiwzQsLjvM4U4yIMh
	 bBrkdH7k8cj4ughM/zQ+nji9fZ9c8xDbFuryF63/CT1AAIkId2lTYcLLdo3eR2GDhx8rW
	 wrmkuziKCvw75lXsEouD/8uJ7o3/gdjnYDGu554655GkpzlYS5XCVKKf8WYU2oeelVUDB
	 yodBLP0SgOsiE4IsaLz1F0zPukiiatchn8ICRzv0Ruipd5TO8s8+ycurZHvcvqzFjxdKu
	 GL/90L4gcZSnumw6JtF3ooZQR5EN8z54FsC8rN6DZOiPEzodYP3v+Hp0EXXkRKYHFTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=VfDn5U2V;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B2606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B2B2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=VfDn5U2V
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-353804b591eso4906878eec.0
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 22:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792994082; x=1793598882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=csphFTdpMBTVxUq8xSOjb1glIePwWhBgc2G/OqCCfTU=;
        b=VfDn5U2VYNvV56jVfnCG8y6ecapaC3HonQmStD6pBkbEAl0RLz5wg3JDXS9n+l70h3
         lS70Ph3nrjso20JwYz2NZAMCPQJQV4vxmLikdYZhRIVxQ3mzssPNoZtgMt5WwJ1jeevv
         DL22UvA5sJ4T2xY1eAWfUei6w5iR+OH2D6j1o87XE3asVy6QNLWQ9ItpUNrbfl/8bq24
         kbx6UQfTHUsY3eN78kp0Qbz40Ps7wIrJn+o/CGam5nN+7C0Y90DIYgro4pBL4HP8f1Pi
         JJu+e0wAbr7gObXeqRvW2hTrE0wLJxEnSc7roEFnsuZS5bCgn/HqY5vMtPhMVLDWN41/
         ZosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994082; x=1793598882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=csphFTdpMBTVxUq8xSOjb1glIePwWhBgc2G/OqCCfTU=;
        b=TJRsuXf0HRhto+mHB3CzkQHag3yO7FKZdzmVS0oL5hTX6bqh9LfUTOvydxge8YwEMg
         iRB/Dw6+SUOh3a7bv73chJRljWoy2xkH+eZHZ7Ra+NI2AVKlheO4ZJOHffayZrqtt/e8
         0pPtFmiY5V2mshtMUp87B6Bv3glRT62/1phAxpcCrxp8Wob4wASzXSod6nnpX7wnqxRh
         EM/GqLcVXLOc7YjQIUKP65IyBahGCeEW3t8qgQLjH068wlpdQ/aC4XGiSfBfs9Ncqru/
         +gV8Qx70wbtNRDVNgt50bWQj8tvl+nbqF/4o0rIujG2IjlbpBGjIirCS8kJqVPkDPsat
         GcAw==
X-Forwarded-Encrypted: i=1; AKwUvBxJ3/ro3vm0pGJ8+VFOsklLz8+i3DCKvtz7Tg31Sqlqw2z/cyNvt4hP9VudwjbsSnF6c1A5Xt8Fv2bm@vger.kernel.org
X-Gm-Message-State: AFq9FYIfPiTArLyzNq0XNNU/c7IRJtUK6d9JXyhDjwclx8XVuRGZferJ
	goYAwywaq94Hm/1K5Q/2eDUyy3RGqPDwaTOidIZME3kcgP7ods9dGWKt7q2cq1WsYuE=
X-Gm-Gg: AYBFou1GtbPrKpa4EzRciSJG1pCxwkTVKyfBXoJbIvnzPZulecvwk1jUX1qkimxQ70D
	C+Fp+DYPNruvZW1aU95mENKwtsEGnLJKQN56X+EflJlmPyukhfun+h8lnYnQFfJYIm1Gdz7NdOh
	6E8IzV8tnlk5VPAkBnyN7E7t2PFZi87ROCjpbDML+yIK4Cjx8rROAKUJoyvmmbNUlr3xW+Loduv
	yAUfuNVdpQ7gshgifRdrDSAyTKkibe2QXRIA52GxYPhSLPKWYFrf76y3Ui5VwEJINbJZUro9uGf
	CB7QHtJI8pYZCMzMuvwIJeAXq2ASEDp8E8cJZCFuzkh9EVnXtuD/83HLo04uZq6eQpEIClgYo72
	qwV3/GAzoKQp19S3koc6tkK1zV50HPDZH/cI9zdp2DDUeSJ4bMCSWJVqgzJGdVZS5h95fTwXm9x
	jQvgBBkJ0OxK5eZ/1w3t5bab8CDdeLUwHcFfUDTTAVb52TnuAV/F3eajn5IPXxjPhH8URMKd/dB
	hN4ISX5gUjrap7bw3gdZqfdB5WM0kcRXOnS/dzsWg3XaGprfYjTwdWcYg6h5VFq1NDihPWE0M69
	I/L7w+pnMbp6g9WrFp7S4rsqqdrQkaNg8igY3aDzqPY3+zpK
X-Received: by 2002:a05:7300:ccb0:b0:366:4c26:2968 with SMTP id 5a478bee46e88-369e84e560emr9111160eec.26.1792994082149;
        Sun, 25 Oct 2026 22:54:42 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d845ddsm22290613eec.11.2026.10.25.22.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:54:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 RESEND 0/2] RDMA/srp: bound the receive IU the target asks for
Date: Mon, 26 Oct 2026 14:54:28 +0900
Message-ID: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
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

The target decides how large the initiator's receive buffers are, and the
initiator never checks the answer.

srp_cm_rep_handler() takes max_ti_iu_len out of the SRP_LOGIN_RSP and
srp_alloc_iu_bufs() sizes every receive IU with it. The first patch refuses
a login that reports less than an SRP_RSP, because such a login hands the
receive path undersized buffers, and a report of zero is worse: kzalloc()
answers it with ZERO_SIZE_PTR, which ib_dma_map_single() accepts on a
virtually mapped transport without looking at the length.

The second patch stops srp_recv_done() from syncing those buffers with
ch->max_ti_iu_len. The receive ring is allocated once and kept across a
reconnect while max_ti_iu_len is taken from every login response, so a
target that reports a larger value the second time around makes the driver
sync past the end of the mapping. iu->size is the length that was mapped,
and the length srp_post_recv() posts.

Resending as a standalone thread; the v2 I sent earlier went out
In-Reply-To v1 by mistake. No code changes. Apologies for the noise.

Changes since v1:
1/2 unchanged. Dropped v1 2/2 (drop a truncated SRP_RSP): the floor makes
the buffer always >= sizeof(srp_rsp) so there is no out-of-bounds read, and
dropping the response would lose its req_lim_delta credit (per review). New
2/2 bounds the two srp_recv_done() DMA syncs to iu->size, the reconnect
case review noted 1/2 did not cover.

Yehyeong Lee (2):
  RDMA/srp: refuse a target that cannot receive an SRP_RSP
  RDMA/srp: do not DMA-sync a receive IU past its mapped length

 drivers/infiniband/ulp/srp/ib_srp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

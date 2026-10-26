Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992044;
	b=bw8ZJej4F9fzH9ni952DGG9wj1uIKDLv57dZQwpKN3RkVaijmOVBHtXYRwomLfT418dO
	 wi9KKQOPYCYsFyppz8ah0EzUh3PILNoQK+2h6/S3zeqH6VKCUGcqP8fKkGHzs84iUmOUN
	 7mAb+Pnqmc4Ha331mN1on1l+Mbly2SgZNvlODJ2mP0Ndu/QAdrc4uHvfL4CQ61ZLMjt1V
	 Ht40/cNohSkDYevkaN6Ix8H7ysRstEQvQt8eVjHlD3PJ5vLmtHjhNqyYP46f3CP9eGsvO
	 1dqIffAxcPXLhIfMP82fyMV0cmW9BlpBbm8zuee/TlrRErEM8LR1DhiIxiRDrDHymeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992044;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kFxDNEtLaJF9FbohY5ofu4rvslw1141Z4oiCfeRJ8oA=;
	b=eFO2skLyO1CB5/gsC4jZbEr22XrR3raNA0AgXctAWZrEJKdVgOgGjgcHF8VtTh/uDiN/
	 rxckB9uGuacx2JcbaoKYvBcRtV/m4rVKoe6PGCueII9ODyQj1xN6f8b/b6dE3n+YwFX9A
	 tf10OGOv1jse8p2OFK65qi4Dw8e48pkFwX/qdOLaL/zc7vt+G/WJuWP2ynRE5ZXHhirgw
	 HxAq6PM3ynOm+1jZaTp9ARwzlnffaZpdO1jwYC1tPbNpl1/hPHowfCELjEdAI/Aah9TaF
	 q82qDl5DRwELkDZgCd1LJa4yhZfRyDXJ3HGUQgIRqbjIktSEZjNlg9kdxhqKM2V1EBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=BaNVFCds;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C33B606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C33B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=BaNVFCds
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1517bda04a0so2661163c88.0
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 22:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792992042; x=1793596842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kFxDNEtLaJF9FbohY5ofu4rvslw1141Z4oiCfeRJ8oA=;
        b=BaNVFCdspruHH8GA8OXuVxcDRo7VDhd5uMp2O+cGb20fDefa4YtsvUN6OVZiIr8SQu
         +8mJqMDKykefwy6jzORLyZsw7Zf5Dje3yb5UK4BEFKGn+JU1NwWitamExQ+KX8I2jaOU
         urCfUjq7f37vTIcq1E46c2mxxTBTN9v2u1KfH4ToPmfQxVCu4B01/tSmvXlUo/mUDNtS
         gzF+iv7jOQooNRGVD2yy7iknYgLRdN6iOBjkJfgozq01QS/euJpAPzrQxck3l+y+jCp0
         L638W4cZYZPWxWbUuoBYDWpMbzqrGP8DXhEx83bK/Sc2Sdi8dWO8OmfeoCrn+01qm9Lh
         QIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992042; x=1793596842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kFxDNEtLaJF9FbohY5ofu4rvslw1141Z4oiCfeRJ8oA=;
        b=H8Cf4IkqEt5rDWD+lFAismiZgPsZPrOEfcx/mJY8LFjes/sCssyRYIEpRjS2SHA9Cb
         wFQuQdW2N+/tZQeeh4KLIs3FGQDJSf4ufWFo8e+tdhg6h07g45t+G0MPaHH+e+pC3D7y
         fnBmDDWI5E1dGI44hVFSqgqhNpNKF/n/bAptJ57Q9NgX+qrnY1+sVnKJ8qGt7VFG9tYb
         w9dcXB2HSC+Jg+GxmyiYb+1FiiPaaG/h8IkqX+bCz/nHW0IoRv06ffiAYSM29AzCYQAs
         a5fGZr3dMKV4m8iSW9h7znRnQB1mNOC77S59hIwmJvG28Qbnrc8Eo/84xUYGVr4y4QyR
         X3Ew==
X-Forwarded-Encrypted: i=1; AKwUvBwSS90lTuIBa5clESVon9wO9CX7w76Os6NeZZjkQgfL3zYRsv3W3gd1T/WZI8ESgHpRrBybnM4CTauO@vger.kernel.org
X-Gm-Message-State: AFq9FYKBGCNRzhGN6nXPU+P8oZQOSpPUycg2CIkaenNXVaieCh0AVQtM
	eLXa6kdZ3f9JHVIFggPQ/Di7hM+JdWh1+use02mGwmVgfhTsjH5Wa6pjDGwtteZ2psM=
X-Gm-Gg: AYBFou2kqaniWW0tT2qKr7t3AqIr8uft9w63L4bvjbqqsR9KwtE3MgSNsv4agqq37vO
	6G9Q4BQFG43IV0kBhA7G/WuF2PH2iaUEJ75VL4fghy5gdIflRZOAbvTPUQOQ3lcqRXL2bYx8HUz
	vsj4LgIolYcwQDUVPYWZxTuftbn8N14yPuyLIJrhNIrISG2tx1lpJdXUtGmik0DukDfqaCI5LKt
	vAAgB3eE+oPFJvYL4dzc7c/GuxnjPrrnBQKcWXxAceGFyoVIhMWxx+4PD6Rd+6FKuYs21WtxmKw
	Y7K+8JzrHMeEtroAX2hji65+dogPSmV+zJFbwpmSC1AK56R6XL4ZaO1lS2HyvsT6T7+PltDI5rW
	Re5WzWbLEPhh1Tqw5yM1YEfNTYFSd8BJuAcv6edgIKVHw4E2m18ccbx4vk1ctqAANskfaHS2Pfq
	usOwSJvEhO6wC5mPexKcs0y8RRGztYYYZc7eYiK0uTxEQIwNk99X5Mv5W9NXVNmhE7WCgdX/wkQ
	dw6QA4/XygERar75re4MVvA7aO4aHT7FM0cczjByG0BYZKm8CwztIIX0j7OQnxHlY6OjRNT21EV
	axOU5oQty9Vp64MP5ksaSqm2Z8lFjR7psdzmG3HsBdbmfRwkLQllq2oCu+pF1opiYly2Yw==
X-Received: by 2002:a05:7022:418a:b0:151:2e62:fe6d with SMTP id a92af1059eb24-19935beba2amr11889083c88.22.1792992041815;
        Sun, 25 Oct 2026 22:20:41 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0f83cedsm26765774c88.13.2026.10.25.22.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:20:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 0/2] RDMA/srp: bound the receive IU the target asks for
Date: Mon, 26 Oct 2026 14:20:27 +0900
Message-ID: <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
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


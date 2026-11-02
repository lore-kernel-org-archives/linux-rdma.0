Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600387;
	b=jJsVFB5PEe4HZV89ap85Z3vTAf5A3AOWUGiA0/7FEejM8VG2qXgLyYpXYkFolEanTJY8
	 wp8eZY+BfIxDAs5sQKy68G58eAKp+cnGXSCy5VxA5AwfW701kUqKW69Ov/23VrBz0n5r+
	 OGN7rGa9QcEdfa01b9PCc6fSasqlq1l/d3P0dMl5iyMPs9Elx+obfpihIdZKRDqF0ao4s
	 aiq0aogh0+ImxVUqf7CSvjP7toIeHoiEPc7dlG0NLLYTOYM74pfV89uIM35vO3oqDGtV/
	 /OwzD08kHvtTHny/3IChq3xmIxCV+WsZhrJPkw81YBW+xUoMWB42+gD7OzbWDcvkBgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hhQA2nqnfR/ndnC07pGNFH3CL1SQgHrxqNYm+C24yjU=;
	b=iL9fEbQy/b9Cc3ERPXLcy+fsXOMKMLnWOoVFI32SHWDW14NnUQyZnvHmrN07Ig8ZEMGS
	 BToTzShBvsSAlqPjR4dyo8BJ14mkXHVkZamU/kpyz3AIsCAH9uUR32A0wb3ZRj7ub9QJU
	 2/GYFJz+VIL7NXRWssZZdYO0PYttnyCRD4TFeeRExRVUjWB2hPE+U3OHLlUzvZEfB7kxB
	 bJ1JG3EfCI9odSLMeMr/qwoaMT+Gzp0LnbMTkad3ZFgK0pxaFnp9HOdwalbpvl1O1ao+5
	 emKKxItcZTW2hSVV+EILRMdFQUUIl5CtEnJ3Q33aFgYwDXI0fUjWoZurQ3xQE8xJMbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sQyRLgm+;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E54E606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E54E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sQyRLgm+
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac451e128cso1565934a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600386; x=1794205186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hhQA2nqnfR/ndnC07pGNFH3CL1SQgHrxqNYm+C24yjU=;
        b=sQyRLgm+OdDyP4kgtLa0LSm+Ddh1xN7YgRjEbGmaDVJP2XJ/mWfWZAZ6cQXhRrgQLj
         QtQ0PA1C9XBxxVVANtsaixK2sdITqFW+ARZI4WDcrKth2//uy+EmAXh+GC4/p6r77TU/
         EVgkK5/v4yc/1W2AtgAfs0/WqIqivtXgZE5fMHHZuxc30n3cyRVo+StwSxGY76w8CmFV
         XY/Q5u2NBXDiAWlOBZ8J16FvTZ3Kz+mqUl7DH5NngnpajtukWu/XRVtqMYUMJxQzwCaT
         s65qDG7J5sUcY2jTT1O8K/1uFlkIAU34U/geHBRVJT+wNCcRJRXH5eq7MMcbml2P4u0B
         uxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600386; x=1794205186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hhQA2nqnfR/ndnC07pGNFH3CL1SQgHrxqNYm+C24yjU=;
        b=nYatpJRIpwdW4Tb/a2B8JxGK407FHo9w381+KUDbhHhfmMxlJCPgGGMtfE+VEaZt8P
         hzNgNM/0J2j2jDKGgDn+1dtYDNoKiqDbWHZy4DACMt1xpxy6HbckKPWN1Kpt6t89Ta0P
         rmZJhdDodhZuLGJfNrO1XnAMSI8ZAKODCi6VEeNFZdwhubh5VCz+Ej0aeR6qyGDJ29Ug
         uPG9CulWyHmyCwkVrnoYIB8VmW8NXz3saant1h608NWPSWFmqeTW12FZh9K1xqEg+4rQ
         nbOG/OHdKyXivHuqZyLRwaq+iNTtJ4+XYQ5twgUGOxAnXuvW1XGuxIz3mje2tlxpgpBY
         qxkg==
X-Forwarded-Encrypted: i=1; AKwUvBypKGqW30/TtNMrl6ga7gvuoOIbCF3gvZuM2vQ9pnbCvWn+vRkDCBCWOUPIAlQHdSBouzWylcmw5vYE@vger.kernel.org
X-Gm-Message-State: APuU4Z9CSGfvj9+rJbjeT0byouEYLzq/fW5LMTca1jOIpEipYyVoyXJq
	nCuJcj+k4OVRKA6DD9lQMzGb0YXV43dlR25bgCqlPmr1fcYvNYVhxpQn9wRV6CmjMWw=
X-Gm-Gg: AYBFou3GBBHk3BpPMZBYcd3aC4gQZnM7U5newnrwQIHI2RbLE/TZNQHAHmjx/qGw+m4
	ps8Zf7vipwXBhR3DM0RK1pD55OKfnoGIrHmtIrVyt0Hnf6Sc27lwc8SrHotyROeOeOteADfLIY+
	Y0xLm772VDJMMAu/dlwDbhhgS0D8V2TvJwz/0QCuhQX/1ZiDef7XdJPI9NNgWngno9vJjtBOvPG
	ITHZB73H3guLxtEZ536Jo8v/XPmLhsSvUYowPktwqNA4loLZLN0GZ4Pi6FMVviLxBRBykM5bC4O
	HCle0ZLJtSrn9aa2mTyxwdW3RGYUukPZinVhhwR+Qejf06fVpXK65xnak0nW8DtQUny5u8I9m+R
	MgKcFh+23LDfnIHJs/aVcrAncla5xP6hgv6QcVhVMlszhllkD4Wpa5fGBS6CgsGP/GDWLM1/U6f
	nPx/jjfXgxrPdk1NwBd9PrwdgBEbTlKeOEOks3Dso0wdPKZRFNP8OdJVJh0BZK2zZhrkEzitUur
	THTOY25ovmqvqu0myYGu5sFV4ymekYKZWqVuNY1vbq5IzPUv2BlUuf6rnuV5HM7hiz10/NklVcE
	ImQo4Nfnr0g2T+MJ06vb5h2EglKy4N8ENcsf6c3nDVVF69srDLF3/X/oCbfaQ7ucBPdb7q098it
	bQchaxTXfBBcat8hQt2xHao+HFRF6tq1hlZqL7ffPYMDmSi5r9hLOVee11Zc=
X-Received: by 2002:a17:90b:1b03:b0:3ab:2ad1:f10a with SMTP id 98e67ed59e1d1-3ae89287394mr6957156a91.0.1793600386333;
        Sun, 01 Nov 2026 22:19:46 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae8441a5ecsm12927752a91.2.2026.11.01.22.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:19:46 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/2] RDMA/srp: bound the receive IU the target asks for
Date: Mon,  2 Nov 2026 15:19:36 +0900
Message-ID: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
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

v2 -> v3: commit message of 1/2 only. The KASAN report now comes from
a real rxe connection instead of a KUnit harness. No code changes.
This is the repost after the merge window that Bart asked for.
v2 RESEND: https://lore.kernel.org/r/20261026055430.406487-1-yhlee@isslab.korea.ac.kr

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


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792928530;
	b=MsyXrN6cP6fVjKxGBgjgrl8mT4kc381GJ2KWCNwJeieKw5jUBqEV0qv+tAzCzQEfo3gb
	 62zUmIO3dH+/hLG/LZT9KgmUFBwl889009tuiU2mEgbInnQDriHNQIvQap+51HM12qNCj
	 bCaYZ/ajDEO98CTwYOV6rTFoJXHvaWGDetCIYkzxtciKr29XCP8lx4gYJ21bRiWZHpHtv
	 fJKDEHNx9Q9ZOMK8DzDC6NGxmq2f70F2LLrr1knl8yub9A1D45vWsi/TdVVsV4pIGdn6D
	 +RVRS2pktWKpnvRUKnyVg6goUqahAYRHxoCMMoEip2bd6WJ4T41U8St+1+RoIEAdPEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792928530;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u35B5SQb1qcpvcXotkj445EdYHZUkvnUz67+RJDCzCc=;
	b=QrjMZ6n9TCXxxfDLVBFYJIC4IGW8BOQRRnhF35nzmeXVotKynxhtapOoBzfeausFWxGW
	 bi7VAGA21+h10ieALmIvSCmuZ4iwpQ4o5soUn1OFzH9jPyR5XRzKuUHyB1Nn0dcqI111K
	 F3/LWaU6cJ8lkdnRI+lA4eg2d4FEIc0oBXwbGffwB4aLI1l6RI76m0HY5VLxxIPi43FAC
	 qISysfj3qUQHMg8YfBMFPRYOVpwCsAraFuXZ/h+4d6NNPYrH8WfFOY4o1XE+B18vj/o+e
	 +VLjfqrsleEJHcQc04aAYXspyu3fz14lWyeg3qGG9tvhvmlOOuofD8Rjh0pnZy4Snig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=l2rtSSMW;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238C5606A31B
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 11:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 238C5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=l2rtSSMW
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so1126263a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 04:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792928528; x=1793533328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u35B5SQb1qcpvcXotkj445EdYHZUkvnUz67+RJDCzCc=;
        b=l2rtSSMWaXnDzMXaCquNqLjnA7MzOiVWZPMTnCWT5DmKjf8LN/ohPo1IZwJwiRF/m1
         8tC7ZSdnjZV/D0YsrpbbK5RM/rvT6yrUdRWLPnPUma8fJnBzM9GvfuXDEbKQCiVH1y/2
         ZUSdOhu73mInLfAc6sgqNGIJ/rp5IlRDgW1PruH7bZKRbH+KA4NoEnnUMFnxVxR9rRTi
         cdSqYmbAyKuDW9i4zYPod7VTGNm6jb8S12XOPRN8QCuEuPAlUIasn3Oo2x+iGV5rY8pa
         rbOEeh8owVfz5U74G9r31hk8psv6H8K76AxlBrUXCqhss1EH7EK5p/SL+JDc/nIW8Qfz
         OwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792928528; x=1793533328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u35B5SQb1qcpvcXotkj445EdYHZUkvnUz67+RJDCzCc=;
        b=s2u+ZT3fRB9TS+lulatoLCURWso4k18JuIUZXQqnD2AOZCE6hlWiMD9ucSUpQm7IH1
         gWtZqJhUX9cr07EohAjl0DlT/JxqX6yBsUoaqVZ5oR71FnWp0+k0qPxrtCfkLTjXCg9e
         2u9Ea2dkCTK+zgd5VzDpMlD3a2LkdmE2F/mcN+WvFBdl0RYjqjqMRTMl8NQZEwPs+RVi
         PKeRCn5WPlqXPKICktRO34Jmx/eYsVd1dGeFI6z7pfsDHnyTj6sBG8JQ4abzjpDVzQj7
         bROGCt4SGBEDtlrPxwDJVIHeuAmc2pWpPABfg2Ksuf2q+YZq7ykMdaB01IN5MRwfrzQD
         Hflw==
X-Forwarded-Encrypted: i=1; AKwUvBwugYUw8baWL+yOTPF3+DK8iLzxlBEBqWYqOCTDhvqUUNw2RRNfI9s1BrJYlrRFnogWyxDmRG+WqGpd@vger.kernel.org
X-Gm-Message-State: AFq9FYJtprY5bXIsOvJAS5HUrcj0mXDuYjQCki264dn179O7galtzD5V
	tQJuuPztIKeFfm3ASylM1E/AlsOcXpFAScKdmOT/iZEE0tyC4I3S2ElkgukXB/Ra65jVOEqrDb9
	6wt/G
X-Gm-Gg: AYBFou2ADxYxwg2cChHCS/S3xw5zmaORCYK5If60oxpeelMQF3oobD9riEkBiJ9MQxv
	iwIHm3YbozaOpx0HtIXDY2P+MsOwNgKflbnuhmJyJYg0z5IpH/xbGnOQ16grkzWlYpSoOGnPyTb
	5oO554qT49wE+PiJBJAmXDR2LlOJit3MU+Pf7l1tBMG9odxTjp0k1u97fYQwf1ZZXRVez5N8I5i
	2cekLYmBU4yymLT/kEEIzTBJIUpP+vsxBL3fcoZwWHsfB7E05H+skAURx2cvkagyNM2271ppzJ8
	W0/i9ow0O0y6MP9k51OB3/jXPRhn+ynLOmWchrMu1MTplXdeILsgSpdPJF7czPjyXMCtWQpdIyb
	6agFrQOPIt0fhPTKsoHsKOMVEKBpnkA5jpMW2giHezfQdxJnweM+anYfKnQAp+Yh0gGwKi6pKVv
	msmWmpFctBtdRalEhc1qf1JRlZjzZgxKX4KKZb4QGF1afPKF8NHPrsAI6SvvB9eGNYT20z0VZaG
	5BEKQ91ABFdr/BXj5dCgQlGFsXnacpJWQZv2ww2LWBdzsPdJyn5k2CVfRLSEkXcFdaaXz+27pHd
	aop9FjKb14bxMloDXzKPz0kcGwd5oeZq8nWslShG2lqRF9uhthcU2FNN0t/bPAp6
X-Received: by 2002:a17:90b:5686:b0:3ac:9ed8:f310 with SMTP id 98e67ed59e1d1-3adeae64a6cmr3750286a91.49.1792928528101;
        Sun, 25 Oct 2026 04:42:08 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba32e38sm5219705a91.2.2026.10.25.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 04:42:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 0/2] RDMA/srp: bound the receive IU the target asks for
Date: Sun, 25 Oct 2026 20:41:53 +0900
Message-ID: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
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
srp_alloc_iu_bufs() sizes every receive IU with it. Across the whole file
that value is only ever assigned, handed to kzalloc() and passed to two
dma_sync calls. It is never compared against anything. Meanwhile the
initiator parses a 36 byte header out of those buffers, and
srp_process_rsp() does so without looking at how many bytes arrived, unlike
srp_process_cred_req() and srp_process_aer_req() which both refuse a short
message.

The two patches close different halves of that, so they are separate.

The first refuses a login that cannot work. A report below 36 gives
undersized buffers, and a report of zero is worse, because kzalloc()
answers it with ZERO_SIZE_PTR and on a virtually mapped transport
ib_dma_map_single() returns that pointer without looking at the length,
while ib_dma_mapping_error() calls it a success. The buffer then reaches
the receive path and the read of the opcode in srp_recv_done() is already
out of bounds.

The second refuses a truncated response, which is also what makes the
initiator stop parsing whatever an earlier response left in the reused IU.

Both have been exercised against an out of tree KUnit test on x86_64 with
KASAN, one boot per case. On the unpatched arm a target reporting 33 gets
33 byte IUs and srp_process_rsp() reads four bytes at offset 32:

  BUG: KASAN: slab-out-of-bounds in srp_process_rsp+0x757/0xbe0
  Read of size 4 at addr ffff88800243f120 by task kunit_try_catch/42
   srp_process_rsp+0x757/0xbe0
  Allocated by task 42:
   srp_alloc_iu.constprop.0+0x69/0x5c0
   srp_cm_rep_handler+0xc2e/0x1bb0
  The buggy address belongs to the object at ffff88800243f100
   which belongs to the cache kmalloc-64 of size 64
  The buggy address is located 32 bytes inside of
   allocated 33-byte region [ffff88800243f100, ffff88800243f121)

A report of zero logs in on the unpatched arm with the receive IUs pointing
at ZERO_SIZE_PTR and four receive work requests posted against them, and is
refused with -ECONNRESET afterwards. A target reporting 64 logs in and
completes a full response identically either way. The test is not part of
these patches.

This is an out of bounds read, and on a virtually mapped transport a
read of a wild address. Neither patch is about a write or a use after
free.

Yehyeong Lee (2):
  RDMA/srp: refuse a target that cannot receive an SRP_RSP
  RDMA/srp: drop a truncated SRP_RSP

 drivers/infiniband/ulp/srp/ib_srp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)


base-commit: 330517c63aa9b48227b6ab45f01003effac77ae4
-- 
2.43.0


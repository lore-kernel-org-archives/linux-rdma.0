Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795307839;
	b=oqhVw8cxk7UqWMIqeX/xiMnrtSEtIiQFYR+hqQOJ70BGrjWOOtVpwZBaqVdLVfcRa+dg
	 UZSX837DGw54ELbZHMbS+wG+/FCIyul4jTcMCYCr6GovC20bhYCMWkPoLqD0JvqlAkk5v
	 okVV6U7BrkxV/Sr8d9Uf1aurYQ7DdQiIuqJjbNfabviQc+XNpTnX0ghOKxVnxt1PcH6dv
	 +prMVDHuWpQ2M+57SteYGWxOhfrCEH1uaIUiwrXi310CEFOMg1O1TlzikdGVRFhIDmLxS
	 fwglVxjA/E94s7nX4dLmtIc1UOuIox5QWoFKZEIOxo1iIyVZAG/rKJRavaUIje7Jl4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795307839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XBP6UC2X9B6jrf4M1TaKnyZUBEL6CQgXTw6HsAQjaps=;
	b=BOPOOUyfJVQD+eSueKIa+uuVyAvhOAopNWxCQRvAPdxXmlV5RacnlqjkldDB+VDgnOzL
	 hPMdWyhlMkXXGm7YwMOF6/JPqakLJdXC+qCWYbH8aWhvX8yontM0TM+ooF6HbBUpcxZek
	 tJKhKLJE4CvMthRXJq4iR2QGlCfR9eg5hj87kriatLRj3OlC9GrFJ2orIBnBlm4iWQvHU
	 VzjDDlYeCfaH1BfUA5keC3J8mpvQk38OgrDiVhrohKzpNWiEr6kso4dipvWmR7/LWEK9L
	 sePF24NEJ/776jtX3d+T3261MyPxADqeaEIhGlI1wjkxSU/KScnHxQByKXVmpAFx1Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="C/2xP7hC";
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0282606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 00:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0282606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C/2xP7hC
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-9213922de73so36715856d6.1
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 16:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795307838; x=1795912638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBP6UC2X9B6jrf4M1TaKnyZUBEL6CQgXTw6HsAQjaps=;
        b=C/2xP7hCvXatO95/54I3Ppoxs8QJopetNEMb3HcvvvqX8uNMrEY2u7uLRfSh4ururn
         VQP0iGSwV3WajFjvqmyGOH81WXIxwO1C4Cbm7nRH4FrNAxhqO+x0rbJI70XqCPfyPWCf
         NHpp4NP6Yp1H3rUuyCCeAIAaJdGutH8gYCGvX7xcM1JrfZXDYo2t/HP9VarQNYX387V2
         MXQjMFTCntbs03do+ay+i7vtzJXWtAdY+tFL+m4PNN3724X+7USmCyEi1mXLwH+vI4jm
         +DjfrguSJcbsNqy9q+F9rt1Wyh3IZHC+hjvtgaS6qQIHlNa7IZBajS0RQW9BuaAb5Dj/
         V2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795307838; x=1795912638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XBP6UC2X9B6jrf4M1TaKnyZUBEL6CQgXTw6HsAQjaps=;
        b=K6udc5TgV1rCw9vJey3y7gaQBN3pRwC7iQ5ch2LejO6P4xMSfF3TBL0VcjvJJ2JgOf
         pGkC7rXZJS4Awc4vhEGq5Xpv+41RDkSQgEQ94/NlVJAhcpv1REpX6QrvJJEGBv3vsqmY
         rqbTyL0WCQVftPrPSmoWwLHvdAe0aLiGS/fn6cRBEiiDuSormLXASTr+k0AjRUbD76Zq
         6LQ07oeINblhAnAjpLUQOM+niap1TR6PPEakCh3zABHijyYN1OTsaSuLBXqyjSWY04Rx
         10UGCGKAvNNh7EXbJGpuBGfKjuZq+tzW+XPfDN74Uoq46zRfp1aLMV4OHH3bf/3+Arbe
         ycNA==
X-Forwarded-Encrypted: i=1; AL+hErF7M8F7xQTzfym87ClJQ989eW1um484onLL01ZSr+c+hLFdyJSTIRXH7LuTgx7wzkX/t0jXp52A9ru2@vger.kernel.org
X-Gm-Message-State: APuU4Z/iHQq/fmo1vWPTRNf8mubX0jUv1KSYQCt2t3f3mryOBv3sJ5dn
	iqNQT1WmsNMjjjoZV4mTNXvWye2D6KLi85YqrCMUlTgOwoDH6EiLaxh3
X-Gm-Gg: AZFdTZfq++fvfkpS4ltylVQzBNmyXO8txLQGmJibsczqAkq95rZEfo/9Pa1h1s1C5yq
	K7I2ePa0ZeJdg7PtxGngNgP8y+N686sgVC4dWG0GPwkJOzugAdPBgNSFdGDvIz6DDJSJBSvbYs6
	AogCdhJKPu9KLPklHLY8K7NG+kgaZd9aZqeekRM1plVo8Tub99kY27e5PP3k15tPkBVstPXmBoX
	YJucXKAE+0L2i05SEyAcH086RFjBbrLuP0fq75r24YPX74G84eT2A/12n4xzDZ3UJ8HgK5njEUW
	2e5O0+vFlrPw2KLO+sAUIaZMuc/Ga2Cg3GsMaC3tcKDTVRHOIVTW69E/NlymahfXdIYlrk5mZln
	d7KRmIBrRST4K31yasFBb9iT7jA/E84C+MgbjYel7YW3vczRzil3CbTRmatlbWxuK3sJKkc8JZ/
	3Q8h3Kb6k/TY5itP4WvUmxB3P+wNDkEcJccV3rtXdKR0lSk4ZtXqKq3Kuy6f6mzrmnTL2Eo98r5
	T+1Ssm2lQRJT/i1WP8Ov90Lue4HbB8FZk7Y1UnaBuPSOYSxtcOicnWpOFQrCco+6i+Q30/Mr/4I
	MrpyOcIIsSREgwXa6W5c8k25gVCdyZD1Sf1ncqsYRtKjIM7ShAoDS0nwsJLo+Cn36gk01pv0b69
	ydWi/JCLxY0rg7KR4agU0wMbCvivErmmTzzLK7kQHTJgCo3LC7DPDX9P4ZVeSI39CFgvodK+n0s
	P3Jkax05VR83Bv5Q+i9bQHLWaBKQ==
X-Received: by 2002:a05:6214:48b:b0:921:282a:9705 with SMTP id 6a1803df08f44-92134b6339amr129379476d6.57.1795307837751;
        Sat, 21 Nov 2026 16:37:17 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c8ee:a73:9097:862f])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349cd592sm66992346d6.16.2026.11.21.16.37.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 16:37:17 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda@preferred.jp>,
	Daisuke Matsuda <dskmtsd@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/rxe: Fix the copy offsets in __rxe_odp_mr_copy()
Date: Sat, 21 Nov 2026 19:37:11 -0500
Message-ID: <20261122003712.91551-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
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

__rxe_odp_mr_copy() maps each page it copies and copies to or from the
start of that page. It uses the offset of iova in the first page only
to size the first copy, not to find where in the page to copy, and it
does not advance addr after each page, so each page is copied between
the start of that page and the start of addr.

Tested as root on rxe loopback (path MTU 1024), three runs, with an
ODP MR registered 100 bytes into a page:

- In a 4096-byte RDMA READ or SEND from the start of the MR, the first
  16 bytes of each of the first three 1024-byte packets were the same
  as the first 16 bytes of the page, not the data at their offset in
  the MR.
- A 32-byte RDMA WRITE to the start of the MR changed 32 of the 100
  bytes between the start of the page and the MR, which are outside
  the MR, and none of the 32 bytes at the start of the MR got the
  written value.
- In a 1024-byte RDMA READ that starts 512 bytes before a page
  boundary, the first 512 bytes matched the start of the next page.
  In each run, over 50 rounds of a 1024-byte RDMA WRITE between two
  other MRs followed by such a READ, some of the last 512 bytes of the
  READs were neither zero nor the expected data.

Each of these also occurred in three runs as an unprivileged user (uid
65534, no effective capabilities) on an rxe device that root had
created. With this patch (one run, as root), the READ, SEND and WRITE
tests above returned or wrote the expected bytes, and the 50 rounds
returned no such bytes.

Use the offset of iova in the first page, and advance addr after each
page, as rxe_mr_copy_xarray() does.

The issue was found by Claude Opus 5.5 and Claude Fable running
Quality Playbook, an LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Opus 5.5 and
reviewed by me.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

Tested in QEMU on v7.4-rc3. rxe_odp.c is the same at rdma for-rc
commit e7732ec135b5. The reproducer is a libibverbs program written
with Claude Opus 5.5; I can send it off-list.

 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 9d27244f89b..73ed4c45fea 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -211,8 +211,8 @@ static int __rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		page = hmm_pfn_to_page(umem_odp->map.pfn_list[idx]);
 		user_va = kmap_local_page(page);
 
-		src = (dir == RXE_TO_MR_OBJ) ? addr : user_va;
-		dest = (dir == RXE_TO_MR_OBJ) ? user_va : addr;
+		src = (dir == RXE_TO_MR_OBJ) ? addr : user_va + offset;
+		dest = (dir == RXE_TO_MR_OBJ) ? user_va + offset : addr;
 
 		bytes = BIT(umem_odp->page_shift) - offset;
 		if (bytes > length)
@@ -222,6 +222,7 @@ static int __rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		kunmap_local(user_va);
 
 		length  -= bytes;
+		addr += bytes;
 		idx++;
 		offset = 0;
 	}

base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
-- 
2.43.0


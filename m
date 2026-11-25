Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613172;
	b=W18SWNQqPims737Tr/QMEa/JsAOGj9Lljo7Q3VRLDZbPBN6LX4bj8VcFRqhP00coyXAe
	 T/T3EXGyaoAWZGoDz7bvnWW+fuBmjXoXqj+Rvv7tTRreXdaoEQsvqnNA5VbFLeIM6bOhi
	 srKyGgJ2GeynzMNcuS+kQXmR4jwBUPPos+BWAxkCpTuCi/Iao2WSzzaNM1+ndrgxD6S2n
	 UXF1zkZOUoTbJCF9LGOvfG1bE0G/hKAentfT7pTVdMWlcvWZf14KoPCMoeRUNiAv9k/aU
	 CABunu3+eweOj9srKaKpJz/N1jThcRJ+OAw2Rg22HgYKlpVxpVKa2mi5+bXypxPbm2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o7rHexeHj+vCB2QshFklwCHahWTd+0U+7e2vWqXL3r8=;
	b=zxCHEplrc0r9jfh7tJFCkudlZvcreF9BW6Qu+ZvY9+Inncvak/Yf7vUqn9qvw8/lsv+B
	 q4rlO8TwVKv+a6rn5t7tFmuuQle8c3iSAUUcxlh0hi8HrcfVA7bGaFH0EzR7Nxjd+tVEa
	 cZHll9T7BNWOh+m5e+M6+D2Xmomt0QOp83GvUOsSELE7hji+lWV0IpcPYlhtixmCNugWq
	 ygNb4v2xMMh7LLUT+T4ic6R/+dupZLRw0u8RhOvvgO4fxs4lQoJ6QT4rqLrSK8j/YY1id
	 UMl8LhtRMi1ry2jgyKSkD3ViPdRx2I2OmNsvoszqTAKDioAu7F2H7mV1LPgJyGYDwSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AgLXKBue;
	arc=none smtp.remote-ip=209.85.217.47
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3C606A330
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 13:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD3C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AgLXKBue
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7d2e43ff4b4so4629051137.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 05:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795613171; x=1796217971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7rHexeHj+vCB2QshFklwCHahWTd+0U+7e2vWqXL3r8=;
        b=AgLXKBuefEKZAenUhUtEAbKqyUonO4KpU9lkPjT2QKAdfYEXOVxF+Yk5NmgeEEyPLS
         djEHHWaDUXCV891EslYE4n0o/R3gBv2JnzSdoMizsaLNuTDn2efcRr55l5eT3QEH6J2x
         /fMR2hW2IFwe0cZQcB0EoUJ5goN/+POkAopoS8Vi/ElimgEfj5bTmjZ0bbt2erDYpJdW
         z1yLQlfIUxib2UuxlbJb9EPCeeDkeKDYbpuDXk4BbCy4TygcY8j1bnN9Dm5fCdfkcdbc
         MIUI3n74uWf1M/UqYj/OJ+4j3ARR5iehux1EF9Lm17QRYVff2PpPGJ1mJLNZyP/33Bzw
         P0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795613171; x=1796217971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o7rHexeHj+vCB2QshFklwCHahWTd+0U+7e2vWqXL3r8=;
        b=QWjGrDgL9jHwRpTRRBYUhYGugjyYsqmxq+a+Iw2r3Cb5akGiKJvyK03igdORzVASBf
         4p+9v2Nb1XL6L6oatvfSz0J31nqZgxI3+HJbDAhFQGmjdC1bc83zuD+QszS+TbT0Wsm4
         KZuX+OP3hKKNLBE+0wN6ftN095Npxqsgnc1ocOeT3PqsmjNUYA0OCII40yY7rZEGyXBR
         j9NqTyKcxXzJQtEo3F948Futqi4C/0Hs0o5OQpoyVgbQ2tUE7CJemtM7XT5B0/UGUGFN
         9aTYrYjCeVI5AxEehwoTpRRAdurrBe0NT7l7TROKL0d4eQbgyJ1IEF8wQTTLicfY5Mq/
         sgoA==
X-Forwarded-Encrypted: i=1; AL+hErHinbkUxwg4yRmMuJ4AKA4+RX5P9GpqfQOxOfl/tCultgc7ixM5diOwmvatcUeVnNg+LuN27dZiJ2c+@vger.kernel.org
X-Gm-Message-State: APuU4Z8l1El0Fzbdn3jPc5sk/1UxZ5PjJNFCaWoqldYtYXvvjvo0ZKgI
	tJMhPMo6+6vNgLFTfWb402JlrsrCWbFKpTZRv+MvZjm/8eQIjyGCseL5J3moiEUa
X-Gm-Gg: AZFdTZdW5+ydZY5ZDENoTARqZHLaKqhlsdkOYB/FULSLin1l5F3G9vni4ZsxtuqAnaO
	jGZ9oNot9+Fnqq1Kb/dRq6kpPi/iCyFJ2dDqOlqcXjfBcS126hiZq34bqRef8SnTd8bwjDYxVRj
	TjBszV4RPKwmFl0AjxpovdhhpD42UzrB8hY/CpmyBpHSHst8/ck6A5FP1D1jBOJAeXUdCnE8xdb
	Khij26T62XkQ1HXC9YaVyN2yzwxbPhDiRqZcAAetBdogmBFaEGKSTfRK2AXmztRJNX76Pw8eXNQ
	nLhb6zPFC4SjPQ2kdP+yPk7sLvU7L9IUaRbcaZ+ObDGkGRJexso+f2Jh2CG1eRHeAga2qhlZrJV
	1BW78AYqmEj0ssd1M55MeUePRXXxdFKtJ2yaSC/Lu1GgFyGuo3FbTasyIWyt3EDAwuzhxN6bgOt
	+WptMcCoaRD8v0VIGDrqGMWeb/ra7tUvof1eaWesU5GMftS/iHFVp1j11l5eVQgl/8kK+N9jK4X
	ObW9ak0SUWuCizee1rBpJn3bihG+COBubvWeB9TJ/YA2cWhgEt76UXBnXkUJmRE9nl14Jsu08gT
	MFTNFfLVOo9Lt91SHBkh6OSE8W5iYF9j90HDkSuMOL+FhQO8DgS3V3WcmMhsHRD041VfhVY0ODe
	7cazBi/mtytN+XVwoVrdu9FfG06BDJGGnt2Jgo0bY5MSIIO76am7QabQ0R/r8mu/6/bjErOkbQR
	k+zjzTlGvtdhkoivuLHHpg+C4Vdvo=
X-Received: by 2002:a05:6102:1489:b0:7cb:cfcf:3d01 with SMTP id ada2fe7eead31-7d6dba0f7f0mr7262935137.33.1795613171034;
        Wed, 25 Nov 2026 05:26:11 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:44ee:a48f:70d7:4696])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349cdfbasm163149316d6.17.2026.11.25.05.26.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 05:26:10 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/rxe: Zero the AtomicETH compare field in fetch-and-add requests
Date: Wed, 25 Nov 2026 08:26:05 -0500
Message-ID: <20261125132605.44412-1-astellman@stellman-greene.com>
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

init_req_packet() fills the AtomicETH compare field for compare-and-swap
requests but leaves it unwritten for fetch-and-add requests. The field is
eight bytes in the transmitted packet.

With init_on_alloc=0, all 200 fetch-and-add requests captured between
two rxe devices had nonzero bytes in that field, including printable
text. After this change, all 200 had zero there. Compare-and-swap
requests sent their compare value before and after the change.

Set the unused compare field to zero when constructing fetch-and-add
requests.

The issue was found by Claude Opus 5.5 while checking rxe for other
unzeroed memory, as Zhu Yanjun asked in his review of the rxe_mmap_info
patch. The fix and this changelog were drafted with OpenAI GPT-6
(Codex) and reviewed by me.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
A reproducer is available on request.

 drivers/infiniband/sw/rxe/rxe_req.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 4f353abd76f5..a1e7fa48c665 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -483,6 +483,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 			atmeth_set_comp(pkt, ibwr->wr.atomic.compare_add);
 		} else {
 			atmeth_set_swap_add(pkt, ibwr->wr.atomic.compare_add);
+			atmeth_set_comp(pkt, 0);
 		}
 		atmeth_set_rkey(pkt, ibwr->wr.atomic.rkey);
 	}
-- 
2.43.0

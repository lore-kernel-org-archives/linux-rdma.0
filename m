Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640819;
	b=ct+yv/C4Zc+lZqNAzdpQPGP2qAr7qOyzuP6VdTKZecI4veC+aFuxsQ8Ugx8cappPkmtq
	 PuttcY4XC8jz8ar+no1DEtVYpSX9Nxa0XncbdqoK149NAuk69Y0AnX3XNIFHtoAI/1HK5
	 crPi8J6Uk8eTlbIwRJt8l8meMS0VIEfZB9b5fNeZiDpW9YELSvZAYDHjb+YKUgOAIcA0p
	 y8U/ATYt8tSf8mj4lyvFxjfK51qNyjtGDmSnU2Flk9NZYQt7qwA4MEKhAzLyBZgf6fZjP
	 L3qe/XTTU54tPuB4g4psF4csJsixQyuOssH9R8louuq1UZimmNbKCo1BUZLtHvpkI8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640819;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0jQLJmqmIBQ6in7lf/1E2WWXreaHdLkXv/DSKBgYzko=;
	b=qlnXIxiyVDo9+03UlK8PV9jThKnMsEKB7bSjwJrvczJj4fup6190beKaKz5V0whG6T/R
	 aK1odygsT7AAMrwpk7rEHdqDL2DKDyni2yr6OiJi/7dLwaTDFe+AajjROLbCmAYR7uS9f
	 Mj/Pj5XsWkTjYa3xpsQBNWc/mWaQCoGkPDcsLz/S5/WVvVeHRv74Kxl5m+2ajPJXQtyjl
	 zpbV9wv0J3m0QiOBSEO51viHtzBgy/kjuw3bTOloEB5s/YTj/G1fadxLEIAnNk9OOK9+T
	 sTJA78jXbl2g6hibDu0av0Q5mtHPH8fYIP8xjAtdeTsxLI8uzAFQI0bT5gYR1aYYRlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oCZSKDMk;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB786606A323
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 03:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB786606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oCZSKDMk
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3550c917fd3so1920302eec.0
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 20:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792640818; x=1793245618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0jQLJmqmIBQ6in7lf/1E2WWXreaHdLkXv/DSKBgYzko=;
        b=oCZSKDMkAZ03uxaC8hvG1XavyDMo/wWix60dsDlKdquTHLMNvr+57YAiOjkqq2iipQ
         +WLXM7KMF7I2+V6RoR/JYgTdFEr/NE8Qp/mZYNF711+zs9FyjnOIPfrm+OQDrI2lX29n
         +gZzgGcvjiKHu7cd9g8+VXCPhlhFt+F8mTdxOY6rcdJ7dAOtu4mLoGJOsFpPJioGci1t
         lWMjMZZ7rVXpUjFfnpq4rhgorkdlZW5wow0MIVHERPyniaPaPrA3GkURSjwVpB0wCDfV
         Tnq33121Ht638fCuYE5o2Y5uxqY2OWpVSND/oh7oKa7KF+QrzNC26pwfJn7DUNNvlmdU
         hWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640818; x=1793245618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0jQLJmqmIBQ6in7lf/1E2WWXreaHdLkXv/DSKBgYzko=;
        b=xT06wEm/UWz6AFgQVRH5hB7ryRv/G2BOzX/4u/AKWRbgiDGhxq8QT0lHdbvvR0w7im
         8TjlsFXIH434iJ6yfjp9eqbvxrrcxoe0Q5zadi4YcjjIsP0J73vtArAXYdl7Hz2KmeAh
         iTHPQ4hXu1qseyPZJ1rIOprsiIv58IELowfwCrMQP7jjzeSGvUbCj1PjbWnjkO+qBOir
         svYmjQRlR+7QMtdxio1uM0AIqtwUppeNzVIxLukLy8ja3Nf2V6Vbm8+x6bA3Ei4tFfGa
         II0sNR62/22HoXxtf653NlcGWl7QHWvMjCKL/XDYbloAMhRJ40EMkrejlHI8eEKyb2q+
         USrw==
X-Forwarded-Encrypted: i=1; AKwUvBxCKDDfZq/pIMjWFzuBluInQVaqA8ycq1wwVx6jMn6rjZK5U+t5hGdNrTFsDde/H+s9u5U02hrSzchW@vger.kernel.org
X-Gm-Message-State: AFq9FYKUQBOWPn/EKCrfmXWlNtwwio5LMTqhYpqRe1ZKMsAuzDGbKza8
	JcFHbtgp0tBM9FLuZkeX/kdg5kR9lU+s78Oy3J5hHXch8GPG25Z1pW1H
X-Gm-Gg: AYBFou3QzyW7bcIA9MAW7SIwBEKTxJZ/9Eez33Oi1aUdotfRxQ9X65UgZCibFlFTdhH
	J9hB9/KUcqq6hpvwOqBlBiiVVfjFDgPyttf1ArTRvBzx2Hqv3g/jdmWM+AuNiJKjYQ1BUXIvXfT
	niJyCBDRLP4nWqEpWOrk0ekxUF6G20tUvhGbaZdzuC5xAohpDbQ1cr6pp+gMdZA2NZxpnB8h3g3
	9LeHb3anMu11MPSZ4ucjRPWwx2VtUYhRnOdKocMwx9j875ELjJET0DFgFPPRy1Po+0zFY5lBovX
	zm8qTOMmCiazfZd48LbI6Pk8aXmCPunWqY/bp8mRv0xDcL112Q0+GuoD48TPD+LSd4Vo9QF8KaB
	/h6tCjeCXtvbm6EVug7jCCLFApMGcklIEwT6887o347fCW2q2j7hycFRIZP9uTwBEYzYMegJrns
	GW7YndV2fsqzJj1R2BKRhnYyzS60Vi2fFxZ0U6h933XrohpYK3KsVPEQT7n0M0sbn7j34EuauMM
	+7IVWDaTOAJVo62/7hRomakzHaNS7aWQYdPmAyXrTed1x0ovQKeopcX0mG9hL3QW2E8n+fL6xvc
	I7i3OVwZ+jvFnsFMdYwwtIarsBVxTQp5fNM39VdZACA=
X-Received: by 2002:a05:7300:c001:10b0:367:41d7:9deb with SMTP id 5a478bee46e88-3674d757a7bmr5710810eec.33.1792640817604;
        Wed, 21 Oct 2026 20:46:57 -0700 (PDT)
Received: from muumthf.localdomain ([123.215.20.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc848fsm12055038eec.13.2026.10.21.20.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:46:57 -0700 (PDT)
From: Hyunsol Mun <muumthf@gmail.com>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>
Cc: linux-nfs@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bobtobabz@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] svcrdma: silently discard undersized messages
Date: Thu, 22 Oct 2026 12:46:29 +0900
Message-ID: <20261022034629.430954-1-muumthf@gmail.com>
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

RFC 8166 requires an RPC-over-RDMA message shorter than the 28-byte
minimum header to be silently discarded because its XID cannot be
trusted.

svc_rdma_xdr_decode_req() instead returns -EINVAL when the fixed header
cannot be decoded. svc_rdma_recvfrom() turns that into an RDMA_ERROR,
whose encoder copies the first two words from rc_recv_buf without
checking rc_byte_len. A zero- to seven-byte SEND can therefore return
up to eight bytes that were not supplied by the peer.

Check the complete minimum header length before parsing and use the
decoder's existing silent-drop return for undersized input. This keeps
the error encoder from reading beyond the received message and follows
the protocol requirement.

On an unpatched nfsd-testing kernel at 764ffa45f3f2, a two-VM Soft-iWARP
test sent 128 complete 28-byte bad-version headers over connection A.
After closing that connection, it sent 128 zero-byte SENDs over
connection B. All 128 zero-byte requests received replies, and 56 of
those replies contained the exact XID and version markers left by
connection A. The test process ran as uid/gid 65534 with no effective
capabilities and NoNewPrivs set.

With this patch applied, all eight complete 28-byte bad-version headers
elicited replies. A zero-byte SEND and a 27-byte SEND each elicited no
reply during a five-second observation interval. A normal NFSv4.1/RDMA
mount, write, readback, and unmount completed successfully. The server
remained running without an oops or panic. Both x86-64 kernels built
with GCC 12.2 and CONFIG_WERROR=y without warnings.

The vulnerability research and validation were conducted by members of
the Tobabz team as part of the Best of the Best 15th program.

Fixes: f3ea53fb3bc3 ("svcrdma: Use correct XID in error replies")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hyunsol Mun <muumthf@gmail.com>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index ed5a83e9edd2..f2fbba4b30d4 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -714,6 +714,9 @@ static int svc_rdma_xdr_decode_req(struct xdr_buf *rq_arg,
 	__be32 *p, *rdma_argp;
 	unsigned int hdr_len;
 
+	if (unlikely(rq_arg->len < RPCRDMA_HDRLEN_MIN))
+		goto out_short;
+
 	rdma_argp = rq_arg->head[0].iov_base;
 	xdr_init_decode(&rctxt->rc_stream, rq_arg, rdma_argp, NULL);
 
@@ -758,7 +761,7 @@ static int svc_rdma_xdr_decode_req(struct xdr_buf *rq_arg,
 
 out_short:
 	trace_svcrdma_decode_short_err(rctxt, rq_arg->len);
-	return -EINVAL;
+	return 0;
 
 out_version:
 	trace_svcrdma_decode_badvers_err(rctxt, rdma_argp);

base-commit: 764ffa45f3f2189cd86ec6d46d248fc0440507b6
-- 
2.50.1 (Apple Git-155)


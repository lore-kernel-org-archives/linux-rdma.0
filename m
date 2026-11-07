Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794025088;
	b=d3AD9cnafK+wE9e6kNr2PBTFNcXbSrMU9H/KnaDLk1UjBtuB+2D3TKZo7P094PGjwviJ
	 GMwXLs529Nzl98k0yjErb+BOSiYzuprg6Ol9sHx4MYcQM/PzT5NLQWufticAxhFMAcQDb
	 9O7cowc3F496QnW8YsDt/x2oYiltEwoPk828YrXIZR+FuDnymMcRiX+H/tVVnPccnthXZ
	 EvX4SpNJBX6wFF94lOVoZPermD0NTJP/l6qlNYFAttQbrUrYjw3xCnCegSJdX6bSgvwko
	 YULc4mRD5EPU4mzPPoVXeFFQjV6G1OoeKKtw7dktD3gx5w0ol8S6OOc1lbZeHTPHnNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794025088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cuN/Wu6kktf8GRN0frnHoHZPEmUKd7TSmOYwdClsOmA=;
	b=f95MNxNbXp2rnbXmZ3crCpA2kokRMK3iYOHTGqftFSYejYjyGDUkRaElG2OTbhw7CrHw
	 fEDfADHie/mD2z7y4LMuwSqVQUY0u9kvvGjuEyARFcdAH29qWtu0lnkRuHX5/18lmTy1K
	 xgeeRL9M+z5hYKG1+fk4N1u8JFgJ0KWttlAI2r36NrLy4IBGMr3CiQoDNWIGcGyshs6+V
	 27R/B0Jl29w4Jl86u7Pn+ztUaDAM90Cuwge2xZ3sR3tAL+J9KlEYS+47+6YisSdJ4wkF5
	 SyLvrpGI9ErjTpkoXpVgHkRgQepvet+HIuFirdHwAChNhGtP5vfMi1xuam8P1s+wOsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b="aSOI3z/i";
	arc=none smtp.remote-ip=209.85.210.42
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D136606A32C
	for <linux-rdma@vger.kernel.org>; Sat,  7 Nov 2026 04:18:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D136606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=aSOI3z/i
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-85f39332862so19807a34.3
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 20:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1794025086; x=1794629886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cuN/Wu6kktf8GRN0frnHoHZPEmUKd7TSmOYwdClsOmA=;
        b=aSOI3z/ivB3dLGUeIFD60/qU+RZHCfSGJam7HUGnDYE6+Cxb0ESvpaauNmGnAy85CX
         fWEwhNdKw1xAwlpNmPmGfbJ2wb6OWAgDmSJVVbVTd++//Kf1luBFiIOGzM700MLMS8gK
         72gMqOTQ4KOv69G1T6Uk6xESdIEbXLQUQpMzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025086; x=1794629886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cuN/Wu6kktf8GRN0frnHoHZPEmUKd7TSmOYwdClsOmA=;
        b=HAbBj6Fl04aA63IuydXpXBlWmBav7FFT7FkYGpVjMOTn+JprpVR9eUS3idy1t+jg1U
         ieWWNbhxCDwbGIzJiC6f5L32H4ZPfUmk/14Vh6r8B/T4FslME6rKrWwf98zhkdmsjCje
         y2Xl7y9TAPiDYhsy6l6tJJ/tJzAsYxqx9yElxAaK9WzAH8EJqDaTbMOfGmW2WB0xdI9F
         58MJr3S7nRDIg/HUiRYHFXqslklnSKXgiDu8MtNHDY8h8OMYsl0BSnqmBfUaqd4TQyC3
         wT9BOUbCLbM4FlHoQLbVO3ToOhH0iNN8XJMzyi67tA7BJZbbR7tGzL1SP9rJOPoLXNz7
         Kxtg==
X-Gm-Message-State: APuU4Z+eA9jjGkemUDSWojOlafSEp0KYZBRIQW6NJMSIBszNJuxo5N0P
	ofPbS80K6c1ryEZz5nHnqFj3kcPlCDXZA6mdqLT2Fa4ej2UgdjsDny7L6dzZIfcBC4FUHxPnbsg
	pWxbJp5U=
X-Gm-Gg: AYBFou1UJfXYTc6sMmfPxJeWQPx4Dk7xom+CX9Chp1Di1YiZt4blIsxJqXfm2kqX4ES
	zVqG5cgCoyqGWPJS4NTwEwAbMErBShCq5y8Wr373OdF3Wh/K4o5l18QJE8VlPO/tHMTcTWUBhG+
	ITpmSPUzEe6tAUEsmJUE72qz1W0TCXZrkiHYY1aTfsVq3wkN1KXuIHmYVEFaH0P5/jQCMckFAAs
	B+AypDvIx7FD0h97hElRygCQiYsb3CVSbZX5tHpleBne8IJ6Bb+j4vXhLL+VY0k9CDEZbA1/gpG
	5mLWmrz/fW+ufjmblxWDhwZAJkGfyKeqmLWGhWu5MH5pCE0JwMPim5u7M67eUH5mX3RMTnDlB3P
	RP93aVSMze2BmAkw2lMfHRlLKNf4sKq2bITG2Y98LBS504+oXwUx2CFURigVSr9gqujrK1QAY/1
	ZOkLmR0CPNpGzTMkGOlXyvzlqw94mcjBzbxfll5XsjbCj4NHu2ElkB9FsiWx59neM8MCJdWjuAu
	vm1codr2Xdx3cPEcXDTwu/6sxv7wqV9Fpw37tZTow5OxMY8mYQZh0iNBk4BuBcQyUEhwAqdr88m
	Jp02qjtzaXxx1YZQRhScCKEUHGiR8tdFyIgMqHdPHmw5P2lT5NSkoH7D/YePx0dxJTxtbE7tpOa
	+kMKitDLCTzYKdvx4rTYhu6BdgrzQlw==
X-Received: by 2002:a05:6830:2315:b0:81b:bfb5:26cb with SMTP id 46e09a7af769-85f1cd702f9mr4751617a34.3.1794025086363;
        Fri, 06 Nov 2026 20:18:06 -0800 (PST)
Received: from com-75606.corp.openai.org ([199.47.143.1])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85f1d951a8csm3575210a34.3.2026.11.06.20.18.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:18:06 -0800 (PST)
From: Kyle Zeng <kylebot@openai.com>
To: linux-rdma@vger.kernel.org
Cc: achender@kernel.org,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net/rds: Do not unpin a page after a failed atomic pin
Date: Fri,  6 Nov 2026 20:18:04 -0800
Message-ID: <20261107041804.64213-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
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

rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
represents a pin that it owns. However, pin_user_pages_fast() can roll
back a fast-GUP pin after racing fork() and then fail in the slow path,
for example after a concurrent mprotect(PROT_NONE). The output slot can
still contain the already-unpinned page.

The common error path calls unpin_user_page() on that stale pointer.
This can consume another subsystem's pin and allow the page to be freed
while it is still in use. A local unprivileged reproducer triggers a
KASAN use-after-free write through an io_uring registered buffer.

Clear page when rds_pin_pages() does not return one. The error path
continues to release the page on errors after a successful pin, and
successful requests retain their existing ownership and behavior. All
four RDS atomic ancillary operations share this path.

The issue was found by an LLM.

Fixes: 15133f6e67d8 ("RDS: Implement atomic operations")
Cc: stable@kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
v2: Use the net subject prefix, add Fixes and stable Cc tags, and
    include the validation results.
v1: https://lore.kernel.org/r/20261030042110.73571-1-kylebot@openai.com

I have a reproducer for this issue and can share via DM

 net/rds/rdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 078090d292fa..71b57abb96c4 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -957,8 +957,11 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	}
 
 	ret = rds_pin_pages(args->local_addr, 1, &page, 1);
-	if (ret != 1)
+	if (ret != 1) {
+		/* A failed pin can leave a stale page pointer. */
+		page = NULL;
 		goto err;
+	}
 	ret = 0;
 
 	sg_set_page(rm->atomic.op_sg, page, 8, offset_in_page(args->local_addr));

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.55.0.openai.911.g06873a30d2f3


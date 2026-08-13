Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE981263F5D
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786599982; cv=none; b=hd5ocuEbNxHgRZLtbDocQslONeHiDC5v23gZKj7bXTrs+9GUOYudzb++gdVvxSA0PhmDkWJeumnphiHhknPmaocCS0QKoFdkskyRgQmDjFgsGDYkvnHvRg4LateaR3Jczx3s8E+tkQkDllgzrn3fmP15kjm+8tzNzXkanir8WBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786599982; c=relaxed/simple;
	bh=ST0fpKUIgscJ50ksF5VIES6iPl8iEv6qqQzFLLQ9TEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qa2pNclhOs/T+wf9MJhIIWg/gqGTZYFLJyeJVdwKxHpm/m7A309wtKGapWE9XajbdlT5prGKdSVHvJ+UjxWYcpd0laaW4BjU/4V4psh6P12VUvG4xX+0T6N9lbgQfERIzv+ftnxfGIQHQcA3wo4Np0f5/e4+YTQboPOijMT9VpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=o6JrZW5Z; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="o6JrZW5Z"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc891373e0so5213565ad.2
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 22:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786599979; x=1787204779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ST0fpKUIgscJ50ksF5VIES6iPl8iEv6qqQzFLLQ9TEE=;
        b=o6JrZW5ZwJAoQmWhNUeQGlSZJnXUWkhXm6aCwW8F9A56G2sdO5ZWrhIthyKX8TgGYA
         SutD6Nyi+QXqUFyGgfYwyHNihAJEoh5REgTNm4sLEa30CjbNh0Gi0rEQnGGlU/zH0Bpe
         NXAGSMJTk1e2KT9AE3VyPYEBQjkUYqHoz+njrEakqXkBL8ad4cs0NtwyjVX2ED9R61xh
         RYBBp4D072BwuCmIMzq9JVOQIrLxVMyrYxw+OrzH3HHzkS1N9R+YG9VT8d22jGeGca2/
         JNGqH/TbMzGIZyQeQ4aACe6ETPljpmT5NX4Zqfm7a+tfcSHCHHuxQTUzvFNm4dv29QRY
         VC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786599979; x=1787204779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ST0fpKUIgscJ50ksF5VIES6iPl8iEv6qqQzFLLQ9TEE=;
        b=j7n9UTYOefwi51mMm3t48m0xvUZRKo8ngHudgsy88rt5uoVr7xYm7Daqs7fGASbbFA
         K5IeQ9xasJFnNmrNb/SdDjceo2Hq9w+Db0F/U7e7osKMAOCP3XzbwkRbsUXWyKBlY68O
         MtSEdClGOubcakRLVi0rc4O/LGzL9cD66cVrfpaW0fbJyFoReKDuZLFNq1001iMhTZhX
         BBsKoARp/UgZ+7ZgFp85BFkwywZosu/EO6Vd/o5OxUfy7oJ/cXzohq8OBNltWkEPdnAm
         ntln+oYmtSfFdR/5ETj/7dmMqsy/NA7A8mmlWBtiZZFQgYyOX7yi48hynYDUiOgv3bQJ
         +u6Q==
X-Forwarded-Encrypted: i=1; AHgh+RqQBEoHF8/fPf2TFSvwI5w0eZDp5W0jweDnAQxL4Qr+l8rhTRaHn/Pcc7zvW4ORx6/6JZV6TDpd5UnX@vger.kernel.org
X-Gm-Message-State: AOJu0YzUAGwmV4Bv/ZwYDQzuNNY9JKMN03Qvpe32Y/Crvp3s5oFNq35r
	KZP8lOL5sto+0/PkD3t/ErHdBNUgpX20q5FOUt+yFnLbaWAAVvRLNer46jrjWJ3CSCAqhK+H2DJ
	1jA6YZ4s=
X-Gm-Gg: AR+sD13bKkrIq0l1O1cUOvMFb0Ay7o8/gqFbOaI/vOKQTtsriEKDrdHO3qWMjB6KxE0
	j1+27n0VpFdOhD7tfGNBPvVTyhh1T5V1i3+agTt/l2AEaQX9dMkWAiPQUFdhiTE+3Q6jiTYEp53
	jzvTRy+fXEnjynpjX0E1gQGG1abP4b0F+du1KK/dPyGxGoQGCDZ52u5v4FpaQxc/A+wZY/qWweA
	TxoRmvNd1mOR0FLJpFvbEsd53KJV9rx31O6XjPD7AyOafti/vzmHwU/7w0YhdMln0P/8qw6qb/r
	0/Atj26Mn8f4PmEgNzxNnGaJE+No8US52yPfstrhWsLVH5jSGrvBnxU4a/hpve7Z3gJP4ug6dzB
	0gYxGHE2xRaRo5TT4QcCr8uv/G6/RBPWACXHHURzDuxfmoUAUOb6nEK3Vgbgkwi1+4R8JbPftKd
	oTX/rIvXBAxfSLn9ExuOX1Hd/zwuOmt2le9xagEAjqbK57EbQePBJ+MAioF1RyaoLlJRE5JMZzt
	0CG7dU=
X-Received: by 2002:a17:902:e788:b0:2c9:aae1:a611 with SMTP id d9443c01a7336-2d37e9b04e8mr38033055ad.23.1786599978517;
        Wed, 12 Aug 2026 22:46:18 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c25e65asm4390425ad.34.2026.08.12.22.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 22:46:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: bvanassche@acm.org
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	linux-rdma@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Thu, 13 Aug 2026 14:46:03 +0900
Message-ID: <20260813054603.4686-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <a97268c5-74db-4238-b0f2-6ddd4fa5c37d@acm.org>
References: <a97268c5-74db-4238-b0f2-6ddd4fa5c37d@acm.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 8/13/26 5:30 AM, Bart Van Assche wrote:
> This change can cause ch->reg_cqe and ch->inv_cqe to be overwritten
> before the previously submitted work has completed, isn't it? Isn't that
> a bug?

struct ib_cqe holds one member, the done pointer, and this patch writes
ch->reg_cqe.done and ch->inv_cqe.done once each, in srp_create_ch_ib().
srp_map_finish_fr() and srp_inv_rkey() only take the address, so nothing
is written while a work request is outstanding.

The current code is the one that assigns per work request, and it stores
both srp_reg_mr_err_done and srp_inv_rkey_err_done into the same
req->reg_cqe, so a REG_MR still outstanding when the rkey is invalidated
is reported as INV RKEY.

Sharing a CQE is safe here because neither handler reads it: both pass it
to srp_handle_qp_err(), which takes the channel from cq->cq_context.

Best regards,

Yehyeong Lee

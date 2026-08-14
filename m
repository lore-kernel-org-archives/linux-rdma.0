Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915B240F741
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 07:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786692614; cv=none; b=XEZfNC4ExF/AHgEftRfuaXePJumxJL8rlVFu5KbBuY8/mWJuWpOUMhgn2pRSY4UR7Mailqcd643eDgePxSvQftTxAbXtdC0c08AbVYQu9uiMzQ+wYvJ0q+Rkcy2N+xlQivDVeeK5iiZGRyHrRRzU1U4+6VTIv6/Px6EynEteWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786692614; c=relaxed/simple;
	bh=sELC/ifOp6VfvcsoDyj58p7bK9nkK5hCzhfBdwzPS7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYp2Mktt2i+KHiel+RkRulR8x8zIDjfI1Q2WWTlp5GNwQ0w4D0lU8DPPfcgSIhdnj1hqxmWld7hGTSZzfxMEcows09fx+sX8ix6aMuuum6NzmoUpY6ibogyqO1zkpHqF6eC5cbu9zdbTjkyeWuxe99Cm+fKFP4OOhs3CSnqE17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=YZSHZg60; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="YZSHZg60"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbee846deecso746313a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786692607; x=1787297407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XQXPTPU+PNdJ/iyLYIhEbTPrnECpXC1+xUIC6UhTP4w=;
        b=YZSHZg60+TRsaLHXGfeqd75scGETnBNLVSz+5PODf289FT93HRFg8vdCBaCHq6UAd9
         wsAPO7c4rfhizjXWXoA71dqBkHJVu8bc7AcnGzToFVT2+9y433JXLEO69Y+vi25F5Jo3
         M0ZeZCXK3T2AQJMVakcL9+LA7xy40KFAKpZCgAS12RE3DJnaxg9VNormcs4PY/S2QYey
         RUuhOc1y/uyb7ZX1F677+iD3AYsEwtB+SXoeGLimV07sDNWuG/cSYgQESzDI1rieX7tI
         LqUwAyduOjc8KIIhXMnroX84vSFqDt3fVL7j7a+BRegDCoAicVcCtRbWPVpAKFgJv2lq
         +y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786692607; x=1787297407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XQXPTPU+PNdJ/iyLYIhEbTPrnECpXC1+xUIC6UhTP4w=;
        b=IIkG6rXsVf9Fz0AfGRvupGT68sO4s7rZllvDZk1Uk6Vp8KWyF+fncdmz+yM90SE/DX
         GrB3RO9hiSqg+PV6nfaalMAhdWIn8lz78wC+EKWNLdr5or+oST6I1X2CmuZCkzpPUAZJ
         ywpVdYRPZjTSvY8+RYpvp51gmpAP55NjjX94OGdIL7Qc3H1UXJcj3iVdPKRJBX6RX+fw
         e7GucLnbICgnHFq/Z/LBnwWbCHQKSqfuLBWF7KTLzUgiQx0JEOIZg36aYJSY4b1YGVt+
         fePqbzYh43PmfvvzJsEW38GXG6SVJyixe6RippWE1xDRA5T7Ncd3ExPY+gYrUIIChv7w
         1bkQ==
X-Forwarded-Encrypted: i=1; AHgh+RqOgCVeDCURprdKDgqLUjbr4KKIPFgZcrtMsC6TAQbTUWHFj/G8Gd853FkaXXpFyu75LevkwIzj7NqZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwkPA/475XHV008ZlHE3nYgbZ+5i4EMv7jOKu878nIbw+RZfgY3
	OGLEM1BDUiPCJN8zNa8DLOYFJCsufdPEc4ozrNk6W8w/7dEUwD27z69+9eIhKbGlpzU=
X-Gm-Gg: AR+sD12BVbfOTHBQ3Ri6dnw2ePuOO0Qf4m9IlzmAkRAB455MwEsshTmnb3n5v6F5YZO
	3VMUp18z+LNyVOWp2mWL/05hXnjJBRPGmGNDUdl9K+SOklGMpdr2T/np0NXNHrwTINzp9HlkozQ
	P99RQ0d1Lbvptd3MXPxf60PoiZWY/NC29EUlWZqQumgf54SM/68j15AJTiIEvTOAbjs0k9sldqT
	rU7O9t7O63q8r6PT5dtIoarRfReL6ARcW3Z+Bwj+KZSOnAZjaI0AMn69thYNOWbGFz4KP0fk/7v
	u4vmZlIdkrlE+4dD+HLXG/+ahipsg0wm1T7HLgeOFkyG8Hd3/tV2rE7/qDVp8ryap2qmtdEIiSc
	fo3hH6wVnLfdYUq9Qj5SpodXoRqLe0iCM+8c4lhoyUC4daemqOP+8DytTE8Xw/L1n1wX1JbTsUA
	7aE63Q5iyBZEsavF8Cxq/EPmTygyVDVZHWmwHeheFs8n+0Rg9qTjZqojylWQc/S5LrTIcC
X-Received: by 2002:a05:6a20:4321:b0:3c3:88a5:83e4 with SMTP id adf61e73a8af0-3cc71a2974cmr4140939637.10.1786692607139;
        Fri, 14 Aug 2026 00:30:07 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc095a3185csm116942a12.24.2026.08.14.00.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:30:06 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me
Cc: mgurtovoy@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] IB/iser: skip an unregistered direction on remote invalidation
Date: Fri, 14 Aug 2026 16:29:57 +0900
Message-ID: <20260814072957.268291-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814054712.260495-1-yhlee@isslab.korea.ac.kr>
References: <20260814054712.260495-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A note on why this skips an unregistered direction rather than failing
the connection.

I tried returning an error for that case.  It removes the fault as well,
but iser_task_rsp() then drops the response and the same invalidation
keeps arriving.  Under the same workload the target sent eight and the
unregistered-direction path ran 132 times; with this patch the target
sent ten and that path ran three times.

Skipping also keeps a bidirectional command working when its read half
was registered, its write half was immediate, and the target invalidates
the read half.

Best regards,
Yehyeong Lee

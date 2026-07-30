Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB935C68B
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376511; cv=none; b=YQW7kRO1PgtQpv1IVLlrr+zQsGi5/qTdrD4WcHGQl0lwnLQQrH0BcqX0HrsnEF067Jpcdn67y7xs6lit0ODc9uF+ZT/6LtbOj/0CqJGis6YZZmodhiZkNpFFLUxI3y5DeW9gm8MrYmmFrfE99poQHmpmuSxkmYHxaI5O63SJSco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376511; c=relaxed/simple;
	bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu2XOySbIesOd1joJ9CeNjsnb/WOFvh4E6TvTM+RAtuB8VJLjm1vXKUVk4DeGkXFkPpyomgJJp2oj7kumQdOWrAmpoUDsrlE2zBks+QG9St6+oL+YTFCzBrAy42z79bbhytgfyTKH5sC5qwyB/C+BSlt6cP2fevEY/CJ6xQHmXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Wnge53Eh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Wnge53Eh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso257839b3a.1
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 18:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785376508; x=1785981308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
        b=Wnge53EhdbKqkILElz5fl2kkSXMYaL6n8F9Om3qBRgGN8c+andpxw4US4VYdccXxl9
         MB9BAltkmbqtvI3iS7W82hYj20nutb/g0azAWvtrRrKvuZlWe8hpHThJkhBYkFAPDdWi
         0D9ZjKqPranNIrN/gICiEVpBmLtXAxHRszh6YnSvmHrtkECY21fTMyjM7ETvYMX0KEFP
         IPdqv/xGDaDNv82G6lZqXK9m6rc30iY1R0Nu+4IHsHiH9tjO6D4R90xpvbs/ZRE6YI4x
         AXwc6ovn7qC9q0OoQydaqNSeJCRxF34CJJVNoZ80Gr27JSAe3I1F9Zcf5tj/CNSB+2/u
         yTPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785376508; x=1785981308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
        b=HUW1o0YmciZl3vdgo6uVLcQwaC01GVtPhhLDU8o2wXkYYcDlffHZDE0T5reALjEsLY
         EbkHXm/fTrPeiIYJjGYFBEldF+yU5DjkKPr6D2pKSwT+5RD+av4VgCnDpNET0heokNZD
         QradU4jJJeM3Kh74F/Sh2Jd9MzwVJZdq1j7PN6KfPeQSGSJept/B/aicB+jcrWV+5yfM
         p2JyLn+0JxL67qpHnGO1E2BKuDbeLsSmePv4Dvzi+U/YPjyLhHLPQbNbFVa6z8QtUFXH
         GKIR2tmeCrMbnSbzx7TLrgAS3YYhh6iAIiPAncb0YHza4VnNZOP/eQeqZAKe56M1xZVi
         fOdA==
X-Forwarded-Encrypted: i=1; AHgh+Rr0y6HEyNtHtsJIrnn0RG2GXfQQyBj13oYNf880gx2TtcjNtOmkZ/RAn9oKFo/GYMalDYtmSMhjX7P/@vger.kernel.org
X-Gm-Message-State: AOJu0YxxDjhaMC5n5Gin949iduR1K8g/2ucVn5Grxa0GmCgr2lfXTzp3
	BWx/yZ9Cc4HDGBLWy1M5miFnYf4p3tS276ey0557faLyP76y6LnZo1RCk1WFEy1RcqI=
X-Gm-Gg: AR+sD10v3l7Vpex0nhL1vICyK8wTLNHA01ZOXWSrbX+rWsL9/uc1FCx7pu3mlKWt9Gh
	K0r0mwtdB+HZYycwvEfoQB5K3L3g4GoeH0uhwgMuXQRM38tPpZw6jxvt5bryJUUnjWkORR6FRsR
	lTk0oc5A8WAjAjKttJyp1M7JddQOQ3c1iHRHZdtnx3ciKGQDbFrGhfaZmoAgwDeqeQYjyuQTlyU
	nxyVYJoxN+2OGMpcXrwjFmH5YnFxKvcH9UVgqXdOP4hQAmwWeHG0j43GngCUK60y/604/zyXVsy
	Z7COKLUzQQTpaKGC7KuHgSWWZ1Z1QV7zm0glEe25NUfrjyePtH079EtWNL6CkWJ4Ozm3u4l8uWt
	ufKYrtP+Kwh4Sjxyoc5fyL/9B1EZj2YVPbrBcCsSGWs8Je4Ca06vlxTkJiQlzYubVVZgScjEkMZ
	gncZ5EGQzgbkWqSLMc8lJVAeGL8Fa0GW33Xq+mi/1umjgEKgJg9sLwkBE3XGDr6jb5Z8G0
X-Received: by 2002:a05:6a00:aa06:b0:84b:e69f:1b3f with SMTP id d2e1a72fcca58-84ebdc67bf9mr352039b3a.8.1785376508034;
        Wed, 29 Jul 2026 18:55:08 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm2192327b3a.15.2026.07.29.18.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:55:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: leon@kernel.org
Cc: sagi@grimberg.me,
	jgg@ziepe.ca,
	michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/isert: post full-feature receive buffers after session registration
Date: Thu, 30 Jul 2026 10:54:55 +0900
Message-ID: <20260730015455.1505508-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729130141.GN12003@unreal>
References: <20260729130141.GN12003@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.

On Wed, Jul 29, 2026 at 04:01:41PM +0300, Leon Romanovsky wrote:
> 1. Please keep commit messages concise and easy to read.
> 2. Include the full kernel Oops in the commit message.
> 3. Keep code comments to a minimum.

I will fix all three in v2.

> 4. Please address Sashiko's concerns about this patch.

Posting the receive buffers from the RX thread does leave the receive
queue empty between the final Login Response going out and
isert_get_rx_pdu() running. On IB and RoCE that is absorbed by the
rnr_retry_count = 7 that isert_rdma_accept() puts in the REP, but iWARP
has no RNR flow control and cma_accept_iw() ignores the field, so the
patch as posted is wrong there.

v2 will post the buffers in isert_put_login_tx() as before and delay the
final Login Response instead. An initiator cannot enter Full Feature
before it sees that response, so the queue is never empty and no command
can arrive before __transport_register_session().

Best regards,
Yehyeong

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541959;
	b=iRiew/+CPSbrdwN7XU/hOyNa6c9O2XwSZP+qK0+qwMnPz2rcNgpRY8m/HEWiUgfiHERP
	 GATj+/LcvqBKukJ++IWSwiof6OcehPfG/LUw3fU4IaQIAM1Wa1HXg4IveRNCJGHuM9lot
	 053jg6aGuS1MP1GoZukh8S1EbxEHmAg6Sxuw4BAeVSHTn6w6QdfrhnOo8CZbJ4GAQWEzF
	 Fca0FNxSwsx6Pe+VGadbPoGlLWiiDfjTRjiwhFbnjVCaZLWd8QesfjyNDIvKHnsyMOAvP
	 Xtyx1i6uvNy3YFYYHlfhTZn9pX0LDV6BZcDpAshvWR4cRHI5+s4xJU9sX3ch1JY6PeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541959;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
	b=2AAcbv2SUgaOfbu1iPkYl+7bfv91yTZzYHu8tMRRgmvp467gGMug7WwVRKT32HkrqoCF
	 n56+ttCwngnGqWxgOLAcUeaxpaBXhj1wHWesUl4FkUmrKZwIOlZJTc7QyGfp2b1utwD1F
	 NJQYaIUCP0NQ+KcMARZt8hXP9TPXTHpsOH56TctsPuKVgdT3nrWGXPqxW6wPp5JcyGmFP
	 R+hnKN343LWKhTmxhv7yGtYS37AYgvX7Jro7T6YESjGR+RnT6PXEwf2ZUmVOwvfWCryAh
	 0Y+IGFUPvJBVOsU5qvTausQKIpxeF8Yx8aMWYw1vYclDE+HbyqrttBrLsCCrYyDY7HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aTNUhhYB;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0C606A31F
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 00:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69E0C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aTNUhhYB
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a0aaa0fd13so121943a91.2
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 17:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792541959; x=1793146759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
        b=aTNUhhYBPXb4Fb5KI8FnGv/yl41UzhK7F9zKmhigXfUmtVeyLgADuCyMCH6nMOONuJ
         Q53U/g7I/R9frRVQWqeW6wCiR94UNCRDBaK9dn5+YyK+TMxBrARynGwko7IQW//0vyta
         FOuBfj4pIkPJIq78Wua+g1QbQi6BK1akPFDHpkihop7w/BwfBrP3s3t5gOtMTSiJszTn
         SbkA/pthRTVAhT85nxpEDBaea53ZJVfF0eJGSiP5icDzV6Rsyt4djG7oZb5ENUNpxyzG
         SgHHUX1p3GN7LO5sK01zDd8WxfeswBb2mHjdiQhAoC05Jb9lZBjFNHBgYdq0BUEuef4T
         fbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792541959; x=1793146759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5eaBZnDCVfRabxJIJDdDONm6fhD1rR7hUy8thDW0u7c=;
        b=sqbuA6lkqo9Sb5wSBAvYMJYBqgkwfSOYKRBUC3rWaWzHNhHJum7xnVx5VAgCIxBM5L
         7HCLwnYyJcwg7RtAe4I0HWN2oMWHHPyzFM551Qkg0Ze8ziHzLSgvubi5NfLWCIXehnXX
         nS44aS0VP2H8UwalIrv0sQ/yzWywx/AF4zZZ5XM+gxNQ4VOmS74b0Iotfqoqx/GaTW67
         NZUxDOm4Q8jVyhgeZm1bap76/8WVYlccotcqQ1v5qR1wIm/IwFrbJYoBtmJwp+zhvXYD
         TWSH7R2ZkgV1w4U1z4bdbuMdGpp3IscrdTpbywzx/xVYiJg78gasNIort+/++rL5qNKm
         4kDQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOcG6y7lKbeX8nMjoy5+RNU2VhcaNukmHlwTWTwkVI1hb9XrTxk+nIlCGlFxjQ7tNsln60z22Y+/UW@vger.kernel.org
X-Gm-Message-State: AFq9FYIGqPHE4FUrnz+2OeMTqo2AL9Mjq6b6wOQXRTHTCbBxTDRYrzd4
	3ntC+iraOpe+1dTXkDR5M0L+osG4skgr7ZA3KtU9OCem8GLIWutymzNLG+H8gSVGzNE=
X-Gm-Gg: AYBFou2VFba/ZouurzaR66+3f+r2O9C5nBKsZz5JOwW9U9RNF3BUWZEMMphr4SE9S1x
	U/HNNQXUa4OzdBS5Mu7vDr4AOXjxBPclng4Moc9BrUwhzHc/SS9KgdYDuzZTm+5zbn8mkYl7iCG
	LcbzKO5uWYDd4HPj2ZnmSSA8k4u32O4G33kh49nT/d1yDkm/YOmrIgKLwsx9Wm4RBijE9zFHts3
	LBF0l/+tG3Wn2qeW6NFSFRybSMAUeJU4HfUlFStOu0Y6EscB9xNFQ7t4cSTaGsyZa+Zumguc0lx
	wzjBQmn4IH4Z+M7t5c73J8rf+gBSTX24wNJXDgrta7NYwZV7mP4H6Qf3KyPVxGAn4Cer4RCtZ0t
	BcHgs6xSXIqVHBeStCnnYn++NKPHflMX0ELn21U6NFWXvm85wJeNkCLOGKZwxp+rT2+Diq8fIWt
	u7BzblXIyeejtx3K0U8ojWPBAlhJiMCmdlaxd+D+0MOwFVTcPeLhF00S8TxCyvAY1lzii/XeGQi
	+PH3dYHBI4jluO9D8lWoasbDOkHY/kygd55k1AldTmCB1n69aMwRsR4XMAcWn5bqagUe2MEaz6Q
	7UM=
X-Received: by 2002:a17:90b:2646:b0:3a4:ca46:8d44 with SMTP id 98e67ed59e1d1-3ad86f1c073mr414697a91.18.1792541958529;
        Tue, 20 Oct 2026 17:19:18 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad8021ac2dsm1570973a91.5.2026.10.20.17.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 17:19:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-reviews@lists.linux.dev
Cc: Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] RDMA/srpt: widen the RDMA context counters
Date: Wed, 21 Oct 2026 09:19:09 +0900
Message-ID: <20261021001909.2343045-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-179333@kernel.org>
References: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-179333@kernel.org>
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

Thanks for the review.

You are right: the indirect branch of srpt_get_desc_tbl() bounds nbufs only
against data_out_desc_cnt + data_in_desc_cnt, not against
recv_ioctx->byte_len, so a large table_desc.len or add_cdb_len lets
srpt_alloc_rw_ctxs() walk idb->desc_list past the received IU and past the
req_buf_cache object.

v2, which I am sending now, bounds the indirect descriptor table against
recv_ioctx->byte_len the way the immediate-data branch already does, in
addition to widening the counters. Thanks for catching it.

Yehyeong Lee

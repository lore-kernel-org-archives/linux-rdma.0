Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51BA34E774
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640272; cv=pass; b=V+CFaSxCulQuNJakOyUP6v154ku2ekrX+3XwGycD6i0sb8mgUwcbBYG6GTf+uvAya2Qev2YptdgNOyFiCOJrHIS1mcC7gbSzB+9HSIbs3E+ck3EaJi81HKR3PfrS1YRfgbInixKn2Ci/ZWC/OaEm5G1oSaUKwiidgG5mQdaKGbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640272; c=relaxed/simple;
	bh=9n1LhFlCwk8MB/qjTM7wamJ+Gpo91o9lvrLort0vxOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KyRgF8t+BMatIpaNGRgyIthRL9OOHMLvDBSE75xDseznfsEMbKCAYs9zhXakcSUtyG4Q35QA8lwz8IPZIP+bT7ZlkThIPXX0vxiS4ByLwKOI7piFoI27YuZhOq255AaYgfKqWx6qwzSTGUT41aAZ11NP8gcWYuNjOXYKRW51uOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y42Wvl85; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y42Wvl85"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-455ee8f529dso1562801fac.1
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:24:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784640269; cv=none;
        d=google.com; s=arc-20260327;
        b=GAYz5OiTmpYwSGA+BkByPBhcKNR4tt2SCj0dtoGwH//P33hsuptMfNrU1ZE3rfxlxj
         sKxowjbckRse76OeSJAONiq2T4yR5r20qmin4n5dVF5aLgM8hnE9pDw7oImdI5v2QBig
         R6Xnr3aGnzhfV82Mx0ZdETjPaNlxRCQcrvvtnYJkC4cfkDqIS76Yqt5MQECqx2RvZ6Cm
         j760RBVmAcFb9oQywi6MkuWKRhxXh5UdSGcd9Cbl/WsqAYgmFfPCfMQpmTVweidIkLbe
         tXvaltCOSv/m8+Kl1wQevpoPX9ZKd9RfHgnQZbvIQh21NJtrCuniGs5YlOexWzs+bwDK
         Wb8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9n1LhFlCwk8MB/qjTM7wamJ+Gpo91o9lvrLort0vxOg=;
        fh=em1e5/nEvIEsKqCMeizBHW/xKUHqsJJE2mGAhDEgscE=;
        b=mA9f9VnwS8WK/ivFhRAaSMiuICL6WrRyhZZE8f9nYGD52kukqPQhiOxZRkIyN+mqvt
         0jKSLhAvGPjBX9+ADgjRN97B1RM4Y2flI2oTr8E/eWd+x7djnY5RSdsOsHDiCNn/zhgD
         VWKneP/jwuxDnenS6SYnTMCXyiv/OXSh23KOgucPu8hJiNvGI9cwXM7sYQ8I872L1Vcr
         9uwfyp93cO1307QkfcPu4mPf87SRJBv43u0ZCdRTtx2W93ykX790Jy62WjLs/kHU6ycx
         U6OjTmetmQ0AeqdzRcXb7z4zP0PXiNUUZd8XNPbuZanLqSnc28DLAsqb0ogBJnrT/HmL
         BPDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784640269; x=1785245069; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9n1LhFlCwk8MB/qjTM7wamJ+Gpo91o9lvrLort0vxOg=;
        b=Y42Wvl85/Jt5XJlYY6hS58wFMVPllR+XmkZwST6B6uuMLCWua5Uneuro925UOhEc/a
         G2inQCZE42FB4zBrNkDTYtcN0HfcW/pg261NYzTS6h0xeYGv2Ij1YCCwFbnLV4uF+nd8
         o967RUkAGXpq6uE/yroRNRgyyI3akKWmTrFuOWWqZU0m0cUhy1b+cbxgcjq2lQYZ1Zs7
         mRZwTjeQANggv3CsQAtoKek7Gj/RHUFu2YwarU0kTHSwFbY9i5ONxFXLY1srTbk95ZH7
         15XEIRsgpt/mNDh/9LnmpWzq7XM4bNKEtbyWadeb7Tk3CwmlbXZkNq/jWOf7EfCIDmJs
         BXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640269; x=1785245069;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9n1LhFlCwk8MB/qjTM7wamJ+Gpo91o9lvrLort0vxOg=;
        b=mxm6s4iYiHeOztYYA2Rvi/2SKVU92UKbV9ib8y/wZpV4QABZIoZU0amHfjFAggFGeT
         dmUutMNQXhD/1JAXUtq/KVj8W9RoS01MRrYDlI3sCYkMV75mb5BBKXuvcerS8ms75h0y
         pk3Nrqaw0qKGk3fUTzQVmA+NZ9TT1P2xPbX6edN9xY4HZbms6FERcRnLkOw3DtISxUYw
         B/7D3/vAKrxqJHvBvNGCx16OCpR5JmYcMf9uIFss3B/YdIQ4IjwB6AkMaC4r28ErBP55
         B7LECqzDMVW7RLyV1YSKFEGRKYfYVxpe/z4tpBqjoMSfqAWVWEbydArvCwZuPbIMgYYW
         e9Tg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5xG8IrSbfwun8R6NHpLeg3fIvO4OocMT/D9nq2t04Ubbo2iG+P3kklsDNNHC6N6tj/lL5rCndJJ+q@vger.kernel.org
X-Gm-Message-State: AOJu0YxE7rIbeSurs1F63DtM9sHwuUDqBgTTpwjfC3coMzGo9EDqHOic
	o+gW+J94AQw3LUbbEsHqwKq/kIws+uEY9OEWHMtwDlLxYpw+dXjeNUBYxBzdFctAIBeC2BDKmnQ
	F/VSkgCGqv0Add+pAZWIXo82iukDvqce6tO9qahjp
X-Gm-Gg: AfdE7ck14qOSY2UJZPThQI5/EUbTwtQJP+S8f/Fx/qU+GLyX4OdKfUfvp1Vrv++TE/C
	XWLr9oTAtCIvU+iaVSZbGu7iYuUaK3EZx1PoPFXTonENB8gL9UDfBHnZOe97wlWKMm7PwFdilMd
	R/AgUbRiyDRquZ+tndjnMaz5sDWveco8cqPZmuJiJdllKf9AeMP7dcePmAIQaRKrdoR38C5nau1
	Os+/6Ds9QHE7HJgD+yapKrjtqnWiUwqaZrfjJ9HP12ZbGLNRDMmDAsS2NMOLEGueER4HbotGpe1
	UoDVRkfEtIEqHEGfNns2
X-Received: by 2002:a05:6870:d406:b0:451:383d:5149 with SMTP id
 586e51a60fabf-4569038e3ecmr9299819fac.22.1784640268894; Tue, 21 Jul 2026
 06:24:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260721082545.47395-1-mhun512@gmail.com> <5dda3040-67c9-7916-436e-47125daeb310@linux.alibaba.com>
In-Reply-To: <5dda3040-67c9-7916-436e-47125daeb310@linux.alibaba.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 21 Jul 2026 09:24:17 -0400
X-Gm-Features: AUfX_mxHKgmcAVgzyig6GPbbaq3N1NU0hJ88GPi-_eC-_M5YAUVDvbHnNagzgqc
Message-ID: <CAHYDg1QDaWPxD7pb-A1ZmqxaX6YACWTsinzEG4_EZDKbAX38kQ@mail.gmail.com>
Subject: Re: [PATCH] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
To: Cheng Xu <chengyou@linux.alibaba.com>
Cc: Myeonghun Pak <mhun512@gmail.com>, Kai Shen <kaishen@linux.alibaba.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ijae Kim <ae878000@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

I was looking at this driver and was curious if you also need
some type of synchronization after the xa_erase in erdma_destroy_cq.

Otherwise, it seems like the CEQ tasklet could do the xa_load right
before erdma_destroy_cq does the xa_erase, then destroy_cq proceeds
to return and kfree the CQ while the tasket is in the middle of comp_handler.

Most drivers either do a synchronize_irq (which I don't think would work for
this since it's a tasklet) or some form of locked refcounting when
accessing the xarray.

Thanks,
Jake

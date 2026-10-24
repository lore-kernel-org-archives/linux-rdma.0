Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792860490;
	b=LvmzAXWkmK4Qzxh0uZT+mHA/dCZ3mjvEBJnf7GxUVnekUz2gFyUrn8qG36iKdW+vk+xs
	 0YMPmXjWmJWLceB3tv7KUdai3K9qUukNTXL4IfJ74INfgzzW/ISj9+mPVQNZMJ7dMoOsf
	 IyzCRmH5J3L/t7YzfFrRYveayk4we6+mjZVVvToBEHwZ+4oDatuDsq0G3kYJiOMI2R8a3
	 aeWbosQ2fyqe2hcHZfAKaZy9UD6VCzNhlkvurfpoxgb190+zx+K2LWOx/Xz2ZGkzWWeY+
	 3RxyKiyma0ofwYmY4wyjTVa8JsZESLMYw01XuOkNr4fWbb/+17yNxrcJevGc0gEg+Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792860490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
	b=YlAOrRXQiIueDeoYQkZlLYDCIAwPLZoT00VwxyfimBQUxzN5242CWE/lxkgIa8KM7Gzt
	 0jKhsfoyd71akMNnbN6HkqMmi7VUJ1N23YMZ5r9Yio0knrQqdUUcSKFi8aRzMsHOENRL4
	 uNaR7/xz8vLa4fZZQtz3kd4thW1fhoiu1KdnfN/ULe7ExWsAFsBQQ9lVUkjxXkPzUBkE0
	 T3MlCH8GYviwphVwGZrhGUVPAGgrSfmMzSiLeqrp+XKXcoiVFdHoXRQz2urRb189YMHYJ
	 TgK2abb9Yxzu6NrJKa7kryJVr/4qWqf+lRbvueUb/BkuOpx2Pz5FJIgJRnHGpJfKi0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=doFUy87X;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7680D606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7680D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=doFUy87X
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so1055804a91.2
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792860485; x=1793465285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
        b=doFUy87XTMAZBcgxsctiSxQm6UY2QpLcDhFXPl7Q5FUufUfrnr0IqaRvQy5BGIFsXN
         vDPq4a5HJGH49+CstisPR4zii7cHvgxSckywC3Fleysm/+e1Ylp3j6+Sf9tPZOAVSr0t
         C3wBSCcyGbaHOePNv363BRwrX+IXsc7p5m6cpRTkbNWuTQ9CXCaBpbHHvB9cPrS7fFU3
         m+O9ye0KZqO0tobxJ6zIJecaXb0z2SjFQX2/iZI2JtntPjQh0DU5WjU9XRzexzkNrsYX
         JAMof+kEyBM3D2wpT+oCXiqKcuA/vnaOGSRS8Co2I+dbSdSI/1VoBLCVPtbNYaYlIqAW
         7Opw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792860485; x=1793465285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/nSNOYlsRmTSeCA9izzSk7iicvciGMpmTzAgDFQrTWM=;
        b=S8J998vibonl5E6qQgPgm6vpZbPA9lhXCKKMDSFHireBdwkhd4AraLHaIMfjLKn+1v
         mA9nZ27fn3d80B83WTVkxuVLosbR+AZOvm96a7/2x5c5I/KYIKlyUd24+RUkWFSqk/Z2
         k0Sm27VdVo+P04LOjylEEfzCTItwKLcKLTMs9gYEhx0DtLfmmkizuvOM+dN9Tuas6dly
         Ii7SJ7Xar22HC2nn8IwmvJUUJXAwfZYtwcrM8dU9hVH3VzZlfBRKcUcreVkobuiqLgW1
         tofWfzV6FmVpTT2tF/sj8ZFCC/nyDNt8bnfA9luaeb/3liSYeD1t4BRVTwlh25lrKzT1
         guFg==
X-Forwarded-Encrypted: i=1; AKwUvByhPHkt+nsJStu1DLuAGvzpZcwvQZrgzB4B0o2UjsD9CCuitmPWyqH30+x9754XuCzBCTX2bW3+rmQW@vger.kernel.org
X-Gm-Message-State: AFq9FYLW8OyYK9gSM21Ph+s/DErdFc+cC/o+YLyyyWFX+pam2+5nVwQT
	BRZaZrvSQjjFYyVqVhEf+vaYyVsIhoOF1qr50xDN5fIgx9JI/36TPtbUPcZgByWC0inw1MnB46l
	bbIlu
X-Gm-Gg: AYBFou3LIkWKN+BKeOtr6bzt/UTPv6XTpR45wLohmFMu4Ng9U3JqQ+LjRVWAj+PYEhG
	zZrepaQR6heYQDN9lxOyUCX+0CCDZw/Oh0+Tr96EQEtiConcKQCzxtLmgFDb4AhBoHaXjaqeIun
	+Iry++61HhTfZO04zys4ehE54LlTjzLCKhIhf2eFyMZl3+Scftv2VnoacP+fMONvqj/yUAv86xH
	YIkHm+FrGbJcVRNGx1td1YRNJS6T721ab2DH4DAVC8VL5uO8obAthrKw44ebrB3ggP4kKNjvmjd
	7x0IyIaVvAbwudLY1shzfhlyqAF8zrQKJdJChkFochn/+NWSDGj+4iSf1lxA0WOh+0oN0qf3z8L
	PxthG68r10CIZ9k//+/Au7hXS3AXvGZsoX3EvX3e+9Xr49RhC7zpcu2thRkQdMO8EHQvtk/ObIG
	yrC4ezpPCEJyyVQoHEgrqfn142jQAH+u0BVZbbWovWGBAepUcuhizZeCP+S1c2HmGDObp8qBg6e
	nRUgQmXHabR03sQd9kMtsWmHqvQ8RTFOC8bjckY0uNJfBSbcCKrHJvp+vlW1voNWIZ3dwcBAeMy
	q5Nr5KvliLVy+aDLuitvnadTJ+Syk5hroQVxDK6nwDqXKU6F3+dAIQGWF8iTAqgs
X-Received: by 2002:a17:90b:1a92:b0:3ab:189b:6981 with SMTP id 98e67ed59e1d1-3adead4fa0emr2149206a91.48.1792860484851;
        Sat, 24 Oct 2026 09:48:04 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe6af24sm3289037a91.6.2026.10.24.09.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:48:04 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 01:47:51 +0900
Message-ID: <20261024164751.3531142-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ea3e91af-53b7-419c-b83e-d70d002ea321@acm.org>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr> <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr> <ea3e91af-53b7-419c-b83e-d70d002ea321@acm.org>
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

On Thu, 22 Oct 2026 08:56:12 -0700, Bart Van Assche wrote:
> The idiomatic way in the kernel for subtracting pointers is to convert
> these to uintptr_t instead of u8 * before subtracting.

v4 is posted. desc_off is a uintptr_t subtraction now, and the room
division is replaced by a direct span comparison, which also removes the
truncation Sashiko flagged in 1/2.

https://lore.kernel.org/linux-rdma/20261024162852.3528224-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong

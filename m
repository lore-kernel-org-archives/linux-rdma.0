Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793555066;
	b=CXh0rqYuJwQXQxGfGsMnphx/QS1kTNC6cqyditnns5OsDPzYpZIAdXWvHOm5vvZqyDXl
	 4TFAzMSsW749wDJLSBS7kEXXAUjQvUQrjXYy41AUZeGKfmqc/XqI35gj95vTx57SxgPxG
	 cFGGNDPOG5xLCRlkiI6Txn6Hcka9BaafVGibCCroW6CDtWL+p6kLF/1N0If4agh21jqJZ
	 VgtRG1+C41kqfYBF8QRmr7BXrLztXHCYjrLH3HNSdBncNKCde2yLkDnh+8VCZl1ZsPEv6
	 96NbM0XYDLaBKZtzZq8nmLoCwqCrRJ+w3jl/NbfB4AvhaPPnx93U7gxgMYg5k/7BWeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793555066;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XNm3LmvLDAoOMp150KbZwglunPFF846Cqv2g3FpPcDc=;
	b=rw8tipzntLjLVpmrF9X2Skeo6h6H+w7wOZ3+gnAPxUdcvodAt/Qslr2cxd+JDaDuTzyr
	 UJpiG+wnQB4a23jNp9tJis2OqA44/mS0cLU7D9j5yiRukaytSoPu89Pj1WzPW6PqE14fW
	 OTFziiCJ74QmKTnxyomRN7vLWXj6+e/Mggpxays9nNhTPtcEspVVFZlrbY2xNq5+3AzzR
	 m4gEwBB4u+rh+6+Fvce2UdjVu4yRJ01pRSqMbXIvOTrMaAzQICWUH7v1Gr7K+F9NSpq5l
	 rQeq4/BUzlZmm2iorQsrWiDiEFPZQXTOMEMENcQeT9/qni4IkAElP7GPmWvPgjG1nRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VJ215M29;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lQAOWYS6;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5E606A32C
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 17:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94D5E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VJ215M29;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=lQAOWYS6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793555064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNm3LmvLDAoOMp150KbZwglunPFF846Cqv2g3FpPcDc=;
	b=VJ215M292f97S1XO38lWLbyWQMyGURPGPjdo0SoOByIgzhPEf8Bm3jjxqVARlsrzsEesSi
	FoCAYYzaV5YK0n5/t5J0ocI9IwSnY9zuW9C4+XxrAiRHvsb2ipPprS5372mWIQ3Rlw6lDN
	ksNpk27DFqDYtJODFSwoM3a/ejRPwhg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-_1Qam_QXOumPEroqYBRLPg-1; Sun, 01 Nov 2026 12:44:23 -0500
X-MC-Unique: _1Qam_QXOumPEroqYBRLPg-1
X-Mimecast-MFC-AGG-ID: _1Qam_QXOumPEroqYBRLPg_1793555062
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e1291432aso1824635f8f.2
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793555062; x=1794159862; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XNm3LmvLDAoOMp150KbZwglunPFF846Cqv2g3FpPcDc=;
        b=lQAOWYS6S+5Yf9TTn5qo1vLRs/TKvPqiCoXOqp5mNMeDDCFVPvK+Ms8pruPNkilKOk
         XKyiuEGS2IYRBo6rqQIQrPCZnX9wlUSHhQmSoRMub96VP3zDcsoqk8M7zS1zQQzipL7T
         T37Qk2PXzQ1gjvJ4MOzQhEMEua8/epD5iax13CfLh30QdzNx2wyDkkyurqP1y71z5hfg
         ENIJJK/0K8LlR76g1BQr+JKqMgO7gX3ra6jqb2jjqR9ySdDs9+4zAnzyf2Z1XZDjyDux
         Cdiqb+GFdiTpSjuZjpbSy+6CvJPxbpsCZ5gktrNlcn8qdm82zHYOF7i0B6bXqfJU/Yzp
         /smA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793555062; x=1794159862;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XNm3LmvLDAoOMp150KbZwglunPFF846Cqv2g3FpPcDc=;
        b=Uor4VY0Cvmae7MzxkNiW1vRbFm6CkCZ7BMHdITtVtN7y2sFpwaK89G8oM7DZ2fnfGH
         JWd9W/zQQphMIh/RGYcEX8iQ4YTSN8Gn+jFxFdET0Ls7fkovEcMRMT5RsvzaZaAhrCDf
         cuX/KbEVdiV1jV7lgdwZfYz5isZr6LNWelCB4YvSn17DBUQOmXRcLdwlrPJF51UFdYBd
         jIcSdyZRJGW6BCc+2BZI7rCczwdXql9sUXi883REIk5cqOEn27PhMVp6Ma4aWXA4PppZ
         djhnYLdDGag1tB2sl8EkJD70t5ajFgoxzIv1vttpa2PfFJStMZzzr+MMGu9NLIt7lX4+
         wY0w==
X-Forwarded-Encrypted: i=1; AKwUvBygbhYg0FfLTJfD17tSFjcLLwDllliZO2RgZwlVu0DcwsQTlOSmVUroV4s/AMvHqPqV/3ggOSCUe+hN@vger.kernel.org
X-Gm-Message-State: AFq9FYL0jifASMHsmBsP/tQJxvkUyKpOdL+PiqdDOmlDJ5avQUqr2P/z
	Pif5s7Qwzh6aSFaH6M1tUgn9o8wOhhshR+3/nTOW14OJ2pT+qi4Zu10u+yylfg/w3AAvO+kPMGt
	DtxeZMh8YnoMIWWk/VwqIPggtcSj49bph9X+OpeCyi1eBFDRjqmQPQ4EBgqJKe9k=
X-Gm-Gg: AYBFou3LwVzEditpC+VuPjnKT0bZZBlkAYsfbBMfvnaAnL4T1LMVLPPJAz2ADQoZbg+
	lUkzHR0jr51t42onGTatDDESVdZvhjyp5JzlKb4uWD3rB5P/UebbRxSEh/00HiQtg9X1EgInN2+
	b+ZzpbJ7iGQCc3arpDYiNUboCYbsLzJXokaLzOPZSi7PvK8MEfE9Mj+bHm0DC88d8FkupsJD7Uh
	ldiA9nLmBYGNKlbOW5otDr5Cccbgd3hHSxcf20rRuENUkRZAaj1wk+X6j39VtDSrB5AT905dB4h
	8jgHtwLcJLsW47Qz/V26c+u5vCmoZDGBXlR+VWHK3pYjlGWPW9kHHeRXmUV3SFGf3p9WorC1uW+
	2aCAUH9T5o3MTmWNUm6WgS4Mq5116R/nbooZEtn5qCCTXEqQgn9Y0y2Tx+kYonGXj7kvjI09k9K
	bTWMfY8PN+SHIVi5LJ14ESJ/YKzFXFVUEmqRiRX3duc2U=
X-Received: by 2002:a05:600c:1f93:b0:4a1:7e76:d02f with SMTP id 5b1f17b1804b1-4ac180f299emr171019025e9.14.1793555062123;
        Sun, 01 Nov 2026 09:44:22 -0800 (PST)
X-Received: by 2002:a05:600c:1f93:b0:4a1:7e76:d02f with SMTP id 5b1f17b1804b1-4ac180f299emr171018685e9.14.1793555061751;
        Sun, 01 Nov 2026 09:44:21 -0800 (PST)
Received: from [192.168.88.29] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf751c2d2sm233727495e9.15.2026.11.01.09.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 09:44:21 -0800 (PST)
Message-ID: <ce0bdf39-d514-42ba-bbc4-066054737944@redhat.com>
Date: Sun, 1 Nov 2026 18:44:19 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/rds: Do not unpin a page after a failed atomic pin
To: Kyle Zeng <kylebot@openai.com>, rds-devel@oss.oracle.com
Cc: Allison Henderson <achender@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 outbounddisclosures@openai.com
References: <20261030042110.73571-1-kylebot@openai.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261030042110.73571-1-kylebot@openai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 05:21, Kyle Zeng wrote:
> rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
> represents a pin that it owns. However, pin_user_pages_fast() can roll
> back a fast-GUP pin after racing fork() and then fail in the slow path,
> for example after a concurrent mprotect(PROT_NONE). The output slot can
> still contain the already-unpinned page.
> 
> The common error path calls unpin_user_page() on that stale pointer.
> This can consume another subsystem's pin and allow the page to be
> freed while it is still in use.
> 
> Clear page when rds_pin_pages() does not return one. The error path
> continues to release the page on errors after a successful pin, and
> successful requests retain their existing ownership and behavior. All
> four RDS atomic ancillary operations share this path.
> 
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
Picking this patch randomly.

Please slow down a bit: you have already a dozen standalone patches in flight.

Note that that 15 patches limits apply to patches tied in a single series, having more
than a couple of series in flight is quite unusual. Having more than an handful is putting
quite a bit of pressure on the maintainers.

Thanks,

Paolo


Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795222064;
	b=cNCSKpB1LMQe71YsqmrN0GjJKdlPqiJW8vP8NwWCaeMyE/s/DzETguxxSRUKT7SVMw6l
	 rdSlm4JOmjRxWHIx7MhdDksIz2OuxSrI9GZAd6E0uc+7MS+Zflfaw4BHgDd1kTfpkYUyX
	 3oPCenpX1XztRIyGo+CTjw+iQpFUAATBhJC19p5LGVvKCu8oJEFwCd3Iede8plfWhWlhd
	 43UQ+z9ym+R6GbQ/a49irxF4oPFEKc3KrcVYrSIdgunKBeKnjVRFj56brgQBymixjP60b
	 Em6Yv3xR/yvdCffrLZWIoJjsji+lZtW9ZRFcDBYndeJBbUsxEx969ihWe/vMMhItz9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795222064;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=sLsPwPwC3HlUczdbFxujwCzg8Up2Cb7L28zak52ZMIs=;
	b=oY3C7zTKYzMvA03H6dDvtNC/C3D0KcH43s725U1eWZ1ozoFeJbov3MHlDBwK4pa1geGj
	 gmLvpzAe97QHcXVLdVjyxtAJbeLpPMl6YgZLari7b6BpvATt2Zn/15okWHHpMKHGYhmPR
	 jrK8Rkc30xHEYa10IFs+kkMSDDBIZ29Gg3VG+EzCGc0Cwnd9xcydSIM3atdYHLcQbNA0V
	 FOc64e0L/ikRBV7jojkHaWRNkGK+BtHHazg1GbJufdbFbgnHoMTU6tpkAjmNrB6keu+ov
	 Zx3VUumM9X1+VGt0cpnceoS8DCo4AP4cjP5XSUWtMOuOKtyJ/mdfvUQc93F45FelB5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Gs8WNo1z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C0606A6A5
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D5C0606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Gs8WNo1z
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AL0Aisu1101502
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:47:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=sLsPwPwC3Hl
	UczdbFxujwCzg8Up2Cb7L28zak52ZMIs=; b=Gs8WNo1zysKKvjTMgfaRYfHr6rj
	CjVTink6G9q9+weAsB0imF3TTcKWjSaWg2uISYkciZb2FyiWYf+6ueH3uAIhcGhR
	epLLvcVq4UeTWS/DsqtG2Mq9MBsTa4rwm38Tbuelq8mwFmoVRc4QXVoOumSxUBX+
	P0ov6PmgSAeTZxYkkdp9ZNfDeteMXRu7UWZ+Z1yBUpsc0zItdYSH09UacgaIRh30
	eYNpm6R07ji6h/Kfq9xhMDoOu7+p3Jj0lg+PDmP9kt7pAZGGIV+Aj+5nfleL/yV1
	ftCrDHhO8KkeQ78gEHV3eAWMAUHhg7oERhPYexh7TVlxbrRl3JwtnboWWGg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j2bb2qupp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:47:41 -0800 (PST)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdb91e288d7so1258513a12.3
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:47:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795222060; cv=none;
        d=google.com; s=arc-20260327;
        b=ZHitLWXu3BjSjwXILhrnLUwIsQjX5wrCc0Iud6XvWRgMmVtON8d1sEIFIYX7Smdhba
         GgYIZqEFO2dDByznBWzNhkxzuOWcMrCIs9ds74zzsqJYCvW/KI8h9Yq4rBko16ZNego7
         PigtMxd6OwfE1SFKSNlF0IkkW/vUQ0V23dpFB/YmYxDSaqf/EGxGceZ5o3juXF9TuRWT
         FyTaM2QRbS3/GnV3h8YbL+xVgeS51SsUxHEmwm7cDqwVeiODx9w9Bxo6zS7SlB+UXoLL
         ZV45b/BfGpwESqRAT83h7fzVUYf/29xvO5G38Kx+quz4CPNl94C+SmrBLRhvfGQbD5Bm
         EZTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=sLsPwPwC3HlUczdbFxujwCzg8Up2Cb7L28zak52ZMIs=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=OMYJHjmivIqvvzHa2SXe/a/X6Gvj64Y/ieJm91gRkuoQbXFpprVLgzUxgbydV8rReC
         bJb4FEUdK1vyYG9Xqrax2ZsUVEyCpe0qsum8SQmqAkAySQfpHaRX92ut7IdIdXChLrWz
         prYkgw9BpjLjHwHntEyPiiq1swy4hg+M6C8YoMUD8awVIihuItiuy8uRVKgT1ULpY/Kj
         zWtd0ShXw6WtULfT+p8RWVzKkugAWuEXYf0ojDoRNcoa+Tma6+R3VANoYRiM4+IKoAhG
         cUhFUMMnNdGue+pFHZUtGPsWUhTmmrM8twshRKT0aOOHdPiaExt2mTF/aqfinmjO8HcJ
         H0iA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795222060; x=1795826860;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sLsPwPwC3HlUczdbFxujwCzg8Up2Cb7L28zak52ZMIs=;
        b=PReHGZlQUPdnqqU8/TNguEGgviSsPLRw/K/lnDYfgWXYLMQ2wc8WIYwpTdGTCE0Wuz
         u43Q9uPUhGnNclVrOEYx4LNo6A0IlJRMChAJF0z+0LsSQDIzP6bMeEIiH9T2fIB8c8F8
         2qGVZm9yRV7MgqqvWMRsblSE8fWnfadpKnCWPFBY/Bhy/xXapRPw8o75omC2xhjvx5H3
         2bZh4465FMN8O15UF5njeb//GplHXMSHTl7JXdq1rUtJzdVQQH6fvznR5mmIxedBhtnj
         824VHJzul3CSC31E8kd71+Ad/b957I1SwpbaB+M020u3aoUwZNp/nNpxjTWXE3egiCsd
         P6Og==
X-Gm-Message-State: APuU4Z9SaKMWAnGLeBPTj7UKJorpqSF2DGe5DppD5tspU4y4OojibdlW
	5XJFJx2jFOz6Gi4F1GS2xPe6mRafNunlAQ3D78ZGndYzoa450vKCDofX8W2EA0g0t5zu9YLBsR9
	RqWbQaCP58Jpg6HBhc4rmcmSLTAAwPkj3iHxSP+Vn0irmXKCTT4FsVl0VwQ8v3m8ek5czTB/yHW
	g/3e1HnR1hwf0XhiYtFMx7kSochFB6B7JXOAgxFNeDaxjD27s=
X-Gm-Gg: AYBFou15rMZgs9uc1MvgC+HOVvDkHcaRm9lY1xFgXCn9tS4o8Zkl4R3RMtEHamSfSRR
	AE2Gwv/9vkDIwLDwTNZt3zXUNrYGfSnBojpAQCJpRhn1wxP+o3R/UQWUBVIe+wMF2X9Z/9BqI45
	xDJyiRjWOngx7CaG78N+RXgRiG2pG9fFv+mXHeJaewjO+/7RhKFej7918FqerSd2O/VgvTNM97S
	KmrTGVWTXCzbi2rWLQiXGAZzqv1elOP7mBNj78r86DasFOB+Zw=
X-Received: by 2002:a05:6a21:880a:b0:3f9:e8f1:697e with SMTP id adf61e73a8af0-4014bc58241mr4169602637.34.1795222060100;
        Fri, 20 Nov 2026 16:47:40 -0800 (PST)
X-Received: by 2002:a05:6a21:880a:b0:3f9:e8f1:697e with SMTP id
 adf61e73a8af0-4014bc58241mr4169588637.34.1795222059632; Fri, 20 Nov 2026
 16:47:39 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119013103.1092559-1-toddfreed@meta.com> <20261119013103.1092559-5-toddfreed@meta.com>
 <sashiko-outbox-224311@kernel.org>
In-Reply-To: <sashiko-outbox-224311@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 20 Nov 2026 16:47:28 -0800
X-Gm-Features: AclHuK-exnYG47aNjV7pMM2O1AFYtercXpmnwywLfO3PdqhYjuMmQGCGR5i7yWw
Message-ID: <CADh2yMyhWxKWTZc2di8OW7H0n2kZ2JL5-esAco7yYju5N_pKHw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/12] psp: add support for socket-less psp associations
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Authority-Analysis: v=2.4 cv=KqnYSmWN c=1 sm=1 tr=0 ts=6b00ea2d cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=855S8uPTkML1Oy45N9_h:22
 a=0HLFHH1_m2ICFn5tl9MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDAwMiBTYWx0ZWRfX6oEKgOD3uFb5
 wFs4DCjNvMvbzdYiUccCVIC90c+Vvbz84OUXt/8scqIoWCvL8shylt5xDbljG17LEDuD/DS90Cq
 iG+r7dlsS7H3GyJla7sLQDzr1S2MJZr/k9w9Kkhn1UKGy8PTx6OtGpSJUU8THW4VNx9eUpiM6A6
 l7C7UINRIQOqgljGNwqnN3KI5a2iqTyZrMtcdidZUNOIgo+iIEcAeggwU1m1QlYeF6jnM1VwWCx
 d1DbxxJEHulFzKY1OvYFVBXbWoYjXWhhLIWKHMkuq4/1eHo8iRHI15wMH23U3WOK3qUqiHdoObt
 2Q7i0IgNCJp7jVnVToT3CfoHxnlS/DVScgqCbdN87aZZbBy/CVnSDMoSsJQxRsnUTpS5KnZxR0s
 qOLSN5XB47hQUxBE+OElltI6pqoO5JWopzM8EHOXhFAZRrhJI8K5/QlIZhWv9bi7Z3PkvZzlyxx
 mBWwPOh8NJJ8DDvBTOg==
X-Proofpoint-ORIG-GUID: C2zF6MbbOw8F4FTT82w9E60G6yHpdX1q
X-Proofpoint-GUID: C2zF6MbbOw8F4FTT82w9E60G6yHpdX1q
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDAwMiBTYWx0ZWRfXxtL1KSkvi1cJ
 JsVHdvWtwEiuAqtWQXiEASLXntWWtRxPK8wMcWPwkQjKzBnNbYcSmxeYOR8H9MmYfC5sR2dGgBX
 5Q28rmfZxgDdeXOcdRCmKjyz2bwAi64=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_06,2026-11-19_01,2025-10-01_01

> [Severity: Low]
> struct psp_dev has a kernel-doc comment describing its members, so adding
> sockless_assocs without a corresponding @sockless_assocs entry will trigger
> a kernel-doc warning under W=1 builds.

I will address this in v3,

+ * @sockless_assocs:   socket-less Tx associations, which key rotation
+ *                     doesn't move

-Todd

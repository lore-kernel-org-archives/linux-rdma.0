Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.66
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248960;
	b=My+b6jrru5ZomyhdlLir+zsp8V1F1iC99a603VHBkOABIW8DfLrlFJ4Qn98JjJqMr6zk
	 TRpCfVGoBTC/xKqwNwVSrOkABpKjm+diKlQg9/k/sf2LJxuIbuG6x8UTVporLGPUVc6lQ
	 r8PdqGHlNhE+pdJvF+w3OPgamEGTbG8x0PafnStoVaVC0WwMdaE7jCquL/oNt/bCLu3sy
	 iQ6BwjHUcda11iCydfVYUHgs7iGCIRZdg2liNyGBHvRX9wqwCqkgHiIugSpanbVSGAdpp
	 5dr5/1JHoAS39G6GwStCN3GoC94eTRjrJg+xSsLqo1wdbmjxpg/YDA2zEEwOsSV/1JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248960;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:From:To:Cc:In-Reply-To:Subject:Content-Type;
	bh=U9tBWhRBh3Q/NIaZ7pvcEWgchBntJxEwV8o5plMJv5s=;
	b=UWv3Tj7OXMb7edyUaCewh4p7W0tV1Rw9fN6MdRDFVEZH/k1RG8Dzx2DtNSBLdgpp/v99
	 oa/t2q260xtMYAkb4vKqNqkQvU1w7IK44OsYBZ9ZBGtXjUz/qyuhpeUNslknTv6BBYjbm
	 f5Ufk8dDhGfpMRP04IZcwbTMnpxEOX4n9eM/tSylZXDeF1Dl6b9LhrmvKAcUUB9a+eTpx
	 bEN7kAwNxtvpvlQuOm2lLcYmvnJCyVWVMJRXc9q+hUOWpv/3nT3GvOci06MSeQ3QT5s+f
	 KEdK1sZTp5aydACfOeAXNhwiyECJK+22UxABUoVjvzVlIh6xuHwt9fRnAbidC4mfy2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H+g8qHTx;
	arc=none smtp.remote-ip=74.125.82.66
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D0C606A5C8
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 18:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0D0C606A5C8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H+g8qHTx
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-1438d9363fbso724091c88.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 10:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248959; x=1794853759; darn=vger.kernel.org;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=U9tBWhRBh3Q/NIaZ7pvcEWgchBntJxEwV8o5plMJv5s=;
        b=H+g8qHTx/1ABTl/J0fYJk8LmReb6tQX8eqOlhMogAupx8Y2+3vIn0oTm0tGGP3USEg
         MA79rIdUVkkQHJXzuMLCwiNGH03XRFTZ+Whl3gw4xKlMuZlAPwQyFzIPepp20O/9tdOB
         KO1p8a+HMsYkPSqgOKZWOdnuvMyJ5CNaLDPKYW+7pUscM02XbPSQKdNsKpo6G4voGoqO
         etYxNNkqRu2JxRmdlye1zTQpLJ1Ky7NmprSAuY1Qi2sxsYn6G2QgweRAAZUTpwEioysx
         9qNKmpiIRCgofwmFJkA6ZJe1qLLExTiwsj9Q1sIOpWgHuBNztIMr7nT6sdM6W+8SSeQb
         bF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248959; x=1794853759;
        h=content-type:subject:in-reply-to:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U9tBWhRBh3Q/NIaZ7pvcEWgchBntJxEwV8o5plMJv5s=;
        b=1aZI1i4rgRBEi1Kb6B8eemo9Lu6JqsbMvKInXUhHv7LgwsD81NA4PRpHqQCsybuO0g
         LRokhZR5/tDGEn8L+YwaC3pKEMrb7VucF0Ku5GoAgsQaNgXQ7xDaUWeQX4yEVOIb95ft
         M/RFEaaeKzalM61kL/6oy+5ca7JU8TDIyWqI9NUoC6HN+nql+3qlhjr/l0/PIiPJAyTF
         vDkl6NzZYL6LzE1A69mzyGFDaJg57g0TG7DzbuYop5ftHNy6rNpbNFHZe+0nlHo7HnXH
         Dp0G1dXHTu9YkrcV33t73KQDyPns+aTcyYULqEt9ONQq1oTtvXA9DmMB6x9ePF0iDB8X
         c/IA==
X-Forwarded-Encrypted: i=1; AL+hErGLJGsBpPBZWmqDGFCGWiYj7gCUCpDAffLbIBS37tDaGZ2Lf6Udbn3QurndVRJzKmB19osKt+heXaz/@vger.kernel.org
X-Gm-Message-State: APuU4Z+wpiODtKzdR8H9c/NbBQj5/6hxG9Mpinxu/iK2ra42N2x1bnVu
	qJ86IEzIe+wdMQUN/Lj32blUVh8P2ndMLefuT3zanwTekBmvmzUpb0ej
X-Gm-Gg: AYBFou1OaslPp6euAeW7xLtUd01ESQnZ4QNkejrJ7yxOPgyQyujaHlhrUUDn7cYL6vS
	1aErkoLY3E1KDnlnO+0IXhIf8s1VsJ6DTTufDTSqtFC8Q6X8YoENDV/nKmgtF+2PAYdd2E8FPGi
	3+1OnuInZhih3KGd1EMB0QbmxZ1V51X96PRpo/OdugZIbtimAyyXYL3U39X2Cg7Q7aW7mJ0Bqiy
	7L3Aavbl6LiH8JKV9eSu1/MpZUdl0H9xJO49d5x9VHn24k3F66S0LSXET67bcmBNw2oqCeWyYOn
	hZ6eFu13Jlos3mdpjw8pQGo36X0l3I/z3O3Qoz48OnRhekhkqQNWpMWXN5Z54GnhnEhEsiOjXsx
	vUKdvJzCQQOYZincm1R6nBSIVLyQlequzakPKth5h39ev2SETepfLx5mMxuA9YYyzCQnpopR23h
	cW4NlrEwifkURY11zn1cQgqOAgvi5foHnk/X8xQuah/wnJjAHm4HFRrVCyi3TFiaWkDz07SpEFH
	FZOuCRelezOU2hAPfNpp0oNWXJoZehiiwvqkFlON6yTiFBM4j6aL+TQfPDxEHVI64iEGwD9WKK8
	Em9dT6gDWBQCXGr+dwvyhvgeKYEyiOymuV8I5wrXdMB2
X-Received: by 2002:a05:7022:5f0d:b0:194:e9e5:11b0 with SMTP id a92af1059eb24-1b3b5e27137mr363920c88.14.1794248958814;
        Mon, 09 Nov 2026 10:29:18 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:67::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2eeffsm684335c88.9.2026.11.09.10.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 10:29:18 -0800 (PST)
Date: Mon, 09 Nov 2026 10:29:17 -0800
Message-ID: <08dc804d3ce9bf9b8a1c0193ee7443c5@gmail.com>
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
In-Reply-To: <179418737922.994134.6838913010792422653@kernel.org>
Subject: Re: [PATCH net-next v3 5/9] bnxt_en: set the netmem TX frag size
 limit to 32KB
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> [Severity: Low]
> The commit message says:
> 
>   With 64K pages it lowers it, 64KB frags would otherwise wrap the BD
>   length to 0 with BIG TCP.
> 
> Isn't this a bug that already exists on 64K-page kernels, rather than a
> side effect of the new limit?

[..]

> Without the tags and a note about the dependency, stable kernels on 64K-page
> systems (arm64 64K, ppc64) would keep the wrap. Would a separate minimal fix
> for the net tree work better?

I'd rather keep both in net-next unless there is clear evidence that net
is buggy.

> [Severity: High]
> This isn't a bug introduced by this patch, but the same 16-bit wrap still
> looks reachable for frags that are not netmem. bnxt_start_xmit() writes
> every frag length straight into the TX BD:

[..]

> BIG TCP has been enabled in bnxt since commit b6488b161ab2.

Ignoring pre-existing..

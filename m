Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384004;
	b=CIEmwMDaghOhFSLxydg8FPeNUpocJxur9JaAdw6Y8h6X7wrXqdr0ZycwJKVPrXNy8V7e
	 BwuiLGLtjhnjBx+1yN/aqvNRDyxbhIokPJYGEnNxub5uopRT+f1erZXK+2RuccVGPHjDM
	 oQL7LCIB7v9Q0t7FreuGVz+rxU3bm2zl85hllehyCjvjdv7H2sxdy2p0XoqAkZMXAiyj2
	 6p4XsK4eCYJOLYMTQV5KIdfNaHvcBYxew+UlegUG1GeAlblok8h+wwMlz6JZNp2aiwuG9
	 z5jP+K8GOi1ii4cWLh3CAFC1Bx0mpiAtn2/NjXzvB/gOB0AEY/5BuvgrcKiF6FeCh2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384004;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fMT+So78QSqhuFKeOQlwYV6UaMLr+CNOGb0u2W5xmj4=;
	b=ShzPbDAr2Jmx01WKGnY5gu9V11qrrNGWDoM+eWkk8JcWz39YHqNtp5Xpz+B5xVHwklM3
	 0FbUR1BMlQGGTM0ooJOz8W7EzmZ23bx/CzvGO/FbOyBta5W24qziyCjO2fTSZcH6vJ5Dr
	 Bk8/LNvfqz28YdC3ORc6Kl18PZx7wBGNwqlgomcIwH4RFs0/bZ0DK420izoLbfdlW8VhH
	 483y9g1KwhZHeRERb6dc4+2XZp/opKL9F8Mdn/JfS7v1muzvvVT5ETflNju/z71sgSn7Z
	 1Y8HAogD3Bn7eZKiuqMZQBYl4RhJkur/oqhGThN9tfAPL4zxkqRH/qL1ErIfXLtjRPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OaE3o8Rj;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14715606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14715606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OaE3o8Rj
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so11743345e9.0
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793384002; x=1793988802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fMT+So78QSqhuFKeOQlwYV6UaMLr+CNOGb0u2W5xmj4=;
        b=OaE3o8RjEVR2zR75eyJC/w/NzOyHFo4/aqxLVy1sTOOTix0v/XRAORx0DvEXQvizgM
         GxTHgDQzNXs28wuRg2tAdlgO4YFbkHs6wSwH1KlAI1xNAwZo7o36zCP4KnM/j5WijmTP
         6Z15Z66ioDDzwi2MWRBKgTvweh+T2EYu4iDu55xkzRjld6HL856ZF+LbbQ9JjGnc7D0K
         JZTexRxXbc+zHP469suaQUi5EcUd9aKst1j3ayVsyPLEsWdcsXAA52P3SDchoTerpujp
         tppw+c0l0zQtKg9qiNVqXGoa3LIBe7VYE1HtlFeUKh5x4PNnZtS9WWdSHSvahFqtzjhJ
         zRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384002; x=1793988802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fMT+So78QSqhuFKeOQlwYV6UaMLr+CNOGb0u2W5xmj4=;
        b=LUrD3rgy/cBma6vYgkvv+vNR+009hd3xQQJmbmsz13ciHziJtZqpt6kypQbpHkaRbG
         KTwM76eGsxI8ARx2ZsfhDDqB8NxqxRMA4co2BCjIlp2Jhgsamg0qH6/iBcLK5nDWNdDz
         nnasQBHwDk5IMLhVgPJcfRdUIc5Vwq7JdPFZWJZIFLxkPaGcPLIUMTJO8xzYvIUztFuB
         n15/dzJ0XbCc3N9IxPLbbFwxxOFHqF0B4W34+VzkTFUfaYQHtiWsWmhqCSbJNZnx9BLk
         fwAkrC2/rzHLusw2YaD07EZM4ggWBQu2Q9i8znYSuwbxHD9oBHKZye6FDp+CItW/Qnlz
         5fng==
X-Forwarded-Encrypted: i=1; AKwUvBw2tsoIZK68ICVCrOyvD9RZIOyeU9WXi+Ng90tIURqRVtth/vmmxtEUrNi1X389vmuSGDXbn9Bfrchv@vger.kernel.org
X-Gm-Message-State: AFq9FYIokpIQy4q2NNpyZci26prjTOpHABJvj6VLoxBKmkLiSMkzXJr4
	ypFz4v7juYspvkjBYXY4fQWZNrSiSVToX2/BapjICh/mSKXMb+OiafsT
X-Gm-Gg: AYBFou04NnHHxBClMQhClGjjE9Oz5G3nn7AGp0ZQ/jUtHmQEIXFPXST65smDikf913w
	OFl9fCfTMhLpAG8Gmiz6+xH8PfT0N085FedPMx0+VKwJzOHje7bN87f6ZoToYPLMuspqYhjl5Az
	N7RQyDwpGba2FjQanceLm8cy8YMGRgAQXn8uqVRjs53fbcV2NrMbL10J7k4rFn1TF2/2M8JOL6c
	S4ml7WMZUs4RyXXOn1dAINr8NxfC35RmCzs+NDmmIcMS/Rx2A+k1GmG5phAT9zGZ3WLkMKHLaq5
	sl4MASgSrPwHbfnJAL29muI9oOICJfDL/1yJtlrBs70/nSC6f1fZ9zgqWmTr+QR7pkXVd5mQqMH
	Ok05YFOFavwKco/7P7X2NLs5a5rBXrMf4hdoDa7kBr5zaeE4kqtLCZAHkqPUTgX0iVhjL99lPxO
	cHKF+1biCbZx5ZMXG1WM9b8gNUmrO5h6ugQb4FUVC31J+NDE3Mit4y5w74VqzUHSoiDmFv2L0cx
	TSYechqhlBkr1zdHN6ZxcgqlTnKYwJ7obBwg5tIErOgbgAfjPttPyNcpM511kEUkcYLWed4X7yi
	pY6KRJLGIfUfOmEDj3fG74hsLXjRBBC2rGOQDjiFz2ky/c81mi4l63DTIqgUnaXiF/v6r505aSW
	zE+3Ce19mmlNe5o9cikulaQ0X3J5CHoBTFLP9JBSDGt1fY4umxHUCW2V6/SWh
X-Received: by 2002:a05:6000:1449:b0:48d:ff71:dd9d with SMTP id ffacd0b85a97d-48e6e2ef786mr7095121f8f.23.1793384002277;
        Fri, 30 Oct 2026 11:13:22 -0700 (PDT)
Received: from SD.cable.virginm.net (cpc117822-heme13-2-0-cust760.9-1.cable.virginm.net. [81.111.210.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8c0b6sm4198221f8f.41.2026.10.30.11.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:13:21 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: dtatulea@nvidia.com
Cc: andrew+netdev@lunn.ch,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	erezsh@mellanox.com,
	kuba@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	prathameshdeshpande7@gmail.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	valex@mellanox.com
Subject: Re: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
Date: Fri, 30 Oct 2026 18:12:52 +0000
Message-ID: <20261030181309.9266-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ade46454-e575-43e4-85aa-eeb5ad79408a@nvidia.com>
References: <ade46454-e575-43e4-85aa-eeb5ad79408a@nvidia.com>
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

On Fri, 30 Oct 2026 12:18:59 +0100, Dragos Tatulea wrote:
> I don't think that all these cases can happen. But I can see how a
> CQE completion on the parent can read a pointer from the hash
> bucket that just got deleted.
>
> Please improve the commit message.

Thanks for reviewing. I will narrow the commit message to the parent CQE
lookup racing with hash-entry removal.

> Holding the spinlock in the datapath is not a good idea. AFAIU
> using hlist RCU variants will be enough.

I will switch to RCU hlist operations with deferred freeing and send v2
after validation.

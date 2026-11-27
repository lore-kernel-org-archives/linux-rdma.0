Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795793204;
	b=GguNF3kxs5jEPaGCysrsuUokT6bpq331EOouHk0rMimjBpfiQqRtjBfgxt5bZRoutL5F
	 7irufgNIHPhBT+SqkzeWLidcyttPG4RtfU+fkgV2SrX+R6ghyYEluf7nzluJraVNEXpg2
	 fkq5eqLqNcIapx9fveejtQAAWZJxQWaSVKz9Yrn+Sd0ucqsWxs9WoD4x1Dw1eSIqCDOZX
	 xa/5SRNrjgVSnGOrYxPM6UbJ/OE+Yw3+nyl8n2peWlCx7ZgMEwHB5JxneBlbepR+Y//3q
	 KOq8HfnGjvpAYzfQ4HFW/H/hkz/G2cGxtefUUzfjtztjEeGuAyDh+bexjpa6lzrl3Aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=+cNaFNq+h0C98G3vTstsz5kW6XsnAXUPToskRbu44xM=;
	b=aDDo0HtzG+DyJrl5pjnqBP05jDjKCa170iYwxZUb5bJYr36Ce42LaOeSfBCCwtMfOMSY
	 uF0G1iTDLHGiFkuo5LrxhmM2fQ2RT+A0w0OJCs0PpGthKctC3ZM8W5ZPDGy7SIqql0nUs
	 a9QpK1P6VOj6b7RTgIWbqkWCiizmGgAxqnzyMpC4WcLVzhcd+ucCtEeUVyI1tq3ngCsxQ
	 1MW/MxKD6kQGkMhXvJ3FHeJnRcTQFEkyWeThtn8aDJslcYTRRfleOCIHjmsDgzx3xEa1C
	 gGs/lkIV6uuLKysK774YSVBAQpmQSkLJrFJC8tqkUIS1XwoQmBeVRjVP6daTp/Sjs8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=n94mAkyJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.181
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952B0606A326
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 15:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 952B0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=n94mAkyJ
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b4ea3c5afaso55731037b3.1
        for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 07:26:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795793203; cv=none;
        d=google.com; s=arc-20260327;
        b=chfO7UII04BvimCtqeJ72YnhQdPw5nmUp/IX2rjbZyDfy9e7kaaWKsmTTLLMjCl5F0
         ZbTS/IBDY1g4ySrF9uBSyHJrDTqRhuGSOh6z8x9PkbaR6UfoOEi+Vd7JfuYzLfNuLz1c
         9WdkSgtZ79qk+5Qv2i8gdke8ztZKBLT7Rjx50yKDDa1+cjA5Rawy1+Ep4brss3W5neao
         //yenu8QEQTCOQmtJzz38SGcUy0uCrwdIYaozALTt88SoyU/BlZBM4mZ9bT42hcB8Qbc
         ZS6CTkaFxWxPvAyyybJAoqKXAwWH+wFYwMITEpt8ekCJjwLAxRWJoQOLR9X5MoiCMiii
         4S6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+cNaFNq+h0C98G3vTstsz5kW6XsnAXUPToskRbu44xM=;
        fh=f7mz7OuamVNnK173i+lgp0dCCVZ34N7JO/xoVU9b3oc=;
        b=Mg/C4UFA+KnwwyQz9BzxswSRp+TV5IXyECF+qPn0AneuAllwVwWTx6qA3RDmzbkU4R
         lcg1l15TFE1tsYtudjVIdTjpF3qItkhkXJOaKGL3i0TOFFEcl+6jOMEMM/eU3CQ6QHvJ
         8rVkebWU/OxeCWIHI2XvStY4WxpjWBBO4S7fN/jIIp36Wro7xnxhQB00wLMp+g9RWVY+
         SuMBvMbxsOm176gLLe/tBbVgtSL6OAwwwz/VjAdA9w9pcm1ytJkrgOQCOjUPpWbnJZjI
         WZtzig6tUpr0hE1AAb/+XQBlwWarhGSwh3ZpbCHj/d6zjwRXRaY6Dm0k048hRhojhPao
         0y4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795793203; x=1796398003; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cNaFNq+h0C98G3vTstsz5kW6XsnAXUPToskRbu44xM=;
        b=n94mAkyJOfvvvFdqyDtEpzjXrweT8JaZWeLZ+JYOiBFDDuYaMPknPGxHUMwIf2p4QI
         XbOKYuOKTdVMFxaHokKbNXTGDBUktL/B8JSyE7b6YdHb/W74KbvW6rbiCZmnIQlF/i8I
         ALou6ktP1I5Zbs41mBTFycRR8rPWR02G+g/k6UH6l6DD/aedUb053tQ5jkZ91GKvmJIw
         67G0iRK3SJp9Ne0ESx6cqkBNNWwucbSzu7o0e1KmDO5YpJZRB7LNyeyOHGcjxEYRPjwa
         qp45YwL1Q5w8yIJrLzHHQk7QAC0knp49PvcDTYRwISeZGMmOYrkYRgoOL+1gkc/Fe8L+
         ufMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795793203; x=1796398003;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+cNaFNq+h0C98G3vTstsz5kW6XsnAXUPToskRbu44xM=;
        b=THXkNr8dpHkYwLJ25c/kl9mkUepP+uGBxVQ/Oeve+qftmbtp1gLD4aBe928TXwjYrZ
         6ggHkammXeb4gX4/ZzgZqpIVk7afbApfQpTiC5t0uKkqDgBrkbRnlcPUfPOMvgsIbrP0
         AQCRzcU39rXgxtruIIj1dae5lkstjS/goeTuFnu3LcDN45J6bO3WxrDl8AGC3YEfWYZu
         j8yQ3AhXI8FAO+u15hNb6MQEIPj13+5U9JJUl7eTEbb/hJEPQ88xXqMdqZ5F3v8uWCSj
         soP2jCffz0AT0c2rEfHj0tHp/Gl9iztDXsyVTBuL1tDw9duxe5wkQhtK1DuI8pFckbSx
         yszg==
X-Forwarded-Encrypted: i=1; AL+hErGNNN849y8zs4N4B7p9jmNrszkKfBySl3fVw7IdJYbqyKRBq32A5QbjHdng7wcEsDdD1N4Db3D0I/H9@vger.kernel.org
X-Gm-Message-State: APuU4Z9i1ksqyJbNl1xShURQOj1lwVVpwClLliYE4kGr333H6wTRV9vO
	Uqrh/eJ0SIvLYJd8q/mYvCELOmyCAFPHqP8skUpzqHMaWiKFaFc9N6V+5GcKYY+fBYQPIRIQRhO
	k3DuEvG5Bx/YB70976xmhkpv9J/H0/1NaBmzPAkUB
X-Gm-Gg: AZFdTZcMgzqIsFcJYKoe65Zxx6eJEKgj2Xaug8Rl03UxCWSkKZ26rCav4Bervse2dYM
	thG+wqqjs0ag3qqfOr0EyX7ikLzPktoE1xSiMmrmAQfZPoGyspQS1Qy569i8BYsysTPOunDry1O
	fingPh5jRlrOt/3fEZEn7PW+hM9PvR3770wHgu6jGSgkF1eYB4MgN7LDqvwrmZZeH+0VnOJUllh
	DmPLVaA1wRmCfyUER5HFGpdM78RON7Z44Gu5Fdu1ovXUYbIx4ZMZdGxFkpqSz9zU1B76I9d4O0n
	4XNOwR3yvjiUnCeoG2aW2hgk3afAtW8aFs3izJLPedZMkCSVqPSKml5x+9BkJjAUfpPL3UvBcA6
	ydlXVI1vDSk9rSsUe+OIErYdzqrjKFBdZs2SHcrUqbBs4+JAPpigSlqSG+Mq897SyRp26oGrvYR
	sg9fN6sysTaUUKKWVJT3NyxnCr3dhB8x6IwdBl3fmV3XFLz9CmVdJOCSV048YL3xRhCpx4O3SwC
	wkD+XlRNbFmYC06FuHomF5LyFlfWN0C0ei6q9BvJc26cTaZTziDAxTT+PptbRa2IY6h5IKMGeB2
	r8k8qP+HbR6WeGhCbQJIJzGQVzMGYqRCRt6hJbryhHfWBFc0Sn668IfwOJKxzbaMID2LyPCE1/Z
	cEzyNU1jaLRDn03P1aQnuWEndwpC84K3w
X-Received: by 2002:a05:690c:698e:b0:8b3:45b:a4f3 with SMTP id
 00721157ae682-8b5204ed736mr106681927b3.83.1795793203488; Fri, 27 Nov 2026
 07:26:43 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795284858.git.julius@bairaktaris.de> <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
 <34e77fff-c57b-4ed0-9035-b9682ad3914e@redhat.com>
In-Reply-To: <34e77fff-c57b-4ed0-9035-b9682ad3914e@redhat.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Fri, 27 Nov 2026 15:26:08 +0000
X-Gm-Features: Aa3M54pxMqgZ_s-9JbfNek_3dyGz87LXsEraMMuneoiDkKTrHn3sKg0m5hARvDM
Message-ID: <CAC1t37L_+P72w+gNcrdphB7xkBmCQp5PQRFpcu1zqM1m-2Am+A@mail.gmail.com>
Subject: Re: [PATCH net v3 1/2] net: keep the TCP fixed-ID flags on the header
 they describe
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, willemb@google.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	dsahern@kernel.org, idosch@nvidia.com, ncardwell@google.com, 
	kuniyu@google.com, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	richardbgobert@gmail.com, ecree.xilinx@gmail.com, andy.moreton@amd.com, 
	alex.austin@amd.com, linux-net-drivers@amd.com, saeedm@nvidia.com, 
	tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, 
	linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, 
	john.fastabend@gmail.com, sdf@fomichev.me, izaiahsun@gmail.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	shuah@kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Ack.

Thanks for looking into this!

Julius

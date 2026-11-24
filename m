Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535072;
	b=bg4VKmP/4TEfp3GB0bb44+cXDrSld3JrayfbeQM379dfE+cwX5xTsRqFeM7TvRy6e6C6
	 JNRXTNUrx37N3c5inuIqTYr9mTNp50/mEzmb0VsMCV7mksaFXbgWS1+PnjQPSkUDZkFD/
	 yvPsaCRNowNuhV9FrXmgQGxYafJ1ZUVg/5akYYz9/GEipY7acCzEWy6yzRiVOLUJFyCNy
	 W8qfpP/wCux7yhbO/ze79zW/XNmP94Mq0Gn3NTIlxnF8YESCNviiW56Eh6nwD99MshTgc
	 eTNO9qLCtbh8qfa2aa/PMS7NJxtBWrB2lWmr+3JXDvIpj4MqhSFijQ5PDdaFkRUhAlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=l5veRuTsjCef0xKyYh69YyZqGM0kjOnoOgsyFhra9otqVBjOST3TbtwFlRRVQUrEqUYr
	 zLnDoTtmhbhzmMsZGdDR1OVvmWGEQ4GKx6YXYd6rt68UoSQNYAKVcdqVTf6fXZ8y1+6+p
	 FjfEb4goCEV3P2jbQmDLIv5rFFKfcBzL3ITY+vpkkVV9Dnzf2GkKB0Nr/sqGXcbuh7byR
	 FGioG+bTsX8XmSdQWC19HqJFoFYwMYOaBPG8ekI3/yyblvOxiReZfrQ3k4WTf8+dJNMLx
	 OC6rU09k//aJ2+hDXLlhc1knvewGXbNshR66acmg4Hw22FbvqKF00RiTRpRAFQ/Mb8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgVVaL33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECD4606A321;
	Tue, 24 Nov 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgVVaL33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C591F000C0;
	Tue, 24 Nov 2026 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535072;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgVVaL3357PSobOf7PgmF85+LVhDXxGOV9OlYq7N0s6Sg2O8nusYgSLBxcMszVBBs
	 Qi+fhARTMLsyB2rU5CwwTho6EG3elDBWWEC2bWT4PyAygfHTgaqjOo3FOdy5Z0joYR
	 7Q/faxAZp0LOtUIt2D/HuKAZmHg3fZaWpxh0zXMxaBr0y9pafquLb+IJYWEzi9awcu
	 MqcCSqDi3oOPcqK8COOSaZ3vjM2/JVRkPRoz+0b5oZCLzlVLrnIe1anb4vTjZrYOGM
	 p9HIJtEvXYPUTg4qW8yZyjsG+8AhOJBbg7Abz6/Lycf9w1ckL0yE4fF3QwcqJ3G2N4
	 omMBAFoU2HyNg==
From: netdev-bot+sinfo@kernel.org
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Subject: Re: [PATCH net-next v12 0/5] net: mana: concurrent HWC requests
Date: Tue, 24 Nov 2026 15:44:30 +0000
Message-ID: <179553507044.3294.2548266527967853234@kernel.org>
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506229;
	b=IXKXwDjINX8Fj5TRVRowafiqszhR+LJpC5AJssuFaOjEjhh2HBxKjx9c1ASPjwzzvlms
	 DlpIeR38B7qdg3ANUJj/Ffw+dZr6KPj5xAo4MiUUiYfO1lXXQKBM3JbpttRPqV519gqqC
	 K6afvad+bagb/xQq9sMFtkGi1/3y+g63AxYIKB5OcJAagNJiUFHqzGr7HPh9AujKzovvm
	 vsAyzbVzBwsMFzW7wuXg1JQyhzG3b6tb6H/E5K6vgZmbk+7UYsK2ZzG5doSLgdNDsMNRg
	 p7gxguJpmZadUsAkqfN2FwA6YednDFVny3RBoxk/msIuI3q1WfLRdIAjKQhDYGnU+oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=MLRWpDubs9Y4rgv+EMrJUHYJG26wrXirvqv1xl/RBsfrPzlEOiy3bM4aY05WK+MSKC/X
	 or/56EBL1PBHLZ/v4lm5pqBy9ihUYPFYPMqXkwjaqqW2O0eoiOZsFpX2T3JwF4vMxybV3
	 R5B9FlFBTGTXfGbb7S8YYd3VAr6tqd4ELw+UG3cI4tc/6PxO/Pl8IwWjY0dFQ1UOkcmFQ
	 AOK4pEs19uApgl8+yhfizE4z7GQVkjSTD760x/Y+NuuQazH4G64hl6VRczYD2gQUW74ZG
	 G5ysSZmpjrxrjBW2fPO3P7OWtsHg7gHvTVVTCxiMQyZuDVsywtLN3iX+3J+AuM4nt3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YysbH92D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0473606A321;
	Tue, 24 Nov 2026 07:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YysbH92D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E791F000CA;
	Tue, 24 Nov 2026 07:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795506229;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YysbH92DSwRDJYwz5DkuOofp4RGojFeYBd38NdQQWNNOVTan0gmSls0rq0QhlXrp5
	 3PxuBkHLjhSXhu5OuKzNphqpm/DEyTxQeRcCPg7guHxjEp4DM4xsOUHDvTXyt4aXTc
	 0DdrQ74eNW/kbrp3i7d3e2e5mCcLv3x2JiYrBkE26D6ZKhIS3Nh437aC6aSsxRtpnd
	 hmrGPsI6iFQUo8N6kzU/7SnrA22pccJ39cl5s6l+RYYAyqFWC1GZ7YLSGIREVjrd0b
	 RtBervhriGxgtB96j8ssSzNStkNRYdW6iKnwVpFxZKxeghxsuMQWc6WtWX+vQOxPxL
	 TD7rXqmZgZtqg==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix sock reference leak on abort_work cancel
Date: Tue, 24 Nov 2026 07:43:47 +0000
Message-ID: <179550622759.3294.11500155506194750683@kernel.org>
In-Reply-To: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
References: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
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

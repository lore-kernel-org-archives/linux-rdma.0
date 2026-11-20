Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175009;
	b=RnGlE3DjikyWbStsRIbJdHd5CRH+emC4P7XjqXN+kykRnpIAp+zO7+v9Qyg/w71fw2xY
	 b8pi3+tuw4xQPHtPitBpZKhWxpRFQDz4UJKi/xywtIH34LAe1BPvDIwzXbOXy2y+FH2HI
	 VkyvzIufNY2NnpAzSTwob20b6ORnIDUR6je9gIuhV+9H6NIQ6htD3Ef4pBytQqLXnjBo9
	 v3c0Rq78W44Qny7RxmaNF/0AmqKQ/IMv3WX/t2ZsTDZ1nqMgxPOszJezF7pvlKLTxr2Wo
	 LBhNNCuKWLjsAGjTmpeq/H2jEe7jN7KLSB/OEpr0q6teCPF544rZhdlutr5wXKwMapQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=aGe0vefWc6wydIARDvKxVuZbDuc0lCcox1IOpKMV8RPC/3h5TckAAvUu4mzjB1YyHkfD
	 8Vx1gi+E9Nppt/qheVty0mWl1TS9qiKuoxSpVm3Vd31GgFvrUtln8LzCz/0GIXuOw9Z/+
	 Q16IVj8tRKAS86xxhQPcG9IhL0H7xvE3dTJyiiL5j817qLVCytZZaUh7oSrW7AjcgLBa6
	 12EgXAeEopgiFHLKgWCIZzHpqOURvntoQcbs7lI5cqcR8nlY37NAdTkHevQFuBTeoUgu4
	 /8iQBnofDRh07JxZQgiROqrC1NcHgHYOpVCOGhXJnARyhQC6hvuzY5MyErzNvK1LoIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGA3oWwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62F606A336;
	Fri, 20 Nov 2026 11:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGA3oWwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544591F000D0;
	Fri, 20 Nov 2026 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795175008;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGA3oWwuRcS2us7TC9QFb1LqYn+ELO6pKX667hv9BLjUJIXlByjo2ydbD7tG4aCWo
	 zE9b9pOYyu34fY4NvWQT1yALHsYsMbAyYcUNChJtWgofXDVYe/61jxt+pEUCYUoFtz
	 ooyKk4tHfE+XIIfq467VVfVVROiti4T9bka//ChdSK+Ov3CRArFVY+upY6eVC5OqXQ
	 WxISFj07pLCwd+PmEkelY93ErvC7enpAjgxcnJJN6j9/29uR2lHz9tDjJjirem7lMZ
	 8/w0yMrt0QW1+U5Bfn7Jnczy07fktupjpg4EyfxZVq3YFHBUZVaBUydDbcFkbFS4Fg
	 cd7W4bXaS/dxw==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: validate smc_diag_req length before
 reading diag_ext
Date: Fri, 20 Nov 2026 11:43:26 +0000
Message-ID: <179517500688.3291.13559881517966104725@kernel.org>
In-Reply-To: <20261120113708.3950966-1-mjambigi@linux.ibm.com>
References: <20261120113708.3950966-1-mjambigi@linux.ibm.com>
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

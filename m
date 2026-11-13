Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794583674;
	b=O5Nu8sQtJ8SRLS6k9COJnwa7rq96/pW1Tbd1P0PJIhep80/eYCIOKL4zB9uPD81OkrPI
	 Eph9+uEKqFN8dGNnElyoTcOXIwWpM8YRpfg7Q0fU+9q0dCVYsJEqZIGfSp00MR/eje2Oy
	 USTsdO7+wtMO/CMijjG8WRfRYzastwkF9ulhhp3QWgdXNYovoeN6ffR2HqYmLGmdIwpWH
	 KxxQszoUv1jUSUnz18SRhCp5K6oP66LXyrDNXBBWKBnywJnL9F6SaDxkbs4iyz7obfOQP
	 QCIXpT/89ymOv1OSHDbPJTtGk8z/mYY0NbDZs2xmC9MRExaNrq8u+LbH9wLgRELg/4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	b=m6F3t6n3XYiMNFEoaj8kMDwHpHc8hJNYjROiUWYAxAuz/u1Ei5s//SF15YyU7QNhh7/6
	 wdILSK8hD1UQJGb56zaekRHHsmN4UoKXltJ2YpPiREgtH5sUL7Om7Bg5otm5Qp+LoJTL3
	 Rev0GIxN51VTHIjxAAREizDk7H8qjxuva4pYkAc9kzS/W4D9cUFdVb8cesOz/J+kFO/UE
	 gF+JXFdZRXyUK0FAwBbm5dsESAiOsf+f4sGJBC1UAZ5kuzF9C9nEcVUlOgbZAGxBXS7+B
	 eYT7O4RghRyHDA8dujnnkyYMEs7VuYMBXWKno6kydGdlHUoJCNKBQgJ/5z2VVC27fPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obM15AJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12538606A323;
	Fri, 13 Nov 2026 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obM15AJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235AF1F000C4;
	Fri, 13 Nov 2026 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794583673;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obM15AJ90mGlXY/jE5a+ZdaDpkOl09kD4/+UEDD4fs3RMqLfyai7TDkxlo5ytFngD
	 lWeFQgTP8x228dv+DxTVIzxtOEtBciMIvLOdq8wc8cjDHX7doFqgFN0Ou5iVOYnNd/
	 Bjun3K6a48m4jKMfn2e0sWnoLEaIgzMEgkDua2AkdIMCo/N7faKrLk7711OjMO91eJ
	 0jdOMgannOdxAj6X4GWFpGz9J+sDZwW19wG9y7nct4vVovsQ2H+f5ylB3iWeO5nYQL
	 mD/drX6lP1j3xSm7iZQD0g0VF0kXa/aUh7nW4+JjNgjOCNhrlhK4XOUXx0Wfxnr7M5
	 FdFsPV8k4fjFg==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Akiva Goldberger <agoldberger@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drory <shayd@nvidia.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net] net/mlx5: IFC, enlarge active_port field to support 8
 port LAG
Date: Fri, 13 Nov 2026 15:27:52 +0000
Message-ID: <179458367272.2168702.15400963269849864687@kernel.org>
In-Reply-To: <20261112182940.3655773-1-tariqt@nvidia.com>
References: <20261112182940.3655773-1-tariqt@nvidia.com>
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
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794385000;
	b=GRXSR7oiIgjSZEUBGD70e3LYb+O3ugiTcvWKrnxIKw4PYKsoV8QehnaQwF6g9ekR+mAj
	 bvLlSOAzI6UI1br7yQfuTDBrrh157gcXG+qyP9BM+Ez30R6lbaiE3q+EtAzBXqJyZktB9
	 xGfD26tkjyf1s4vQ6tRSoYbXR5iLUxgIxw+HArQNkf4YG+ICKM8bBAnBfvtjsYk1VZU8L
	 10aiDOg0Nf1fkZC/uaaimzxxPCPk5D/T6rZkCe3qavsGmtufcwYanM6S80adrlVM0wkOK
	 xWJVurmb0HnWPzp8F1pwu2bsvDEedW2gU2EX4Db5B9Ie67i08DviOnvdzczrFl0oA/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794385000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=c08ycn78SciT8jjKiZ0/Ch3hlNWvDaou/5bI/e0+bP2+LTECum6NEMXEW7+Z5B0teavJ
	 TvvTX4WImSqW63HUg/EbGHeqgrmK6cfrZB33PG6k7m+AKPPh1SSqLfopr40c+TI0Vnn/l
	 xYlQ9yy1IjtcObzvrZuZ+DBmWyzkzcj8ddnIMbAjkc2N67ySJnM/ZgqZvUuMrUU5hn1bX
	 hxe30yZVZvj4u/JRo4cae3ChNOIdZnkCwr8APRJQXtCwcP/0+QnizrdgobyGFn0Sii4go
	 2J3olJJH5Xdqmru4sDIBF3WxI3Oqltul2rv8jPbRVXdPmkIhbSJyitz0oT0W1jvM9Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrX+w3aJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960B606A31C;
	Wed, 11 Nov 2026 08:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrX+w3aJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42291F00A05;
	Wed, 11 Nov 2026 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794385000;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrX+w3aJ0o0l6i+4arJ+8uWvxzmuetDuCUcrn7c9afsFmKgVYr3q6apkKg7rKcd3j
	 RPx9qBpubGoGvPzRXGwv5jezIlAfHOcwWDc04JP041dSOqfUm75AaNXafkYH4iy0Ej
	 zF17oy7IQhdhg5OJ5VMFxPFaMRZacoEmqK46qw+bA4YRTFtShyDY2dvmWN66RIzJJF
	 ePxULUCR0PYxiT+UPO2gk/ApXvoHIJ2chLisWkeXFger+jrBoA5iT9f6/nsPMcE9rO
	 4Asg3qPW/gis1DO38fOePCR/nbWbBTF9WwInGKePye9m3xMgBfuVx4Gge4YhX5B2UF
	 MX9V4aPxW+viQ==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Andrea Parri <parri.andrea@gmail.com>,
 Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: IPsec, don't match upper proto selectors
 in crypto offload TX
Date: Wed, 11 Nov 2026 08:16:38 +0000
Message-ID: <179438499843.2168702.6164625421208055212@kernel.org>
In-Reply-To: <20261111081337.3129580-1-tariqt@nvidia.com>
References: <20261111081337.3129580-1-tariqt@nvidia.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199931;
	b=qpFfmsAjbn51yY+jHB6s5jIJY/w5IjogakPj/Gb0WzPTxfk/wqPwTj8f81PgTXH5uln8
	 7dPp8K6Lbhiu8a6GM4FbCqk/m8XYqt+tJNk8CEtqILb3oH514xHk0Prk76y4D4zrhFoDc
	 RrPfFmjaqlqKHmnGUF02K7Rk+aGQ3J+ivLo+TYizxEeVc8QOV48qs/0FyRYfvCFXSpxLP
	 rahK4LeegvhmtmeeTJp4oy7uuXf/ZFA1hbg9pWmUlpDARGo/CrpiiORKohvrAMVAGQ2SI
	 6Lox8+jiz+iHnUcivM8TyTMIEp04c5/XJBxaWBuvuu8oaD+5/evqaBg0bYm9aZMffWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=xOA7Zl1aMTn9XJPiIuz8sT8J949CRLW1Pl2E4Q887QxYvXZhf1Ck35QtNPvElAtYWAcf
	 BbBA8K10fZB0cyWxcukZLN932DdhV3PvlNq+eQ/zZWiQ4SGz8SB2k6z4QnJd3JUPhn6gU
	 OGUxPdTkEQcVlC7/69MoqUzFUxA5nduLaaIjn4CIUJ/4SpwTR1xcxca75RcXhpuzp9AFr
	 Hk9yVJaI52u/KB+kPoSgyEEx4xbSQR+QPWJYUW0RQdyN3N5r+m6V7kPncLgMoDCrovbe7
	 OMd1hfOancHDVPUbY3XPigrhPxjvRlGzJB9/XHXsnH48uXWoH7ftr0UUifCATtPkDsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ect+WvOu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DE8606A31A;
	Wed, 28 Oct 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ect+WvOu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F071F01825;
	Wed, 28 Oct 2026 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199930;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ect+WvOuOqK0f6SE1IoGuIk+likqZQGP/v1d3udBySDda4TVYqV2X2rGI3ddq/2YD
	 puh+x7b3kY6Z/UX43Ofsi/dUmPYqrMGXgJM8yLu0UqDoIe8quo6/rVYJ1DjBXRJunS
	 D3XQusYkB1x1v+al0+p4fwDT6gJtducfVU+QBDuvl2Ai/flFCc3HD/Wnhg9lEvHmYA
	 JrjDJ9FXOP1ZitinSzxZFQnQLiTHl9a9R3ymiWsaMX8357HCG0fwpdCJkWTRDQ72Xw
	 eRmwBImOwIoB/ZHP40dh9n8m7w/u/Q2YyjStbPo710dolRJOxRAeUhl7+FSKueIXQo
	 qtdU4zOkUd9Uw==
From: netdev-bot+sinfo@kernel.org
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Oz Shlomo <ozsh@nvidia.com>,
 Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
Date: Wed, 28 Oct 2026 15:05:29 +0000
Message-ID: <179319992946.3327.16474832196958485781@kernel.org>
In-Reply-To: <20261028145805.54595-3-fourier.thomas@gmail.com>
References: <20261028145805.54595-3-fourier.thomas@gmail.com>
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

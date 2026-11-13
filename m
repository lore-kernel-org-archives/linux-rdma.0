Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794583665;
	b=UM4/OFLQZbUsVhN8AxcdCVCQzl0xQM6NWUdehNP/IhWO0MEryM9FDs5DZXNKnZUMQT3I
	 SmRPdJZUQvk04F0RvBGBtb+0Aq0lEh9XU40RbGeeZe/427j+ZtdyAGR821MpH76cVLpEL
	 YXHfmijX+uSUugKanqC9mPKY9hDhsOfQpNjt2+2tMsWHAx4WwzSXUhNxRxxiVqzf6soNX
	 fryUqPqRLyavLvUfqrYIH49KNBz76UxiyAbBRuXpeMBZW2YtHJJUHGChodDnd/8VO3D2z
	 p0mX2sGawbSq1ScDcpzNxKnAMAhlpDTLTkj/vpxJ+tL7eOZuHyiY3E/xRSPgsNbvV5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	b=TlEsBtTyGX8sfYomityBCA6OPOR9nqJ2bY3OCnLxvXPQhm3fTabMS7uL3wPiPLxtK/H8
	 rfVZZrZNu8UhBCWLgs+0RSSuAnWEGnFL8va88oFrIpIQVfxlDvWvtZM8YgD4elU1MCIjt
	 lie4EP59Nicw91OJ9U3zxuOP/ghvVefvvIGeSIBPJuNyhThw2ToXtzVl8bbFUPkAroPcF
	 uvoPByrihFxn6EUCTkh96LY9ouqGYRqm5vSegWN58GSI/gS58cyPsxbz6SMBdEZl2CmB0
	 LlXh6aF7mYKV4LmDILgdEsbz/DrU1CdDnfAbVJFtihjBFcahrYhYuugmMIsyERvDb/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JyBaqzb5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A99B606A890;
	Fri, 13 Nov 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JyBaqzb5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071581F000C5;
	Fri, 13 Nov 2026 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794583664;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyBaqzb5EK8bIQjRZtAMSfMQy+4fT8zgbjvd0sz2CxEEWkPGBLpGpjiYPO9nhPWCM
	 oreWbXK84Ns0N6OwwhsPluXFT2Ot5jCrslyeMxAAdG3GgpAFUe5iAdLzQA2CiDQ7QY
	 r8cdCWL1Ur/aeWUGVE8seRs5K59QprhmYHe3jnAP1A3uHLYlSgWvgtbFIeUU6m4N+F
	 UUtMTnQEDHDmHPzCMMuQD67DQN1nJSl44MthhfLkRGe5UPQSqHMKxzq4BDYDM1HxH1
	 Ajn2QChmE1g/WzDjsOpyTlcdeGlV44QXA5TnR6QsSVW8PEkjKl/Y2IAI/JqSns/YU8
	 n4q5kSEgeg+hA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Mark Zhang <markzhang@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: rep, Fix races between devcom PAIR
 event and uplink close
Date: Fri, 13 Nov 2026 15:27:43 +0000
Message-ID: <179458366354.2168702.9670595647220092131@kernel.org>
In-Reply-To: <20261112182403.3646298-1-tariqt@nvidia.com>
References: <20261112182403.3646298-1-tariqt@nvidia.com>
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

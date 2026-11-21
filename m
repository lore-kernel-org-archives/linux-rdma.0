Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220235;
	b=U1nkDShGdhk+XtHG7BtB0V4+ACGoPFDasSnNq/lH8Rnz4IDVckl7Kg2nL7GVL+RCJrmy
	 0/8+waCBBMlWoGQY/dhQrb6cqFkjjMK+Uje2nrfojEWOS6DMcliyMXhrWlYRdgn4OPlZH
	 2RMOeE7Nq87RIpVjDnzAPGKcLDFqS0PoAN9BZbqQ/Eh7hQeOB1QDDAEUoe5bscjJQEyRa
	 J3bjfAe8OVRdrATDH0u2QGb82ssOPP5CdN2n8teoALsZk7gLFY85gBNnI40p4D2p0TZpt
	 QH7NlTp3zShd0UyoYTPPItXWzRuRDWSZ9QU9X2tJIaQdECrv2FNuRh9YG8mIjC0KrvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=ldkjn0GAoSq0AadeiIO4zyyUD/VkbTdn0WpkhBoBAHEUuS+7jdDa3S6RXU9yy2dAopxi
	 JxKn1mW0Ao+f4AWDleIeTIQzBx+X3TbRIT3g795y5iMAEpHBBLbP8xbasd+KqS8ifZg0m
	 HSgY69ieZv2w3xi48JWMTeYE1HYIpfZO/S4cPNH5+oeN6YSiTEIqRtLtC9Bc1lZHaD02U
	 eVJthiAYEKyUIRSnOxra8whjIObyxVIfW5N1dicnnG42jcow3zwkBrI4pApJIE9VwtjtS
	 Zwy7LJqIddutMk51/XGkPgPEYhYRdMvrek1mYRclyYd6ltHZAluz6BMTtnuBRS9n6Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZErb4B9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C461606A683;
	Sat, 21 Nov 2026 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZErb4B9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5ED1F000C6;
	Sat, 21 Nov 2026 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220234;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZErb4B9EHESIYu3xvINTAS1QXCkS/kLr6+RshU1PGGm25B41/ysfSpfv5A2KQH7fd
	 +YcCo3bs3CyL9j8giCQ/tTNstieLlF0ODxViNrSv4xb1cBagXUijJn9hqPKRfOL05Z
	 079+2NjPzOK8//UmEcm7oe0dTvO9kksCk6HhfV8CghDT10SBrCCOKnS0l7qGtYjqqz
	 xmg3iT5kagQ13k20qKTRWM2BlVkRWJ244p1p/MJ6sL+WAdqH1Q8dKsFE0j3MN6QG99
	 mZ4wtv/j4crT9Bk8RemRi3hHI2SF9LVls0VSYILA1zMYduKCQT2rcJTlJFhGtLb1HN
	 0iu71YbPHQTNQ==
From: netdev-bot+sinfo@kernel.org
To: Artemii Mashanov <ralerrdirsardx@gmail.com>
Cc: netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net] net: mlx4_en: report the actual RX classification rule count
Date: Sat, 21 Nov 2026 00:17:13 +0000
Message-ID: <179522023307.3294.6067722832080574797@kernel.org>
In-Reply-To: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
References: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

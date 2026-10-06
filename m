Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A76191F91;
	Tue,  6 Oct 2026 11:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791286172; cv=none; b=khO1A3WlWZq9EKEjuiSkTk3S0NKhUCTTqpYCRtbDHCH57QcEjthZjsATPChILrwkllaa7r62y18Zobuj3aBqi4+p3sKcj1knZpz2kaaMd+SDGD/y1N2XRV80KCmGytzgHCetv0l859q6RSgln+CQD31YWGyx9Z/lvZA3vdfmKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791286172; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OC0mr9wpJ3wS2VNr/VYVJv62sJfru6BowRtv1AV3EI7P3HNDgis8/9dkeUqHgVZIBCZhftmB+U1NctqdPSXjXQ4G01/LkWH1bWotFGFNbx7KMP4vC/lI6Ksx30Cy8mkfkxSgeZA705no2/7uUvYpylhLvCZdjaL52EB+/Y/67vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOFGM8x6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOFGM8x6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639C61F000FF;
	Tue,  6 Oct 2026 11:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791286171;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOFGM8x6kH2JIfTclU9clhxH1GiUosxWXNi3s15H8tgseNR/DT9JPR7DLxDXL/+Jw
	 TvrhVqHAP3nK9HXFdZjrs2abL/4ynuoYEjcrxpCvzprSQpY60RKGlzNSWaYUiBi81Q
	 wIb3c+qkRajCIZV1KD/R8xJgJ/8oT3rTFnyw5zd37OWDjzmp+vqNPlH0JPeFugGW8G
	 jiocx76sgTRsBdOq0dAGYXMgCyFXNAuVpPNoQPP8ZM0rgepLFFJYk1H1/A/PXuVXqP
	 G28z6QDRlA0At8eZze2KuoPO+k1QTXN6nqhSxBq8IGHSbryMv7JOaXFsROdiW7OSX0
	 On5QHf/132Jmg==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Edward Srouji <edwards@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
Date: Tue, 06 Oct 2026 11:29:29 +0000
Message-ID: <179128616987.2231598.8807408813571443447@kernel.org>
In-Reply-To: <20261006112415.259157-1-tariqt@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

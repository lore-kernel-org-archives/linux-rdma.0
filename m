Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EEC378828;
	Tue,  6 Oct 2026 11:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791284729; cv=none; b=Me30cLwFnf4qqbQf9fbd/hSHGYsWBK/lbyuAqahvzBKXZLAihb27wkOhJ+44CtzcXmEuTC7bx6Ezs/FxtRyb24cTuJQUBfg1VPqYmicWCYkt1f/2IGNrM7PYOy0XwP/CMTTxQoHPaFZ8T3o1E7PSRlfVG0daYmSLTP17DxaLyns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791284729; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M2Xu1TYHxa9FPx8wSFa6VdtxWcKtB9RpfVhaArXZB6B8AnM3rzSMQRi3bJ0TpbaMwOV1RrJIFtEoot4avYx8XJ8MjzFv/d0m6Xsz6RVfrxibB+3bk7VqVnKGTGX1uXH1b4hLi9Reuse9vEyKZhjrOjHLWj4F5qcm9nE09vEh5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ieO0XSSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ieO0XSSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFFB1F000FF;
	Tue,  6 Oct 2026 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791284727;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieO0XSSRBkV6bifG9bsNDpbmysAY9ztnxNEcTzG0/KOK1EZ7xC3m1mqDOI1wn8BFe
	 DzVUY85PJD1JALrWEdD6umbghkFk4kcQ6QOkezfuf5N/0Lu2bP1DkkrIE8uYhCtVBh
	 Mm6gui9dsikUFvRGI29f5z4RJXaokowpYHFe8naTY5FaAp7CT/EBlz98me3Xp0zh13
	 +IxewkE4EClAigsJWmVaAXsyipfcCESN2HIbI9zVFaQPh+vG4s95nZUELbnJaLOGbM
	 +cMhuXzZ/+KSdALxCYNMdQUtTVYHhfOhsqpK/MgD6UffSpPyw7rx255RYAgo21lqmM
	 qJc/o8mDEqrdQ==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Li RongQing <lirongqing@baidu.com>, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net V2] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Tue, 06 Oct 2026 11:05:26 +0000
Message-ID: <179128472633.2231598.10325462603155616600@kernel.org>
In-Reply-To: <20261006105820.257208-1-tariqt@nvidia.com>
References: <20261006105820.257208-1-tariqt@nvidia.com>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

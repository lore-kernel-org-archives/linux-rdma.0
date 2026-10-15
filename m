Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DE049F130;
	Thu, 15 Oct 2026 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050230; cv=none; b=A4ZM73g7iFZD39+kcUyGRg9duiTjKbLs7mixYwREzFHkyHZt+yoNQW03Q02+RzzDLW8Bu6UiXk/4e8cUm4k53X2jB9EhH0x8IY23algBcZY2N7xMCVvS8Aybtk1Ca/MxGoVTGXOSu4KN9OwLIqinlgUGw+qYPB5QxbWttwxonpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050230; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tB4YgVjgYmGRxDELm9+zG8z7SgxZl0b1+q7qMGxaSNFZEzIi/dsVuKmtYYQbg44n/WVg2m6+veVec+9riWEQaK/n5mn+LNd9g3avwPRSrICdwLcxmmXa5Vg3HCdJs4X7lIdrQhxiLWcZhwLfmFIcCBL+DS4NQDrl/9c22/o5l1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NG3IXvfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NG3IXvfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8EE1F000C4;
	Thu, 15 Oct 2026 07:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792050228;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG3IXvfx29I7ciI/r6qxqoxDtr9GZzQWK4m4ul5MDxHvszWjfauDM+NdLSygblpwD
	 YeGAM/CC1i24s9/Z/xWg4HXPq87x0/LkGROMZdAt42jiwQRP7B4ttsWVvMA/xRgxw3
	 vOAfq5z6y3LtCFZoIcCuPGySHh+zUbpefNavwHDDPD2ozTtbZ1Dlhj7bUbAAaRGn0Z
	 XDYzi/HKvR9OsnZa/WFPaYJskx5ZwmseP2ea1nsHDlACf0Zl0CSI3DWxACn000jxMI
	 Y58ArQDnHqM198QeLdt8oou+d6oCb9N8flNjB87jvm3mzrvxhyfDgXIwYTqHSJzAYk
	 sZsHUtOFuPvWw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>,
 Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
 Carolina Jubran <cjubran@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jiri Pirko <jiri@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: 
 Re: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset scaling
Date: Thu, 15 Oct 2026 07:43:46 +0000
Message-ID: <179205022689.408196.2502809558369367458@kernel.org>
In-Reply-To: <20261015074035.1092340-1-tariqt@nvidia.com>
References: <20261015074035.1092340-1-tariqt@nvidia.com>
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

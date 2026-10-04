Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5238F947;
	Sun,  4 Oct 2026 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791097700; cv=none; b=BW7S2HZLPMd1h/2B8c7ITXA2TQYY52PofO6zlJxeyrF958dHd/6nHX5q1mvS+rahkgxo0dgmZB8S1zkEBl1/k5UcWfmtZhxvil+mXSTrqFwRTgfAKB/cXzdZF6AejO03CB7q107zvFSG2iwUlJp6k1SFlVI+WJ4z/qqM3+LqVuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791097700; c=relaxed/simple;
	bh=zvpmhm+BAUlfIVJ/6Kp9ShG7pA3G2q65FWBMzuTisWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UCPtY/aTxy+y6Uos98XC2NvMa78TO7926OXQUo4VTubWcZai1Acmi/cu53APGeHyWxH0nZA3wiVYwQNbnGgCah+igUuAxr4WsxOIRGiejKVg940XjYb297WOMzMmzfmBRahfpDZHwwxvcDk4OwO9Xxj4/wba7P9t/IF0hADjd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqSBMjPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqSBMjPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5751F000FF;
	Sun,  4 Oct 2026 07:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791097699;
	bh=R4WIaVmgxMJzlsaERAlBqwLuDwVcuzfSzsQMDWtKV3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqSBMjPGizCDA7dvs+RMYH2N1mB/6iSb4Cag9O+n0JX5pz3HcVN5168xoS2PG+EFt
	 Q75oRuhDw3gL/T20Sod5Do7rkRfSOdpWAzNaGWh8nUoZtKRiFY/YsNMrm3giMcaoBg
	 O+jBg1qO1TKjSjYciUuX6AzIvY/HhtmSczwWMJp+YsceYNBOxQvzlmhAJdcbgo4zbt
	 X6ahlPgqgwIOLqXvAKuvGo6o+ZE+TcYCTobtjz3sxH1MpdyoHXOwPZe2B81zwKFjQW
	 izPWR4fGfdZ2b43g1di0OnU+m+5ce8C3xdnQyOwwijIGSTz0AIpLwdaGAAX6FJip/l
	 ODU7RTM5x7YUA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
Date: Sun, 04 Oct 2026 07:08:17 +0000
Message-ID: <179109769789.1402591.13480427139921934784@kernel.org>
In-Reply-To: <20261004070246.215239-1-tariqt@nvidia.com>
References: <20261004070246.215239-1-tariqt@nvidia.com>
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

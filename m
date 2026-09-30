Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEB75187DE;
	Wed, 30 Sep 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788107; cv=none; b=s1yVIn3yrqTRewfEyAqe+e3+Su9IyXzMgmaJO9hc7pOZpQmQurIYKBehxRTWT9ILG0VMqSmuazMX4K/fs3YHrPocbb7mMd8+OISRKLKQaIjY/TkgwgEbHiZD/SdcXls9pmWboQeIaiy9OPebNoPcrdM7eOJBhmH0ZEJks4IXC2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788107; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nTR4/SgTdmd204b5JL+sFvYsuB4s4bRIFGW98UNqyI5qharWKgBy++EKExRoW0Dpm9TD8wD6O/QTuCV9cZpp/3dgWL4HQpv0AOhhLWzrxbkLtZ0J0HqCLrz+TLmpPJfjoABZbmvqDrBTcIUYxNCHni4A5kwlKuK2Xpa4lIK7Cio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZsTcLyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZsTcLyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918981F00898;
	Wed, 30 Sep 2026 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788106;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZsTcLyGyXDQmXDhafQb9DBpgxH4aoNWq0IkDIg/DaH1PzH43o6hGtlyV7uKbfNbO
	 Sy1X/6rin70o7Hppbs0hg4Iy3YAd5oNrlPO2BsdEiCj0rJYyYD5Fsl5qOT6IXmRqrd
	 HwjRy0QA6ranN9RMSWTnnirYHjRrFhLcsevdwtVXPQ8+WLOC1LK6HtSCE8xo+gvFJe
	 ztdsNFMFUaYUfMJ7llJ+QFsyw8qdbl8I6rciAsoUs8i1/Wf9LI+y5VcMcY3ChOS+3g
	 qqX4Y+JoCaiSkoF72uyYvx2F4kNEWOZya0jEH+oegyDITvOemDkbX+ZuS8arUJTcCl
	 lzNBbXb/ngGJw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Edward Srouji <edwards@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5: Lag, split aggregate speed into oper and
 max helpers
Date: Wed, 30 Sep 2026 17:08:25 +0000
Message-ID: <179078810510.31693.8484299734852796324@kernel.org>
In-Reply-To: <20260930170406.148548-1-tariqt@nvidia.com>
References: <20260930170406.148548-1-tariqt@nvidia.com>
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

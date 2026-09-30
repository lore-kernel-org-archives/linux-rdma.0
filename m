Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109FE352029;
	Wed, 30 Sep 2026 01:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790731428; cv=none; b=VOeGZgz1M+VX5gm1HvH4HkfBAx+F0jV63hA2MXEq2LHnA51IigF3KAiuJ/ndinJLbLCtBjDmUtiU1mFzdR86SL6eFUaB3aUTG1mizcXqQCzmToSpTQbp9Dd9fhc8DNdabNOn9MFVqkbaqnGxR3GFHE3HkYaUEX2pm769OD1tWxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790731428; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EbNIaLOKLAdXrSvvhYbdprqzeNoUzafN2wEhv1UgvsYtBqYZq/5BHdLw8BRPz10/sW25DZtp+V/oGuR7iTAtZS8I7rafI8ZB515JDmup0YccnrlgeCEe3tdzqKn+bn1tS99MmGrvBdqPznXU9/KlfP++/a2MXmElo4hBABUsjqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HkwetENP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HkwetENP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCC71F000FF;
	Wed, 30 Sep 2026 01:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790731426;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkwetENPS1CD62qTb2peJAr+eZB3Tk6MBfIRX6JrlO+NjKDFe+EHn0H3hhaccNXsY
	 iTuHqlIxl9nlH2B5ADarprIwHqhv20+FJ/KzdiT2KoLREsAtORiaraa5p1quqMPtV4
	 50gIgX/TsMbdvEc6soHm3DK/8EquXjFlabgpDyuvLZQH3iJXoODuCM+bakL0N6Ndp4
	 KdqkxFouvnl100jFSgvi3xveuw/Z2R5WybkVpFKB2ePFa9TKPLkoL8T4XT97huzxIO
	 6z5CtPHO5igQUWB+Qp73aYdFs6gxkAjJn+HVYoaTPp2MyLnJnMkbnbHrDmEpjSnV+2
	 0IfzgmjFbfYwQ==
From: netdev-bot+sinfo@kernel.org
To: Artem Dinaburg <artem@trailofbits.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, Shay Drory <shayd@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 erezsh@mellanox.com
Subject: Re: [PATCH 6.6.y] net/mlx5e: Fix netif state handling
Date: Wed, 30 Sep 2026 01:23:44 +0000
Message-ID: <179073142484.31693.6369739027942879312@kernel.org>
In-Reply-To: <20260930012143.95721-1-artem@trailofbits.com>
References: <20260930012143.95721-1-artem@trailofbits.com>
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

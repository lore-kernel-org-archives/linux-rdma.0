Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CD24FDE66;
	Wed, 14 Oct 2026 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982559; cv=none; b=PeVxqnYIH69qEuOUoVumUPBvFr0BtOc0Y9cyAYrQ52mEV/Rz4EX4/smB3CrOdNmgehQvMcztyxWPJqLL6BLxAoRxN+Xb1gAyJ+0mYWT6Rxzb6CaJUeZdX/1hdO9ZY5VonWUKb8wxT746GCDoe6Rtz0qnscjSceJYuASSE4dwWAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982559; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=neFK3EVPY6YENd8PfyO/ZN2DpJzXnIVPCbfx2BYzyRMP1IZZLXd002yRsByyQhjy1bQjq9nGVxLde0uqeE4crPEAAb62zL8C+FXnp6WdZXF3lk5T6pIN+ZfE81FYOMuQJxlqYjfs4WD92Og4A8KPrY85HiebGciByw2mXzGfdgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nU0EpuY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nU0EpuY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833B81F000FF;
	Wed, 14 Oct 2026 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791982550;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nU0EpuY/kqEhj+nazoEHySQdye5JYzC0oIB7AKCgy2yFvJAIv/w1LKpxCR91DIMUH
	 O06iVjInkJ+n696hC9U+oaKotdNxWOSdqCGJfOG1ydvsZelUspwK9KwfY4YV+VS3/g
	 LXna5DBYL97tLRU9C7ufDYGL1RSTxyaZj4aHpDmYVxGC9TRFW7PnI/mah797Me1LK5
	 Q6AyXMeGQy5Al3VZLeUbIf8TASLsmCG2TB9mAwGOSIkPntTwOmP+yFhIn75+xLdKib
	 s0g6sPiEucXZEv84OFtxbA8XNyxLbiY5i0/zF9mBvxqLjjEQc386TUTNM0EqBy9cV1
	 Dlc3Op7DZVq+A==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Joe Damato <joe@dama.to>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 "Nabil S. Alramli" <dev@nalramli.com>,
 Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Yael Chemla <ychemla@nvidia.com>
Subject: 
 Re: [PATCH net 0/3] net/mlx5e: Fix CQE moderation mode reporting and control
Date: Wed, 14 Oct 2026 12:55:49 +0000
Message-ID: <179198254904.320699.16853742213486052764@kernel.org>
In-Reply-To: <20261014124704.1017782-1-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
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

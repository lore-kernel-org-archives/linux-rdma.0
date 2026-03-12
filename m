Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4E238229D;
	Thu, 12 Mar 2026 02:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773283770; cv=none; b=npgd3mtfbkX64SodQMlNtGq0iFDlSdKb3M2+UIZv/HjsoiS3fgQt03NXQIYEN82rmRWKuB1DNJ7TcZmYKGZiutTDOsiGwIua+ZJ/SJQ/Cd8KOefBziRKE1c7VwO60krXFd/1v5w/a9c6mfA0O5bSKtsvSGEhn+tbpsrawwK38Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773283770; c=relaxed/simple;
	bh=t29lE+1pJnepXVpEJVjVhLyFN27mXL8YNyxsbPCtvDM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDJiypkkqL64HbsAW/WsgNMr3e/ezDEjaD/uM4LA99kzi7YuugCONomKMOildJ/s4PzTJ6Zr5TvKqUn6yGJ3hR1N3zgjCL/vLwvI8r5KeoMts2oCYm+FG1Q0C5OIVeyjHXpIFh1YB3LUW0KrIBrSbKD5vHuvNWVJnzdq/Yxss8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2BiD4VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2BiD4VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AABDC4CEF7;
	Thu, 12 Mar 2026 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773283770;
	bh=t29lE+1pJnepXVpEJVjVhLyFN27mXL8YNyxsbPCtvDM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t2BiD4VHgivekkZrTjByr8V0+e0f6fqP29pQ0wrzb8gNdNUs4ozcz7O0MxJB9ox6/
	 zg8SWVskrvBqqvzfI+W/Qwg096+GPeKoS2pjLv82tmsecpUAGu0Ftg2q7cwnZz29Zy
	 0jDTa4NZ6Lj8lMNFJ5a306C43jU9QAC/N0P5dFeF4fqQRFwrjtcEfQHsTgFCxkuvAq
	 zd+cAEOGeliFaI7xQ3G6CWc46fO3EY8IjES+il/YAlFR4tjOxMrbQL2U4yn40OsxEv
	 tlU2QXMac4rEdyWoJyCILEUHfTCiALTxF6bQkF1f71hz4bpnLI3FssN9zFjV4UdVbr
	 X2mnUaqnRWv+A==
Date: Wed, 11 Mar 2026 19:49:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>, =?UTF-8?B?QmrDtnJu?=
 =?UTF-8?B?IFTDtnBlbA==?= <bjorn@kernel.org>, netdev@vger.kernel.org, "David
 S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Donald Hunter <donald.hunter@gmail.com>, Eric Dumazet
 <edumazet@google.com>, Naveen Mamindlapalli <naveenm@marvell.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Danielle Ratson
 <danieller@nvidia.com>, Hariprasad Kelam <hkelam@marvell.com>, Ido Schimmel
 <idosch@nvidia.com>, Kory Maincent <kory.maincent@bootlin.com>, Leon
 Romanovsky <leon@kernel.org>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Piergiorgio Beruto
 <piergiorgio.beruto@gmail.com>, Russell King <linux@armlinux.org.uk>, Saeed
 Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 02/11] ethtool: Add loopback netlink UAPI
 definitions
Message-ID: <20260311194928.0d1dc338@kernel.org>
In-Reply-To: <abFJB6mZc-0qNbrd@pengutronix.de>
References: <20260310104743.907818-1-bjorn@kernel.org>
	<20260310104743.907818-3-bjorn@kernel.org>
	<580debbb-8f6c-4b60-95ef-22c68480ded1@bootlin.com>
	<abFJB6mZc-0qNbrd@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Mar 2026 11:50:47 +0100 Oleksij Rempel wrote:
> Looking at the current patch:
> - component (MAC, PCS, PHY, MODULE)
> - name (subsystem label)
> - id (local instance selector)
> - direction (near-end / far-end): These terms become highly ambiguous in
>   branching topologies (like CPU port on DSA switches).
> 
> mixed loopbacks across complex interconnects, userspace will eventually need a
> Directed Acyclic Graph (DAG) model.
> 
> By adopting a DAG topology now, we can reduce the load on the initial
> implementation and bypass much of the ongoing naming discussions, as components
> are identified by their topological relations rather than arbitrary string
> labels.

Not sure we need parentage chain or just "stage id" within each
component but FWIW if I interpret what you wrote right - I think 
I agree :) What matters is the topology not the naming of things.

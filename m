Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580395;
	b=WSXLytHUrI0OKMhvrhFBicvA/NkJmc5kQjJI9/udQ7LYFTXPE/zCJBhSjTAzqCtPMN38
	 ZvvZwvy19TrPR9j7IC+5qY3W5kA3JCXF1TyPjQcQTpc1i4rHJ3cUoSAWv/rUlZOxZA94e
	 jPxNpx5D+mKQ1qSVoXdMuEgo57PhbrAjTbdvmQcP439RBwDOtKADhPjISjde7chw/gxdi
	 yABu7EoSSwjX+Rqaa30qCM1u+H/7YQdxGARhQCELJywkRQjw0sN4RPe35grDwuqXTzXqQ
	 MYgJJzDESb/f35Eka7zHEGMeji5ExZ7paPiMbUSc+4OuhXS3qq0F5CZpA2ofus+waJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=G8v2e50XhLomGSLoGMxev4ZYQsIaen/z4rzlnOSj0ZfvPd36eBYmMrwJ2eT/yqzK2lca
	 2rGc/v25R1asR5nq/dMQ+WRFyGjoZvxOjiXcJSH9SWCktKii5jW6QLS+q8Jl6d9oZCl5V
	 o41sRPl2VelZxkeiNulI3ankonUnVMGAunLC3SvI7DZyYBEcFEkyrQppfI2fJoSmmjwjR
	 5lsMYKute+pBc+FDSFmt+Yp3dpxo+hAAsfD4G//3QvLr3yqj14vGkB7SAZfu+0JNy2iPS
	 p6coUwgoddzYDaYI2NeEALN/MQ+LBEetcE+PeHjvZiZzydWJH6wbI/DMx8v/WMPj5SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGAVP2PW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134AA606A323;
	Wed, 21 Oct 2026 10:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bGAVP2PW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547641F000CF;
	Wed, 21 Oct 2026 10:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792580394;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGAVP2PWs7TsABoef0+0loPEw/F4nPDoiPvfBYCSfDknRZ9X2pj/ChflzXSoKcIbu
	 +psusGqPMfCp692cx0D4Q/Sypu+dewmPV39MpZ74THrg9WB1hYGipHN7Cp8Gj0C0T7
	 +shu7OmGwklVPNX5n5w1zbBw8ct+yIaXU1L6pnBBCv+Gx5FqHY4KaZHdLexQjoRQT7
	 asqgmQ/VPbPDnCCXaNbIOH5lmbI9ai7g4eZ8IEVykx24u6sIq0WtqbuZEdt77SkiA3
	 kHyX4wJsQ4J+zxyCKx8E/GIYT4OXdL7E1VSGAYmRS11ft3Hc2hy3RmzjNEilOmM9tn
	 sUYhTGycCOdRw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <markb@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@mellanox.com>, Patrisious Haddad <phaddad@nvidia.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shahar Shitrit <shshitrit@nvidia.com>, Thomas Gleixner <tglx@kernel.org>
Subject: 
 Re: [PATCH net] net/mlx5: Use only loaded devices for PTP clock operations
Date: Wed, 21 Oct 2026 10:59:52 +0000
Message-ID: <179258039278.3290.9931291968534367820@kernel.org>
In-Reply-To: <20261021105600.3481485-1-tariqt@nvidia.com>
References: <20261021105600.3481485-1-tariqt@nvidia.com>
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

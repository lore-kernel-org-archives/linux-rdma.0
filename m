Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352642;
	b=gUmVJ/Qq9Qn9RlJwn8UJz1q8hS0VwKZq1DKVbbMEURVRDsRV9lZ/tM7XxJtBhSjzf+cw
	 0ewpLgWBZiP6OcpTosbBpOpqomEYelfiBJWbLx/EyoIgD/OieH9wnk/2wV5sxJX5R75uE
	 rGBJVTjGNi595yEmpGbJy9sVCD4rVvpx7Q1GGTPWSwfoKGHqRfoF8eVHO7LhNFQnNl5M3
	 onjkCJNpyW9y5P8+q3kG7+Uor4jsQyvXd3wYEMgOLA0La9r3OpcICUZysxx60VC0s3tYZ
	 +aAW8y6xE2WMTz305UsYlPOsXbGyYm5DLtm7zOi+yVvK+7WssC8rdMweQVHvtHyH4aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	b=DvCene54f8JoHBVAdYusVChBuzep9mDTDlOTEveYCj07lvkcEX3PpW2Uqqv0J+3xsq7d
	 n/R7vEvZDbnhqJY3C8nTBWIoY8U2qnKptSWUIXACD/Yg4VqhvThSlDj/dwm3JeMzu1HIL
	 hKxXm+Q1h1NGFiTof+ViKJVPcE8d8I9OzyZzzZdaEtfge/sjoKYQ49gDmApxgEHrAK9uM
	 EtaBiFvPGcbUrPgPOnTO+4Fv4LucFZbp/dDtlo1Kfa9jlVyPXCk8ZhlHaiSbp+/s+yksI
	 NMSE/vHykLrpoTs3KAxgyJYOpPL4tfOF+8V6qXoG+ldmkFZ116mNBOMk4LqperHwXZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NVcbbR/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A64F606A320;
	Tue, 10 Nov 2026 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVcbbR/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA91F0093C;
	Tue, 10 Nov 2026 23:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794352642;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVcbbR/u6YHy0CVJMQN5pzuITpPdRA8j7Q7mCejlkTnsEoM0fpjMg3oDPUSU8IZTE
	 HUJeFjaHdpF3rD3VVuhwuJ8sHme+sxF+Fp36LiIWm6+ZuZKeJrHeYq9L/VjkHB+vbh
	 Uj1YjpV0yHMYJJjz7UFYUKF/2lyzRuHMH/jlMPZvpIXX7thjjnLONkXWj0OEwFMVLt
	 Qhpj+mWTUSJ1QmhuvSwbs/XnzUIq/fcifq4ftzvqJ2I9snnn1d6JSEZJ3brxrF+lIu
	 TT2k0bC9HBSjqg2b0EDSkV+WSHb1L8uCXCqgdbNIXextdYsbqe8JdkdeypUm2xblRz
	 lPTLwmodGMKWw==
From: netdev-bot+sinfo@kernel.org
To: Joe Damato <joe@dama.to>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@kernel.org>,
 linux-rdma@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlx4: cleanup and doorbell fix
Date: Tue, 10 Nov 2026 23:17:20 +0000
Message-ID: <179435264086.488859.12644173782807656441@kernel.org>
In-Reply-To: <20261110231304.1859217-1-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
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

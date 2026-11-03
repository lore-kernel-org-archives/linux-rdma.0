Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716112;
	b=XN4EQL6JPkL6Da17mPzEAvJt3rljCD1Fn5Am4ZgLX6E10EPN3jiI/pTVW8UYeCUP8Son
	 72zTYf8uzRlXt0sYUxbCNqc7MSF+BUlGmHhJULCsRMKqzxDre3gWsip7hERt04sJIZeZn
	 RyMTOsWZWpJUEW5/1zs9em3BiHydPYh0DXHSx625Xs+TavoZgvc7lB24ukEKcRnn+c9Z7
	 QH+o0XI38mqB86ML9idXz+073DiTvGyDdJeQ49nrOkPs0vnUIAcZwUln3ZOv1olPweN6u
	 3J9EbwQewIS12ufZ7VzjT/VuymrrJe47XnGyQgGGtcWH5OgMSHzU9MqHq1IOQSu0Qdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716112;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=UdCrdVZDlFndt41z3bOYToZNZuvFj+cGbPGOI0EsK3c=;
	b=KeAb5TOVeDDgj3LEWX5zMppOgRHvxohelfV7N0f5bGK0UiV0eowsfEqLcfIAWDCW7NC/
	 IElQKzQOovFLwY00fmLjai0VdtEbrabc3/hejjd6ivQdl8v0KNdD5nFalvCnBtwvZ02u/
	 lXWH/Uo/DpzhOhL4X4ArjnDm9IBK+J0f6Qu+nrDnx4qtYf6p+lBJYjXsLgtCTalK0H8Ad
	 MqAnwu56Ja2cYxpR6JD7YO2rTZQSXz3AVJi9BRIxkmCi2JH2e6tK5cRlBqlSEmc6zobvT
	 MSpiHYZIZHH7T7oV2z1bJK181UzHr8TOGaBOxdmxKubD2WPl8gi71+RgGPUVghtf/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tpdud+3C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0807606A324;
	Tue,  3 Nov 2026 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tpdud+3C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A141F000C1;
	Tue,  3 Nov 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716111;
	bh=UdCrdVZDlFndt41z3bOYToZNZuvFj+cGbPGOI0EsK3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tpdud+3CVTx4EXgG0n1UYnDjsNjSYDWp0IhdEQ9xm4ODBqo65s5eT+h9s5Jlyjel0
	 4aJ813vPYUdS92yJC+bSEbpLs5bBTgsoREc0rYzum9wx714WiCg8zKX7sFX/Vm0RlB
	 xqgfa5GN5YnYUpMk9l/0glqdetN30GfhOsorjEbidU1C3LDURdEWz+4KNhGVR/VmuC
	 vY0l7L4JHwGtCdTe4gPcUMayWjfCSD7j6DEuOiB/TiSTdvjR4WxPbQkg2V/4E+w4Ay
	 gwMcVnfhStEpP9t//ddi7V/GPgCYogNycrq4CKWLjsp/dbQ/7UYrd0v1E6b+86R/2I
	 dMi+C3/lOGhcg==
Date: Tue, 3 Nov 2026 16:28:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Doug Ledford <doug.ledford@hpe.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Iraimani P <iraimani.pavadai@hpe.com>,
	Mamila Santosh <santosh-kumar.mamila@hpe.com>
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
Message-ID: <20261103142826.GJ264423@unreal>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>

On Fri, Oct 30, 2026 at 09:35:28PM -0700, Doug Ledford wrote:
> This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cassini
> NIC. It exposes the NIC through the verbs API using the UET reliable
> unconnected (RU) queue pair type from the UET RDMA core series.
> 
> cxiverbs does not drive the hardware itself. It is an auxiliary bus
> client of the cxi-ss1 Cassini core driver and does everything through
> that driver's exported CXI interface.

<...>

> Before posting, the series was reviewed with the Sashiko AI code
> review tool and checkpatch. All valid findings are fixed, except the
> open items listed above.

<...>

> ---
> base-commit: 306a2f8432f516069b2e673de7a07043132c034f

Sashiko failed to apply this series as this base-commit doesn't exist.
➜  kernel git:(wip/leon-for-rc) git show 306a2f8432f516069b2e673de7a07043132c034f
fatal: bad object 306a2f8432f516069b2e673de7a07043132c034f

https://sashiko.dev/#/patchset/20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com

Please make sure that upstream sashiko runs on it too.

Thanks

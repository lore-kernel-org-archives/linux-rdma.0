Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683332;
	b=lUPZ3tm5iuQ/5HIspph950RCy9/PlL4wip0v0N94rtO0fCT3t7vUWFJ/mbXyTZKBdYmX
	 FPiRaLO0qfZ0x2jlNPRjvwUlLvChxcYDtpG/fv728aRGX45cFM5rq3gdTgHBvrjMnUyjV
	 mEvuJXat8ZsowRxQdiWeAsYzVPXlxkJ2e46TTLvviE7ukMhcI0R7pNenpnPbDcm/Ytv+7
	 FPsjO7HEKo8wvEYsUKmkjHNdwMouX+74egC6hTUrmQ6TpPelrK/UuPoEURHZV4QEI6beP
	 wlACvZgcbN5cYqhq6l4kM6z9ULZgMrWeyWFb5eyKGn4oAphQJr/aw+dql9ic4qxhwZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683332;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=HqWxM4sTStKjFp4q0IoH0AiF+PXEee7+fHFB3ji0SXk=;
	b=4S7gK2z6Pd1tDrGdiIc/3sPB0A/aFkX+8lvFqyQykYimBgxDVijBjkl36CN9BeQviybt
	 ftk+8cvBbQ8yRobQ37XYcU2d8ECLzNWUrMlxdGiX6SeIUmPti7/IsK4UWzB+PvF8RVWuJ
	 BO4iY6aNi1TYZasPAzQqXdlfwq6qJ6Dc4fsb6JYsoQHTps+RcOfIB/OZSoxTC0cwnWlBd
	 ahuRivkT0hhzkFpfjGFtZRJ+w4jCBndhFIJZwMu8MgbbgTBDKF3dKMEE5nmQ0dmkKVcu6
	 MyroX8947AD7NOP4sE/Kjt0Wg8quuUS4gD6jZEmmS2CeoVU4wAwElbIm5mMUMUWqC/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMaiWCp5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339D606A326;
	Thu, 26 Nov 2026 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bMaiWCp5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B2C1F000C4;
	Thu, 26 Nov 2026 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795683332;
	bh=HqWxM4sTStKjFp4q0IoH0AiF+PXEee7+fHFB3ji0SXk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=bMaiWCp5KspGN4lA5icZTBR0qngrGj35PeNTZDNXEjbUzm1Zlm2t6pCk8kN2Hn0KA
	 mLlDHjEMrSclrphZUeODQTXUQ3f4SbBzMR0BwWMcKAfUtcca8Z7H1BCxxopA/5/yTN
	 6pE31pAtsWmsZZyfAgxApwJbrqfI2H8ldVT3k2oR0hsF3meOeTVWJS+7IQeAn/SrM1
	 VeV6qdS+5OYAnVXZ+0bs4AN5UpLPxlOzIL8E4RqSDCZ6VHlfvwNMTszB1U7cgyOcXx
	 0qMtiRA68jW+y9NN75StgGuuZU73sKHmFDdC35z2XnKopxmBW98tHNIHnBnFeRpASQ
	 24bVXXcB720jw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Maor Gottlieb <maorg@nvidia.com>, 
 Chiara Meiohas <cmeiohas@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Maher Sanalla <msanalla@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
Subject: Re: [PATCH rdma-next 0/9] RDMA/mlx5: Don't lose port configuration
 events during probe
Message-Id: <179568332961.1250082.2132083992228429570.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 03:55:29 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 22 Nov 2026 19:39:08 +0200, Edward Srouji wrote:
> mlx5_ib registers its event notifier after ib_register_device() and
> dispatches no event until the device is active, so a port
> configuration change that races with probe is lost: ib_core and the
> clients keep what they read. A lost P_Key change leaves ib_sa on a
> stale P_Key index and IPoIB without a carrier for good, as OpenSM
> writes a P_Key block only when it differs from the one on the port.
> This is hit on hypervisor setups, where the SM can program a VF's
> partitions while it probes.
> 
> [...]

Applied, thanks!

[1/9] RDMA/mlx5: Validate port number in handle_port_change()
      https://git.kernel.org/rdma/rdma/c/b60b42559388d3
[2/9] RDMA/mlx5: Don't let a slave port mark its master active
      https://git.kernel.org/rdma/rdma/c/57e8846fbc47fa
[3/9] RDMA/mlx5: Flush system error and slave port event work
      https://git.kernel.org/rdma/rdma/c/4104da4f89854a
[4/9] RDMA/core: Derive enforce_security from the cache event
      https://git.kernel.org/rdma/rdma/c/5e2c7d3b46a3a2
[5/9] RDMA/core: Add ib_dispatch_event_sync()
      https://git.kernel.org/rdma/rdma/c/40fde0fd31f0b1
[6/9] RDMA/mlx5: Pass the port and subtype to handle_port_change()
      https://git.kernel.org/rdma/rdma/c/6db275d186dc45
[7/9] RDMA/mlx5: Activate the device in a stage of its own
      https://git.kernel.org/rdma/rdma/c/9c31888fdaf66a
[8/9] RDMA/mlx5: Replay port configuration events after probe
      https://git.kernel.org/rdma/rdma/c/c32ba2c6e113a6
[9/9] RDMA/mlx5: Register event notifier before IB registration
      https://git.kernel.org/rdma/rdma/c/bcfc30f05f9b87

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


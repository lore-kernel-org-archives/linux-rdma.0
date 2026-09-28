Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA4409102;
	Mon, 28 Sep 2026 19:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622512; cv=none; b=qqPbB7E2lGEC9E87LXyQgLIhPIUCIQ3siJNg4rts3gIwI2jVgTJpaKMI29+IkLG60sGBW6kOvNwcfB1RaCzrEiQFMdkRYHlpg37CPNftJFCoRgPISc95sv9UViVkA1iyiDB9axw9uKq/N8v3VHQV66Jtku2u1rDUL/tPX+OQQ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622512; c=relaxed/simple;
	bh=FFiNJNkkYfzsH79UwNXC518+qVzZYPjByNLl+KNkvHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgaORGGN6d9NwSM7g5SA/glLbQV6oTWDoTS2fjJdVvkubOeYkdEBvUzVDndb1sAE3QXwccifFK4zUdm06/UsrwuzqRRoYV76AJKT8a0O9KRiJvZDo+1WwyRLAMpoqGjwVvfsSQxB5FirjS7On6h1bIInu4pBMDd1pv4B1V93jsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUzYA8SK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUzYA8SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971801F000FF;
	Mon, 28 Sep 2026 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622511;
	bh=mF+SMrQYRFHkOS0SXrpou4paQ8X9+SDGo7RetcXsTh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kUzYA8SKLVc2z3wXqeIiiQOLqHfJX/rRv8yOK43+yJQafJAtorAybArJPGioh8SRP
	 zPKJVbZ/McxiYJag6R0abwEPr4HxSQENID4BfGXWR2Sy+2u9H2j131OP62fZeZPkTw
	 LdLjtn9cmrYykaZHgeKTQIv+fSu4MO/MPWJh86dVVyVydGN1FBB+g0nALJ3m2Vah0Q
	 3hOhUSBe9w+vw7f6NSYvp6vh0FRD8b1fO9jObLMOTYZ70mYz6BZQSYP8lbBKWzo5Gq
	 80qlvOiL9w0R8a/BMSdiHotc4actKE0XTxWD1MNkjSvv9t3UedGcUqUOFiAbqqiIxH
	 wxW+z1WwqEw0A==
Date: Mon, 28 Sep 2026 22:08:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Cc: jgg@ziepe.ca, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	jiri@resnulli.us, kalesh-anakkur.purayil@broadcom.com,
	ynachum@amazon.com, kees@kernel.org, mrgolin@amazon.com,
	parav@nvidia.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	anand.a.khoje@oracle.com
Subject: Re: [PATCH v2] RDMA/mlx5: Add poll-EQ callback for ULP recovery
Message-ID: <20260928190827.GB563127@unreal>
References: <20260921085006.1443240-1-praveen.kannoju@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921085006.1443240-1-praveen.kannoju@oracle.com>

On Mon, Sep 21, 2026 at 08:50:06AM +0000, Praveen Kumar Kannoju wrote:
> Some upper layer protocols, such as RDS, use mlx5 RDMA CQs whose
> completion EQs are not shared with mlx5e queues. If an EQ notification is
> missed for one of those CQs, the ULP can remain idle until another event
> arrives or a driver health recovery path polls the EQ.
> 
> mlx5e already has a recovery path that polls a completion EQ from the tx
> timeout handler through mlx5_eq_poll_irq_disabled(). That mechanism is
> internal to the mlx5 core and is not reachable from RDMA ULPs such as RDS
> when they need to recover a CQ-associated EQ.
> 
> Add an optional RDMA device operation, reap_eq, and an ib_reap_eq() helper
> so ULPs can ask the provider to poll the event queue associated with a CQ.
> Providers that do not implement the callback return -EOPNOTSUPP.
> 
> The recovery poll path is sleepable: mlx5 disables the IRQ synchronously
> and serializes recovery polling with a mutex. Document that ib_reap_eq()
> must be called from process context, assert the contract with
> might_sleep(), and reject interrupt-context or IRQ-disabled callers with
> -EWOULDBLOCK before invoking the provider callback.
> 
> Validate the device and CQ passed to ib_reap_eq() before dereferencing the
> callback table or provider-private CQ storage. The mlx5 callback also
> checks that the CQ belongs to the supplied device and that the mlx5 device
> and completion EQ are present before polling.
> 
> Implement the callback for mlx5 by mapping the ib_cq to the mlx5 CQ and
> polling the CQ's completion EQ through a new exported mlx5_eq_reap()
> helper. mlx5_eq_reap() logs the EQ state, invokes
> mlx5_eq_poll_irq_disabled(), and reports any recovered EQEs.
> 
> Serialize mlx5_eq_poll_irq_disabled() with a per-EQ mutex. The recovery
> poll path disables the IRQ, runs the EQ handler, advances the EQ consumer
> index, and updates the CI doorbell. Multiple recovery callers polling the
> same EQ concurrently could race on that state and reap the same EQ in
> parallel.
> 
> Use this only as a recovery path for missed EQ notifications. It is not a
> normal completion polling path.
> 
> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> ---
> v1: https://lore.kernel.org/linux-rdma/20260919100609.732391F000FF@smtp.kernel.org/T/#t
> 
> Changes in v2:
> - Document ib_reap_eq() as process-context-only because the mlx5 recovery
>   path may sleep while synchronously disabling the IRQ.
> - Reject interrupt-context or IRQ-disabled callers with -EWOULDBLOCK before
>   invoking the provider callback.
> - Add might_sleep() assertions in ib_reap_eq() and
>   mlx5_eq_poll_irq_disabled().
> - Validate device/CQ input and CQ ownership before provider-private
>   dereferences.
> - Serialize mlx5_eq_poll_irq_disabled() with a per-EQ mutex so concurrent
>   recovery callers cannot reap the same EQ in parallel.
> 
>  drivers/infiniband/core/device.c              |  1 +
>  drivers/infiniband/hw/mlx5/main.c             | 18 ++++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 25 +++++++++++++-
>  .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 ++
>  include/linux/mlx5/eq.h                       |  2 ++
>  include/rdma/ib_verbs.h                       | 34 +++++++++++++++++++
>  6 files changed, 81 insertions(+), 1 deletion(-)

As noted for v1, we should not add an API for ULPs to work around
driver bugs.

Thanks

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FF93DD86F;
	Thu, 15 Oct 2026 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056125; cv=none; b=DrIi+V9Qg2eh07xYBp0CTOuJL7vFqo599VKkLYkAqeI4RmZnPwf/NwUIKMbqf4keBWl8C2S8so5vVWrBn7HlQWQs8r+qcFwprERdS8sTOKyd7dRc34mbUiyUW9mcgqWq882dAZMQsDIEu2neWPYvHL0BrzRinsh5FsTE35v+P/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056125; c=relaxed/simple;
	bh=CAKYVj1U0g6GBVdWgBPDilKUVYF9bVX+TIjpGxMFNfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/GjjrDedLjDxHlX8HyGcO6TjwBBBrzm1724BEOP7SeMYm6AdHLf3YE+OfXd8pb4c/wvSc1+SIQM4c7LGb0LmDXVwFIzBQpkdBwzPRqsq98HMqUWAec3RC7ulzPrxpyLwzoqjX6/g4oNgDA0qviLVEJb1d+B/NC38Sg0YAYxC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXwEv6c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXwEv6c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779411F000C4;
	Thu, 15 Oct 2026 09:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056124;
	bh=ku3TKGB0PATxhfChvUbNKqRJemvZDJ7u9QXPNgQS0cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RXwEv6c02mM0CwUh/hgHHjvhYw7LDHofcvMVjsvt0VZD1KXpmkatRo1twy5TbbIHi
	 Krfqfs/hOVBDQ8RqjnUaqhEb5Suoj8LVmvx8E7QaMlNBQLXF84IKB96B7XPQtSmbdz
	 oPVsPXUB60jdRJQIdsMh9X+UvOLkxBwthl9z0BZMEJAQ6qKuu0fOJWpoeDQzafKLm9
	 wU1SNPMrh7mftjURlLGEa41sbfVu65r2Y9bFM1034mAgmryqUm4o8iwWBy8nBRF3af
	 0xJvC1LdP6V2wn6oUqpUuvo2rGY+GekxL7bEx8AbwU0KRulf7p0Fz1YIv6G2VIP5ho
	 Xe1iilvCQ3Czg==
Date: Thu, 15 Oct 2026 12:22:00 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: tariqt@nvidia.com, petr.pavlu@suse.com, yishaih@nvidia.com,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: mlx4: no ib device for Ethernet ports without IBoE since v6.6
Message-ID: <20261015092200.GZ219304@unreal>
References: <CAFcZKTyCu7K=1OOETBvVrKf-9YKHRk7wXNRyZW7m5P0PEPg1zQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFcZKTyCu7K=1OOETBvVrKf-9YKHRk7wXNRyZW7m5P0PEPg1zQ@mail.gmail.com>

On Wed, Oct 14, 2026 at 01:55:48PM +0100, Peter Morrow wrote:
> Hi,
> 
> Since v6.6, mlx4 no longer creates an RDMA device for an Ethernet port
> when the device doesn't advertise IBoE. On Azure, ConnectX-3 VFs are in
> that state, so DPDK's mlx4 PMD can no longer open them:
> 
>   net_mlx4: cannot access device, is mlx4_ib loaded?
> 
> Petr, thanks for looking at this off-list; as you suggested, I'm reporting
> it here.
> 
> What changed
> ------------
> Commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus") creates the "ib" auxiliary device only when
> is_ib_supported() sees an IB port or MLX4_DEV_CAP_FLAG_IBOE. Before it,
> mlx4_ib_add() was called for every device and accepted any IB or
> Ethernet port via mlx4_foreach_ib_transport_port(). An Ethernet port
> without IBoE got a raw-packet-only port. mlx4_port_immutable() still
> has that branch (RDMA_CORE_PORT_RAW_PACKET without RoCE), but nothing
> can reach it now.
> 
> DPDK's mlx4 PMD needs only that: it opens the device through ibverbs
> and creates IBV_QPT_RAW_PACKET QPs. It does not ask for RoCE.
> mlx5_ib handles the equivalent case by creating the device with
> raw_eth_profile when
> RoCE is disabled.

The best approach is probably to add a similar mechanism for mlx4. However, since
that driver is quite old and has limited test coverage, it would be better to
implement something like this:

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index 82e467c45d23..31860b4abe43 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -43,23 +43,12 @@ static DEFINE_IDA(mlx4_adev_ida);

 static bool is_eth_supported(struct mlx4_dev *dev)
 {
-       for (int port = 1; port <= dev->caps.num_ports; port++)
-               if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
-                       return true;
-
-       return false;
+       return true;
 }

 static bool is_ib_supported(struct mlx4_dev *dev)
 {
-       for (int port = 1; port <= dev->caps.num_ports; port++)
-               if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
-                       return true;
-
-       if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
-               return true;
-
-       return false;
+       return true;
 }

 static const struct mlx4_adev_device {

Can you please send proper patch?

Thanks

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6653B637E;
	Wed, 19 Aug 2026 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787150179; cv=none; b=gq5BK5Ci4OlWdpRH7t97uz9hlg5ZkkKsVoLuEt9wLOLpNS48nV2dBVBviVeTAMXKnd9awJvQm//FF0UqP7r5rYGTNJQ7PvggfbRoR/O0wmMQEvFObInwoCleF7hqCB5Xl78tAfOUmW/DZZfNtuSm7OjSPLfBYQXAQCQewzBgLS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787150179; c=relaxed/simple;
	bh=W5+RB1kh5G2NAioQhMSFs1Z9+Gv/BMq6ShELO+gpRkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxn87q8dGvhOBiV7tQ7QkmdtLCt0+zYgm5VDMPy6ZYfgsn75NHVIqyziklb4xBF8+dUqIOmqRD1nC6Hq3ahdpvDZqU2jv5hswrHm71UTEAMu7GSxgxxNzKo89fCG6TGnzecg1k00fGPhckKRQ+zaJlHtyKjU6nMzqh41cxuDiUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJIlnmEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJIlnmEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9141F000E9;
	Wed, 19 Aug 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787150177;
	bh=AqFgiGxP5ESF9RsoMfA8QXW9PcZaNheAxHHBKBnNefQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MJIlnmEbxHjVXs9vfjnaGugesm3h24CmO3NjCAvyvpjcLJHLZHWKl9VL4f0GcWVIb
	 sYz8TgBmeIdwAHJUJpx9Vyy8893Fp+2cQ1dYmyKUzZvFHT+VBaBj/+UARx88Gu8Lta
	 VPRGwR23+20m5C+BTmOrthDfqY25wbIJmSPMuysBfTcl0CAM6HOHzTY3uOsi6eOhec
	 PmTbp88auI9NyybhsRAc8ORvVnKQJOIDOQDDSPvmqj2wLVtb64mUBnbEP9WhgZSw6g
	 aScV2zTpU+pUeP+hhAXrv5YW9oNkVT9tI5VsVNWeJcXRf6j8h2+WPp1OgZSdIT2xt2
	 tIgnDWvycs4cQ==
Date: Wed, 19 Aug 2026 15:36:11 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>,
	Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net 0/3] net/mlx5: Preserve speed and state across vport
 modify commands
Message-ID: <20260819143611.GT265046@horms.kernel.org>
References: <20260816065015.3280733-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816065015.3280733-1-tariqt@nvidia.com>

On Sun, Aug 16, 2026 at 09:50:12AM +0300, Tariq Toukan wrote:
> Hi,
> 
> The firmware vport modify command bundles both admin state and max tx
> speed in a single operation, which requires each side to preserve the
> other field when it only intends to change one.
> 
> When modifying max tx speed, the driver already queries the current
> admin state and passes it back to avoid overwriting it. However, this
> query and the subsequent modify were not atomic, a state change
> between the two could cause the modify to overwrite the new state with
> a stale value. The fix holds esw->state_lock across the query-modify
> sequence.
> 
> When support for setting max tx speed via the vport modify command was
> introduced, the existing admin state modify path was not updated to
> preserve the current speed. As a result, the firmware interprets the
> zero speed field as an intentional reset. The fix adds a speed query
> before the state modify and passes the result back in the command.
> 
> To support that, mlx5_query_vport_max_tx_speed() had to be fixed first:
> it was returning zero whenever the vport was DOWN, which was correct
> for the query_port_speed verb but would defeat the purpose of querying
> before a state modify. The DOWN-to-zero logic is moved to the
> verb-layer caller so the function returns the raw firmware value.
> 
> Patch #1  holds esw->state_lock across the state query and modify in
>           the speed modify path
> Patch #2  moves the vport DOWN zero mapping to the verb-layer caller
>           so the query returns the raw firmware value
> Patch #3  queries current max tx speed before modifying vport state to
>           preserve it

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>


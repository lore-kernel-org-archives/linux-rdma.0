Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C70339719;
	Tue,  1 Sep 2026 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257937; cv=none; b=E9M3Lvo01LoK7axJIRnMnrSAXV0xSU5uvTatJhDcd4Lw0dtd49gsP2620jX4tmcy1A/A2G/CvzBqkbHz4Ns9DrwtAkZkyw62KSICrbW59727SfdJKNZMfKN0sttC4UcXVOm2S/YE3uniM4++0gfUCu3fONNcPCJ1rzGt3L2ptdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257937; c=relaxed/simple;
	bh=WQX3IVodqbImdCBSG+YJAJR6aIXwTH2ynIp8BtWgjMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejoTKzRJl6PnPgc1EYSrFmFPYPJxf9gm3VtA2WnokUCmd/DlbdloalALqTxCCwN/Is9216LlXQpEXlweI89Hm7gelGAEcJVQeZJgNDckyud6WtEoJR5JF+L8u2aV6MIAzTsSSI3M6EiDgSiEh7oUSaBuQdQUWUL1l0XWLZSHpfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKNjawl0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKNjawl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9101F00A3D;
	Tue,  1 Sep 2026 10:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788257936;
	bh=w5JPc2aRIFjCWmCKt0WbPeIcbKxS4QsvuWN5FwFGQIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SKNjawl0qzxgCLVZArcuJpVCJTa+7NEsmMseJhMRYYmcA9yrR5yMxt9jP4ySIOt29
	 5ChmvG+j4HMx28AUDl9suHomocKgiSFtfGZi8NX+IbbPW7A7SlNIFsrC2Vk4KdPRB0
	 Ym4/Us3uKlH390Gc/alT0o+mZFiJb02PmOCyZEcpEUxN7hH+YE8giNu+U9Nm0Ca/Ua
	 9JGh7Wvhw3G4RrGNw07AErdCbqvsMGSxiMbLDhnzb+tNR8L2e2AY7eJrl6zjezmgIF
	 D9Ti1EAUjUNRoL11rY/hOsSv+oHcg2TBZpSaEcJdt79hVFj3sfHa4UMH9bFDc8RDBP
	 PwtRs9/VHoFsA==
Date: Tue, 1 Sep 2026 13:18:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Ben Cressey <ben@cressey.dev>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Will Mortensen <will@extrahop.com>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: Re: [PATCH net] Revert "net/mlx5: Add sensor name to temperature
 event message"
Message-ID: <20260901101852.GI24140@unreal>
References: <20260828-b4-mlx5-temp-warn-revert-v1-1-4e2ae5a0351f@cressey.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828-b4-mlx5-temp-warn-revert-v1-1-4e2ae5a0351f@cressey.dev>

On Fri, Aug 28, 2026 at 04:55:52AM +0000, Ben Cressey wrote:
> This reverts commit 46fd50cfcc12368bed9ae5257cc3beaea5b3c193.
> 
> print_sensor_names_in_bit_set() passes the sensor index from the
> temperature warning event to hwmon_get_sensor_name(), which uses it
> as an index into temp_channel_desc[]. That array is indexed by hwmon
> channel, not by sensor index: it has one entry per ASIC or platform
> sensor the device reports, plus at most one module sensor
> (module_scount is 0 or 1). Module sensors have index 64 and up, so a
> module temperature warning reads far past the end of the allocation
> and prints whatever memory follows it, up to the next NUL byte, into
> the log.
> 
> The mapping from sensor index to hwmon channel cannot be made
> reliable here: the driver registers at most one module channel, while
> the event can carry bits for other ports' modules, and the bitmap in
> the existing warning already distinguishes the ASIC sensor (bit 0)
> from module sensors (bit 64 and up). Drop the name lookup rather than
> fix the mapping, as suggested in review of an earlier fix [1].
> 
> Fixes: 46fd50cfcc12 ("net/mlx5: Add sensor name to temperature event message")
> Cc: stable@vger.kernel.org
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Link: https://lore.kernel.org/netdev/20260518112555.GM33515@unreal/
> Reported-by: Will Mortensen <will@extrahop.com>
> Closes: https://lore.kernel.org/netdev/20260512-b4-mlx5-sensor-fix-v2-1-531fee4fd7fd@extrahop.com/
> Link: https://lore.kernel.org/netdev/20260515-b4-mlx5-sensor-fix-v3-1-f537ce191d6c@extrahop.com/ [1]
> Assisted-by: LLM
> Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> Signed-off-by: Ben Cressey <ben@cressey.dev>
> ---
> The restored warning string intentionally lacks the trailing period
> and newline: this is a pure revert of 46fd50cfcc12, the commit that
> added them.
> 
> Will - happy for you to carry this as v4 if you'd prefer.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/events.c | 31 +++---------------------
>  drivers/net/ethernet/mellanox/mlx5/core/hwmon.c  |  5 ----
>  drivers/net/ethernet/mellanox/mlx5/core/hwmon.h  |  1 -
>  3 files changed, 3 insertions(+), 34 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>

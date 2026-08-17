Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AE63E1680;
	Mon, 17 Aug 2026 10:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786961849; cv=none; b=iyiBCM9V940Mm0dnv66OxWP87NktNTeGKyay9K4bsL8a/CTNQx9Gn4xA6lpL5P0obDKAu6AVHpPl/KhrhWKxISJcJFUvb8lSLYQ3z7L2wF5nfHCGW9fLYiUcQ/zpZM6HL/cxzR+EIG4SuLR7/WKw607Le2OQqXo+8bNS6zCaoDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786961849; c=relaxed/simple;
	bh=iDMaq6J2vgO2D+Rl58ZKffPpJxI/Mu6uPi608ojNNeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+itqfcxZIueICMZpcYnNW8YXZcIDGbzBuwmAslZWukGqHJnTY4eScKmGi8aE+qQDyq+VLBrVX8PyUYOOn8bOc0D+IUmjuyfP1h2SY1iUBR9r9wNECzSYvhMngv9pbPbtz+S3MfjQ3uVzxD8l1/HvomHmXEG3RfC9k7/hcwPEq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCLqWUDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCLqWUDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3EE1F000E9;
	Mon, 17 Aug 2026 10:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786961848;
	bh=vBwO+o8/g3c8E5g41SDi1C7yT6nUsCVbHkSVCJNe+7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iCLqWUDdgR60lfTw8qDSfaik+jq0gVVQ2pIQ9nR9Fzve0F46IqthNlpYXx6i20W9J
	 V16oGiX5xkxkdMzLCSfTOsdvHXsT9SBAZhaV30aC8Z/eOBonZNfNWYbjFGXdfGVlBn
	 /FxYZRJpb8y1sL2eubbgEaQFBs+RG8chBlTgzsj4WGqiKHohZ+3vl9aoXEhoDFu3TX
	 c1ohb5moXp31CqhGHvH1+y3iYIbS/Oes9dt5cr4dYrmsmvUyK7RjovsJ0y+fG3JeHb
	 FfQOSrNjf+NZ7Ivob3epw0MJSctcl2VDgBOxUd8V0UDQWYQX2Bv1Qbstx4oyl+0zJS
	 N1te37kfU44Nw==
Date: Mon, 17 Aug 2026 11:17:20 +0100
From: Simon Horman <horms@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, aleksander.lobakin@intel.com,
	magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
	sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, witu@nvidia.com,
	martin.lau@kernel.org, yoong.siang.song@intel.com,
	rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
	leon@kernel.org
Subject: Re: [PATCH net v2 1/3] xsk: align TX metadata layout across ABIs
Message-ID: <20260817101720.GX265046@horms.kernel.org>
References: <20260813190800.222527-1-sdf@fomichev.me>
 <20260813190800.222527-2-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813190800.222527-2-sdf@fomichev.me>

On Thu, Aug 13, 2026 at 12:07:58PM -0700, Stanislav Fomichev wrote:
> Add explicit padding before launch_time so xsk_tx_metadata has the same
> layout on 32-bit and 64-bit systems.
> 
> On i386 and m68k, the old native 32-bit layout put launch_time at offset 12
> and had a natural size of 20 bytes. Using sizeof(struct xsk_tx_metadata) as
> tx_metadata_len was already rejected because the length must be a multiple
> of eight, so the straightforward use of the interface was broken on those
> ABIs. Userspace could still register a padded length of 24 bytes, though;
> mixing the old and new layouts then silently reads launch_time from the
> wrong offset and misprograms packet launch times. This intentionally
> replaces that incompatible layout while the interface is still new.
> 
> Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Reviewed-by: Simon Horman <horms@kernel.org>


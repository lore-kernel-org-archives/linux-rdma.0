Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884F935A938;
	Wed, 11 Mar 2026 03:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773198763; cv=none; b=J8f+16G9r6zaHw9SjAADdoiePBhNCqAt85QRvy/Za8G+Ea97fU7VvPzMjZVH/LuYZa2n/nh5PT3tPxPzEV/FMhSGalL6SUPg8atj4qH/8v8wm3MwT6iWpAZDQ/bgYqNHB4XSG/kryCVH1MJSDQgYCJDgWbkK6RYaT7Fme9Rkc5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773198763; c=relaxed/simple;
	bh=SDUWr51B+h5ikqvo7TzBEoMCm6C8OxHIRzg3bWcb7GQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7NpCbTHlxCUc0JeL9743WkacyCRl1l/+KgHbToom3CT6iJhTuD0/wE9wiJ8JbRmxBGzgEELec+Mr0lDcIwS80ObM7uMmnSIlfqHF0xvsl85CHELEKiBspfrmTQ5v6t9XcaqxFDTrUomqQt3p9W5hYURym7R2m+4SWnJJpd/n5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmO0g5WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmO0g5WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907C7C19423;
	Wed, 11 Mar 2026 03:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773198763;
	bh=SDUWr51B+h5ikqvo7TzBEoMCm6C8OxHIRzg3bWcb7GQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QmO0g5WWQTdZhQYSc2d7BIBWhFKMOZjtRH4SeL5O1qETn7L5HsVtD/RlBRGpb+U/C
	 qNv0ZP2CKT8SEZGGhreTyzvz/iNG/DdIz/hcLD6B3J+3CrjrK85ku4S3Nv5C+Htkbz
	 /cM1SurMlNPKnL9qTxlxyelI1MdiNO2gJos0Nded+7dGrYq/E/N8c/qTj/FLwy9WJJ
	 xUcscguVuZdL80S+1N1dlC4sVAY3pegXu3TvkYSnQhscMhpo5HRTNgIQ9x+AT6xUQe
	 zOpEfKtCA2f9faZ+ZDx1p+INskCdAf5Bdk1jYLZCQHhYk1Kbba4obZpyspx+u2EQCC
	 +frKdXgxeRXKA==
Date: Tue, 10 Mar 2026 20:12:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, "Mark Bloch"
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 1/5] net/mlx5e: Report hw_gso_packets and
 hw_gso_bytes netdev stats
Message-ID: <20260310201241.2f6e87c3@kernel.org>
In-Reply-To: <20260309095519.1854805-2-tariqt@nvidia.com>
References: <20260309095519.1854805-1-tariqt@nvidia.com>
	<20260309095519.1854805-2-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 9 Mar 2026 11:55:15 +0200 Tariq Toukan wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> Report hardware GSO statistics via the netdev queue stats API by mapping
> the existing TSO counters to hw_gso_packets and hw_gso_bytes fields.

The docs on our stats are based on the virtio spec:
https://github.com/oasis-tcs/virtio-spec/commit/42f389989823039724f95bbbd243291ab0064f82
which is not very detailed, but to me "bytes of TSO packets"
is a sum of skb->len of those packets. And mlx5 seems to only
be counting payloads??

Maybe given the ambiguity / mismatch report just the packet
count? IDK how useful the bytes are in real life anyway.

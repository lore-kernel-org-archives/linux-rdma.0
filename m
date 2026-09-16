Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F89F3DE424;
	Wed, 16 Sep 2026 05:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536680; cv=none; b=nwZ0+nY1L+xngovI1q7IrMTcjJsmeBnbT1Kusx2rtlQZYEIkgN5Rgyj3BPoRxznQSi9OAb2/Ylm/+Z7XPLKhrAgrQfa8XKLEMBI4Uzuhly5t+dyweAL+lJaC1LzAgFn6wfjgER94Ud0/HFTclqZpvHC4F7iHSuXIwPInczBzocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536680; c=relaxed/simple;
	bh=fDcFdztgqglKFi0eQ9GvswKVa8xcGIe2kDORdCHKjh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgYuyGbJYINpTB7MyJrKEoqK1kMV3mfuaHgFqlpQ3sd5gdzZ5FYed9S/t7q/IVHtKTiK+TZuVG2iZrihYCI3/5PfzIDevU7o1zCpnQnYLlblQamaVi8XoMb5LRt2TH+0I52H75o6gg32CdNjS1+tLR8jXjG5pAYiQrUC/axYKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0nhE6H6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0nhE6H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB731F000FF;
	Wed, 16 Sep 2026 05:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789536678;
	bh=fDcFdztgqglKFi0eQ9GvswKVa8xcGIe2kDORdCHKjh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V0nhE6H6MYM0AODK2HbOkUiSRaJWoDD4wxE2ZUNA/B0evPOaOBxwSrwho4Kgyf9ni
	 yDh2cpt4lubvc3eyToOHCcHEpHUSbyYzs4m3Oy4DpsrXqQ68cQvp9xTg5gMVIOYCYR
	 n1nPcCUGkdMLTGfUL4uupRy4m6VTXXPzPhD+ATshhA9JGkjo9TQqn0P4PSNFkj7Hsi
	 kc9KqTrw+9oUiGOV6DV5dtPtdznS83rPaje7Ot2nByAR4tm6sx2wpBrhUEDqSf9DFx
	 Q9jeXJ7URo/KuHXCluegCVLP8QZEo01e2ym6hrtkOg/93YUPk7lMGJRzBD89YnVQ4B
	 3bdezgxQM/S7w==
Date: Wed, 16 Sep 2026 08:31:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Eran Ben Elisha <eranbe@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net/mlx5: command mailbox use-after-free, and
 the teardown hang hiding it
Message-ID: <20260916053113.GR13683@unreal>
References: <20260915225941.554568-1-dcostantino@meta.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915225941.554568-1-dcostantino@meta.com>

On Tue, Sep 15, 2026 at 03:59:38PM -0700, Danielle Costantino wrote:
> Two defects in the mlx5 command interface, both reached through the same
> door: a firmware command that times out.

1. Health recovery should handle this. If it does not, the bug is there.
2. Please review the cover letter, code, and commit messages, and trim
Keep AI-generated prose to a bare minimum. The current series is
not reviewable in its current form.

Thanks

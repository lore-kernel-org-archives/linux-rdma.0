Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C53231A23;
	Mon,  6 Apr 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775490228; cv=none; b=Xg2SjoEjaCIxoCBYzIxuFyq2uvgNkRdBcMEFjQPmeQp56ikMT2higCBekk0nmjo8Gg+/YFfeMK2VTA+Iqg7pceNojJjVA/h+WTcMF7/6ILsR9FeKlY8geU4XZDSojcHEAxHC1fTIcb2v4GgeVB6WmX7Bff6l9GGspeVRQWDk6P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775490228; c=relaxed/simple;
	bh=Hkr2KpDesjIEd5ApuJhYi+O66bNgcXZNYZxYNWBxb9I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDRBSkZwT3vaCAEy40UZ8BhEXVtqlIe3c4IYziRlscbip0MmfHzg7eelbhgwKKEXMRindmwn5ZoVv8qFniL2K3ueAHdCISkAEehg4mu7QRY6nrrB644S+rOx55fVTkzlz4nDGZd8DqeimNZYptd6ZORjwnV9rvEAIcclTtFx9Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsVsAuLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsVsAuLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B807FC4CEF7;
	Mon,  6 Apr 2026 15:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775490227;
	bh=Hkr2KpDesjIEd5ApuJhYi+O66bNgcXZNYZxYNWBxb9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZsVsAuLveymFpYoMx/Pn6RtSf8RIylqyYgsv4RSfZBOc/A4xor6FdVrnXUeQbJUwH
	 JUi6KMUvDaX7la7B2TkZs1+qavmrf3092aTksXjyJwmqsCT5uS4Ddv4Xi2fMpv3hLf
	 DAK0+QmrYF7wEEA+Ezh+5U2SLXLsO4sCX7KLxHU0ak5WWcUox3P+T9CX3PUQq0tmPP
	 P48Ap1hvp6Qpf0k6sn4Bmz/xniJf43BMwNXU0cozBl9Ykb2tEmByP7o+cLZwti98bC
	 dxVRt7qRghvLlxDRBz/gcQRerJXcZCBoMr/fMtJoQQSaFsDWUM+76YDs+NWcV+wVSi
	 Vw6KNEgLjQRRA==
Date: Mon, 6 Apr 2026 08:43:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Cosmin Ratiu <cratiu@nvidia.com>, Simon Horman <horms@kernel.org>, Jacob
 Keller <jacob.e.keller@intel.com>, Lama Kayal <lkayal@nvidia.com>, Michal
 Swiatkowski <michal.swiatkowski@linux.intel.com>, Carolina Jubran
 <cjubran@nvidia.com>, Nathan Chancellor <nathan@kernel.org>, Daniel Zahka
 <daniel.zahka@gmail.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Raed
 Salem <raeds@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net-next V2 4/5] net/mlx5e: XDP, Use a single linear
 page per rq
Message-ID: <20260406084344.5d315f01@kernel.org>
In-Reply-To: <adH5yAsPJ8rNgT0k@x13>
References: <20260403090927.139042-1-tariqt@nvidia.com>
	<20260403090927.139042-5-tariqt@nvidia.com>
	<adH5yAsPJ8rNgT0k@x13>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 5 Apr 2026 08:08:06 +0200 Dragos Tatulea wrote:
> sashiko says:

Thanks a lot for reviewing the review! It takes a lot of maintainer time

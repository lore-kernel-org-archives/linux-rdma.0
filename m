Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5841435C68C;
	Sun, 18 Oct 2026 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792336411; cv=none; b=FxJX0rEG+npnNsW7aZt24gfrLn6oNdxDi8q/y7h5kQLZhn6I+ZuRisrfaX8v0bQPHpyNXmkSqekXGFaqJiimoMPpc6uAyAdHyDoz6svm3U32RQ3r+DE4riDcD3/syt+ao8y7c6Awmhu9z3oX8/Nj818tW9SbOjLl0Nx0+XTqMzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792336411; c=relaxed/simple;
	bh=U7VgBonWvdSl8FluRyON3Hb2KOF19VzseGsJtL5EYTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e72pTpdIrDQOztrxqyhkoOKDdzzAy1bLDqtCM9K1uc3RiQ/UIhjYThrErSaGZ6g48kmZFxIMOhUaiZnKPHm807mOwbOz+Cn4guEsKegVXHIiZg1ScMPd3G3fFJ0ZQcr7sAOkf8wGWfDZlF0W7ydOJz7Xhhd2eq1aQ1v0YyjDesY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aai4Or3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aai4Or3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A851F000C4;
	Sun, 18 Oct 2026 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792336410;
	bh=6nm3/heRuld0tUqrdNjEQiwVkJeGyevZGRjtlCGwWXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aai4Or3/VOS+ihemGgmjI1GmOze29H6ugG+DgUmJhoPFXTHMSo9r6pPMX3sj+YLad
	 jAujbsXVdzST+GIVzneAps0mkILhkJTQUhDzFmWNOrq1Mc9dPJffbEsSJBmskVKZlb
	 5qpjCdUtYUKGHRmcEQPgtDSFl5wuRYegwMc5CBRNnc6iFE6KCXc/+yeXtK2erqzZYu
	 cUthx6NVFNx9W7KRS8srIBjOv6T3cR7H/NHnXdWEfSNLCIjEZJ65YTheOprrJfxXUW
	 3q4zn/VTKLsXG/t6ZJCh5rlbQVuWag0jEZOwvmKGPTEVdR9+HkS2meJH4jWwQs6C7D
	 JHKXF/+ZB6lYA==
Date: Sun, 18 Oct 2026 16:13:25 +0100
From: Simon Horman <horms@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Remove redundant memset after kvzalloc
Message-ID: <20261018151325.GP503057@horms.kernel.org>
References: <20261012150311.555104-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012150311.555104-1-ekffu200098@gmail.com>

On Tue, Oct 13, 2026 at 12:03:10AM +0900, Sang-Heon Jeon wrote:
> kvzalloc() returns zeroed memory, so the memset after the allocation in
> mlx5e_post_meter_create_mtu_table() and macsec_fs_tx_create() is
> redundant.
> 
> So remove the memset.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Hi Sang-Heon,

I'm not sure if the value this cleanup brings is worth the churn.
But I do believe it is correct.

Reviewed-by: Simon Horman <horms@kernel.org>

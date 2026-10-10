Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178AD3B5318;
	Sat, 10 Oct 2026 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791646932; cv=none; b=aJxNgKJ9yrAIAqdvHeanwinhBoJIFCiByRR1DuVu7s4RMCLC6LBkw5fJzcy4rcmGnc7c03vqVVMibo/WSxOXqr6JA6Yu+ZXLcyrs3kjSmslNWx7Z0MNaRs1a/k88X0eFwuXyH5n678mXcTrULeXMaobXfuJAjUkDLfIO4X9wykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791646932; c=relaxed/simple;
	bh=o0Nbdtt+z9Xl9B0BpBsREqyYw5ZQK58jImSSl3F1+DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsrRuablmgMka6zK28dLLM1Kb6TuLY5MZQL6pgxKi1gPYzGmmz+KA6PuUAMQda2DdwHcnOQ4Vrpd007cgWkApPMOdV0svBSESo9T5jyuf1GZj1L1zTfMEo53CXaqzZTWXCHW+pOh2yySyRRjWqp8tZTr2MTGYSdM/mxK+WJgHP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXxjPo13; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXxjPo13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336991F000FF;
	Sat, 10 Oct 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791646930;
	bh=Ap+Tq/Y+qhjykp5ER3ePeXaxEviOW6XIy2R2my+Dgsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eXxjPo13ut2gtaFOMruHDJlPpKT4h50VawIOovx8npMzZpm/9l+v9sZLMxAcnRuix
	 x/2GPDzg5Z7AoXpa9uWisGGdwDjW5TF6eaUUYI6whlE5a83QXJjY9rsnsB304ZmgUE
	 hJwd7qNak+9hjSaN2exjFsil2ykZ878qjYPMtcgTTmHMBLS0ieKqzQ9WOAdNQHFsLf
	 ySljyUEWaeCtrmxKAyV0wYSBIWgkGZ+MIXwTLtIsUrTFRiZ+iIMg2C1I785Ht1N1gm
	 4+g4/Smn7aTdeA2azs/FmSNpGKrh1ohoQaH1j6c5H4KoBqnWhhFdjA0LxM+XRkLaRS
	 RbFyslVnw0+RA==
Date: Sat, 10 Oct 2026 16:42:05 +0100
From: Simon Horman <horms@kernel.org>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5e: TC, free NIC flow parse
 attributes after offload
Message-ID: <20261010154205.GS83879@horms.kernel.org>
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-2-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009052103.3621855-2-acassen@corp.free.fr>

On Fri, Oct 09, 2026 at 07:21:00AM +0200, Alexandre Cassen wrote:
> A NIC flow holds a 4 KB allocation for its parse attributes until
> deletion although nothing reads them after offload. Free them once the
> rule is in.
> 
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>


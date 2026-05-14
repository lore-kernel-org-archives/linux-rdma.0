Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C115639B94D;
	Thu, 14 May 2026 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786365; cv=none; b=AziavpTrKDX460Rh/YQzO83yqscJoh42SFD4efA/kMgAu48DJiL+c0c7FivHZR4m0jjPsmJBgocaCy4UpXjqmKWYm6dIUDOldNVlo5CrI6ZzPbZYm/UuZjq4gOobl1u/bGrrsVuM95yrobyO+lzB9Ql9nKaHctfOKhDiocJmW84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786365; c=relaxed/simple;
	bh=03wBdPzVqhOiMAr5bStesrdEHrdTtvRd2tO6+WrphDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfiE+Cqx0J6Y1gCFp1Wc4QRTeVn3pNCXjScBlryH8emFypuTmmEhKw658bPPWtjRV8Xw2MGF0nCfBq0UZUsNQmC5NghcjYUmS52BmdbV+xwkyFZoQJZq37YXLX4tsgvxzQqCQMPWTjN40pSAr5S+VLhHh1s5KRS4ld3ADLsCutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o6DIbQEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o6DIbQEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4734C2BCB7;
	Thu, 14 May 2026 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778786365;
	bh=03wBdPzVqhOiMAr5bStesrdEHrdTtvRd2tO6+WrphDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o6DIbQEGtF6ZTF7hG9nxXBGNMwLv+EzCYILY1Y1A5FCZ7FT0MNLXRjEkry8DluctH
	 WbZCvUaguhRy/Ov5mLAC77UrnNcrn66gHBmeaGUrsgfTPN/fzKaq81pgSF3zfDuyzM
	 Z0+cj/XP9QZvR7VUnxe7CdebcSa3KbqLOLLuwsB6n5DXGhRlqeB5STWlpeydMr2ySh
	 BuP2wXZfXBoVVdsK+kWdTZOGHYyExLN5f3J4DYJL6sdAI1dtdZlyTROSX3r68Vxu3k
	 odpRqQU7VJBnNG/jkogp5xj9QtPJ+zKB1q4LpjvTy105jpsggVeVtz4oxq/A0Snen0
	 8fxfnczmuSp/A==
Date: Thu, 14 May 2026 20:19:20 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next 1/8] net/mlx5: Use helper to parse host PF info
Message-ID: <20260514191920.GA15811@horms.kernel.org>
References: <20260510053448.326823-1-tariqt@nvidia.com>
 <20260510053448.326823-2-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510053448.326823-2-tariqt@nvidia.com>

On Sun, May 10, 2026 at 08:34:41AM +0300, Tariq Toukan wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> Add a helper mlx5_esw_get_host_pf_info() to retrieve host PF data from
> the query_esw_functions command output, so callers no longer need to
> parse the layout to obtain the required information.
> 
> Convert all callers of mlx5_esw_query_functions() to use the new helper,
> preparing for upcoming support of the new op_mod that returns data in
> the network_function_params layout.
> 
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Simon Horman <horms@kernel.org>


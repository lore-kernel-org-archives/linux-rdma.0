Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00C2DF717;
	Mon,  6 Apr 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775487775; cv=none; b=mJuArrntPDj8o2QtSXVMxZQ7JYXEpZt2CYbykz6yzW8rkZUI9e0t9Opj5PA5qnCNj51nlW01CiVSp1f+rjxQXl1JMbELlX7t5d1qOBcGfQdR1IzNI/y/NAtxD65lv/wEHG1jLfGyItygGKujJ/9VMnyLqa/ujOO4preRzsSXnJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775487775; c=relaxed/simple;
	bh=/zWTTEwu/4ZvHrECK/ZptCOk4mvqjq4tGCDOOrZFik4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/Ion+OGkY33iVkJwYIzP6phmHVWpvhN78YyUftBZklbBJVPSKPIF8xJA+Pf6laZNjsignHfplOlptHbPImVJtgzZOT9pCrg5PZbwqTXveUeEovJ4MD7+phfUoSUW8pHIBkCpAhO8thvMvXEwi48VjJ6DE2FKQuAt5KZWExaojU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xii0MaFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xii0MaFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76DFC4CEF7;
	Mon,  6 Apr 2026 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775487774;
	bh=/zWTTEwu/4ZvHrECK/ZptCOk4mvqjq4tGCDOOrZFik4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xii0MaFjExvsIQcUvAeczdhUiDvrdopDAvaRxpwdpJZni2L1gqeh/hgnwstwshDRq
	 jxT+YEcaWwqAf15XkxeVfCUWMS7tuIiC7qonC73r1Nmr6mWduiZPur8hJm14TEb++w
	 b6iBvxj84KbE3mgkdVdGyvokgk7rVno5kNkaC5fsCDBFQqsUhk3Jv0HkhXsJchPZw3
	 aQ8iMdh9ZQ9bwJHbRapwIS+Jdg6eNs41pEwlDePE2qYZbcZCJRGmkGwnJR9AwAR9Gm
	 SvbdckSWuL57eqWQaMeKY4/6lmsWd4+4RQfrTsb26UU/T8BlT/UyKEZ7D4oHic0eHl
	 R1ORlDu1Jbs6A==
Date: Mon, 6 Apr 2026 16:02:49 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>, stable@vger.kernel.org,
	Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Update the list of the PCI supported
 devices
Message-ID: <20260406150249.GA410024@kernel.org>
References: <20260403091756.139583-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403091756.139583-1-tariqt@nvidia.com>

On Fri, Apr 03, 2026 at 12:17:56PM +0300, Tariq Toukan wrote:
> From: Michael Guralnik <michaelgur@nvidia.com>
> 
> Add the upcoming ConnectX-10 NVLink-C2C device ID to the table of
> supported PCI device IDs.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
> Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Simon Horman <horms@kernel.org>


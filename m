Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E3236453;
	Thu, 29 Jan 2026 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769730026; cv=none; b=Sllsoo7AyltPuOXAtDCqe+dPLFYSjzlztZb0vRfih0f9uIrKtjM9pHjGhXccDxUrcPgYlFMeZ6/uvC4S6gWmJXUwMBoFGKN72QWgsILLaZqns7tHxL5cB7VWMt6+fDPG2y1Y0hzl97qgo/2UCN2fh+rK40gEl6uMC3VppFrzUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769730026; c=relaxed/simple;
	bh=7V/w0cMiWKDJR01klhKtUJS0e5hzRvts/SSEVugoySs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPOWr4qHLBO7J2NAeUrUPahkOhyOrNxfTf/mvAohlrqLbY3hutM9dMP3O9zfjgZTEKJOg8LxgNHZXiBUlpkMujuLeXe6/HP5tHe9qGBxwOJMhmF7OaDWzzw2MJ3zbwjpHMZ15M/6FuhxY9U9uY1BSFYWtoAHqG0Lw5y+l0V0byQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHZq4Xz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHZq4Xz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C218C4CEF7;
	Thu, 29 Jan 2026 23:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769730025;
	bh=7V/w0cMiWKDJR01klhKtUJS0e5hzRvts/SSEVugoySs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nHZq4Xz8dM8FOkArZFPv+4z5ZXxi2TDozybO19H76dTX5MKZqTdf8MqZD4UCE+Ji7
	 FtMGJOd5+0TD8Hcm5hfxn3ar5aA4aOCrSp0TqJ2meMMnLH1FOzvlEmtTwtMLVVpDRh
	 h4h7/bF26q0XwCao27Jd2gBGSBWkkNg8DMQWJhtWxxT2Pnxf+HLHik+8LsOhdA+dBd
	 J8S6nTdyL1YoIHK+cJQNQD1V6LhrR6lxGhopXLFXJM/eErBKDXOO/hg6CHWnn7+919
	 EFZe+ZUeOc+aucirwIjX5OG1S9TKNT4+dGzulfcESVdraotLH8skN547lkfCuYWGkf
	 7lG+r6hzYQJRg==
Date: Thu, 29 Jan 2026 15:40:24 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, "andrew+netdev@lunn.ch"
 <andrew+netdev@lunn.ch>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
 Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "edumazet@google.com"
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 "horms@kernel.org" <horms@kernel.org>, "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net V2 2/4] net/mlx5: Fix deadlock between devlink lock
 and esw->wq
Message-ID: <20260129154024.3915c3bf@kernel.org>
In-Reply-To: <d52714243592921c08175aa742f32ae56e4f6651.camel@nvidia.com>
References: <1769503961-124173-1-git-send-email-tariqt@nvidia.com>
	<1769503961-124173-3-git-send-email-tariqt@nvidia.com>
	<20260128205622.12e1f026@kernel.org>
	<d52714243592921c08175aa742f32ae56e4f6651.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Jan 2026 10:33:40 +0000 Cosmin Ratiu wrote:
> > This is quite an ugly hack, is there no way to avoid the flush and
> > let 
> > the work discover that what it was supposed to do is no longer
> > needed?  
> 
> Not possible, unfortunately. I stared at it for quite a while. The wq
> is flushed because the esw is being unconfigured, which removes data
> structs the work handler uses. Flushing the work is required, otherwise
> we'll run into worse issues.

And having a refount on (I presume) struct mlx5_esw_functions
so that work can hold a ref is not an option?
Are you planning to revisit this in -next?

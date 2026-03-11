Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5AA3E276F;
	Wed, 11 Mar 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248784; cv=none; b=ldEjt8GKn2GFyIOv+bDMUB1/NuENfG6lv6dWU/7XAw9QXWDkJNqv6W2uSdbpFDsax9bsRHy5TMo/1EcmnYJFyI9EDkMM/6gi7vj89Jr3CUoNMDDlu/MeAej72c/YQKQcYQv2TP2HnixqoEDJewPOR00DOPzld5lokxliOLNS6FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248784; c=relaxed/simple;
	bh=a9SXR14qqh0v0ixFe06cRYgWDpfT84m+vR72jgFvJ8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClbSDXtJI58hVO3YXfdGM6iAqGMTqHIU/zNhOEx6/0XhIkYXK31enhdaN2LlYjFO66X/wtZ1AHHE9SAF1YqDu6cpmHkrExuYnfb8UuY9Npo58cBhXXJYPgf29jJxfbZIWIuSI48S1N4AaB8rz8wGcqU1UAsIsNvmHOP8JsdqeEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPalNFZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPalNFZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6C6C19424;
	Wed, 11 Mar 2026 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773248783;
	bh=a9SXR14qqh0v0ixFe06cRYgWDpfT84m+vR72jgFvJ8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPalNFZO5HTWu7Lvg1Qp+Pc3Xq6j5NmpZD6oor/KlCIlVLsU1Qp6+b59tFJtLRvAa
	 PiGx9mBUe3N7X0LPLTwoI43v0yT3sYu42O1H2KUNJ6nCeZ1OAIHAdaa/HAkDL5Ddyz
	 46+83BL+1m9TDdDFdk8tBW00vhfeKXR27ZGXmibNXowVYoVN18MxA1001H2Giwzqa+
	 XpeHAwA8flvpTzQ/EEUwgPzD+g+6iExLyr4U2ndCOvehzq1HZoyHvAMezqT5fB1f+5
	 bMZIAmpoTmj2yC2nOhDxnGTXR0kZ2nETVx+zn0ZNpn+5t+CyzoZ1jtumHwa9Uj98Su
	 aXnM6U8rEwu7Q==
Date: Wed, 11 Mar 2026 17:06:17 +0000
From: Simon Horman <horms@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: shirazsaleem@microsoft.com, kotaranov@microsoft.com, pabeni@redhat.com,
	haiyangz@microsoft.com, kys@microsoft.com, edumazet@google.com,
	kuba@kernel.org, davem@davemloft.net, decui@microsoft.com,
	wei.liu@kernel.org, longli@microsoft.com, jgg@ziepe.ca,
	leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/mana: Null service_wq on setup error to prevent
 double destroy
Message-ID: <20260311170617.GA1133151@kernel.org>
References: <20260309172443.688392-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309172443.688392-1-kotaranov@linux.microsoft.com>

On Mon, Mar 09, 2026 at 10:24:43AM -0700, Konstantin Taranov wrote:
> From: Shiraz Saleem <shirazsaleem@microsoft.com>
> 
> In mana_gd_setup() error path, set gc->service_wq to NULL after
> destroy_workqueue() to match the cleanup in mana_gd_cleanup().
> This prevents a use-after-free if the workqueue pointer is checked
> after a failed setup.
> 
> Fixes: f975a0955276 ("net: mana: Fix double destroy_workqueue on service rescan PCI path")
> Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Simon Horman <horms@kernel.org>


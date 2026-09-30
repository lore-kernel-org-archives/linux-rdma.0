Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740C246D56B;
	Wed, 30 Sep 2026 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773878; cv=none; b=syU1lvY2pE/buX3usKq6XpN2NkWmLyCwjMFFgX4pVL3lGorY9ihZfyzvRYPRn+9ATBQBmT/pUOa+MA9fWX5qILXISJG6z+gK5SWcIlL/dUsIdX/jwz2anyUQjXrMlM6l0J3gviFrE57YRFehxd5YCmOwkKs43Gp+7j75bwpjNLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773878; c=relaxed/simple;
	bh=Sx9Bwbi97UVzpVUBsz4JKc48YS6Xo9cENaYaK5J3hIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSe+IzwCf1o219Y53lkX/CCCbh/FtJvlxxnfmByVdijlstVRFwShDIt2a0eHlgmA9HFaa7wGFlCnz5/v6pDZVkaLZN0ezP6G9xeQSVMAwXDaCfOprXvzfA3lhNoXah1zWHpUAFLKgSThaMV7hZy67+tDEMskbeQ6aK0Vo/qeFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZUeNuCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZUeNuCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AADF1F000FF;
	Wed, 30 Sep 2026 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790773869;
	bh=18rTJWA37RWN/25BVUdozUuv9Zd7lZFAFXYCp4w70bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AZUeNuCRUWsTenBaU69EJYuqV5Dqj1Ax+bc6ERIlcnWemqyVRoYl4atB6Bl1jFhCs
	 YkMJmSg0OQom5G5tRZz3Wj6Hz8ev9kjvu0hYMPZI7xNvtIQJ7CKJOou2cJTdQbpgw6
	 g0P1g8hlIzn1lgowUs8RLOZSu3IwSHEfZdkzplnuxXOO3etEBptSF3LWAoz1ToMidO
	 LH9pfyxDvjREAg25eL2R8gnrCfM9MTiwCtAIJhQoYw48Yf0yLniDi1wM6uo72cXrP2
	 2vA3BrC+fK+OdYgTXxxstBpK9vdVjWOgaQgiDthsKPDPV0z5gwF+vFCE9WCazcDwMc
	 qGSz1n7IXsFAA==
Date: Wed, 30 Sep 2026 16:11:04 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>, jgg@ziepe.ca,
	brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com,
	a.k@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [for-next v3 0/5] RDMA/ionic: add SRQ support and firmware
 assigned CQ and SRQ IDs
Message-ID: <20260930131104.GG3401365@unreal>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260929185857.GL563127@unreal>
 <20260929162126.5b3ec458@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929162126.5b3ec458@kernel.org>

On Tue, Sep 29, 2026 at 04:21:26PM -0700, Jakub Kicinski wrote:
> On Tue, 29 Sep 2026 21:58:57 +0300 Leon Romanovsky wrote:
> > > are available in the Git repository at:
> > > 
> > >   https://github.com/abhijitG-xlnx/linux.git ionic-shared
> >
> > It doesn't apply, please rebase and resend.
> 
> Let's pull the shared branch, and then they can repost the patches
> themselves to RDMA? The branch should pull for both of us. Pulling now..

Sure, pulled now.

Thanks

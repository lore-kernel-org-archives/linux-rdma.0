Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A55349D6;
	Tue, 22 Sep 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087125; cv=none; b=SniDEWyAiSwhoIYXrHqBlfhXUt293fdbldwtRDqvmPPpcCbqsAfDIc21XIhr/D47p8FeIfDEkx1YxHu42To77X84MoV+Iih7ApY5gu84jkn4asZk1gPnl6lPAb1Oa5m/weHDsMwGA60ezOC690GrJ0DD4ELZ73Y/ddFjsl/9exk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087125; c=relaxed/simple;
	bh=Q0zgcsP28r50ZWV8DIUCywvQs0EultufdwcPHW3ZY9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElO+2mT3U7lwFMKePTATbVRXq8Lg7EIPQ/FRP7TQyof+SfFStf5Z/giHMGh0nH5E/JBHOaWYW6uYlNPpxVsdiabbPUTHOgCjNf/gv519+WtEM8z8l0sIfWW6E88Tl9cQFsf+jV9rC5zVP2BG3Bd18hm27u4Oq4uzbmCIq68bPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrZBRkcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrZBRkcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287461F000FF;
	Tue, 22 Sep 2026 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790087123;
	bh=uS4xEiJna1S46gYsb08Tyd0ici9ij8Tt9QUftH8z5m8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mrZBRkcmxnZrDF7+XaSk4I6M+WNsmX8NPfPeto70GRiFwi09wF9CnSeyA6D61EcI9
	 SZE+6L8cy4tYM//oW+IRNcd0dBCHmk26HQ5JQutBmugwm00CId5rEYcUDUhRQ43kby
	 ANR3jW0dBHbOAgewtOfsRnhHZ+Rypfraqj3TiourFywW2YPGoxlGcLG3psp8Jf0kWP
	 rzqEfwVozpjtp0hNvJTnQtMxfzSVZapjLwxijK/XYnfOCxDp+xvRjtyZy8nyDc6hH3
	 2mLFLi1nHIssdUdRolSUAFsevGoB3cVrexsZDIzU26v7UcwPx2BdnqT0sWGkSP7pq/
	 8PArltNMF9Q/w==
Date: Tue, 22 Sep 2026 17:25:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: benve@cisco.com, dledford@redhat.com, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	monis@mellanox.com, selvin.xavier@broadcom.com,
	yuval.shaia@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] RDMA/core: Fix netdev use-after-free in
 ib_get_eth_speed()
Message-ID: <20260922142520.GK563127@unreal>
References: <20260916183306.2092381-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916183306.2092381-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 06:33:06PM +0000, Wentao Liang wrote:
> The device reference is dropped before netdev->name is read in the
> warning emitted when __ethtool_get_link_ksettings() fails.  If that was
> the last reference the name is read from a freed netdev.
> 
> Move dev_put() below the last use of netdev.
> 
> Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/core/verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

We already accepted this patch
https://patchwork.kernel.org/project/linux-rdma/patch/20260812081708.32468-1-krystianmkaniewski@gmail.com/

Thanks

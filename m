Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9A410D16;
	Thu,  3 Sep 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431009; cv=none; b=GO5jVWxzfIHFXWPyfTNSRBwoLlbyuBbN06MrW0UUvACM2rVRwb6vi4gHVXq4yve+bWMhJ4F0DJHKL2OZ7epxkQX8Ygx26qfPOISnIjkTj8OrNc0KG19FndvXblfMzjC8IgptMVZ+NP2yMfcR1s9OQCAFNEI5DR4wAWS0CbOfeDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431009; c=relaxed/simple;
	bh=UYBOliex+QFlSIyTxTprO4Pgb+8d2E3/xYOJKxp0mJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGph1yeiZ8FwCW83MfZ2vTIKyynLv7XYVc2TJJll1O5CqB6kiZKmowhN47lhaJgF13j4gXOF5U5SzFXKK4QCLx2euQ3zHIFxrh4YJzm/3i+LeTWzVQWyrfh7/twFtX4icaFMPLvpN9Mo8a/TfQN2gckpKsO9lkyq+6TFtIHsqZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KX+McMAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KX+McMAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EFB1F00A3A;
	Thu,  3 Sep 2026 10:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788431008;
	bh=sgnmZ7wzkB140e4pmpp8+EIYE2ND8te14jNTEI5NuMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KX+McMAceahVXejtD6QkWz+dr51mNOzJzljnGNs620fxH1lfysZ2SXuRZ8Jwfiw5q
	 Meof7RGuPtJgvgu4i3C9BtOA66DbyvYIxY1RZ/Lm7XIWdkIJt3hvlt69woa7xW4XxJ
	 G7V0O0AgOglq9/r4Ce63+Vcjp7pqFmDoqmxClCuvXqnVG/kDq2jXxnMkGMph81+Ayb
	 TYO82QvCNyrehz9GbP/i9erg9jpasRXQRdW+rx+IjK6NoIhUyXPj+WFlWGs4yBbcSG
	 /4O1NbWnLCffomyMTSo+zZ3hHJdxuZ0SOgz9gE8T1dhFAwGPICjJIUyjKrxlvj1gds
	 gVR1gTATFWBcw==
Date: Thu, 3 Sep 2026 13:23:23 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: jgg@ziepe.ca, kees@kernel.org, Tatyana.E.Nikolova@intel.com,
	roland@purestorage.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, larrystevenwise@gmail.com,
	pj.waskiewicz@solidfire.com,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/core: fix refcount bug in
 iwpm_get_nlmsg_request()
Message-ID: <20260903102323.GC24140@unreal>
References: <20260902085213.145312-1-jeffinphilip14@gmail.com>
 <20260903101742.214304-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903101742.214304-1-jeffinphilip14@gmail.com>

On Thu, Sep 03, 2026 at 03:47:42PM +0530, Jeffin Philip wrote:
> iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
> making it accessible to global list where another CPU can kref_get()
> on nlmsg_request causing a refcount "addition on 0" bug. Fix this
> by initializing kref _before_ list_add_tail() so refcount for
> nlmsg_request can be incremented/decremented normally. In addition,
> also initialize every field before list_add_tail().
> 
> Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
> ---
> Changelog:
>    Changes in v2:
>       Add list_add_tail() last after initializing every field as per Leon Romanovsky's
>    suggestion.
> ---
>  drivers/infiniband/core/iwpm_util.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

The patch doesn't apply and please send it as standalone patch and not
as Reply-to.

Thanks

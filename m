Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83623019D9;
	Tue, 15 Sep 2026 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789459360; cv=none; b=WDyg1B4TDZJ5genVKIr5BIRrmPQNZs73/R7C1UBSxRTwNewnbTTIliCvy88enRU2AQtSTlZHZswDmDKz+WRANO7keaYiYnO50j8J48ffRmzl07bM9uDZ6dcu8aksa58HgawVtDtRNxfA30IpXsRAoXFD4CRLBFs8u30GnW2TGUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789459360; c=relaxed/simple;
	bh=pnhREXvqOF+UrpqTgAsUR2dNYS/7+rdAaPYx5Q9rgzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1Sk9zfxioH9iQh/zl/L9xQ57c1h2lC6NXOREPFx076uKNvC2JELr07ZITw8qIDMncBU7iRo9h8J0a7JPmL5TwNZfG81C78eqiIaWUJGrJcvb/yCGDkWAtucDWmbmIAFJxoBxgXdGws7RSo5S7eo8elDqgcWVHgtfIzmY+OBk0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h68NUhj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h68NUhj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA121F000FF;
	Tue, 15 Sep 2026 08:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789459358;
	bh=aKWMPeS8fODd3BDlAH3NmbkCVdcRfnuEKp0dZJ6h2AE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h68NUhj+jwlCTaPZIYltES3AQcJDLEkO9H5vokfFvzbzActaoFbI80KMfJaZ5Dkuz
	 yhehg6vn7+qPKFSufhTkaa/fleLqY/JkAuNFSLdetQZJ7eyhOxivvzWnrBhZs/Hoik
	 6MBOEd+mLvURyBlVKCRuzKeAwarmlK6EzuTBkJhnmVpvi+So2CQWvxi+7xKxw0zK2S
	 2rkPYqS87OnRZDZQDHvFDe5WXgAswmQdMpgcGtZiz26P2idqRzxcW/0PUbDHvUmgi/
	 Zh8MHkGP6pLbHznzovVFUXppWxqEYqphQTSBNedwaY0AKXwtnPUIepmha5OnGxue5Q
	 c7UHmF1FMLJcQ==
Date: Tue, 15 Sep 2026 11:02:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Reject WQ creation without a completion
 queue
Message-ID: <20260915080234.GG13683@unreal>
References: <20260907113918.2315-1-lirongqing@baidu.com>
 <20260910123318.GQ13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910123318.GQ13683@unreal>

On Thu, Sep 10, 2026 at 03:33:18PM +0300, Leon Romanovsky wrote:
> On Mon, Sep 07, 2026 at 07:39:18PM +0800, lirongqing wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> > 
> > UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
> > method definition, so the mandatory attribute bitmap does not enforce
> > its presence.  When userspace omits it, uverbs_attr_get_obj() returns
> > ERR_PTR(-ENOENT) and the handler stores that error pointer into
> > wq_init_attr.cq without validation.
> 
> That handle should be mandatory, declare it as UA_MANDATORY.

ok, I applied it and fixed this patch locally.

Thanks

> 
> Thanks
> 

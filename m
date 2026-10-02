Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6B8547045;
	Fri,  2 Oct 2026 00:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790900028; cv=none; b=mqWM77Iu+rthsQyXtbwF7BmY58Sw96veNcO/SwA+kfOm6ZjG4LKHzTs2JCT3jut/JVKYDzirIEaxws+8L2ONRB5vAVb1tdQM690Rrfbl9fOoaUArvrM74qU7tZWR2FuVL+ZgZxChYAdGL59z23tMrtBrhCY8G0C2Z8UPy8nZNhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790900028; c=relaxed/simple;
	bh=02mVl/6HwYUNDWB7dDCQuiZxKUXxbuur5L17Usnme9s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHit4LLGYj8A8VhLOzPmpL08jhO6BxCRxIOUw+8GY6D0SZmiRCoKvomAS8Hun6oqMRGgzosCdMqr+Rr4nOrfir6m84k93w/2hx7aFoLzS8ceEOLwgj30Oxlg1zD8W9JClQbyfxP2pUWR8NAXUa2c04x+6AA7TJHnHJ37lL/CJTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBf0ik/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBf0ik/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1911F000FF;
	Fri,  2 Oct 2026 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790900027;
	bh=LiiU+jYn+D7MDLNhgI1rcAYoMNaP3mJdQOYKHWh+nJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nBf0ik/avV6a+Cdru2fpH2oO21psFfrUZANQOZoe9tvE9d0JA8LIQU152youHNPnj
	 zIqOjlSW1nOz36M7yDBQZviPhyysNQlh62cChk5q7lil8uPe8ITsEg5Z7DW0XJxusY
	 tHe3hmDD7QMLSSiYupIedU6QufrNTA2yQ05rCnud51Sq2IIcyV9BMtrTiz9mWLxz3F
	 sPdvb8VTy1xHQnmvMvKaH5B6lw8MJeOWFtghsiBWfq6960ErC2lJG0RN3lrynkov+B
	 Y4OTL9Vg3eT/xJHBB7+89YcB8immyhLzew94tjg5k+gUmyFdAQPCmvgpqk31GlWmEe
	 ibyC/5mweVN5A==
Date: Thu, 1 Oct 2026 17:13:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Atharva Vartak <atharva.a.vartak@gmail.com>
Cc: security@kernel.org, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, mjambigi@linux.ibm.com, sidraya@linux.ibm.com,
 w@1wt.eu, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
Message-ID: <20261001171345.1d9d0a2b@kernel.org>
In-Reply-To: <6aba080c.b933486d.297b72.5042@mx.google.com>
References: <arn3qTu_SeM8Yrjj@1wt.eu>
	<6aba080c.b933486d.297b72.5042@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Sep 2026 23:24:12 -0700 (PDT) Atharva Vartak wrote:
> @@ -949,6 +952,8 @@ static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
>  {
>  	rtnl_lock();
>  	ndev = __pnet_find_base_ndev(ndev);
> +	/* keep ndev alive after dropping RTNL, callers must dev_put() */
> +	dev_hold(ndev);
>  	rtnl_unlock();
>  	return ndev;

dev_hold() is deprecated, please use netdev_hold() with a correctly
populated ref tracker.
-- 
pw-bot: cr

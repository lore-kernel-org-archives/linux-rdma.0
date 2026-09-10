Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51347206D;
	Thu, 10 Sep 2026 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789043606; cv=none; b=djRMVa/f+5Ol/Z3TRY5liDpBCa0OhAxOeAeJBcC/Hx+uGXilRJlGNX7EdChHJFqVACGK/X4TLwnnqMbLumVtiB3PcGNSikg9s1rTQY6hZKQEqJxaXjVzfrA3d6D+x5KImEtgrfyk9u69VA5UGN2OcIO89v2reH/U1ShO5yZ2UWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789043606; c=relaxed/simple;
	bh=16K8jyNUkTTINxKrRbCOYqnznpV+h4uR93+q7VSOt+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdhT+mVfampIITc4MpexxytIxz+5zDitubQro89WDfez5iKzfZNtJxx8qGKPsWmM53vmCGa8tyhz/+LMNLnGjxi+G4ZZf9Y/M/LFAqOIzbSW3orSjCimVuEcT/L6H+pXr57uZrcn+r3m/zHzbHKfxo9tNtqjTPr8sqqyKcA+T0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5WpQpQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5WpQpQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869E41F00898;
	Thu, 10 Sep 2026 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789043604;
	bh=2qboF0MMLQ7pG+FUSE/SOMqnEnYE6R4THqMqaAyU8FI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5WpQpQtpmRoAkio18/HpfoE4l/tEFJ0jF8n4L/ogf7Kluuaud2s46bTUYOYLr76y
	 7g6/QXTgDIdMGFlYzXV6rPAincNvN9euSEpTPVQixd5Y3aUfiYQthaNQhNscYFzvU3
	 qwDoV/LK5FtE+uLVMzohoDVcQ6499Gwh2imRqwE0qdTsCgrl5sGR/kdSEvxYClHHpj
	 9uTdDXTY/uUxdg4+sA1GvEP/9pcqwCaHC2GKUqU1uHHp3cz3cww5E2BYZRiCjPlG2n
	 LKYp1wUBD2d84sh2MzOLIcG0dSnQN51rGSqx8PM8h4rXMNVeSd8sbMyEdFFFiZm2mj
	 +PzD3vW0xdvlw==
Date: Thu, 10 Sep 2026 15:33:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Reject WQ creation without a completion
 queue
Message-ID: <20260910123318.GQ13683@unreal>
References: <20260907113918.2315-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907113918.2315-1-lirongqing@baidu.com>

On Mon, Sep 07, 2026 at 07:39:18PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
> method definition, so the mandatory attribute bitmap does not enforce
> its presence.  When userspace omits it, uverbs_attr_get_obj() returns
> ERR_PTR(-ENOENT) and the handler stores that error pointer into
> wq_init_attr.cq without validation.

That handle should be mandatory, declare it as UA_MANDATORY.

Thanks

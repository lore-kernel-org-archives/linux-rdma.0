Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C075392C32;
	Fri, 24 Jul 2026 23:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784934674; cv=none; b=tsBmAIB8a0U+OSqJbCFKWAmrHF6WQj9/WtXQ81y2yvhKPuDahdY48nb18oHa1hfDg7F34ETjAlWxSOs1Sw3KoX958Vy5fOJOh9ctPphmd2N1Z8jTi8T1drEjmaseb4EbGoGEqwdfQorjFsOuOL6dZ7LKUl6junxsqqgqFVtVdKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784934674; c=relaxed/simple;
	bh=xvWQxd4XdFEm5EknexlaABN+edfITT09X1FEwKizLWo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T30sSG3XavLlSbh9XEw9RhRrtU8VYyub0eONcjN4fBLRonPeaSPDfgxKENDeehZ4g3B9xbtRHB57rinoSUslXWIhwc7jxl6mKh/oW5PqYjqmYgkLmHfiqT6O2DltEUQAymOMMypeNHYbF4aF2Be3cyQnNlutQuRZ9msQjotjo7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8IRWQbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8IRWQbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650D11F000E9;
	Fri, 24 Jul 2026 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784934672;
	bh=GD/nWqQa09AH6HzVIsp6HOFmR48o4uf7nQ2PZog2B1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O8IRWQbKdUfA+aOgXD/GJGtFwb4bLe8eZ++E0UcEL4zMs1+GlhhKkHB6OQaDKQ5SH
	 mfALW6t9wPc6yf4i8A+eDppcJpv6BaV865lfxhC8YrmSbjmnWDkOtXXvhogjtmkeSj
	 PjqkHSjQ96x40vlCcudeuEhWbBbNSleHsUJ0zTXQ/r0k3sGCfdczgtWHPCpF3xYv8K
	 7bFn/Mv1dYV48ZgL75p9tjviRux1+5OdDtZlBxBdCSqKb/i/a0/ZIkzxH3h77x/j0w
	 5nAArpXVoal0np7sqZ/NOuwn0Muo4vZul1+ziVqnmhGMxKBTeZLi5vRqtRgqkFM8EQ
	 +zssSOui1nQyQ==
Date: Fri, 24 Jul 2026 16:11:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot
 defaults
Message-ID: <20260724161111.2ac47089@kernel.org>
In-Reply-To: <20260716084852.549909-5-mbloch@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
	<20260716084852.549909-5-mbloch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 11:48:52 +0300 Mark Bloch wrote:
>  void devl_unlock(struct devlink *devlink)
>  {
> +	devlink_default_eswitch_mode_apply_pending(devlink);
>  	mutex_unlock(&devlink->lock);
>  }

Nack, please don't insert such hacks into core helpers :|
I thought we discussed this.
-- 
pw-bot: cr

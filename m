Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B4F3F8236;
	Mon, 27 Jul 2026 20:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785183035; cv=none; b=ffEW+m4Er1juECZHpVqRlM3n+JPyIPBDCXefGepPLJ4so8owYEPews5J056b0KaNTKtsPb2aZ4FZpzIDX4ScgZBLEYQcKtiSdktN44xZXOIz0M0wJiARxwNiySXT6+Z6XC/piQ0QsfyByTsKClRuy/TNRW1wCZ0r0gULxm0QQzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785183035; c=relaxed/simple;
	bh=xV2yRk2jIp82V0i1IacFF4mR741G7XdVrhbOQiWY6ic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEFZv8kPI1gvhZ3hPx8epGxezjXncLhXBRoi1370WfD/Hjw8hX+OArcCR/t4nlK/MGmRqoGs9DKC1zbTMlSZ4m2d/BQxUzKZ+j+e1Vy7axnsykRvRr+ODmUiVhEDiwnZuSEt8NLPNfxCDb6BZHMUdoUiKRuDQpZZw9NOs+O4FzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNLr8nFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNLr8nFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB171F000E9;
	Mon, 27 Jul 2026 20:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785183034;
	bh=hT7rBXZFrJH1Jwk2GRv6Mrok4i24yc1tb1R1Myn9MLE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QNLr8nFnTDLsTqlAJAnSsFQ6oGpBCmZZgzPzYBRpRpsLJWymVognwZFRU7dhVYsdy
	 NoNIKclYkacsCTVgHuKOWIh7WQfB0LLZOQ8LfJhd4AkGTm7lUYyUxx7+T5muQdDWfc
	 emItJkQRzdusaLBpIbvw7W3RWQ5JuSy9+dZ+lIDzyjCDSfxS++8KFeiHHS3Df5qRJH
	 pcXbNLZmp/nZrDjeOekBUQcAzagCfj5qsCDG+DikYfCe6e52VLyIYWzxPKXxYeQ4vG
	 9ySJ3PR2zFGEt21T/nw0+GyBwV+vjAwtp4uaO0bE/MpuRYHOn+yrexP0e0V+AUXEQb
	 Iu/1aemnghuGA==
Date: Mon, 27 Jul 2026 13:10:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot
 defaults
Message-ID: <20260727131033.237f70b6@kernel.org>
In-Reply-To: <c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
	<20260716084852.549909-5-mbloch@nvidia.com>
	<20260724161111.2ac47089@kernel.org>
	<c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Jul 2026 09:51:34 +0300 Mark Bloch wrote:
> So I think you and Jiri have different views on the basic design
> here. It's hard to respin the series when addressing one review
> takes it back to something the other reviewer objected to.

It'd be great if Jiri, an nVidia employee and a devlink "maintainer",
paid attention to at the very least revisions of nvidia's patches
touching devlink. We discussed this on a prior revision and he didn't
say anything.

> How about I drop the driver API from this series and submit it as
> a follow-up? This series would only have the generic workqueue
> fallback.
> 
> But where should the work be queued? 
> - devl_register()
> - devl_unlock()?
> 
> Can we settle that before I post the next version, so we don't go
> in circles again?

Maybe a middle ground would be to add a dedicated devl_init_unlock()*
were we can stick such init? Slap a WARN_ON(!registered) in the normal
unlock? I don't want the normal unlock to grow in complexity like
rtnl_unlock ended up growing.

* better name welcome

BTW AI reported that we reset the mode on reinit request. Based on
the code this is entirely intentional but would be good to document?

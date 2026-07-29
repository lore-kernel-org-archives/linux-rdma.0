Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD33AEF21;
	Wed, 29 Jul 2026 23:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785366371; cv=none; b=CgojwSUJIyMNxoMYySgRKY/2tw+nC5/Al4YZZf3d2FxklZPU53b39b3RK2cGBHsBvHqgdxmIi0qmACKMSSswXhP9uw+sYkRPWiShm12iu7cfVNx6HhZ4kmAh+c0xn+HVcxYMpmWF55W22ZAnzFvlSvaF+ObxrhXvn+GEP5rzAas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785366371; c=relaxed/simple;
	bh=q2rDVXugQ85YEJfZ4RfMYucmMHzfFdJBuns8BG10unQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idywL3FEi6+mZKNb6V3s7vSMXusZJrjehqvCN82S+Dk4/PAgm5orJlgxsCOGBjqK8tGusxzbO8S737e8/6G5ImYiMYdI+sUTvYt7Shr0RXsXLvVarR4H1AUUkv9T99EIqWF0JPuSUUNRbVFnZtnUqZzSu8ZuTqK11i56X2j3AcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iS18peI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iS18peI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB971F000E9;
	Wed, 29 Jul 2026 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785366370;
	bh=Lhsi+afaaIB87p+bKoLmsL0ptY21q4TkorQ5Ox+KDoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iS18peI1cFRmKE2uTiZFcR02rn4viAdu3B6h6M9lsBYieZwi+U67WO9e7FI07jrVd
	 JNHleBhGNBZ7mxEeLAaCw5WTnQISmOYj/JLG5qyFhmKQzb8FTifrM3TL3gn8qjtW0T
	 QKeBuEi6sVnn7ILuNCiI+NrE4qTzfQ+Tnjl5ea69jC0m+0F7qmvlys2/Pei5j9EEF3
	 L1NgvOZb/joAiiluECmIsytMIExf2QWh/mY+pPpdrBG/TuSZY9iQ2Vn2mwLr+KoYj3
	 GpNRn8S7QfDHRezBRmftnpt6fW6brL3zIMkDXJPGcYxJaJiJ4paWsI2r6qaeytImU9
	 OJovwcFDrVGTQ==
Date: Wed, 29 Jul 2026 16:06:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Mark Bloch <mbloch@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Saeed
 Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot
 defaults
Message-ID: <20260729160608.3c491568@kernel.org>
In-Reply-To: <amnDfSmMVzpiH2gE@FV6GYCPJ69>
References: <20260716084852.549909-1-mbloch@nvidia.com>
	<20260716084852.549909-5-mbloch@nvidia.com>
	<20260724161111.2ac47089@kernel.org>
	<c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
	<20260727131033.237f70b6@kernel.org>
	<amnDfSmMVzpiH2gE@FV6GYCPJ69>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2026 11:11:53 +0200 Jiri Pirko wrote:
> >Maybe a middle ground would be to add a dedicated devl_init_unlock()*
> >were we can stick such init? Slap a WARN_ON(!registered) in the normal
> >unlock? I don't want the normal unlock to grow in complexity like
> >rtnl_unlock ended up growing.  
> 
> Yep, that was +- my idea when I suggested this, to have this in a
> separate helper.
> 
> devl_unlock_in_init()
> ?

Maybe "after_init()" ? "in" sounds like we can release it multiple
times but I think the idea is that it's the final, single "release 
into the wild" unlock.

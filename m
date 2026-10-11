Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DF5344D9B;
	Sun, 11 Oct 2026 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791740118; cv=none; b=RwmAq03VSpsgVz6FcmqP5sWr0FbS1FPCkJDoXDLtzi72XzVX2hBiAm/jOsOyVTyqwCs2AogxV5s+JeP3cxq6GzDWex4f6Du1Aa/VmIexYE9GAIb00LqFrlequ9Jcbz+6zuTPhwj/pYoaMqIXV1z7x05gPq7+wJ96YnCWTj5vgrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791740118; c=relaxed/simple;
	bh=BUQSd1EazJ5jQDrnhwYrGmrQViXQaHfoRlGnBjmF7b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNOSzaaOx/RxWUK29hIp9I0NzOwjt1RpbZbSSIpnB9tQ1HT1esRN8ApDp1ybcUOXEjC/Pc4FdJQxMQ93UK64PRGsmvein6ZKWCev7TZDh1WG8HM9ftnYfWhyZnoJ80xldrpCg6oXAa/56GzAhQOcF6NkWKwxzwqdjhiVDDzs5Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=NS7NGOuU; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="NS7NGOuU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791740114; bh=BUQSd1EazJ5jQDrnhwYrGmrQViXQaHfoRlGnBjmF7b0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NS7NGOuULhTUJ9dCzDJBdiMWdStScT4NJUA9ujQ4fBkGWhpyI29fEDZ9N0o6vHMDv
	 yCIUnXaypbp4yYNmIV4D7yW57nK39MaQlIiB35GPGmmZARhZMAnmLjYzuxJKwcrl+C
	 zm6DMH/07wM8HC2SJ7BS1o9CoJSp7LRQfYne/Cn+dH0lvcoen0bLpWKMoDMiTlBhFc
	 B0kcMiZVrZIZj1i7pOUQm6jm/+bHeT4Y5O6akGxJ35gWy7nIRi3H7ZZ1bfHLCjiHzz
	 ptwFEPbAbpt6kYdGxJb+PAbyCVzlaEpl+jI87Zie06ZYuWQgRZTzbQ0iBY8Xd7wQ80
	 ZsgPd3pImHNIQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id E13C844C117C;
	Sun, 11 Oct 2026 19:35:13 +0200 (CEST)
Message-ID: <ec7e506e-2aaf-47ac-a5fa-3ad2c09b6bec@corp.free.fr>
Date: Sun, 11 Oct 2026 19:35:13 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix modify header pool creation
 race
To: Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-3-acassen@corp.free.fr>
 <22e85761-ba52-47c1-92bf-b4dd331fc069@nvidia.com>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <22e85761-ba52-47c1-92bf-b4dd331fc069@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the review Moshe,


On 10/11/26 09:57, Moshe Shemesh wrote:
> Please keep the lookup out of the lock and re-check under it only on a
> miss, roughly:
Agreed, your approach is best, I will update and resend a v2 around it.

I was also considering a lockless variant where xa_alloc() picks the 
index, but 2 callers racing on a new pattern then both create a pool... 
the spare pool still allocates a full bulk of 64k entries in the host 
and device memory for a single rule. Your suggestion is better here...

-- Alexandre

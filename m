Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E5215A86D;
	Fri,  6 Feb 2026 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770337069; cv=none; b=i0IfNo7KAI0/Bh/beyzg67mRf2MuCJ/ej9QNKmskOdltfKZUNOouaSC1eldJBV/l2VaORGbalJnqm/p+dIYALQU3S1sZkhGMfGK/J9qrClGTw7EO8Av6MpONzHAjE0Wi0foxSOrTDGxtF9bo4hw7yOWLcy/BZrHdXh7gwnrfvBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770337069; c=relaxed/simple;
	bh=DQrq5c1J+kiv5UEj7nlCQrtJTusd0d502vuVJr1r7pE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Io1r9SIYEgGXX3KlMpXo3ixm1xyuru3Ou5LXVTbOiH3iuYYjeE/KdpnWiy93JmELwfarLxGEhjbDzRrS/Y08KPYXrYerqQzKYbQrrVvCjCHKsxQi6Svxd9/upStEXtac/Ot6vW7Q3IZvgDe1iQNW4bbreagocs4tWa2/ljEhCds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gf9tjtCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf9tjtCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59429C4CEF7;
	Fri,  6 Feb 2026 00:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770337069;
	bh=DQrq5c1J+kiv5UEj7nlCQrtJTusd0d502vuVJr1r7pE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gf9tjtCJFiCokVo3TecNVaL7vYEpVzQS+7qD7EkE4j0zwz6pQa8CJzf8yq9jCKQPh
	 inzUgyrJC/kXCAypadw2sf4WwKVDYiZpLAJ3vJtNXFKbaMABNo/IABgZ78lhjDoy3T
	 KrRc97EcUTmRJ5KPSZratWTiMDx2crawaWu41OnmHKeRBkPTjPlAqEg7qbQRoCqYQu
	 wcdjmdRXX/zZctk/GubMb8xTmTrtJiEbmboWrZfXfzGiNRfxIYC/uyEJwhU/T1twax
	 RhHenQ/IlbuNZ8iCDPEeuLPPZrOhuOmRsGkmzn98SaM2Sio/TXjfFDM9+suE00uxKk
	 yBIBVmhLjVuog==
Date: Thu, 5 Feb 2026 16:17:47 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed
 <saeedm@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Shay Drori <shayd@nvidia.com>, Jiri Pirko
 <jiri@nvidia.com>
Subject: Re: [PATCH net-next V2 0/7] devlink: add per-port resource support
Message-ID: <20260205161747.26dd7bc5@kernel.org>
In-Reply-To: <20260205142833.1727929-1-tariqt@nvidia.com>
References: <20260205142833.1727929-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 5 Feb 2026 16:28:26 +0200 Tariq Toukan wrote:
> Userspace patches for iproute2:
> https://github.com/ohartoov/iproute2/tree/port_resource

I pulled this but the test still doesn't pass:

# TEST: resource test                                                 [ OK ]
# TEST: port resource test                                            [FAIL]
# Unexpected resource name test_resource (expected max_sfs)
# TEST: dev_info test                                                 [ OK ]
# TEST: empty reporter test                                           [ OK ]

https://netdev-ctrl.bots.linux.dev/logs/vmksft/netdevsim/results/505601/9-devlink-sh/stdout
-- 
pw-bot: cr

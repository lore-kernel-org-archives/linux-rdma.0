Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC15229D26C;
	Wed, 12 Aug 2026 23:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578357; cv=none; b=uBa6FnjtzXcSLiZUF4hO9VRWXb51IXvrT30fN4u5Dq411CsS1iiwFLBCzmxa7QJOitEJjqXpF05INQblUqz1I35CR4ROuGlJ/qEbzalLT3SkhIXGWcqRkoq8LUTi2hDIxmcE06/BGb48cIgA8bCQWJ1LY5WYc4zSRMVECqSYsmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578357; c=relaxed/simple;
	bh=TFKTn041Kur+V6R+fCesi83OToIA0NjtW7dKPJbPeKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8ksJdmAo+SCk8PMuNYQnElGVvZfV722Z2WVDbQbJDwjwxn0IvoZ3dzWKkThc8ZRtbzSScSfhLvh64TUvy1IjmSmHMeLptAB+HmcfM+g08Ccx+iZN76iO/aGemF7GDgvOJ70k8tuxevNncBF4ubDlVx7hGemWxCltfrXVzTUG1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YS8uNJ8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YS8uNJ8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505CD1F000E9;
	Wed, 12 Aug 2026 23:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578356;
	bh=p706KxrXUyLLS3SNduLoqji7VPLGV5gqpRQb9OIf4ps=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YS8uNJ8jJIn2VoyfwsLTV/jBigQm8VJFCwa09I2C7Est+DAs0ps3XEWReinKwhfeS
	 1qkLZbzEUm2PfBjQlUIEvvdPGIt05qM3hSgzfhd9YyrqUM9JjdUhvQORufVYOT2yhL
	 twn2b73tbhc/27nbo9LfYzcEEJe05SUnMxvvDK7a4Ti+k1pc0ymxypVj49YcGGOxRI
	 WxObm7Pc5hL3viZe6JTnz1BJlGSjnCrIjtdxxzJf7oPnogcIuC6R1b5u8OisEy/1p3
	 fLzdEsIjRj6nk4stSdRwQVtWZZzJ6oQ8cSL0ztNRy0cjrGCv6afCTX4VPU0a86+WAf
	 DLcs7i6QYHaTA==
Date: Wed, 12 Aug 2026 16:45:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Li,Yongkang(ACG
 CCN)" <liyongkang01@baidu.com>, Mark Bloch <mbloch@nvidia.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: =?UTF-8?B?W+WklumDqOmCruS7tl0=?= [PATCH net-next V3] net/mlx5:
 Expedite notifier unregistration during device teardown
Message-ID: <20260812164555.692846cf@kernel.org>
In-Reply-To: <63a64169bfee4c429698fa65e27cd275@baidu.com>
References: <20260811062837.3196902-1-tariqt@nvidia.com>
	<63a64169bfee4c429698fa65e27cd275@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 02:48:58 +0000 Li,Rongqing wrote:
> The netdev/build_allmodconfig_warn bot reports a new sparse warning at line 217:
> 
> ../kernel/notifier.c:217:42: warning: incorrect type in argument 1 (different address spaces)

Why do you feel the need to send this reply?
Sparse is flaky, the maintainers understand this.

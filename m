Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38202874E6;
	Wed, 16 Sep 2026 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520766; cv=none; b=HfJ+zGJiSgw/o/kynGTiXa9o3CnbVRCo3Ea3VWkbhT6wm6hkBJtrXl3FGUza+80I2HO0UBkzustteioXRVUbJcFOQK3yeKHWzH3V1/mjtymPv7myjYaVvtVuUwHkji90a1TZni/bMw7DgkMzh6qpyjbDIiL29USlWiiy7jnPXCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520766; c=relaxed/simple;
	bh=ZkIMFahVBYH1CQ4o/QIlzjjKpE2FkezKAhx3Tah8uC0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7t7KStPbKxKCtg8l+t8VK8ktv4n9DXMQHNyiKGhPXvwQXbukwK44P8+xn7pwe2QwUNI1MDDr8TqAcenaT8dF3BF93rbpEbQVfZzIBaKgcgZ6hF0eoIk6EN0RzEO8+DHtW5FuKd+IISWWjhHUN7WLv/N0ThAdv+EFonDCn/Zq0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNbnkCpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNbnkCpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83F1F000FF;
	Wed, 16 Sep 2026 01:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789520765;
	bh=u21N0zd2LeVS+La3mGIX7olO+1XgqdEuoZs0E93JSOw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DNbnkCpO+RTWtTF+MVpzhyfYZzE/anDN19wGD6KS7dCNoHJMUO+zlpDD29UiuLAWq
	 IxP21HIFOlCRCSRyMn+WpLvjHiXuk/cgjLc5K8twZmviveZcA+tJMbhDFHpnN7x6N5
	 4vYGI90ehW0pDSNMigSrH9ugUF+m+Z1gqt7SopIaksHbSzuPZafNp24dhN1NAAH4jz
	 kKbQj1Cf+dEjiulI/+vEki9T3fdffYjaMMbUr1gC7dSVZTYoOP/TTP1Zj/xQkOePHY
	 bc2jYMTtVsi3jwVleMbNxnD3xixzkIFrWwISFlYaN4sPrmF/ZPFYWMYDByd6i/uPhg
	 M4DCwW+Pa3X3w==
Date: Tue, 15 Sep 2026 18:06:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Long Li <longli@kernel.org>, Konstantin Taranov
 <kotaranov@microsoft.com>, "David S . Miller" <davem@davemloft.net>, Paolo
 Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "K . Y .
 Srinivasan" <kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, shradhagupta@linux.microsoft.com, Simon Horman
 <horms@kernel.org>, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20260915180603.7434fad8@kernel.org>
In-Reply-To: <20260909222416.884246-1-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Sep 2026 15:24:03 -0700 Long Li wrote:
> Replace detach/attach reconfiguration with pre-allocation and queue-set
> replacement. Allocation failure leaves the running configuration intact.
> Publication failure attempts rollback; if rollback also fails, the port
> is stopped and requires administrative recovery.

Does not apply cleanly, also the AI email reporting had an outage late
last week so please check if any of the feedback is actionable:
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260909222416.884246-11-longli@microsoft.com
-- 
pw-bot: cr

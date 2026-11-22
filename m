Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795339656;
	b=r5KJIfXz6Ka7UxQwoxVhqzP+9CiH4ylVs26cbGd0RZus+qFAoZiZfs2AxkHqezxK7Uw+
	 ZyON7yFK1UICKvGZngF1gzWZjLUeVphKPwANG9d5gXkcTRARb2QO947mqbiO8kbHievUX
	 C43p7YJNXzz+8/mZ7un784u4q+pzCJkfLbCajKnIPfJ+gQDEXS6nODWMrl2tIf6gnWAuq
	 3VhNBxCm3SZ/+yFKFbo/JeSfGwDEJOefeY2u97avQuPyMlwjZsChnE8L+kmuy75Pnjj82
	 Urla1RS0dgPsr0Q+pDiKhAQEnSFlN9L7w3oVgtVu0BWqlhiipdswkopCEXh8x+bZeWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795339656;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=iDAaZWIaq9xunca0g9vCV+8KK+wjL0upr7YilM2q358=;
	b=mkDpv4wL/4KiYwWzpNuIL7OrMdLj47GSqPxFLmOYr0j49RZwFtVe0WkNjqec3uR7/+qq
	 eZGMsseW2J/z2zpoQ+NTdJBhzanRQh6Q4I5CdXvuJt5vrktwTL6CrWvd2b8kbPj40Q0SE
	 7s/1E15tM3mVl8AoHk9cUhX1ipbypyK/eJ+VW8Vh21NXWWtcqb+Vgi8mxIghf6fKEl4+Y
	 kJ90fcJqf6N98zITImtOLPKghdQVpeQjTRl1tA4Iz4l1s1Vy9Qs+lYQ0NMj/tpwESDc97
	 FMnUpacb+vlOOBG6/6k3etdRCuM8Jilz0U8f4K5u0cRzmGyfmYZSy+wZbK/7BuPKKsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxQ7W32r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF722606A320;
	Sun, 22 Nov 2026 09:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GxQ7W32r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23A11F000C6;
	Sun, 22 Nov 2026 09:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795339656;
	bh=iDAaZWIaq9xunca0g9vCV+8KK+wjL0upr7YilM2q358=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GxQ7W32rXHPD1eyrruPEOiE+4cWz37zo6VYQvQvW06mUd1XhFhLlYo+3LqkCM1teT
	 pydJHxSOor5sqTr9JBz3cmYMA3TstlolCwi9vVVc6RnkA/1DcqC7vYBCSan9FlOdQK
	 MU8YRIWbvUhMmczVRtztOMGxWuOIerSKFFOGeB5ZhF7OeZwN571iu9Eo1sEj9Y9oNe
	 QrnilwUhi5IxJt6u6S/Wwyrt/HP4SQXmtBQH7400OCQfiHMDBBch5/1JkAH3IEMO4L
	 vDMgQ7+W6+nsbImLMUV7jOi7IGtsSk8121w93R9WTZ9lOsCc4TCRexZhbpDCsYg4AM
	 Eg4y2XF19JxxQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Suyuan Wang <shyckless@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261117-iwpm-perm-v1-1-11f1b87d6fb3@gmail.com>
References: <20261117-iwpm-perm-v1-1-11f1b87d6fb3@gmail.com>
Subject: Re: [PATCH] RDMA/iwcm: Require CAP_NET_ADMIN for iWARP port mapper
 netlink messages
Message-Id: <179533965363.282288.8028872314848162239.b4-ty@kernel.org>
Date: Sun, 22 Nov 2026 04:27:33 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 17 Nov 2026 14:11:13 +0000, Suyuan Wang wrote:
> The RDMA_NL_IWCM callbacks process replies and notifications from the
> port mapper daemon, iwpmd, but none of them sets RDMA_NL_ADMIN_PERM:
> 
>     [RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
>     [RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
>     ...
> 
> [...]

Applied, thanks!

[1/1] RDMA/iwcm: Require CAP_NET_ADMIN for iWARP port mapper netlink messages
      https://git.kernel.org/rdma/rdma/c/13fe248d139ace

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


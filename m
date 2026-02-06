Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E441F5846;
	Fri,  6 Feb 2026 02:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770343798; cv=none; b=iCNOllwSf0xbj3E82Reav7nr6MYcW/ztbwmwajo2VWlGwSSGiJt3/cSwr4MJLzjwvIsejMARfcpbV7uNX4JOF+v9+kbLAKHwJ3ywW6ajrR6NxCwDuHjKyfDpnBzID32yPZ4IYpiNwMa4n3aGeSzvQF77mrlm8R7ejwNWLU2JnWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770343798; c=relaxed/simple;
	bh=mCEfuVKF5ClXIjAUjvnsjD6UryGkeSvPBNFLTZ+mKck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tje1wcG4wvguR7bjG18/GLqlb5G20/ZeUMQgEuUw9s8Qb+s5X9+bfYPlg5LP3wEDLEud5NBc4X377oM24EDYi5EDdXf9mGydGbXZVWlghCrDf0CVZc0p3DDVVBZEJM8pGmlAEyk9ZxydL6aTDbX+b70IQ8tnetU9HsCgxWa9vMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILh8WY92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILh8WY92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E487C4CEF7;
	Fri,  6 Feb 2026 02:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770343798;
	bh=mCEfuVKF5ClXIjAUjvnsjD6UryGkeSvPBNFLTZ+mKck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILh8WY92OWCH8GsvUqlwwhSu6Gc/S/SAUzVFkgtBpxPLEgj7Ta9Dy8KuZkZYCBz+h
	 6yY4JWkPwc4kXEgoVbe0zAQXc2Ka2D0vG8MoRhIz6WMBklpUZJUf0OL+ozXFtGqT6D
	 em4cy05ijc2j+VUaUAW2aP2DNX8usOOPriySFNiWs0aCLDHXi1Q/cfytbeACcsCc1H
	 HvfZ6pHipXCM+oYsVmgfznbQ5U8pLAifDlIfasmE065JaQbfVl7okW+oj4gZmUSI0h
	 So3YR27zGuqDig29if6KXYdGlY+hNblVG3+zJkZAY50nraCnMEGmei3j7KyhZzayGI
	 5WbcmpcrEFc3A==
From: Jakub Kicinski <kuba@kernel.org>
To: arnd@kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	arnd@arndb.de,
	tariqt@nvidia.com,
	leon@kernel.org,
	mbloch@nvidia.com,
	jianbol@nvidia.com,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com,
	saeedm@nvidia.com,
	davem@davemloft.net,
	andrew+netdev@lunn.ch,
	raeds@nvidia.com,
	edumazet@google.com,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	cratiu@nvidia.com
Subject: Re: [net-next] net/mlx5e: fix ip6_dst_lookup link failure
Date: Thu,  5 Feb 2026 18:09:56 -0800
Message-ID: <20260206020956.3176617-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204130057.4107804-1-arnd@kernel.org>
References: <20260204130057.4107804-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
net/mlx5e: fix ip6_dst_lookup link failure

This commit adds a Kconfig dependency to prevent a link failure when IPv6
is a loadable module but mlx5 ipsec support is built-in.

Fixes: e35d7da8dd9e ("net/mlx5e: Use ip6_dst_lookup instead of ipv6_dst_lookup_flow for MAC init")

> Add a Kconfig dependency that removes avoids this configuration.

This isn't a bug, but "removes avoids" appears to be an editing artifact
where two verbs were left in place of one.
-- 
pw-bot: cr

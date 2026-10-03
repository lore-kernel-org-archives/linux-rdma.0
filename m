Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2133397922;
	Sat,  3 Oct 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791066912; cv=none; b=Gjqjd7X+k9eYkf5mO3nsIOS1xjDe89rmW/IYyjh7MJbR7h4pw7AytrQRmVWcaOS2ka+JzY00GgAkTEHASRhsyAI9XHkSvhB9bA0Jd9nLO6afRABBP/o2w91s5rFoZPqmh35pY7EBUc10/f7Uaz4oq8/p5qhPg44dg6AnAca+zM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791066912; c=relaxed/simple;
	bh=853QdQVL5LoPghVETvPDlEIIoSKD1y6ewYuU+Skt0o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4IcKr8v5bzYHK/gBVABsONq7TUsgADr68rLwGSge1URDtoawV1y4myacUKteyw7ak5Q3f5WywURZJuR+dBBU5lvL5EMu2n2uA63P4XaX9HxwdYvKEjQH+smATdySeKEER9MUiiOOS9DsgYufi5LfxWc5f0zgbU+rDngm5gOdQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cS3C/QZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cS3C/QZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B681B1F0089B;
	Sat,  3 Oct 2026 22:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791066910;
	bh=qPVo/SZuOpYrdP6/DW851iFt8Gn6OcMW9Tj36/k34mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS3C/QZGKEJ5ESKK+RQJADkk2n3+15GV08z1BiRPmlwqSKI2FQd+FobRxxd6NJKVk
	 Fs5rt+VHyE41S0lZ1+bbqSMBopng3P7kTxZCiQrQhy7Y3OgVRxjxRk8kaJZPPTsTiG
	 fzdC5RyMCbRCYHKlSwz1L9tm3Ocll5u3SRNVaQB5BWpvw/j2Dl+NrWfNjrxvbbhgT6
	 GyI3ISI2nqs4I9wVPuRkkNcWxZpzrYM42ssIhJjNvlzll2ADIC+k/GBDtn8FWop3ic
	 kZB5rSOHTtA5bgJC9Iybiv1k8kUVSA2vukzG10Eq0flwbvWPAgw5LQSUTh17KECFrn
	 6S9WORldTnGFg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shay Drory <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>
Subject: Re: [PATCH 6.1.y] net/mlx5e: Fix netif state handling
Date: Sat,  3 Oct 2026 18:32:51 -0400
Message-ID: <2026-10-03-1-daily-reply-0010-re-mlx5e-netif-state-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002204438.26168-1-artem@trailofbits.com>
References: <20261002204438.26168-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit 3d5918477f94e4c2f064567875c475468e264644 ]

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

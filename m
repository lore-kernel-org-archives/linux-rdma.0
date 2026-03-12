Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DFC31E832;
	Thu, 12 Mar 2026 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773283997; cv=none; b=jAAFcoS5C9aylm9cPF/puWJ8J0c4nvBYZYPK98LppVFaWTQMvPe/q0KDiQtzAtuZoKTYs7tryNXqdNzgDGQtdPnUL5PjDejHP9n1tUFGg2+aQ15Nxv0mGrPvE4tnpkKX6YLiuyE3zziMd/M6VimDnex6J7XTfmXQMadFfPg1n3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773283997; c=relaxed/simple;
	bh=E5NgNfgsKpSMSXUUiQUUEOgT69a7Y/Ps41320Tguv8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPyt0lT45hFUQ44yriX1WRqQcveosrc3++wxvWzFEgv0HPQ2FXxsgtkPF7qG/4uNVT7Hq0oOJW+QcFx2LQ1xYuRuF16sdXBWsEG3KHNwJLAIOgYXOxouMQTl5fRsLcimhhnHfyF7eELcIpuxWJFlNdxxtNZW2hYxgGIZ4Lrm6g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vrdk7p7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vrdk7p7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B379C4CEF7;
	Thu, 12 Mar 2026 02:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773283996;
	bh=E5NgNfgsKpSMSXUUiQUUEOgT69a7Y/Ps41320Tguv8Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Vrdk7p7ZMUgOwDF8tPT3i8m543UPuZTHcUreMreh8TzexcAI2wwlXzF36vADmqJlq
	 GjqUceFftvxJCZ7bARkgXUq67eu6Z5S3Z9ep9xrwytl8r/xpNbyGTVtlqjHPDXv78s
	 rMO1PUr21fPALFX88cBUoDFmb96bbXIhWmsqVyeq36vk8AvTnbD/m2dPjS316gZXcR
	 pYO1NUx91t8yTDEnJYDs8O/JZeMa+9P1KDalnrCb26EhjQLZaTvTF9ECR/PLFFu9I2
	 g3XIytGwatiuOa+BGmSkxr4ea+9XEJU+QvtoyB99HAbjxUyTKjQb9RkymCh52WfiyI
	 zyGizWDGhYlTA==
Date: Wed, 11 Mar 2026 19:53:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Donald Hunter <donald.hunter@gmail.com>, Eric
 Dumazet <edumazet@google.com>, Maxime Chevallier
 <maxime.chevallier@bootlin.com>, Naveen Mamindlapalli
 <naveenm@marvell.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Danielle Ratson <danieller@nvidia.com>, Hariprasad
 Kelam <hkelam@marvell.com>, Ido Schimmel <idosch@nvidia.com>, Kory Maincent
 <kory.maincent@bootlin.com>, Leon Romanovsky <leon@kernel.org>, Michael
 Chan <michael.chan@broadcom.com>, Oleksij Rempel <o.rempel@pengutronix.de>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Piergiorgio Beruto
 <piergiorgio.beruto@gmail.com>, Russell King <linux@armlinux.org.uk>, Saeed
 Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] ethtool: Generic loopback support
Message-ID: <20260311195314.6dd37c26@kernel.org>
In-Reply-To: <20260310104743.907818-1-bjorn@kernel.org>
References: <20260310104743.907818-1-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Mar 2026 11:47:30 +0100 Bj=C3=B6rn T=C3=B6pel wrote:
>  .../selftests/drivers/net/hw/loopback_drv.py  | 226 ++++++++++
>  .../selftests/drivers/net/hw/loopback_nsim.py | 340 +++++++++++++++

pls run
ruff check
and
pylint --disable=3DR
on Python stuff. Or=20
https://github.com/linux-netdev/nipa?tab=3Dreadme-ov-file#running-locally

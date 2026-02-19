Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4EE1E9919
	for <linux-rdma@vger.kernel.org>; Thu, 19 Feb 2026 13:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506977; cv=none; b=mNFTDHk4SKKKxKFe83e7lhA8XOJzbcePKqkDBCJc8ET2han6SwvSrVLuPjh4m77ECefKpSTA9wRuQA5pAd7lWe4PMlWYz3DRks9R0NOkQ+oOj1vsrKrA5CEa2QCoUI0Atcw2KeUZtENFPXDIe985NoiUnPNDW6xg70U73FWgD7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506977; c=relaxed/simple;
	bh=rDD+vCWtRHrlOrhx1l+8AdAVeKfvElGeaXbBhEZtxMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1QdUwzwPoE0kZ0j8Rav+0YYC7zL6FjWlx76oF5JaTsrmlWpPGX+s1ar4SqZOpFlTeZ3HSRP1v3hRvoAAbWazURmIjPWPAAUAJPlBlSCokY7P+8ig7VHm3nxAuDKIcfcixdFby5N+427a6ppCQaHbJVtrnmHhBly51EJ33kmepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=py/+N0a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="py/+N0a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D0EC2BC9E
	for <linux-rdma@vger.kernel.org>; Thu, 19 Feb 2026 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506977;
	bh=rDD+vCWtRHrlOrhx1l+8AdAVeKfvElGeaXbBhEZtxMQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=py/+N0a5zJlGXuv43IH//nzXGXPEQqLyHzk4jNAHRzLHbFu3KVUa87gEp8EeoSBBJ
	 mHDsXXaQ2aeMFh9sYnyXKAKJxUBWVrx4hkMKhkocovwbGOmAtxoZQL9TY1Hx7+gWhu
	 mXl1UR4u93HL5MK9b1k/IwfNvM5KkNcBwnFPVMKynOY/ky+JJy3YX9XNk8/97+RXBp
	 fFbKNgpiWEDj7p45Em928dzjPRxSteLy9vqKHIQVHu95yc0FJnEdh7EmjHxlgvZQi5
	 jgfg3GHMWpDBIZMRSyOkWM9xEjqI9kiXjYSuULhL44bT2ccN7mV0jwz5K/h86uXX5x
	 Pmn7fY1hdmwqQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89545bd3324so11070696d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Feb 2026 05:16:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUqAqzEaACDBhcx6G9AzcQuDz8rRDd+TEOYhU8c3+wzLYl57eVbcax6h4qF0kYaK0cvmu3AR/Q7CSIV@vger.kernel.org
X-Gm-Message-State: AOJu0YzorhpoiU99UcBkZD47AJ+UEuGbKdIYXEdnO/4fzfxl8to5/NUq
	0K9blA5rFBsGvkp3bfK453m/FOcHS0RlswNl19SlA1rjJ26PSSBZNUXljHMQRJyfNo6muFuuaIS
	OT88Pa+Kb9JdRJYwGZ4PGBELT3hy+sCw=
X-Received: by 2002:a05:6214:61c7:10b0:895:48c2:aedc with SMTP id
 6a1803df08f44-8996204f301mr26401446d6.39.1771506976138; Thu, 19 Feb 2026
 05:16:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219130050.2390226-1-bjorn@kernel.org>
In-Reply-To: <20260219130050.2390226-1-bjorn@kernel.org>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Date: Thu, 19 Feb 2026 14:16:05 +0100
X-Gmail-Original-Message-ID: <CAJ+HfNiLH1YYdpsUWPoh=0hxFbPwuo0Pvva-YWZMKzx_8uzSBg@mail.gmail.com>
X-Gm-Features: AaiRm50yp6C40qlYZ1h2gOWGXShzSkYujONDQb8FnWL3MEilQIfdd862mNpsb-U
Message-ID: <CAJ+HfNiLH1YYdpsUWPoh=0hxFbPwuo0Pvva-YWZMKzx_8uzSBg@mail.gmail.com>
Subject: Re: [RFC net-next 0/4] ethtool: CMIS module diagnostic loopback support
To: netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, 
	Michael Chan <michael.chan@broadcom.com>, Hariprasad Kelam <hkelam@marvell.com>, 
	Ido Schimmel <idosch@nvidia.com>, Danielle Ratson <danieller@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Feb 2026 at 14:01, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>
> Hi!
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This series adds initial ethtool support for CMIS loopback.

For the brave, there's userland support here [1], and use, e.g., as below:

  | [root@machine ~/ethtool]# ./ethtool --show-module eth0
  | Module parameters for eth0:
  | loopback-capabilities: media-side-input, host-side-input
  | loopback-enabled: none
  | [root@machine ~/ethtool]# ./ethtool --set-module eth0
loopback-enabled host-side-input
  | netlink error: Netdevice is up, so setting loopback is not permitted
  | netlink error: Device or resource busy
  | [root@machine ~/ethtool]# ip link set dev eth0 down
  | [root@machine ~/ethtool]# ./ethtool --set-module eth0
loopback-enabled host-side-input
  | [root@machine ~/ethtool]# ./ethtool --show-module eth0
  | Module parameters for eth0:
  | loopback-capabilities: media-side-input, host-side-input
  | loopback-enabled: host-side-input
  | [root@machine ~/ethtool]# ip link set dev eth0 up


[1] https://github.com/fb-bjorn/ethtool/tree/module-loopback

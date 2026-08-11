Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4AC2D97A6;
	Tue, 11 Aug 2026 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466441; cv=none; b=LGkDhpxhfbALkXA930wIcd/mivszwvMTgkNBMwQYbb9uRTl3dxkOXTSbfg9SzAWvtC+/JqrecYyMclsS9snSOrwjSt+zImTTWdPgtlnDNdVvpMeMh49EX1IfngK9ZtZ0INaU8m4Ybe/KAffqhNPuk8E1gqvAFzPjmzB8T1c0zbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466441; c=relaxed/simple;
	bh=PVJN5w1R4Ol8+oL/uorvIno/9AZHcmuf/Bm8T4uucS0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwJVe66Ft7/+SQvMLDmUSMTKYPHA8OsWgX2N2hzthAzF91EwcoLw8p8Qp3Dgy7Uh20nDfEnTEUUIkVKRsMICyVzknvnUiepQVeCk741Ft9RXRQT3ghnYtptKi3xhP71GhFi6xqOKoVzlcgWFMr44LYBaZDa/exM0r0r2VZFi97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvMSI0h2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvMSI0h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1757E1F000E9;
	Tue, 11 Aug 2026 16:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466439;
	bh=PVJN5w1R4Ol8+oL/uorvIno/9AZHcmuf/Bm8T4uucS0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LvMSI0h2k5LcVmHQDmEhqLkGwHClMbFRKcJq/Y7qyGrifd4AxI0sqz2oMbjqlisR/
	 na83GdMDcYnrQHewHHIjd/haT+EIMUOVh9JBVeDEXhIac3KK+biWDgtELqyBbi+MkD
	 WRaXcitV1wgQxYX5e3vryT7vGiGTo+CcjgK2veusRUbmGHdF9M4oNPTQbwBtXSklHu
	 B10w4TbCHDRRcYMumB252M3kOI/qGyVIWaDuyieKae/Kb6kG3Cx7C3WMzXLlBwnInK
	 WjtsYBcU6pZfBEqQwxUHKaRlm0+B+dxb9ZaqxKOq+h/WsTHWPV0MN1iv/oj8xoRbTC
	 t++jlquAq4eZg==
Date: Tue, 11 Aug 2026 09:40:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20260811094038.6be81ee7@kernel.org>
In-Reply-To: <20260811063506.2428213-1-longli@microsoft.com>
References: <20260811063506.2428213-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 23:34:57 -0700 Long Li wrote:
> MANA reconfigures a port by destroying its queues and building them again.
> mana_detach() tears the whole queue set down, mana_attach() allocates a new
> one, and every path that changes a queue property does this: the ethtool
> channel, ring and private-flag setters, the MTU change and XDP attach.

This posting is broken. Please *wait 2 days*, practice sending patches
to yourself (--suppress-cc=all) and the repost.

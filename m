Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5DB348C7C;
	Mon, 12 Oct 2026 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801643; cv=none; b=m6GSwdiBRx2J4pcGcaffch+AironYzY4e3TWyso0SiAaULwKa235YMJCHkbe1EKkLywTBFThMUmdTvpW0FX2WwkPQf7iFU/5ETyD5D26BIuIscrKM1ZXNi6j05gtpU1aoZAUHcBeoaT/hnTirKbzr4ADlQNVJKwyLrQF/++nxno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801643; c=relaxed/simple;
	bh=0lqlHCY1i9/hvpDM/SFAMnNmI36PW0atq9twP1Ql5UU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qsxptKN3xohcNP64E1j/SZDc7fKXHDG7Fbt0qWO1Ct5XgHrZsgOgGeZvHWWu5xMoqfQzti6IL5qRBk6xsQDiekUm0kiHe9xMnVoHumdpySJde/sk016bttKHUFLfeiyrGme1kI+Ere6g0MqvlnyOCUNjKCgQoniDCIE8yXhJpSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrZ+jots; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrZ+jots"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED301F0089F;
	Mon, 12 Oct 2026 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801642;
	bh=0lqlHCY1i9/hvpDM/SFAMnNmI36PW0atq9twP1Ql5UU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HrZ+jotssrXgtMm9Lrf2S7dF6bwHiq+8xfu35AQgvaxE4bPrMAoDE3mfC489K01EI
	 3qXYKxAAB20DNFQpVx5Ht06Dkkl3A4X0NDlzjalz2YghWjCFPOWIVZ5OhnPxRQVi05
	 +5/rAKxPYK8LF3F+MiM693CZ3UtfqzLpa3DOyu9eHqg5N0rL80MaxaOg3NaUkAFl7M
	 Zd8ZiwNhQj+eXG87WKpri264X9Nsuh0MTigI9mpqD1B4P67URIWjmQ+WTfjHDQzktI
	 gqakU7RXHGxKymjvJZLJOwsLfe1SHTkH0favxB6VT4Qoc9BSrtEILhIuMTDa4dY/WR
	 uSCBVpM+w8zmQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 54EADA8936A; Mon, 12 Oct 2026 12:40:39 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org, Carolina
 Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel
 Borkmann <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>, Gal
 Pressman <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Kees Cook <kees@kernel.org>, Leon
 Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, Mark Bloch
 <mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Tariq Toukan <tariqt@nvidia.com>,
 Adrian Moreno <amorenoz@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [PATCH net-next 0/2] net/mlx5e: Batch RCU grace periods on
 channel open and close
In-Reply-To: <20261011133212.807979-1-tariqt@nvidia.com>
References: <20261011133212.807979-1-tariqt@nvidia.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 12 Oct 2026 12:40:39 +0200
Message-ID: <87cxtfqk0o.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Tariq Toukan <tariqt@nvidia.com> writes:

> Hi,
>
> This series by Carolina reduces the time mlx5e spends waiting for RCU
> grace periods when bringing an interface up or down with many channels.
>
> Today the channel open and close flows call synchronize_net() per
> object. On close, RQ, ICOSQ, TX SQ and NAPI teardown each require a
> grace period, so the number of waits scales with the number of channels.
> TX SQ teardown adds a wait per traffic class, and XDP and QoS can add
> more. On activation, mlx5e_activate_channels() triggers the ICOSQ of
> every channel, and each trigger waits for its own grace period. With a
> large channel count this makes link down and link up slow.
>
> Patch 1 batches the waits on channel close. Channel deactivate and close
> are split into pre_sync and post_sync phases: the ENABLED state is first
> cleared on all queues of all channels, a single grace period is awaited,
> and only then does the teardown continue. NAPI instances are likewise
> unlinked with __netif_napi_del_locked(), followed by one
> synchronize_net() before the channels are freed. The existing per object
> synchronize_net() calls are kept for single queue paths. The change
> touches the regular channels as well as the PTP, QoS and XSK queues.
>
> Patch 2 does the same for the ICOSQ trigger on activation: all channel
> ICOSQs are first marked as requiring locking, one grace period is
> awaited, and then all of them are triggered. mlx5e_trigger_napi_icosq()
> keeps its existing semantics for standalone callers.
>
> Results with 248 channels and rcu_normal=3D1:
> - ip link set eth2 down: 10.183s before, 0.715s after.
> - ip link set eth2 up: 3.095s before, 1.794s after.

Nice! Thanks for tackling this :)

Don't know the driver well enough to comment on the details, but in
principle, emphatically:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org>

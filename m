Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705630;
	b=WQj4Vsl50ecdjlvdnuXacfOWzLX2hFIn97yV4UOxswtGesRCLk/CeblWu21F0zy9C6vM
	 fJ0UEnAOuyRH9OXDtF5kuux2sRWyUdAO4aoae5eJSN6tNHlZudjbA4xTfc9fQaAqneKVT
	 j2t+X/0lyZNa6bMpaZyt75Yqe5uwZZLBNrWtM7Ys3MPTqoFoSZaNT9x5OggTfm8Ux/dA7
	 QbNPBocGxGAVFcG11LZlMlxcm/IyE22PhKyMYZ8apAktLqZB6tF989G8EYW4YL5V4S5VR
	 zdCmKKFYYFBw9R/nTzEU4uQt3Zp9WuhS9iPwmduZQAJT7/EnAntwQNQFN897/wgHc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vsjnvGGljX9pov+p77+0fvVdhwRr+JXPFgWF2Ng3Rww=;
	b=ZjCIvPuvQIoXaspL3raCWYl82gvHVBdc7ldqNegpG8HZ9riCxx2SU95coo+lJuyc+59B
	 0GocDoppJYkyQfC/eUbXuThXbXoAFR+t/Kj+aTwWYZS+c3UiEg/ZSefUni9hVckdiHxW4
	 TsWp+duv7kfW2JOTgLqEFHYEvIpj5ggVjSKykE9wlbEv8XW6VVXQN4Wyz936OBYqz5bfJ
	 ZlmwTzpKjcjcIDg7BMF43x6NYmLDjy7wS6ffm7sDoRyL5bj3WPj1mTlW6heBBo0kYfHLB
	 lbetjdRcAYwzDK8+chPzRDbEyqcJ5mDSeYowYcKaLAOnS0IRiUMwEVhN/AuACoAxhdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoTa01m1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE81606A32A;
	Thu, 26 Nov 2026 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoTa01m1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74891F000D3;
	Thu, 26 Nov 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795705630;
	bh=vsjnvGGljX9pov+p77+0fvVdhwRr+JXPFgWF2Ng3Rww=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LoTa01m10c/DFZtn0E18pWQOzi4WRWeXm/PToA80poqv9rMEQN4wOov6H0/4L7lJe
	 uc0iMxmwFZ54pWHI8X2OCZH2jKBPIEEND4+WwURhtUrClzewlh0L3aaAjS+rVRecj8
	 XDsXgFdK4MM9rLbT8hrf9ackhQi0GjFkweNgeGkr1XlGwCD7HUyhRrNLK+LNLIezHc
	 MidXYkkfw1prDM8i0QXxEx6X2HNntFP+90SzmYy7rafHgJf5yiBoXzk6VDE6pvcsJ7
	 78sYnYQl5CRACUTGxXyboRSwKWtxZoqco/WJHBkuZI/EfdeMp6Iv/cJWLs4SV1gw4z
	 QhZfukUObWyEQ==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Donald Hunter
 <donald.hunter@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, Leon
 Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Paolo Abeni
 <pabeni@redhat.com>, Pedro Tammela <pctammela@mojatatu.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 bpf@vger.kernel.org, =?utf-8?Q?Asbj=C3=B8rn?= Sloth =?utf-8?Q?T=C3=B8nnes?=
 =?utf-8?Q?en?= <ast@fiberby.net>, Qingfang
 Deng <qingfang.deng@linux.dev>, Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgense?=
 =?utf-8?Q?n?= <toke@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Matthieu
 Baerts <matttbe@kernel.org>, David Ahern <dsahern@kernel.org>, Jonas
 =?utf-8?Q?K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>, Hangbin Liu
 <hangbin.liu@linux.dev>
Subject: Re: [PATCH net-next v3 04/12] psp: add support for socket-less psp
 associations
In-Reply-To: <20261124221758.3230929-5-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-5-toddfreed@meta.com>
Date: Thu, 26 Nov 2026 16:07:06 +0100
Message-ID: <87cxrriqcl.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Todd Freed <toddfreed@meta.com> writes:

> Currently, a PSP association is bound to a TCP socket when it is
> created, and can hold both an Rx and a Tx key.
>
> Add Tx associations which are not bound to a socket, and are referenced
> by an ID, so that other parts of the stack can attach them to packets.
> See the subsequent patches, where the tc psp action does just this.
>
> Socket-less Rx does not need an association, and the kernel does not
> keep anything for this case. For Rx, userspace calls the rx-spi-alloc
> operation, and then uses tc filters that match the corresponding SPI,
> version, and PSP device. The flower matches for these fields are added
> in a subsequent patch.
>
> Add the following new netlink commands. They are admin-only, and
> restricted to the netns of the PSP device.
>
>   rx-spi-alloc  allocate an Rx SPI and derived key, without a socket.
>                 The key is delivered to the peer out of band. Also
>                 returns the number of key rotations of the PSP device
>                 so far (key-rotations)
>   assoc-add     create a Tx association and install the peer's key,
>                 returns its ID
>   assoc-del     delete a Tx association
>   assoc-get     get / dump Tx associations; only the SPI is reported
>
> Socket associations are not addressed by these commands, so for example
> assoc-get does not list them.
>
> The kernel doesn't enforce key rotation for socket-less Rx the way it
> does for socket associations. A tc filter which matches a SPI of one
> generation will also match that SPI if subsequently re-used in another
> generation. It is up to userspace to deal with this eventuality by
> removing such rules in time. Userspace may subscribe to rotation
> notifications for this purpose.

Could you talk about the rationale here? rx-spi-alloc returns the key
rotations, why not make the generation part of the flower match?

Probably missing something, but seems like natural for the kernel to
ensure that stale rules wont match reused SPIs?


Bj=C3=B6rn

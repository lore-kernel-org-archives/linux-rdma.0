Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451334;
	b=xicBx4OA6PTV5JGaYogOvyPBKWCe4nUPPfoVQgntlfigNXPdBi1pAl5yKquvr6cKLnZ5
	 /a8hU2R9D6u0yfvINTgbCphEZBWW5KVgsVTwogkHceGJv+qiKisBbY316TG3vR2kB0yba
	 6wzrLgSxnpiI33IdK7GCJPKCQO8sXw5gGkH2tKTSRQE4QrJ35g5v/qZcbZpZXAL+zQ5jA
	 La3bfZwKTYB8SBf1ESuCRVkXPq8qGTKQzWASdCyVrP/Alh+9R8afCmCKQOTWW7rNAUZxt
	 vLWe3Uykxztib4cmD1eEw24D5cl2276Tvp7PF3ScERUKNh1koH+5nVscRhKhO92xYJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451334;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eLKM7MMeaqzoIZ75AVxnOBs7+cOS67Dja9Pr1r6VNKY=;
	b=u05Y25hSqc4fj95N6QCuruBN286njiMi6GYfn6s03F+o+XzOIpTeLzp+Glp7QWYUuEii
	 QnoNHftf79Y1qXusDLKFiNthOscpc7Ym/QuGg/xxPsipuIsIa6NZz32NkeJ9ZIutVDAgs
	 bOZchLS+9TIjaTAHHqR4CL6QgWSTBPj3gY2DTKBCtH5QONW2LLF/Q3+vHV6EyWb2X0nOX
	 OShxukGu9RB4az0rCrkJLbrzBSnrnJ3yFnlVl32KAqNOfvARvbXD75XwUHkOs4AoWgmtg
	 sxJ9pfOAeBYYpuvINgK1egoigh/Hx3kOw7bIUeddkbdShgTir7xP+1gdpaswLChFO9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NkdYFlrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30A4606A31A;
	Mon, 19 Oct 2026 23:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NkdYFlrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0251F000C4;
	Mon, 19 Oct 2026 23:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792451333;
	bh=eLKM7MMeaqzoIZ75AVxnOBs7+cOS67Dja9Pr1r6VNKY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NkdYFlrVNZLObvTMqbesr14pbD3trgw5L2H4TNqYNolXpHBvm0VC1bK38omiDO3Fa
	 fbASWjUz4Y+mxBOv7Oe/+5lfZy6Tv9f0jeU/7lUFPuSCc/5zBgIO4IHYm7aHHO0AlE
	 EKk51z1IAOvHRCTyFS/ZKGBLG1uwo/XKGAfG7H2cWCn1l1TYWMcfIRVB5uyohEbjHy
	 XKNzoa4NveXR4CfL86ig0/VYGiJo4QZ5oAdy5NICa9gP2biM7Tkl7+62MOXScL2R0C
	 JuLj10XXX4Z9gJ0TIeOQoZJJ+UonvzJlctKIAe3C2/mR8tnBXQowrGbiE+Q6lS9W6+
	 kaHvsfl0o+lqg==
Date: Mon, 19 Oct 2026 16:08:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, Manish Chopra
 <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, Simon
 Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] net: stop calling __pskb_pull_tail()
 from drivers
Message-ID: <20261019160851.7eb2a889@kernel.org>
In-Reply-To: <CAEzrpqfgBrvwy0Q_AX8X1s3ogq3g1U=JmpqHAM8QUmMHAqWPsw@mail.gmail.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
	<20261008141131.0ac356dd@kernel.org>
	<CAEzrpqfgBrvwy0Q_AX8X1s3ogq3g1U=JmpqHAM8QUmMHAqWPsw@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Oct 2026 09:43:31 -0400 Josef Bacik wrote:
> On Thu, Oct 8, 2026 at 5:11=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
> >
> > On Thu, 08 Oct 2026 21:02:47 +0000 Josef Bacik wrote: =20
> > > v1->v2:
> > > - New 1/10: skb_drop_empty_frags(). xen-netfront, netxen and qlcnic
> > >   relied on __pskb_pull_tail() releasing zero-length frags even when
> > >   there's nothing to pull, which pskb_may_pull() doesn't do (Sashiko).
> > > - xen-netfront, netxen, qlcnic: call skb_drop_empty_frags() after
> > >   pskb_may_pull().
> > > - skb_drop_empty_frags() checked with a boot-time test under KASAN and
> > >   kmemleak, on cloned and uncloned skbs. =20
> >
> > Please keep in mind that we ask people to limit themselves to 15
> > outstanding patches per tree. You have 18 right now.
> > (200 active netdev contributors + an LLM) x 20 patches =3D=3D insanity =
:/ =20
>=20
> Eesh sorry Jakub, the skbuff BUG_ON() removal series is the more
> important one, this series is the followup so I can finish that work.
> By outstanding do you mean per-merge window or once I get
> notifications for things being merged I'm good to send the next batch?

Sorry for the silence, I've been mostly offline past week and a half :S

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872429D281;
	Mon, 10 Aug 2026 20:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393988; cv=none; b=UaO/YgjIDNCCb0f1sw6R3DHrns7hGShY2LY6xdMmtZxtFkThEfAPUWihffd/nf2CTs3sOqSRrZxzRP/wNsZDlN9245+o7KSUD0IDkCgES6gMhaurZYk18ScXZ3C77Ermaqi5QU63+R4U2wNj2SFMGJfBeroKzYBM5NKxEJ62nw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393988; c=relaxed/simple;
	bh=IoZf+0v3NXUaqjQ4OFHXfKoewg75jXTnqVC0au64aZo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KnsvpMUGq9l93Jsx2QkmLn1BKz3saHs6az5ShEufmyWsWcfc8OlGNgAw5esCROrNE6fFczJ3OpEQwddVs24xwWTJBGi8kU6ypsVs8I7GeKzWoktjuSeh9pFZGEfH0dtv8MM0pJC+dTPxskIG7cmwY/LcLixk270ZwOek38iijZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iv+04Ojw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iv+04Ojw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9B1F000E9;
	Mon, 10 Aug 2026 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786393987;
	bh=JS4vnHYFrCQbf7xPWB/u3JTRVCD5Fho5rhw8IOrRLRs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Iv+04Ojwq1avRKnoViIVwnZAqslMydNfkcGczHUpooAsdPqDjN124v8HrgFxGHavx
	 Ia9qn3abP0aH2q6nkKrFlN36OIEEtEv+HqpVV+2rTWkhQZH9uIrveFRoCkwY34PZrg
	 IGEtki99WkaOiNYK388KcfYlazsq4QZhH7imKIWg9UuSKn5sJf6o3u8WoBU13IyPEx
	 xcSeRjas7PXh5QNSS5mg0l6/nXpA63tgnClLE2HYI8GnSGtg71ggW0WfwZYvzgW746
	 Km1WpW7c2xzSHdROZL0J+KXQuPgWZm5GRGBKVVCUlvS4WSvrDJOlJCSwtuoQDc7Hc+
	 s86Fi3bNQQsOA==
Date: Mon, 10 Aug 2026 13:33:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Patrisious Haddad
 <phaddad@nvidia.com>, "davem@davemloft.net" <davem@davemloft.net>,
 "daniel.zahka@gmail.com" <daniel.zahka@gmail.com>, Chris Mi
 <cmi@nvidia.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "pabeni@redhat.com" <pabeni@redhat.com>, "horms@kernel.org"
 <horms@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kees@kernel.org" <kees@kernel.org>, Dragos
 Tatulea <dtatulea@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "andrew+netdev@lunn.ch"
 <andrew+netdev@lunn.ch>, Mark Bloch <mbloch@nvidia.com>, Alex Lazar
 <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, "sd@queasysnail.net" <sd@queasysnail.net>, Raed Salem
 <raeds@nvidia.com>, "Jacob.e.keller@intel.com" <Jacob.e.keller@intel.com>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "edumazet@google.com" <edumazet@google.com>, Lama Kayal
 <lkayal@nvidia.com>, "linux-kselftest@vger.kernel.org"
 <linux-kselftest@vger.kernel.org>, "sdf.kernel@gmail.com"
 <sdf.kernel@gmail.com>, "doruk@0sec.ai" <doruk@0sec.ai>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "aleksandr.loktionov@intel.com"
 <aleksandr.loktionov@intel.com>
Subject: Re: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix
 responder parsing
Message-ID: <20260810133305.3b7448c8@kernel.org>
In-Reply-To: <51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
	<20260804083535.2946459-13-tariqt@nvidia.com>
	<20260807175858.70a717d6@kernel.org>
	<51b31f2497f1c42464f803818b0e9b6cc6b9aa56.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Aug 2026 11:42:36 +0000 Cosmin Ratiu wrote:
> > > +#define cmd(_name,
> > > _extra_sz)						\
> > > =C2=A0		({					=09
> > > 	\
> > > =C2=A0			ssize_t sz =3D
> > > sizeof(_name);			\
> > > -			bool match =3D n >=3D sz
> > > &&	!memcmp(buf, _name, sz); \
> > > +			bool match =3D off >=3D sz + (_extra_sz)
> > > &&		\
> > > +				!memcmp(buf, _name,
> > > sz);		\ =20
> >=20
> > Please don't replace off by n. =20
>=20
> I actually replaced n by off. Did you mean "don't replace n by off"?

Of course!

> Because the two are identical after the recv error checking. I don't
> see the point of maintaining two variables when one suffices. Either n
> or off can describe the number of bytes in buf. off is static and
> persists across chunks, while n is temporary.

The variables have semantic meaning, which makes it easier to follow
the code.

> So to clarify, do you want to keep both?

Yes.

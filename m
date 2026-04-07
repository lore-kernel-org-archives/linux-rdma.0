Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB270830;
	Tue,  7 Apr 2026 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775522606; cv=none; b=ue1fgAe3HkXp+Rmi79X8HzCn3b/OLSbl+5eKF9EQyZXYCsm04LJwLhJYjzXXm3KvUruvEBkqASoKQQGX5sJmjCLLdNxV4FueA7EDfMrvfvus5gHYqo92j/CJx1xbvs77aJL5wU2GOqjLc/DWCKr7cNCjHNzwTUSKADnQSftCLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775522606; c=relaxed/simple;
	bh=JY9IxlluVwlJCAKpBGKd5NaRfJ6onloYtkTR64nerzg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM+qBPaEhWBAb0000soc8tjEThc/UdVAU5ohw6pyD9rQLbrE6b/FMMSH+gEpPNh9baflFq3XxGXqB1/OlBpvhQwzO20gp3TfhypLp7W83icc/JDAVwphPQuAt8xgGg+ykpgI+7awD18+D+dsNYY37Sk+4kfsixQ9FkuBFTbo9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1msI51X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1msI51X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAE3C4CEF7;
	Tue,  7 Apr 2026 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775522605;
	bh=JY9IxlluVwlJCAKpBGKd5NaRfJ6onloYtkTR64nerzg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l1msI51X7ofjKkDGEwZ7TwCpO6NGnXPJnQA1lhuTqtcWJfoR/UN5nciutx8NZY7x1
	 88KESoAUzgoAVxwpeh3cqmpaVWHfK1NdIkub5nMFky1HOhcMMt6VIt9oMAliFWypky
	 Y5CbN/7UsM5Qwo2xvW+Fb0DR4qytEphv36XqoIHIgqi1EZjg/ZmORgNyNZpby3AdNp
	 xThrScd8bMR1/Ya+pQJEubcerHYHo2slzgW/sgvVoGuZEnVRkW+0rCI/jWtDXUlaR8
	 76Csx3avtjyGJtd5JzmiJ/TtZo3lhSxFg+JJQrZ/BIuhFaGPJp2XXxhtMak+/6dV4J
	 HfYV6BSzNY21w==
Date: Mon, 6 Apr 2026 17:43:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: Mark Bloch <mbloch@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev
 <sdf@fomichev.me>, Cosmin Ratiu <cratiu@nvidia.com>, Simon Horman
 <horms@kernel.org>, Jacob Keller <jacob.e.keller@intel.com>, Lama Kayal
 <lkayal@nvidia.com>, Michal Swiatkowski
 <michal.swiatkowski@linux.intel.com>, Carolina Jubran <cjubran@nvidia.com>,
 Nathan Chancellor <nathan@kernel.org>, Daniel Zahka
 <daniel.zahka@gmail.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Raed
 Salem <raeds@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net-next V2 4/5] net/mlx5e: XDP, Use a single linear
 page per rq
Message-ID: <20260406174323.4597db58@kernel.org>
In-Reply-To: <d7c247276e39d88e1cd9d86e21c74779@tipi-net.de>
References: <20260403090927.139042-1-tariqt@nvidia.com>
	<20260403090927.139042-5-tariqt@nvidia.com>
	<adH5yAsPJ8rNgT0k@x13>
	<20260406084344.5d315f01@kernel.org>
	<e0ac9755-fd49-4620-92ce-0f5e4203a95e@nvidia.com>
	<d7c247276e39d88e1cd9d86e21c74779@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Apr 2026 21:13:43 +0200 Nicolai Buchwitz wrote:
> On 6.4.2026 18:31, Mark Bloch wrote:
> > On 06/04/2026 18:43, Jakub Kicinski wrote: =20
> >> Thanks a lot for reviewing the review! It takes a lot of maintainer=20
> >> time =20
> > =E2=80=9CBefore posting, authors could run a recommended baseline of re=
view=20
> > tools,
> > where available, to catch obvious issues early. During review, tools=20
> > such
> > as review-prompts and Sashiko may be used to assist the reviewer.=E2=80=
=9D
>=20
> There is already https://netdev-ai.bots.linux.dev/ai-local.html which I=20
> found really helpful.
> If this is still the preferred approach, I could draft a patch to add it=
=20
> to Documentation/process/maintainer-netdev.rst

Right, I'd like to have something similar and a bit of time to drive
down the number of false positives from Sashiko. Compared to the
NIPA's ai-reviews the Sashiko comments take a lot of time to validate
and are often alarmist. The merge window starts next week so I'll have
more spare cycles.

Please share if you had success running Sashiko (https://sashiko.dev/)
"locally"!

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398541946BC;
	Sun,  3 May 2026 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777772516; cv=none; b=WGnTdkioNOE8PzvvjIvs/J9k/IXGMYJMBnTViazGY8WVRhtaO9naSQRJaw97Df42KS4taigsYVek0gDPtcOQZhOt+Zg22Ytyvwy0yMlSBAO0Tyc6rhDShXUTCHcheIUgUv9Q/lecFQ5t0ArYEsgjhFPUxi1kb62P5IzFMfZiPLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777772516; c=relaxed/simple;
	bh=sdhzFmIu5+xwpn/icCOWMOFjiPJj5PJM+2/5CtvDErc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRLxKDxEmfVCGKVgwNawGOWjeuDQESkoP5Lcok+SrFqm4itPwuTZKOwjuSPwkwqmKZy7Hqk0xAhro6BZ7arLOHOXU1QIJ3iuVxTRmU/wLoY9QJn3RqzwWgly068/8b/YEoIfKjU9gOUByUNJNp1At3sKWPOMMR0ESf2tdzwQiZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dY64iFDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dY64iFDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC189C19425;
	Sun,  3 May 2026 01:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777772515;
	bh=sdhzFmIu5+xwpn/icCOWMOFjiPJj5PJM+2/5CtvDErc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dY64iFDJ/4tE9xaXtnuuPF1zru1DE+NZ+sbjT1vjoHW9zsHTw7SRFPVZMB4e0ILuA
	 vUGJvF15rBJhwXJ+/HauxbfZ6rK4syTXVzpQy9bCYmrJs8pkNbN/beAqfn+I9YBNQo
	 /Yp66Tsp2NwoDBCv9cLkNWuTCfID+oYfPhwIfE+XpIO+f1EhVXV1CGUcx0kdhxcPJk
	 t/ZISkA2jxVb5ffjtoass3FnnaVL5Zdi3QOrV+aGGbqFZXIj/LXz53O+5/cA8+WWZP
	 qQOo1Y+a2rDjbGW6gx6NhwS8SAHkE/1LsHd3OP2u0qGUgHLy2qOwPkFYS5Wmar7Fh9
	 OSO79E6OqyIKA==
Date: Sat, 2 May 2026 18:41:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, Shay
 Drory <shayd@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Edward Srouji
 <edwards@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Simon Horman
 <horms@kernel.org>, Gerd Bayer <gbayer@linux.ibm.com>, Moshe Shemesh
 <moshe@nvidia.com>, Kees Cook <kees@kernel.org>, Patrisious Haddad
 <phaddad@nvidia.com>, Parav Pandit <parav@nvidia.com>, Carolina Jubran
 <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>, Dragos Tatulea
 <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 7/7] net/mlx5: Add profile to auto-enable
 switchdev mode at device init
Message-ID: <20260502184153.4fd8d06f@kernel.org>
In-Reply-To: <421e8885-5849-4390-8956-9bc344fa0bf0@nvidia.com>
References: <20260501041633.231662-1-tariqt@nvidia.com>
	<20260501041633.231662-8-tariqt@nvidia.com>
	<421e8885-5849-4390-8956-9bc344fa0bf0@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2 May 2026 23:08:43 +0300 Mark Bloch wrote:
> Before I respin for the unrelated MR_CACHE cleanup, I=E2=80=99d like to c=
onfirm
> whether the opt-in profile approach is acceptable at all. Regardless
> of this last patch, the first 6 patches fix real representor/LAG locking
> issues and are needed independently, so I=E2=80=99d like to keep those mo=
ving toward
> acceptance as soon as possible.

For probe-time config module param is probably our only option.
I'd obviously prefer to have a devlink-level knob for this, instead=20
of a mlx5 specific one. Can we come up with some format that'd apply
more broadly? devlink=3D[$bfd:]flag1 ? so devlink=3D[$bdf:]switchdev-mode ?

BTW looks like issues Sashiko/Claude finds are slightly different,
let me send them out.

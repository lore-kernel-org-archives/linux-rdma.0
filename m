Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794838901;
	b=WMXcJkfx72K4u+Q4Txfu/MCx1XdG/LGH+ZjUpWOvX42UAz0q5SR/NE46+ofQtNjzwhyy
	 M9rG4nfbaztAdN4ZmOb051rETIawWD+O8uZqi3BdJFt0uoEueD0iYMbal5hO1CyDRehBX
	 JuEkwLCh3MwUbRPoWBZ9Cv0QWA4vTBSl5XtEweBhQSDATOsc7epCQQMyLLW8abjs2zD13
	 cFlresQ5dAQ5zOEyh9Q7hAqfZltdIobT+iWdIzrmvy+Enb8wwGB77aG6kpc04Kc9tCuHU
	 gX4ElJg634UbdT9UdBQNdg8okGYG82r3Q0lL3PtYl8TAO5Vf80sHX+baGQOrZvB3Mow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838901;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Y0rdAK14A9QxWLhf2/bZaFf5ckFBWBa/4SrRIbcp79k=;
	b=Rf/Z8UtsFhVbIPGSXwZ5JEqT0FQc9852uJjxmSUlfCVbqPTg4w5qZQmow9htEeSWKlgE
	 yAXUQy4a0/3oNRcxYhazZ0cB1f7seuh7+C5NSD71+M9cmOPjUI0qqwinEvnJtDfqDjY87
	 KQocQ2faodemu88suG4b+xrHAMZxJdcom4SoKSM67bc2FM/TXgmT2uiHpzTrYOM1ppWF/
	 chd4JT2BEdtbyw/Rgf0839LpFpFOO9WECUyuBDA2ALVCIkhUeKhMpzSevjmHv72N7zUg0
	 C7FrC18P15fxFygugCXuhpNygDo8A8TOVxTQLQi29qBGPpaWduPYba0TmPQNjkzeGnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWgpGfo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB63C606A32C;
	Mon, 16 Nov 2026 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWgpGfo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C702A1F000CD;
	Mon, 16 Nov 2026 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838901;
	bh=Y0rdAK14A9QxWLhf2/bZaFf5ckFBWBa/4SrRIbcp79k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PWgpGfo0zBhHUU+7HzLzeXkBUP/sWrAXkdzEkVPZhb6PaFREO9wBL735/Ow0sXXpD
	 1KNKsFD+EMzAKyB3QJ77pdeENjS4vytW+MovH5g1/PmGus8JoK0TtHc+3bYOGFhlcU
	 6Sjaw06KNgKJAiApdOBDYm+esipkdmSdrQuQllcif0xhwCG3Euvsly8wy9IbJ4BJXA
	 kzSKnmNGejStbcmpq/IdCDydID2QZEuVyVRckYNR/PXqdUlQAXaa3fX70CeC/LYOWw
	 AreCkPbfqvZeuAYziZlYEXqy9yvd7ZsWKfpSNkfmOR70pWLH+6rdAT74qTwPaEF0Sy
	 9QiiPkTaKSseA==
Date: Mon, 16 Nov 2026 16:21:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 08/24] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Message-ID: <20261116142138.GT11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-9-yishaih@nvidia.com>
 <20261116085701.GA11319@unreal>
 <759c8f05-a018-4040-a791-fef794eb6933@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759c8f05-a018-4040-a791-fef794eb6933@nvidia.com>

On Mon, Nov 16, 2026 at 04:12:55PM +0200, Yishai Hadas wrote:
> On 16/11/2026 10:57, Leon Romanovsky wrote:
> > On Tue, Nov 10, 2026 at 03:43:04PM +0200, Yishai Hadas wrote:
> > > Cache mlx5_is_adversarial() in a driver-wide mlx5_ib_adversarial_mode
> > > in mlx5_ib_init(), shared through mlx5_ib.h. The mode is the same for
> > > all devices, so a global avoids reading it through every mlx5_ib_dev
> > > and keeps the checks at the call sites simple.
> > 
> > This patch and description makes no sense. The mlx5_is_adversarial() is
> > simple static pre-compiled branch "cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)".
> > 
> 
> cc_platform_has() is a function call, not a static branch.

Please check how it is implemented.

> The wrapper keeps the policy of when mlx5 runs in adversarial mode in one place,
> used by both mlx5_core and mlx5_ib. Anyway, in V2 mlx5_ib calls it once
> per device at init, see below.
> 
> > > 
> > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > ---
> > >   drivers/infiniband/hw/mlx5/main.c    | 3 +++
> > >   drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
> > >   2 files changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > > index 65455aedd559..f4f2ad80e76c 100644
> > > --- a/drivers/infiniband/hw/mlx5/main.c
> > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > @@ -76,6 +76,7 @@ enum {
> > >   	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
> > >   };
> > > +bool mlx5_ib_adversarial_mode;
> > 
> > It is not kernel style to throw random global values to cache existing
> > in-kernel API functions.
> > 
> 
> OK. In V2 there is no global flag in mlx5_ib anymore. This patch is
> replaced by one that sets ib_device::adversarial_mode once per device,
> and the checks read that field. Patch #24, which set it at the end of
> the series, is folded into it.

You shouldn't cache simple function call to an existing API.

> 
> Yishai

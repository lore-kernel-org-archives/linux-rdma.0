Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB173ABD80;
	Fri, 14 Aug 2026 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786738392; cv=none; b=fUWkkZxkqPnYk8ul6bQTqJTXLpRYnEW4Tq+XcWt1vlDdVm91WHXgx8/KgBjKIe7wHE4TSFxZ56D4dvlDwtytkQShLrOgRLJkb9lJtUfI+dfJmSTvatf3wS7rtD3FkuvqZTFdQrTp5fVIGytjEzN6a73orUJLp/E2vUAqMUbKCgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786738392; c=relaxed/simple;
	bh=zwqdKJQM7upl6d0H4MTdoFz8ojNglsD0VIBuPeC7Exg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbwig9gE3471g5NUDDZ5392ejF+IM8Atlct76aFR5/c+h7YBtsM7vphSFA0YVaM+v8qOpeHrKSFrh+o/3ELmmiBQDvfL6mDWJR2j+yQ76KNsW+CjvBdaBXp12wuBpA4pU1ZPJIiQWxYGtSHevB/OeIBj4z5IsiugkdOce0ZiQdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpcavg4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpcavg4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4EF1F000E9;
	Fri, 14 Aug 2026 20:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786738390;
	bh=2I0SuLcBpueNb79CMBegHK+ya6WQQvIiBcTCOAI3ntk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mpcavg4fn1WEOsNj16PrgmM8LzAyAofHenp/guE75y6MwBkGKrXiubapDC8tCPdXJ
	 M9QFdjm0b6ECL09IZXw4c+mkYEUANVjtlsP1ZtNT5nuzbaxqs+uAxcOlplMHAuRsPv
	 VwcvnfDAIg3iQqnAiZ/1y3yAGLXEmHGudQPP70ayw1dv4CC5/OGfn1rN3J5/t8mm8/
	 y3L7gwisvzn8xqGfy5xX57wXOx4rrzhvdy6cwlaFjC4qTNpmBiR/IzyvFdE01lQCSa
	 EmQrJkyj5mqKMMXdJ+Ij7ZgolNokCdlZageUhLWimum72WOwRTFqkIZQapgyJAJwnf
	 cF+hlPHZPF0IQ==
Date: Fri, 14 Aug 2026 23:13:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Vikas Gupta <vikas.gupta@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>, kuba@kernel.org,
	jgg@nvidia.com
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	andrew+netdev@lunn.ch, horms@kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	bhargava.marreddy@broadcom.com, rahul-rg.gupta@broadcom.com,
	vsrama-krishna.nemani@broadcom.com,
	rajashekar.hudumula@broadcom.com, ajit.khaparde@broadcom.com,
	siva.kallam@broadcom.com, usman.ansari@broadcom.com
Subject: Re: [PATCH net-next 0/2] add callback
Message-ID: <20260814201302.GC79153@unreal>
References: <20260814091054.359508-1-vikas.gupta@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814091054.359508-1-vikas.gupta@broadcom.com>

On Fri, Aug 14, 2026 at 02:40:52PM +0530, Vikas Gupta wrote:
> Hi,
> This series introduces support for the PCI shutdown callback. Patch 1
> implements it in the bng_re (RoCE) driver and patch 2 in the bnge
> driver.
> 
> Thanks,
> Vikas
> 
> Usman S. Ansari (1):
>   bng_re: add support for the shutdown callback

Nacked-by: Leon Romanovsky <leon@kernel.org> for ANY changes to the
bng_re driver.

The current situation is becoming unacceptable. We have been waiting
for almost 8 months for proper user-space support, which is a mandatory
requirement for RDMA drivers.

https://lore.kernel.org/linux-rdma/20260318161330.GH352386@unreal/
https://lore.kernel.org/linux-rdma/20260114115858.GA10680@unreal/

Broadcom doesn't leave me with no other option but to remove the driver.

Thanks


> 
> Vikas Gupta (1):
>   bnge: add steps in bnge_shutdown()
> 
>  drivers/infiniband/hw/bng_re/bng_dev.c        |  6 +++++
>  .../net/ethernet/broadcom/bnge/bnge_core.c    | 24 +++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> -- 
> 2.47.1
> 
> 

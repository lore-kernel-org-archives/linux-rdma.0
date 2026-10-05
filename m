Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA85B400DFF;
	Mon,  5 Oct 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791235493; cv=none; b=q7OgQIjbePmJ9AlaS/Y3gaKAxJxt5O75Glc1DRElYhYavHsEF20frrekYB5tHN/N4Gk4Ifbpf9d/O8F+OC5zV2RtHp8AbcOGV2NLceakS4tV6mnUklufr5lfxwWpYzyynD6LKAOE1/R66lZUOnfFB424czBGUufCbJwOH0gVqew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791235493; c=relaxed/simple;
	bh=NPP1gBbYJNETpiQcxyHiqKpK9rW77F8ycGcRa0DJlps=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MchlizFKG8YNnLOVrIwmpo7h0dbSNiPLCV+Okqvh4PHgFE94ticvvbBTHCzq2cieVgoeiiLz5ZE++3UVp6ZwXH2JhNQWS2r504q+rGtFQE0rJPSqB9XbM8sN6ZIVTxTTyM6GovOYQ5jzRqUs0DT2CitM1zEO5ysPzxE0LLrUzXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOvBrwAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOvBrwAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C211F1F000FF;
	Mon,  5 Oct 2026 21:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791235492;
	bh=K0o/UFddcUsLGRCC5nI1BspGg+4BBQDRVa81+bsKChI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QOvBrwAwe3rg+i7vhx89mpKhWnzhGI8m/DZgAMjb2B5jb3CA+KcfhVGMDGxmHpHeV
	 Mx0We+EDaLQGGdqSTEhMMgCzs764eEVWpjMXEC7R6onu5IxI4WWzZkiD4tceIVJIcs
	 grC3k42N+2TIdxT5Uc7PIMO+dDCH0zMCHwzVZ12WZ7GSD31uYxWiUfWxt8wuUOSpBo
	 dn8mv98bOrVdIRnmJbqIr3V7wsfoSdL4IX5mokouGrFnQWT9FS63uYLVPcEcHRSyUB
	 6yZSAhVUCkwVfhCV3v+zcI2drpx+Sy6cI+zPY7x9xj+iAOBqx4VoTXQ1vbJEgNubxB
	 JdAYqIfF9Kj8g==
Date: Mon, 5 Oct 2026 14:24:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
 <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Gal Pressman <gal@nvidia.com>, open list
 <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Nimrod
 Oren <noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Paolo Abeni
 <pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-10-05
Message-ID: <20261005142451.4cc66357@kernel.org>
In-Reply-To: <ae31c9f2-eb4e-4d9e-8ea5-27364e389be5@intel.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
	<ae31c9f2-eb4e-4d9e-8ea5-27364e389be5@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Oct 2026 15:29:15 +0200 Przemek Kitszel wrote:
> On 10/5/26 10:40 AM, Tariq Toukan wrote:
> > Hi,
> > 
> > This series contains mlx5 shared updates as preparation for upcoming
> > features.
> > 
> > Regards,
> > Tariq
> > 
> > Or Har-Toov (1):
> >    net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC
> > 
> > Shay Drory (1):
> >    net/mlx5: IFC, Add capability bits for virtual LAG
> > 
> >   include/linux/mlx5/mlx5_ifc.h | 16 +++++++++++++---
> >   1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > 
> > base-commit: 00290b9ff59ef47b990d26a6b1a8b2ea6dedf5e9  
> 
> my understanding is that you should at least link to the
> actual code using the new stuff

I guess, tho this is basically a FW API header update.
It's not like we inspect the FW API update patches to make sure all of
the fields / requests are actually used later..
I did not spot anything "funny" here.

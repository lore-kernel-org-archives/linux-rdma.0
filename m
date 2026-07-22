Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD0356771;
	Wed, 22 Jul 2026 16:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737450; cv=none; b=ryfBp/+vTDBWXP3kIJlL6xrXXMCrT/vPf5Rs1SBLjxvWCJ0/jOyhxAd51+EFVgvdLPSN+bd/jqjwXv7ttn4xz9bIe4oaCNCtiaLMMc+sILo8Kjm45BBwi9wJyGmEJNYgJ0E7RqHr9I85i4hNKr2iouaywdNjudYbNRwFp3mpiIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737450; c=relaxed/simple;
	bh=m7RvQy5PwHlbPDICi+M4H5Y8avqK0+ly1l7Gncz3ixs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9I1nAlpywSRKwLhFRilZqwCKeAOMy1dOX4+weLa+yMbKAS/FDgTnqNmsOqly3gNKCkFeoauIw6ClqaI4wdsCz0ZFvbNl2UXXs6Pl5TZMH+bMDR5fDqb/HgSMCOiW/E2FXbmT7ccqxBgmpYDi8jHbnynV9L6FCuxgJtyv/YJLQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7f+M9e9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7f+M9e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE0F1F000E9;
	Wed, 22 Jul 2026 16:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784737449;
	bh=rpNBhigwBwG3TuB1RA9VZuCio89YeXNyU7OkviM15So=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W7f+M9e9lSh/0IrraLIAWWo/fvtuLyeDlSjpjCO8azboBx9heHISnkiMpaOiEQe0V
	 xeFOLZz5Wv3S85Nywpn+w3jkbS2Ji//XmIYbM9mZ3jmCyVbE/pzqPaqslJ/0D6hpPb
	 K1TuFI2xvQHoBEgMe9gyOIPw9AUJ51oAVt78PHnP9vtbh/eyHSm/Aqybjr5ehgjYP3
	 BXp+zxIedYBGGEYrnU/E66P3twMYKrQ8Hm1avKVlsiGk+Bszshl6+CunD2cxpoOpCw
	 7fXNAhbmU77qe5wb4hlyc7L+pgwtTqRwvgS8WTmIW9cWBrEFxYHSxwNh30tw5BKfyn
	 GMWsx0WSj6Gkg==
Date: Wed, 22 Jul 2026 09:24:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, Aleksandr
 Loktionov <aleksandr.loktionov@intel.com>, Boris Pismenny
 <borisp@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea
 <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
 <jacob.e.keller@intel.com>, Jianbo Liu <jianbol@nvidia.com>, Lama Kayal
 <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Mark Bloch
 <mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
 <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next 00/15] net/mlx5e: PSP cleanups and improvements
Message-ID: <20260722092407.7601a19f@kernel.org>
In-Reply-To: <d7d7949e-746b-4e54-aa97-04e63544a98d@nvidia.com>
References: <20260707130858.969928-1-tariqt@nvidia.com>
	<d7d7949e-746b-4e54-aa97-04e63544a98d@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2026 09:05:17 +0300 Tariq Toukan wrote:
> It's been in-flight (still marked New) for ~2 weeks, and is blocking our 
> queue...
> 
> I don't see it tracked in Suie anymore...
> All comments in the thread were answered, no changes required for now.
> 
> How do we progress with this series?

Cleaning up patchwork -- looks like this has been applied but bot did
not respond.

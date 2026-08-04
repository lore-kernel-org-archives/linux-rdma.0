Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818A53AEF2D;
	Tue,  4 Aug 2026 01:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785806777; cv=none; b=QHauNVGn5p41Nxp/VsKbqEiMHekpCf11FxIlwXmH/1W708MnqQpC9RoOPBiVGwB3FkS6dqumkNPTjacz3C+pSWM94BuEht46nj0H3rU+r3OmmlmXT1mdh6iNLCC/9nkx7o7yPGZBG2BKcRIwXfp4i6c82OoxLh8YSmGYD5TUprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785806777; c=relaxed/simple;
	bh=eLrbTjjQ8Gmp4PWxryZR65OiA1mzk3rWDhjfLXOlKPM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D68wL0q1OG/zCAKYXDEic858guYsUnQ1vBW4rvDFCZO7Grri0EPa/vONDt+VSR85a71kWeiBthNnGRZqW+o8/soZXKRwtdVUlmCpNVZkf183nHure8h3TyZTzJV+xAiKZx8WUXDGWbIO4ZvyljGEgnq4kmIdVecvUHbqkJFG5eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgp+Snig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgp+Snig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CB71F000E9;
	Tue,  4 Aug 2026 01:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785806776;
	bh=eLrbTjjQ8Gmp4PWxryZR65OiA1mzk3rWDhjfLXOlKPM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cgp+SnigjHp8jK4LnkESFR1xXmZ8wE6CYw7SDwNtm6MAGPu4FJZPkR2Iem9/WsKk3
	 Aak8jPmtFQH47kD2jQnX1xtuIPQ1Tir3T8sFHxbDYhGuQo4tMNGc9NsdK3UGxflgEQ
	 vjpzJGAMGTKu4icHVrVJTOkzd0jm3cHt1Rb3Pnn+LgR8TOnJf+rhH7NDGd7Am59k27
	 7moOvcnd7HqlsEJm/98iSP0RLNx5DA3etoJtOkRH7Uh29fawWl1NzBJck8rUkyK1Xt
	 33ybUgl/HZoaRDo6EIaTVC0MgY8DqZD2lehPxOYHzE3Jkyvmc4Rv7jMWU81Tos0+gu
	 MD54857vdTrVg==
Date: Mon, 3 Aug 2026 18:26:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alex Vesker
 <valex@nvidia.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Gal
 Pressman <gal@nvidia.com>, Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
 Kees Cook <kees@kernel.org>, "Leon Romanovsky" <leon@kernel.org>, Leon
 Romanovsky <leonro@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
Message-ID: <20260803182614.23f26c91@kernel.org>
In-Reply-To: <20260730210200.2590115-1-tariqt@nvidia.com>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:
> Prefix each cache name with the device name to make it unique.

Why do we need a per-device kmem_cache?
Isn't the right fix to make this driver-level state?

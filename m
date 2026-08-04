Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CCB3AEF3D;
	Tue,  4 Aug 2026 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785880679; cv=none; b=urVpTTSVCuHChyle8gcnvx4eivgucmntbl/m9zl5FPCTj3G0Co/N7+HhiofeQ5+vCg5Ez/RlUT9OjgcrbABDwl5WIVsYGG8Uy2Anm5U5xlynWBPMeKAOa18oHaKaU6DtXPwYKSWJR+0H3K7kXkwGtS6VTue4hscapIEeaGH04vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785880679; c=relaxed/simple;
	bh=Km5Rbzt6otWkuq18nAmHrL+0nk1sVh/QtNTPObAoywM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G71TVy6GhhIkEq8ATTMJl33RJA4IAhrGxqyru6tJnY6DSQOs+PtogeOLofy7SI2AM+0dBu1NqVWO+ne/y3Wih6mgUMdpE4T1+TB/HtQhyKznITh2Pm2R4uITAM6RGuKWn7z7kIg+NS0ZmGfxlmsbmOUfrJFHXHZCQaETLmyEcMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MySsu/eE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MySsu/eE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FB91F000E9;
	Tue,  4 Aug 2026 21:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785880678;
	bh=MgP8aPuZKKLDuPnK56SDEqWhpb91AaRFG/k46OhHMcE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MySsu/eEClo89latN5PBuct/V1rTNjkTdLLXHYYR3HAR6Xndo20kRrnY4vS5FjNVf
	 LUD+N5qMTjnLJSAJu8/VYmxd7pVPW3uVwPu/RJnoCju4gv3fcviKmmob65GbeBZLBB
	 XJQqGF5AtLS7UK1D8fObEfkKKU3gyWXJnqxbRnaifwkCw97gTdrJvsvFnqunzizawJ
	 GXed0dJlrNPNja/Y+6Zyr11ttGFCvx5FZ7Wl+u6CoHiWPBlSioKlvlY07/UzM5B+NV
	 ThP20wF0ETGTNBGHVd0x6jGRl5g3gTMUGgCxvlHe5VyAwPFZp4Dqxarpa/o3+gil61
	 gBvpT8Dkh1SRA==
Date: Tue, 4 Aug 2026 14:57:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Gal Pressman <gal@nvidia.com>, Kalesh AP
 <kalesh-anakkur.purayil@broadcom.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Mark Bloch
 <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Yevgeny Kliteynik
 <kliteyn@nvidia.com>
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
Message-ID: <20260804145756.331951b7@kernel.org>
In-Reply-To: <20260804080455.GB326170@unreal>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
	<20260803182614.23f26c91@kernel.org>
	<20260804080455.GB326170@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Aug 2026 11:04:55 +0300 Leon Romanovsky wrote:
> On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
> > On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:  
> > > Prefix each cache name with the device name to make it unique.  
> > 
> > Why do we need a per-device kmem_cache?
> > Isn't the right fix to make this driver-level state?  
> 
> This kmem_cache is required only for software managed steering mode, which is
> configured per device by mlx5_fs_mode_set(). In general, resources
> should be allocated only when they are actually needed.

Of course you have to wrap the init in a lock and count users.
Trivial stuff.

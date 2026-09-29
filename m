Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EEB329E5D;
	Tue, 29 Sep 2026 23:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724089; cv=none; b=FbwORRZ7/9sm78PIOQNG8/s8tQ/JsmM0Jmwhk+EudylA1p9Y3KOIOQLG3GFXMWUrjC+RcNHCwyGley4rxOELO5J25fp1HOdoyAPcAhPMjUZSRU3gTFVd9V8aY7jCnkN+dxpSBYDOghffQT1U+w23u7pl5SwbTGq7oRO4hDzX4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724089; c=relaxed/simple;
	bh=TSzzyK88U/K/2L1P70gc7juloow+Bn/2g8YpC2al1/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYBe3etQVG+2aNqMahwcy0IrAxmUjVIbnAcDi17/2Khff/GN80xFQ9BSkOT/zOBBFJC8JR52kt3xdEDmNB0zPk8MxjKK6Vp2nrLUWpUTDTUysUjgLhnT0B6NjyW4W3T1Nv2ErFqXsxeITP69tO31xtuMm1TZy2dVKT1F6rZokDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oddUbWUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oddUbWUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9DB1F000FF;
	Tue, 29 Sep 2026 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790724088;
	bh=YWC5CYXuxTUv8G0istiMuS24MKP8wRUGra3Hzs7V2vs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oddUbWUylZZS5umWoYXO8nPfuTzgJozBSi1D4Kz3svnydyXiFDDcrlmbmTgvpep4V
	 X9yCqHkNyKfyflWP2i184+pGnpTnxeMoIdDD/mep+4969DRpy2GtOGOL9TiJpT96ep
	 vePw302gib/kk9bbqat59o0NR8egeNtY1vRoNM17CVKqVfHZ4z/0297/dKFERW0cMX
	 LVB67OvZItz7m3nS4K2EVhnrxyY/gCtQDt/U8QWIaq0y9aFIUjUvXmtkoXvualuNtB
	 4g8iLdYrDLuxjvixJsZ2Frlaqwr3yF1aGTN5Ka961DS+g+8o9U/E5bfK45MFPPEulz
	 Zg45HQipUzM6g==
Date: Tue, 29 Sep 2026 16:21:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>, jgg@ziepe.ca,
 brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com, a.k@amd.com,
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [for-next v3 0/5] RDMA/ionic: add SRQ support and firmware
 assigned CQ and SRQ IDs
Message-ID: <20260929162126.5b3ec458@kernel.org>
In-Reply-To: <20260929185857.GL563127@unreal>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
	<20260929185857.GL563127@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Sep 2026 21:58:57 +0300 Leon Romanovsky wrote:
> > are available in the Git repository at:
> > 
> >   https://github.com/abhijitG-xlnx/linux.git ionic-shared
>
> It doesn't apply, please rebase and resend.

Let's pull the shared branch, and then they can repost the patches
themselves to RDMA? The branch should pull for both of us. Pulling now..

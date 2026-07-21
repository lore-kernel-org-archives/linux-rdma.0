Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73777449B20;
	Tue, 21 Jul 2026 00:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784593239; cv=none; b=nFk8D9Df7UCJ/WGaPqMG9MPv46v9fm3ewu6Z46o3UxhMPMGsyuj6qbipSvkT7S3E8ImP51oIpZ4vroCPupg+wvHIXPca99eABC2r2rG+4BWle2UBvGh7qHCduXPOkz1Yjr8iQEalYCp3xRRnx/Cl+8/xCfK3jTpZ6x+M1/AYiBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784593239; c=relaxed/simple;
	bh=w2DUrpioftc3r1B+AoXs7fjAkOI8PTdLHsIG1u9FFCM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FFgQzIDGjRyZj8ftnmFCW2PSAMQmQJJDeqGe0iQqa2U2Zplts4k2xZ3U4/ZNSTyrVh6+7Q4tvk6EVLa3dVIX+VMN70A98Qx/O1p/8mOHLoEK/fouamlfJfCddk6lHeYR7QKMGyFsTMt6GFZZewXqMrjMyYjo4EXzESDzBtu5gOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3wZhoKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3wZhoKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81961F000E9;
	Tue, 21 Jul 2026 00:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784593238;
	bh=yDLG/pRbBV5027BoYBeuqAZfQUOGdU9jKn9+HH/WD2I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k3wZhoKnSXhHb7Gq2p97VFEwce61ZwNk2t6pRH54+BQD7SyZXrj/ooLdYfbgQ9UUJ
	 9d6eVmfD873b7C1uFP5tcztbJ0W2VJ6GwSqqRjpSx0jkieybgn9pt0XadR+6bl64Ca
	 o0iZzZA+g9zx3ZUBsDpGsba3VILJL+aCuUG6dcrxt7GhWDoCtsr/mtjviqD/4Iu3wa
	 dWKiOXQI4Fq/3d8l+pbQwrK37WjTO9gmCtVuGAZLHlp+tRS9ZpCMEVGutS/5XcE2Tv
	 8QX5PmDPVk/cKsvrprmSqsqfXgJQrA0wLlY1qfKtjFUTRivSDXENALRomh9cQyY2u/
	 9EIrPCQP6I/4Q==
Date: Mon, 20 Jul 2026 17:20:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vikas Gupta <vikas.gupta@broadcom.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 leonro@nvidia.com, jgg@nvidia.com, bhargava.marreddy@broadcom.com,
 rahul-rg.gupta@broadcom.com, vsrama-krishna.nemani@broadcom.com,
 rajashekar.hudumula@broadcom.com, ajit.khaparde@broadcom.com, Siva Reddy
 Kallam <siva.kallam@broadcom.com>, Dharmender Garg
 <dharmender.garg@broadcom.com>, Yendapally Reddy Dhananjaya Reddy
 <yendapally.reddy@broadcom.com>
Subject: Re: [PATCH net v2] bnge/bng_re: fix ring ID widths
Message-ID: <20260720172037.5d78a213@kernel.org>
In-Reply-To: <20260704164747.1995227-1-vikas.gupta@broadcom.com>
References: <20260704164747.1995227-1-vikas.gupta@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat,  4 Jul 2026 22:17:47 +0530 Vikas Gupta wrote:
> Firmware requires more than 16 bits to address TX ring IDs for its
> internal QP management. Widen the associated HSI ring ID fields to
> 32 bits. The values firmware assigns remain within 24 bits, bounded
> by the hardware doorbell XID field.
> 
> RX, completion, and NQ ring IDs are unaffected and remain 16-bit.

The netdev patch queue has overflown. Please repost.

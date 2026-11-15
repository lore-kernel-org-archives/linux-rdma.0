Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794750217;
	b=MK6pt/yCT7iiCvPu8J37CZXwcC4Kcf5217jIzJlr83U58vuuDljijpJrUUyQqd6G4b3g
	 b8hAzuKndE0tDOJMW7f3WnC897DkDir5Zx4XqROKlT3NKNvyluNGRBHPsvhCcPAIg8mwp
	 Mmbw0EThrTQpnsthnxzzHyWk/DrHlLtl9VaVHzlIAdoRNcUBRCsl0ievwScPHIzceGL6C
	 JOqOjbTHfoBtVXPRsXVOeuLj6kd5B5XgtROcvgrGtd2fM9zj8GyG4Tgd2Bvu69aEFOH6p
	 /jCOabTDQT705MY6EVBFvYCHiasD3uKtWZfTCSQuFturNMNVxXRI/a5W+NV1zQmKm4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794750217;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=hKmNG7/PUDkTFTFWHzBH3UfWdxGcdz+gZqXAszUVFns=;
	b=gVTxwcYEcevpEMV3SQrGU5jgzX9NCTRH2YMFSYfxxydfvZfcnfXlnOyo0S4JSUCie/8c
	 dTwGBNLNH24BpcX0NCE7WRUTmCfM+5riDjn2nMV3jiztn5o0ABnkfbo34CQJ7qPlenfz5
	 BQQvj2LLrfhaUd3KN5kuozLzMj6ee1vfDrxw37g+1aV3OXa5/1bgiYppGeGapj0Q+k337
	 nfKu3ih13TyYYDuC/vPVAdVUUucRamNfsPblRJkQIS+VHPP3DfIi4TXhliHDUiOl1QKwm
	 u8dw6fBSjeDANWuIQKnTsuVReujYaSgUIr2VQ0QgRL7rmwr9osGQimpWTqAGdgRBQgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwksNlKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3C6606A329;
	Sun, 15 Nov 2026 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lwksNlKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16041F000C6;
	Sun, 15 Nov 2026 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794750217;
	bh=hKmNG7/PUDkTFTFWHzBH3UfWdxGcdz+gZqXAszUVFns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lwksNlKKqWcap2cDYkbGiNmbIjfil3xcjpk3c9TeIS+UEKav9sLziQYzFLPZMy9nX
	 oW/j7rbaX1jq5flNWOL0zWykxRQsv79YvWODHjs9P0Z8MjfrE9vJGTnnL+TvZ1w2HC
	 XJOhVLoGJGq9oUHRKL9iBzXM6d1YjL+VRCCRgMYmKEe16khZqL8d2hjhkNwdo/63v8
	 sjn6SOfnML8R4EmWYn0hKXln34DAxcpoIbjXckXaA6nlESv/paFovQF+8DBIef0UYa
	 KrCo/yqi+Q8Fzxh8FRO6RxhlMFRoHCJmHCnnfrPNMsquSZ98MotNLeyk24eGAarQGW
	 EzDAf3vgqEclg==
Date: Sun, 15 Nov 2026 15:43:34 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Xin Tian <tianx@yunsilicon.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Junxian Huang <huangjunxian6@hisilicon.com>, weihg@yunsilicon.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 00/15] Yunsilicon XSC ethernet and RDMA drivers
Message-ID: <20261115134334.GC42525@unreal>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261110104822.5d8a1a76@kernel.org>
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
In-Reply-To: <20261110104822.5d8a1a76@kernel.org>

On Tue, Nov 10, 2026 at 10:48:22AM -0800, Jakub Kicinski wrote:
> On Wed, 04 Nov 2026 23:57:31 +0800 Xin Tian wrote:
> > Subject: [PATCH v1 00/15] Yunsilicon XSC ethernet and RDMA drivers
> 
> This is way too big, initial driver should be minimal, maybe 6k LoC.
> You may find these prompts helpful:
> https://github.com/kuba-moo/ai-prompts/blob/main/driver-upstreaming-prompts.md
> 
> Each patch must build cleanly with W=1 C=1.

Please submit the Ethernet driver first. The RDMA driver will not be reviewed until
the Ethernet driver has been merged.

Thanks

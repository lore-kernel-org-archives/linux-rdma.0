Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615255;
	b=yHR+lIqbJRQkShumnOproIe6RM9aT+uIHBHopx86IC+0GnaxyD+DSU6b0Grt8S5cUjWj
	 7jpFMfMznC2qQaOWhTkflZC5f/TXLBq8vfISpHPDG4SDGULvujNuQEHmG0/P4a+lTJIZ+
	 pzRT3erEXCzIfYszvM2AEWWNM9eE9ZTqlYhaYZbHLBKgdDIljNBvD4dQJ+u1rp6W03Tc1
	 cJdADaD17PzJNEX88YP9GwPNA+BDhKC1ecYx4Zk0hhQPmg/ErUHKUrtyLxOFmjaJwDYjn
	 8aDuO5ybG62+B3aDjoEEHYHu6gyGj2LGCW2w1vedpxcSr3H6/Wtd2h/egKvK8LBDKvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615255;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GSL1GGdImg9hl4VmD8JgKMsvGIQDNZPkKDE0HV3fsIk=;
	b=CnGukwZKFYo7tdWeFVGnunkGSvcInrz0+PZTkIH30dUHuv3zmSsAf26j/Zr14k0x3pnF
	 aq8DEmW0alVO5/8nYtjlzz4uJUZr5MDqy2TdVswUmlJK+pO9RPUE8ZS4UUNK/rTadC5nj
	 vpdejmlh0lRCo7dS5RIrFUmbg5VQXOjUf02wQgRp2lcSNsuuYDW+dxrwNAZ4BVDO0bn2J
	 MUPFfXlgn7AZvdiU/IGql4joNt6sZDsUCs+Zcl86xwCnO1Pca90FcQ6d/U/MMiqmVzKgj
	 KdBFYshNFlmXCJ9jHZkN2CeDpovDpH1U8qJRI4jtJK8YX54xcaebqD6frTjuKIvYHiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bY6t7Nko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28612606A319;
	Wed, 21 Oct 2026 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bY6t7Nko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0654E1F000C1;
	Wed, 21 Oct 2026 20:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615254;
	bh=GSL1GGdImg9hl4VmD8JgKMsvGIQDNZPkKDE0HV3fsIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bY6t7NkopaHQe5aa/mdvJAALDELewJyZEq+q1bwFZuNAuIm53sdBHodM6puPc8Mya
	 OghPky/009O4iGSgpCnSZvVtdQUi1re/Zb0Y9X5IA6gCj77I5g2Th+1lthOCevqsGS
	 F0IU62MlXLPaFNFCvwmVweGu+7hTD6pxwbBjT9zJlI3NLRBz9fD6YIKtkXUKyAbeZo
	 u8eMWbIh25rdKMyclx45baYwDh6GpZFssI2Bw0LC7wXwZ0YOqJINS3aH9BuDbAxGWE
	 cHDhV6orObUIybY6QLvujsX3XZuB0zKRfiyWDsCxtk+ZbYGb80RnU8wRd1XbTrR8sH
	 +QgoqAfmrbs1Q==
Date: Wed, 21 Oct 2026 13:40:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch,
 jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, shradhagupta@linux.microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org
Subject: Re: [PATCH net-next v8 0/4] net: mana: concurrent HWC requests and
 dynamic queue depth
Message-ID: <20261021134053.74169d5a@kernel.org>
In-Reply-To: <cover.1791998462.git.weh@linux.microsoft.com>
References: <cover.1791998462.git.weh@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Oct 2026 12:06:11 +0000 Wei Hu wrote:
> This series adds concurrent HWC request ownership and negotiated HWC
> queue depth to MANA. It starts from depth-one bootstrap queues, keeps
> setup private until the final channel is tested, and preserves the
> distinction between CPU lifetime and PF ownership of DMA mappings.

Please respond to the netdev-bot AI review in a timely manner.
(You can ignore the global review bot, it's not even CCed to
netdev so maintainers don't actually see it :/)

Can't tell at a glance whether the Medium / High severity issues
are indeed valid or nit picks, but since the merge window has already
started let's revisit this after. Please repost in 2 weeks.
-- 
pw-bot: defer

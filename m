Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D836E46D08B
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 18:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089873; cv=none; b=ji9Z6aYvOLofk71RKBoLY0DK2TGK7ajLMTBx8wd4d8cxJggJhjHIrKT2A+bQwI6AvyYE/z0RqER95fB7XyZP7ISdoVd73RJTBaZgtDYqyp9cZqur0jKSA0oyodCoGRNbCuLVJx1CZ9u2s8pO5yT8Uu5AwJxgj4BYeWei5tSdD44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089873; c=relaxed/simple;
	bh=3u8hac9+m1J2qWDAJamgQlhB+u/Ws7T+zc2NHUI4XbI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZHes29JdYKw7+QwVCW8FaUS7ETThe1Rz27NAPJgSR1UrCyDMFKDpb39YT5+czY+vC5QtkYqbYJS3yOTrgnMEBEdbQYvH/8ipktNEUvCYqJoS38DmxaP5fT3rIAvnGspbcmMGcwu+AZJuEEgTLxxVflowAopFOcK1o2b6lq6SDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9ugXZh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9ugXZh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0735F1F000C4;
	Thu, 15 Oct 2026 18:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792089871;
	bh=WtW4VuqVLo7D8IEdaHM2iGPRR3QdLuXjULByHYXYzA0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=V9ugXZh/kKYa+Sl1bhFI8uztaybBbgia7jH8WT9RdOM2s+HO1lar0UCaeWOtCerbG
	 tAkYnEMFg6tzqIgtRxju7bhDGewf9ZyPdO6J74jDVLXkYCIZwG1/KBVnEbVuwmX0QT
	 ZoenOXBixeDi6+Gyciwmr0ZUVkpj+zCELhGSSymC5cR47bsqDoeSOaUDXGS39HkCaH
	 BdM71bR7IC+613ZSAJix4AeReIhBuSQVbgO5TmSCeHuI4RqYQYVXdL1Hz0OYiaXmax
	 pyUQlcPb3Yk7F2NOGyFVtiQuVV6A5jleBr4sQZiAJdc5jdA515K9qn5wm9ZKHEj/Og
	 /EXNUwbwfWS+g==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org, metze@samba.org
In-Reply-To: <20261015161756.3078300-1-jmoroni@google.com>
References: <20261015161756.3078300-1-jmoroni@google.com>
Subject: Re: [PATCH] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field
 population
Message-Id: <179208986858.417468.8994738327508258200.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 14:44:28 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 15 Oct 2026 16:17:55 +0000, Jacob Moroni wrote:
> Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
> using a mask that was right-shifted, whereas it should have been the
> address being right-shifted.
> 
> This ended up working fine in many cases because the lowermost 12 bits
> are always zero (the addresses are page aligned) and the uppermost 12
> bits are usually zero too, but it could break for DMA addresses that
> are wider than 52 bits.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
      https://git.kernel.org/rdma/rdma/c/59df57262e6fa9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


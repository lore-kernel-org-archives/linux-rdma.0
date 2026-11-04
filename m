Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778663;
	b=Wjsmad+R6gaOR+vbSAN6TAZsM9YBflbj/Ow6fJHKYdn5u4qXK+Iyhz+DI1Bz/P30gRLf
	 DY5AjYEfi1xk4vgCp5g7R/E9WXW3nxT7aina3s50P7oI12V/yvv0VThg6TsI+ntotDpSj
	 1lwxc00xIws9TdqioxImF7ch7uMHXXTfHuZ1FlPB9h5MQRnSNf2pFxV1MJ+NLLB7pQfxz
	 9rShetV19d8Fbc48pfqhg9qIn7YUUrwCFx+fmGkn+nr7Te9ORAWuVjnvmzWwdPq1F3gDz
	 LMCUZoe2lyBD9wfO32iTMC9xuNyvQhx3FaSY/Z73F9xWU0NxXZ5QqJDDrVLlDrnj/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778663;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ZnBMVlBZ9FA7vi+t9qEZyDr9qGdnO7eBQQiCUp2N+qs=;
	b=XLsyl+uYO9bV60Q03hvrWh8Su6/EGe8321gs5J/Dfe5mWx8Y3sZMJ35NToCs7Fk9T/CT
	 Z4iuzd7N5oho8/a4Ov4wQMqtdjpklC+yNKQT2TQ1VIQJH5KagLnUwgkyxv4ig5jzjFe+d
	 8W4rb6nv4QNJ6Hjjyy3DR+UK7NmxgHprA6n6mNgyZGaAnc2mn8F5KOD1DiqveNs9CQuyu
	 hvGleLCgBAX8Eq+OI3Z4FOFRWd+VM3+EqyGXqV97YHBGFWLOregL7aPa8Ol9pS5ru4Qzb
	 GSlWp1sJ1b40ju26uFJ3IiuxylqrY9SL7WePGICWUiW/W3ggm2D7bCp59zvFHh7L9Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfh2EDLR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A344606A32E;
	Wed,  4 Nov 2026 07:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfh2EDLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE751F000C1;
	Wed,  4 Nov 2026 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793778663;
	bh=ZnBMVlBZ9FA7vi+t9qEZyDr9qGdnO7eBQQiCUp2N+qs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lfh2EDLRAKl6CugKHqK4Nev4O1PxVPLC9pM581Xp9avVw13KEnVY7BFw8YQm/qKxD
	 zazub/AMBbFr6vMDGXMsZY3e4qhNFpeelWjx7SZOK3AP28Mt0RAeqyEkJuo3ipidQp
	 Oz/Yyvq13oCgiU3vmAbSlQfkRFAIz1/Xu+ortNqfrTdd9N4oeUnTipUkUPl4qN0k/t
	 NHAMK+AI29+U27RtoJy06mr1eStKrrfeiQj4LQSw9TeNHKEKCR8MTQUyCDGDy2Lfxt
	 zbNxg5aagJwgaQh1gtGZ2SbdPR0BKsyyAhVCyeulo6MFnHxvLYxL9DhQLEUWDJo4Ww
	 09Bngcb+Ddo9Q==
From: Leon Romanovsky <leon@kernel.org>
To: Mustafa Ismail <mustafa.ismail@intel.com>, 
 Shiraz Saleem <shiraz.saleem@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 David Hu <dhu@x6u.co>
Cc: Jacob Moroni <jmoroni@google.com>, intel-wired-lan@lists.osuosl.org, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 David Hu <xuehaohu@google.com>
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
Subject: Re: [PATCH rdma-next v4 0/6] RDMA/irdma: Add support for ioctl
Message-Id: <179377866057.1745081.14077156608414561671.b4-ty@kernel.org>
Date: Wed, 04 Nov 2026 02:51:00 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 30 Oct 2026 18:15:06 +0000, David Hu wrote:
> From: David Hu <xuehaohu@google.com>
> 
> Hello,
> 
> This patch series introduces support for uverbs ioctl queue creation
> (QP, CQ, and SRQ) in the irdma driver. This series makes progress towards
> modernizing irdma. This enables 1-step queue creation from pinned UMEMs
> and shared dma-buf heaps (system_cc_shared), providing RDMA support for
> Confidential Computing (CoCo) guest environments where memory encryption
> otherwise prevents standard host-VA-based queues from operating.
> 
> [...]

Applied, thanks!

[1/6] RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
      https://git.kernel.org/rdma/rdma/c/18dde0629b58a9
[2/6] RDMA/irdma: Register irdma UVERBS ioctl namespace
      https://git.kernel.org/rdma/rdma/c/7a69fd61897e60
[3/6] RDMA/irdma: Support UMEM attribute for QP creation
      https://git.kernel.org/rdma/rdma/c/3f68d3e1326882
[4/6] RDMA/irdma: Split CQ setup to umode and kmode
      https://git.kernel.org/rdma/rdma/c/d1d5209ec8d49e
[5/6] RDMA/irdma: Support UMEM attribute for CQ creation
      https://git.kernel.org/rdma/rdma/c/b6da1bd879f1e7
[6/6] RDMA/irdma: Support UMEM attribute for SRQ creation
      https://git.kernel.org/rdma/rdma/c/45ac42ec8a486a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


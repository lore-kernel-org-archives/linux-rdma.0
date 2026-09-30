Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552E3B637C;
	Wed, 30 Sep 2026 13:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776151; cv=none; b=iWSfGMo/l+h0+Vx6xMsh5IlvdRDuuJRndVa3lX3QarH5OTp+qGWwKL0YRiNRikh+zJ5UIYJ0j3r9jzBAgYbxabj7z8uj82SZLMExLb2X15Q2TMCPwkQRFruEwtsoCrZbjMvD04TFC2EmA6e3Mi1pFcPFsOYrMnM40GxxTQEn7o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776151; c=relaxed/simple;
	bh=tPrtiaAf10sa1nrwzT4Z8PKwBdArPhHf5SjZ/ozBosA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RTvJmbl0C7gD+3Dy3QkOvkGSt03Kvl3Z608yWoTE31winxe9MM2j1hyEWZy5FaqDUHiy5pVIxM4Rbzss3ums81Ge7/XyP+qUwDEhk5h9kfo1wiURG+7ms2h/YA89ctNKIsTK/SSyqPV1Q8QJzTrG7ggzvUnA6xt++TYt/6itCXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a09sBEWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a09sBEWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BFC1F000FF;
	Wed, 30 Sep 2026 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790776138;
	bh=xIhYxCCSYSlabBotPpPEW9l7ZjIfESVHChnu+sgse20=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=a09sBEWf1+GYq6j4jr9dpMwYBPl0dTLxB0gBkWiPep9ca06efyFRhZscOz86kOPnt
	 +JJ2MIe0oFrwoX8PKdr2VGcAOqFR32jdHHidyVOEfXERUmgrMfPp7WuvmzAPYC4BNl
	 BzMLguSaMN/9CsVViaNpYVZDEKdHjfut4BnBiWYwAV413qPNuDZX0CRaINRlw32wCV
	 DfK1LRJYuMJnhEcJNMHTjx6updeklSdDWZHH8z7yJvIciYOa9gWhwW7JtX0ACtD/0u
	 se3GxKMwVEZx3m/NAJM+acJEnd/YXXuhoghm0y8q7rVcv6r2FsCUlZYfd2g4zK7Pp0
	 64VtOJSCI0aBA==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Mustafa Ismail <mustafa.ismail@intel.com>, 
 Shiraz Saleem <shiraz.saleem@intel.com>, 
 =?utf-8?q?Nguy=E1=BB=85n_V=C4=83n_Cao_Nguy=C3=AAn?= <nguyennvc@greennode.ai>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260930-irdma-reset-fresh-qp-v1-1-065327274e2b@greennode.ai>
References: <20260930-irdma-reset-fresh-qp-v1-1-065327274e2b@greennode.ai>
Subject: Re: [PATCH rdma-rc] RDMA/irdma: Do not move a fresh RoCE QP to
 ERROR on RESET
Message-Id: <179077613532.237951.4495857187155740059.b4-ty@kernel.org>
Date: Wed, 30 Sep 2026 09:48:55 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 30 Sep 2026 14:51:42 +0700, Nguyễn Văn Cao Nguyên wrote:
> irdma_modify_qp_roce() handles IB_QPS_RESET like IB_QPS_ERR and moves
> the QP to ERROR. On a QP that was never moved to INIT, this makes the
> following RESET->INIT fail with -EINVAL, while ibv_query_qp() still
> reports RESET.
> 
> RESET->RESET is a valid transition. The Mooncake transfer engine
> resets every new QP before INIT, so it cannot connect over an E810,
> while mlx5 accepts the same sequence:
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
      https://git.kernel.org/rdma/rdma/c/6de34bfb56ad8c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


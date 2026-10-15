Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BF5304B4;
	Thu, 15 Oct 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088786; cv=none; b=Gll1oAbdaObiHVD9diT4baqLAjryyY1cwXHeLwuzJwOKvsG8p2GMgP6Sun5/ChL58Uh33neMw2wW6dAvzqMRbyx6A2iGzAIbztkM68YkkIvye04Fr7p1dELMoi07doKXeuDPwBw/f5EDGGkIggPKm2MZv99fMliJEIVTFkmvz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088786; c=relaxed/simple;
	bh=ST5BUeQLCxTzOu6nSfVVxb/ivjXazAGmY+eELSRxXTg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IKNSyJD7sGWE1JF59GdNKer+1x2egdai1ibUP9gv2kntnLPJo+VGH/hvS9S/k7xfVr0BLbq0RVKieI5bjJg1vqQBSxlVoPQYVZxZ+xe0g5wFNWz43Igg4MrjFCoBZf+hVux/YjGnnv+mR42JPW6f/r1JxhVb7iXkg/zrL6jcW08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/UtXZt0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/UtXZt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4651F000C4;
	Thu, 15 Oct 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792088783;
	bh=sadFmgl3XM69f+qJSPhZ4YzfHgMPpjdjq5tZFtz+3Xs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Z/UtXZt0ZKyseEYkkWeT/4ymtUXvZst7yIdx+67iF8e7NQBk83NAfFWC8q4WtWzDs
	 7osdULo50IbGXTz7Xdjbfv309gLZJml0yFiMQQxNTBpT0Gl9DUmxV7Cm3INLY970Xh
	 6ua9ylnyNqSqOFZSJzF+UNVp47LxlxmKiD59lNC7RY4cKXtJM0FJeiJ2DQNqTTyng3
	 N0XvjXxhLT80bRNV5i0soJqbBk3QrkXwPNHZY4hz5zmzJI1TXTT2dVMiRW2MY4mUD3
	 wxkmCa05IV/zpFokF9MeWkDUjUxmgJ8EylegELbaidWeTAsAbMREPamDTPUCX4YQOb
	 wPLPEi1U9iStw==
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 Serhat Kumral <serhatkumral1@gmail.com>
Cc: Kaike Wan <kaike.wan@intel.com>, 
 Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20261015102518.15780-1-serhatkumral1@gmail.com>
References: <20261015102518.15780-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] IB/rdmavt: Fix error unwind path for qp_priv_init() in
 rvt_create_qp()
Message-Id: <179208878077.363667.13360017652159828549.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 14:26:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 15 Oct 2026 13:25:18 +0300, Serhat Kumral wrote:
> If driver_f.qp_priv_init() fails, execution jumps to bail_rq_wq, which
> bypasses bail_qpn. Because alloc_qpn() has already succeeded at this point,
> the allocated QP number is left unreleased.
> 
> Jump to bail_qpn instead to ensure the QPN is properly freed via
> rvt_free_qpn().
> 
> [...]

Applied, thanks!

[1/1] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
      https://git.kernel.org/rdma/rdma/c/dd36137b218ad6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ED14E4C2E;
	Wed, 30 Sep 2026 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774768; cv=none; b=aUpUU4nBPLzTisGyqE5ZmFyEk0TYcUD9XDZ93pOcOb3VQvN3/u3nMFN3eaqHO264dTQ6rAhakQ5tvpXj5LWUTYK1+NUJdeHzZgJsJVij/i3MKmZTk8hLhXzftCSami/JTGIiJVes25J4zx09dTt0nmcwtNruGK5+aN+dD6wFhZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774768; c=relaxed/simple;
	bh=ZkKmodTsMq6naUDF+JbIJfuuiz3vn/IwxN2Dn7oB8Ns=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TLsH829IvYa+P4GiLCtlI51Nccfrebf4YG3EkuF/MKi2mDR/LIG//taK6gzdhjgIdgcvYoKYycG0tlWQPmiRUeH2YdiEQSmUloEws9w7J8HTmKfM/FuD9JGK4k/yuQK+qETZlSBMZIFcqFkB2SZuX7PPiWH5FNIGaAk3KtGGjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6zdYgbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6zdYgbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01391F000FF;
	Wed, 30 Sep 2026 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790774758;
	bh=tYSQ/TvZEEMbnauV+2EB8ZNPb6yU4eGGoTjNqOtauXU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=M6zdYgbterj9JY8VHUYBN7WKc91OclDHQNmBc0vENOd+ujkUf+0Cr6ffsJjoulzmd
	 5Saa86SmXfFjYQEEpX/eJLiBeZ4ZlDxZY4Jp/8jeYNa6D5fLVkQo8/nF9CQY6weaLA
	 KajvHf1rg/DXdEQxgHQAtbEkKH3J2nOuuK9EHeM5SD3EkTeljUDbt9vSj0PAggqYim
	 sOzmOQT291erqLOtSnMZ+MyEHEP8SXj8tfpba+YaloZXmXO48J2hl2H1lBC/5r4p5o
	 yT1BrzpypYzga2oTF0559QhAxD5klJFbNIzwtc4v23eySn1948lBj9Cbfic6rBWKOl
	 co0vp+4Br8Ieg==
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Jianhao Xu <jianhao.xu@seu.edu.cn>
In-Reply-To: <20260930070455.2934286-1-runyu.xiao@seu.edu.cn>
References: <20260930070455.2934286-1-runyu.xiao@seu.edu.cn>
Subject: Re: [PATCH] IB/hfi1: Shutdown self-rearming timers before freeing
Message-Id: <179077475549.237055.5128264178867848863.b4-ty@kernel.org>
Date: Wed, 30 Sep 2026 09:25:55 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 30 Sep 2026 15:04:55 +0800, Runyu Xiao wrote:
> The HFI1 receive error and synthetic counter timers rearm themselves from
> their callbacks. Their cleanup paths use timer_delete_sync(), which only
> waits for a running callback and does not prevent a concurrent or
> subsequent rearm.
> 
> Use timer_shutdown_sync() when releasing these timers. This prevents a
> callback from enqueueing either timer after cleanup begins, before the
> containing hfi1_devdata is freed.
> 
> [...]

Applied, thanks!

[1/1] IB/hfi1: Shutdown self-rearming timers before freeing
      https://git.kernel.org/rdma/rdma/c/9d3259e41ccd50

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


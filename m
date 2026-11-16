Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827345;
	b=STDD4WxbEW7v7GLI1yRLTw6nqqNeUcTUFR2BJZaPZBlaPFmw+hgdmYsc3kghwUAOQNbW
	 7pJZxSliqsrpbMQyU2HrzgMdi7yTkZE7po562MXrFMwzYeKoy7eSI+wDszI33qxM0vdG5
	 7bS4xcEw/2P5vZelB/UrdA9zUSIZgjs4SBO4dFhc62PfTrJHs9H7PGgKl4WMdt1l7yFcR
	 H1STJNSjtR/rwFdXMtdNNjr+1S3zESl1xUv0/aT73MJklwvFFCj6ZKYVYGDc41CCLGnXR
	 107hYWvZMtCh6F6X/H32uvaw4EB2GkG+2ZlqpZCjhWOEUPzYYwJVfR+VUTggLucxiiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827345;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=kaepOtWIGuJZgQh/tUXEDjaITAkWhsxyYpUqo4nzZUM=;
	b=inZW71CrtFDFtNn/NJt+NGCGPOxZj7KwrSvNOIan5oBJoTNhAeXp3LXdO7l7KSXuruL8
	 c6FWAuwmXebShGMIANIbWkGoPZGYxjz/9BdiPD2eM9tNxGQOD7Lm3vQmmGHwZwOTndQn/
	 S7dAUysj93GINeyzK14QNezq56Nw32t49m4kkcRgQn5ZHHBTvFues5IyAzbyDT6Hpeeyf
	 wdWEflKYItAMVLjlJlGCKUdYBoZDMrlEezg+VGp/8dAGSSYhyIoeNEcdronrAwYcyuIkd
	 osGPU6jLcyy2//fOD/zZyrz3iCiBxk3JQMSZ1535aWX3twJ2kZB8LvYwqnAbwD/sBlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aVZ7TH0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DE6606C129;
	Mon, 16 Nov 2026 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aVZ7TH0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2ED81F000CA;
	Mon, 16 Nov 2026 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827345;
	bh=kaepOtWIGuJZgQh/tUXEDjaITAkWhsxyYpUqo4nzZUM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aVZ7TH0WI4oS+sVfKP5GLhp32oBoB/PduBGFqgZR6HeuihCsrPlZ4v48ev7WT+S42
	 CMurhV1u8uR/fmGQQukGLjNu0Lt5I/Bz/rEnl43OGfPMUW1PA8Cxl7a8JQNUpZVEhf
	 Cg/cMUQL+zk4BgzWuMzCVA6edi2wBbN6NH+tk9xcllulRofI6xkFONnwaFkNcQxeSd
	 +/FuItRyTsxb3oc5BmJ+snfT1mPTwvYJuoGEXoDJiFQOySdNly8RaNpiyEfO1SVTjf
	 zrZPDqRCICRBg/QlNQKEj24PMOYjzVktkRfQH+4CXWYsWoSrHsrSwQcCKni/Y9z4UG
	 N0Sy6d+Qv5Dnw==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
References: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
Subject: Re: [PATCH] RDMA/srp: Fix potential fast registration list leak
Message-Id: <179482734229.1346556.15607125463238063296.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 06:09:02 -0500
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


On Wed, 11 Nov 2026 20:23:14 +0800, Guangshuo Li wrote:
> If the indirect descriptor allocation fails, srp_init_cmd_priv() returns
> without freeing the fast registration list. The failed request does not
> receive an exit_cmd_priv callback. Release the list on this error path.
> 
> This issue was found by our static analysis tool under development.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/srp: Fix potential fast registration list leak
      https://git.kernel.org/rdma/rdma/c/4ed9792fd24738

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


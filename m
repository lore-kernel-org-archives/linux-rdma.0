Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648A8DDC5;
	Sun,  5 Jul 2026 11:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783250962; cv=none; b=MTceyCFVwyz6izzXjxKzHU2+xBfHBu2YmGLJSrL/HSMzZkDIOMXsVAxC238m1EjLxfhOwuCVrMxH0zDtrKCU4qu1gMI/5/1S9Jge3mTyX/R9I6gDvU9ijWig0LC2gG3qq8vpI7cqpSNy482nvT33r6SWeWzzp7YL287xVF76Rp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783250962; c=relaxed/simple;
	bh=AnSiRn5Mz+KaE+5vfLgi26j5InO1gkSSQ+L4NikMCGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdvVCWcsdmlnQPB2zOy5wKwWmYHH0vxgjJqDR3cJZX5R3lgnPU+lzKKN9/I9P2lapIWhsN1qFKlNgtTLPylsLQQQXujDkXdG1SmlqUD4cUip8gMauLjFw2HI6O70B04SXL+Y70N0BTEXXewowUNxRzh2kGWuz+nef0Jv0XWL1vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kqefn8fc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kqefn8fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D721F000E9;
	Sun,  5 Jul 2026 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783250961;
	bh=iBRWHL1Dv4Qu26+bJrh6S9nes0enzYT8ggJ3P5MCRLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kqefn8fcKhATqEQkNd0a2laG/0F2dXy6UaPiADVUUChwPLgVaU+/y+GEirmqgcAcl
	 H3TWuMqOdrCewUngQt0K1rVXCF5x+5dJHdNWYSv1VvxDKRIJCgnb3v1HIQtZagzu76
	 HhBjKKLaCqMYQi8S2btIySyX75vNOqYlNTzZA44Y/Eht7uNqLwXBqzRfL7fW0IqPxv
	 encLgWZllK78vOAxKXxEoO/EKcG8Q3ZJZcYYa2ckXbNGQKeGkrS5Rixi0Fyn273yYN
	 c+Wv/GWNwDz9XJGBWkHj4KkyMbSNSU9FXnJzbj/HZhKqkbaSjxPwXG7qvdGSCTl5zL
	 KxuMazAqxGIaQ==
Date: Sun, 5 Jul 2026 14:29:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: zhang.yanze@zte.com.cn
Cc: jgg@ziepe.ca, julianbraha@gmail.com, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
	han.junyang@zte.com.cn, ran.ming@zte.com.cn,
	han.chengfei@zte.com.cn
Subject: Re: [PATCH rdma v2 0/2] Add ZTE DingHai Ethernet Protocol Driver for
 RDMA
Message-ID: <20260705112915.GB15188@unreal>
References: <20260626165050955lBuUhmj0yLn5xCsQ-tbx4@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626165050955lBuUhmj0yLn5xCsQ-tbx4@zte.com.cn>

On Fri, Jun 26, 2026 at 04:50:50PM +0800, zhang.yanze@zte.com.cn wrote:
> From: Yanze Zhang <zhang.yanze@zte.com.cn>
> 
> Hi maintainers and reviewers,
> 
> This is v2 of the ZTE DingHai (ZXDH) RDMA driver submission.
> Thank you Julian Braha for the review on v1.
> 
> Changes in v2:
> - Removed redundant 'depends on INFINIBAND' from Kconfig as it is already
>   wrapped by the parent if-block (Julian Braha).
> 
> The driver provides RoCEv2 support for ZTE DingHai network adapters and has
> been tested with perftest and rping utilities.
> 
> Best regards,
> Yanze Zhang
> 
> Yanze Zhang (2):
> RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol Driver for RDMA
> RDMA/zrdma: Add hardware config code and improve driver init flow

1. Split this driver into smaller patches to simplify review.
2. Remove unused defines and functions from the driver.
3. The driver must be functional. It cannot operate without a
   driver ID.
4. Please refresh your
   https://github.com/linux-rdma/rdma-core/pull/1611 PR.

Thanks

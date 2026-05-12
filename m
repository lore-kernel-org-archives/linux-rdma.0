Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3910C3839A5;
	Tue, 12 May 2026 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582327; cv=none; b=NmiNcs5ASgdeGP1KV1dMhbDR8NM6/TOgMRk8TL3tgsw+bv+pqHCRzYfUtCFLslM+XWNLXI1z6fmUj0B5jC2zhvzxBgENWB3DaSEi0//w5gQDIalGN3j67QfzAiOB1LdCAFyU4R+NSuJV5SGvmrEjeg678mZUEAxS7Ua6qTwELfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582327; c=relaxed/simple;
	bh=hCRg/CtSTdb7nBAU6P+6OBRWflMXYRVMPQh+JQ9ovuU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZQX6wHSgRNLJxk9KI6bKbnl2LrLT6+f1YUIlw4kNZTAZY1iQ4+JdoII7+prYWz0znK4TG5/tcVWtA/GVKJXgNJQPxxv6plMI52Ol0lwef7Yk5vepOQLbw7KowU6SqhAacTQYWhynZIRCh1JcXAUGH08MgBGsnrnN0yaUPdNBK+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHUFDdIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHUFDdIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC67C2BCB0;
	Tue, 12 May 2026 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582326;
	bh=hCRg/CtSTdb7nBAU6P+6OBRWflMXYRVMPQh+JQ9ovuU=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=NHUFDdIo5BP4SPROTB2K6Xz3ZBAv/nBuISx5vftKVjkauIA623xwdK17Hn1AEbtjs
	 kLxbWt+bZZnuwY8LR+Y1hqLrb217UWhWKzFxW7QC5hS+pBIqO0FnZo2ovwH3L578tW
	 FvYFAyySnknb3PhXknIik3QlEGmTBUAN+fSj8LjybggAcJ7SQX9mYe3Zh5U7gdpjP3
	 kpdfMfSMB+Cc3DCQceFLYB9dXMFoGu4RwCjPPgO6tXnHQUKoxN2M6pJoh9eVzoSCnp
	 fCVt78lgSu612XakrthZmwSGIFrRAf7uMQZgH2mBrNMfCTeH4x1vSnGZFENZ31ZWS/
	 /Xg6uSNrZVj9A==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rohit Chavan <roheetchavan@gmail.com>
In-Reply-To: <20260505075308.1754861-1-roheetchavan@gmail.com>
References: <20260505075308.1754861-1-roheetchavan@gmail.com>
Subject: Re: [PATCH] RDMA/mlx4: Use secs_to_jiffies() instead of
 open-coding
Message-Id: <177858232406.2277459.8653199587688444747.b4-ty@kernel.org>
Date: Tue, 12 May 2026 06:38:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 05 May 2026 13:23:07 +0530, Rohit Chavan wrote:
> The conversion from seconds to jiffies is currently performed by
> multiplying the value by 1000 and passing it to msecs_to_jiffies().
> 
> Use the more direct secs_to_jiffies() helper instead. This simplifies the
> code, improves readability, and avoids the manual multiplication step
> by using the dedicated kernel API.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx4: Use secs_to_jiffies() instead of open-coding
      https://git.kernel.org/rdma/rdma/c/8b2a66cb49546c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


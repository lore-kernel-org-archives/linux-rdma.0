Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795353301;
	b=X6uE03p7Py2PdJMYORV2F7vW87yzpiS09mT4DfOjJdrO167LFHFAecam1ACnV6W9Av0E
	 H3OZfmimxchbQ4ETZbolpHcqIQMU7buHOU7aBd2ZyHjc377vDCqVQF/3L583BUE+GV/qx
	 55eGHqgR2yLZzHKE3RcM3G1QraF0ARdaUkxY9kyZbSeW48wN5QvGpEFZT5BRRadbFzz01
	 WqdWScX7XGl4SDcBYuZIyn6OipD7PENzP1Xf0IRw4CfyGEuq8Shr/yiu+EH0M0bFKjlTI
	 h/ROjropzKOU2Z8BZCjDlyl0V85O6U1VIOA4mJEhS9uMpNTf4WwfO5gyAeqG3yftYvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795353301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SISesY1O9y/+oZcxuShwuyNoIlQSRIfQ8qcTbcJSWow=;
	b=n+9y0IBmJ/YdY+Dn59y8p34bvuSEbL7uBv6zUIlDuwnm7j/4u/87S8kLo3SNCML4xg/m
	 y/LXuDPSWJvfqnXfmjYa7rrBc1rI1jOwdHoXKHQ7C10idz4RTEC0xBOTvn7BDKsAbm1kK
	 8yE5urBrzknbRSml8ybSRm6127Ah0lV/kZHlHWEpzUiXmTO7QCPLAcdPFxCl5E6eW+wzw
	 d8wDoSAdNuMNqtBDTqlGUI3Yi/5r7yewczmmgoc8dlJXad7qa9Qf3jyI7CQNUpoHhqV7W
	 q0kKrh3N+nk4jK8wHeLV5PJqa0TpeJ54M9OtzKJbWv+oKcm0dcqHflrKWohLYVlNH7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0PiI5oI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC194606A336;
	Sun, 22 Nov 2026 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b0PiI5oI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763F71F000EF;
	Sun, 22 Nov 2026 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795353301;
	bh=SISesY1O9y/+oZcxuShwuyNoIlQSRIfQ8qcTbcJSWow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b0PiI5oIRQetGol/ALHQSzVkFRfMQEmTfMFOds1H02ufmYoHq0C26efs5ATLgf22W
	 PGjm6plGLsA+WYobOgEe6QOksAN4BzuZG/Zfojdu1UCHQCiaZt8RDozHgeGEROYhOH
	 ygVBm0Dc3yFFUFPVesrInuc41K55Wo7naghRUoyHCwLerRzOV8U+VF2CHzf/vWo3Ra
	 JNe6lrB9dxU34QiDmtj/zJfV1WymVW9KLleOilQbHPhaZeBFeuGwSiWvHOrKqaRTGO
	 5/yy0H6y9rfDSLYecGe1bWQHDDX9scAsMbOdsKhlQLfQLBeV6DHDXPxcjD9+8808YF
	 M4jm71hVpQ/Fw==
Date: Sun, 22 Nov 2026 15:14:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Boyer <andrew.boyer@amd.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout for
 admin queue commands
Message-ID: <20261122131456.GE14811@unreal>
References: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
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
In-Reply-To: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>

On Wed, Nov 18, 2026 at 09:57:52PM +0000, Nikhil P. Rao wrote:
> Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
> firmware can take more than 2 seconds to service a device or admin
> queue request, and is only expected to complete it within the ionic
> command timeout of 5 seconds. The RDMA admin queue watchdog gives up
> after 2 seconds, and a timeout resets the RDMA LIF, after which every
> verb fails with -ENODEV. Wait 5 seconds, as ionic does for its own
> admin queue.

Is this a real, user-visible bug, or merely a nice-to-have improvement?

Thanks

> 
> Fixes: f3bdbd42702c ("RDMA/ionic: Create device queues to support admin operations")
> Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
> ---
>  drivers/infiniband/hw/ionic/ionic_admin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
> index 0ccd869ad8e6..859893568538 100644
> --- a/drivers/infiniband/hw/ionic/ionic_admin.c
> +++ b/drivers/infiniband/hw/ionic/ionic_admin.c
> @@ -19,7 +19,7 @@
>  #define IONIC_ADMIN_BUSY_RETRY_MS	1
>  
>  /* admin queue will be considered failed if a command takes longer */
> -#define IONIC_ADMIN_TIMEOUT	(HZ * 2)
> +#define IONIC_ADMIN_TIMEOUT	(HZ * 5)
>  #define IONIC_ADMIN_WARN	(HZ / 8)
>  
>  /* will poll for admin cq to tolerate and report from missed event */
> 
> ---
> base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
> change-id: 20261118-b4-ionic-rdma-admin-timeout-3cc9f4afe247
> 
> Best regards,
> --  
> Nikhil P. Rao <nikhil.rao@amd.com>
> 

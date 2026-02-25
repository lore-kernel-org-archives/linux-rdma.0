Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AE424DCF9
	for <linux-rdma@vger.kernel.org>; Wed, 25 Feb 2026 11:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018560; cv=none; b=FyzGEF2Gkm4o4JdkuMQj+754fl51BtPwK3xAlHo2VJl40LeYS4KN0PoQmUz7mVDOL3Vh1Ekhw5MPAv0AP0NlW61PCbWcQYDQN2M+DzwPQp0XRHXtpCj4nwARy9XJaf9IxYOTSVPdlOcDm7pVXFVlpfZSLtVKKeTamo+RfOv/7+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018560; c=relaxed/simple;
	bh=axRPWJkvFCtVyB01RB3oKGz5+rlBMJ0yTnEU/6KOcJs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=to6UGxt3Mkced0odSolZCn8Av/mS416DpYQqzzf7ZIIPtZ+tW/uPz4JFiTUOiJo823uJAYNK/bur4NcUOEEJU1+4xjlkCoDxFjHU8e/vcAepJK/EVxBAkxApyUtnZ3DU/Bcn0HFWhVQXqFpX4aDslw+YN3W+psXVPQh7tUchd1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VebRy3Ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VebRy3Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D4DC116D0;
	Wed, 25 Feb 2026 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772018560;
	bh=axRPWJkvFCtVyB01RB3oKGz5+rlBMJ0yTnEU/6KOcJs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VebRy3Kilx0JZrToXG9Mpf3OpfCOHambM9bsSutEvDRq12rciabkz3GGtvrtSJWCU
	 rIT+CFUct+ATnxUP2e94sOuAEcSahQgxM3HsZtRD7dUrzmO0Me68PJQPQLh/+lhmcs
	 MXLr+rnDU+pC4IlJw+WwEbU8GRsHdJZiNLZ68nzZRmkpX6S/1NPSxiFZKwACsFGMZT
	 ebrJsd2Vq5F7lZaRDoRSZjGxb8QWH53W5UOE+32zuaAqpafDQC+D7WEKq1/UTiKkpO
	 vTDjC2B4ZN+GYwijhr3TZb629awi7LrQc/U6KdLqCTB1JKqX0DRI0vPyPVXh5euG2p
	 LNDiMooRs/cFg==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: mrgolin@amazon.com, sleybo@amazon.com, matua@amazon.com, 
 gal.pressman@linux.dev
In-Reply-To: <20260217112304.36849-1-ynachum@amazon.com>
References: <20260217112304.36849-1-ynachum@amazon.com>
Subject: Re: [PATCH for-next v3 0/3] RDMA/efa: Expose extended max inline
 buffer size
Message-Id: <177201855699.15725.2276774488803304663.b4-ty@kernel.org>
Date: Wed, 25 Feb 2026 06:22:36 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 17 Feb 2026 11:23:01 +0000, Yonatan Nachum wrote:
> Changelog:
> v3:
>  * Use right enum value for new device query.
> v2: https://lore.kernel.org/all/20260216133351.14896-1-ynachum@amazon.com/
>  * Added patch 3 to use the extended inline buffer size for validation
>    in QP creation.
> v1: https://lore.kernel.org/all/20260215120451.18053-1-ynachum@amazon.com/
> 
> [...]

Applied, thanks!

[1/3] RDMA/efa: Rename admin queue attributes struct name for extendability
      https://git.kernel.org/rdma/rdma/c/6b8d5a0cdb1961
[2/3] RDMA/efa: Expose new extended max inline buff size
      https://git.kernel.org/rdma/rdma/c/e736a223ab1506
[3/3] RDMA/efa: Use extended inline buff size for inline validation
      https://git.kernel.org/rdma/rdma/c/d1fc91be263d0a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


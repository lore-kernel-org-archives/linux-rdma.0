Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769D30F55F;
	Sat, 12 Sep 2026 01:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176310; cv=none; b=Zvi3FSNDVT7LWMZ+7VFzMBCE4C29prPTE6xiY2ee/vkRHJ1ChvknmvZynANEES+qGgP+bMkVwUi8Ebo0ch12PWPATIG9+VgDqwe2t4ROPD/Cypl9LOIuGjSfzF16KF23iXOoIvov8esDenOsEUlK57viHtvdss9B5htXR6g/cY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176310; c=relaxed/simple;
	bh=3vL79JzL59vDO/rso4nIkVM2a/5e+EkjCi+I2jIcYAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVInm+kkgADpBDpbAyVyFN7w1Ftg0LAuM1tfUShrkY85vkTQsemROQLDBjCpR0HIGiRbXAUiwpdG3flpJAI1XpwvWNtsdazeHfiWxwSyzHR3q0MlL4klsxov6PP3vnVFCn7Vf/Jytb+qNgnSasbDe2krpq/BlUZKAL2MVMkbd6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1lWadE3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1lWadE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C65F1F000FF;
	Sat, 12 Sep 2026 01:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789176309;
	bh=JmF1Bp9931VSThbLGEpfXE5S1nsVlVxel+t8Dt046Qs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n1lWadE34DPZmHBiE/mWVsCvahcsho/7F0S2liVll+j8Q+J5QFo8gYwOUqGkzOT59
	 v3PLQtkeWjspKTKjOfy4uzSx4rfoQmTBLsPDxj+8K6sA68L7CvrBd0Y+LuEW1ZhNJA
	 CPql48UophTbPJSLbLvtKP4kTqOH6Yy1BkctvjRhdLkDeiX6pvHXi0k2yc1UB4IZsL
	 742RR1vq7W+jFWryarokwR/TFgJPWvFg95dcxLvDzaGmDe/Lc0PFw+fRstkIth47Wn
	 WK/muTT3lkVe2uFIsgXoWE35CcypmzxHrLc4hzb5AWvYPEpPqQj2Hj4O/zjjr6ZAPS
	 aoo2gKdJivmhw==
Date: Fri, 11 Sep 2026 18:25:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com,
 doruk@0sec.ai, dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com,
 kees@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com,
 rrameshbabu@nvidia.com, saeedm@nvidia.com, shuah@kernel.org,
 skhan@linuxfoundation.org, horms@kernel.org, willemb@google.com,
 willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net-next V4 01/14] net/mlx5e: Generalize TC <-> IPsec
 mutual exclusion
Message-ID: <20260911182507.0f1e28e4@kernel.org>
In-Reply-To: <178907726586.219967.4695695146458742597@kernel.org>
References: <20260908065244.3799142-2-tariqt@nvidia.com>
	<178907726586.219967.4695695146458742597@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 21:54:25 +0000 netdev-bot+sashiko@kernel.org wrote:
> Pre-existing issues:
> - [High] offload_block.num_accel is leaked on the driver's own flow-
>   teardown path, permanently blocking all accel offload on the device.

Does this one need to be fixed in net first ?

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046058;
	b=TEVf4NB7IHGJTUxfiq4gXc4U4qjqibXBHiPxG7/6Fdr6mYwOoa4Y/PBFVtLJRZL5GMBx
	 vBPcLA5TygpwI5hYV9EiNsGvY/mBsxbylUQUPrCWP5dZddKj9Etm98MtXfBsSmgQniwjF
	 8A6+H8ozn9dOGuDI0VZGxxJiClhsrMi5dtO54fxW74G0DJ6hxV1aB0AUGQJxY7MD7Yat+
	 oorbuLTSmIgrjMSaeow7RYIC5/J6bZexFttcLTMpZlxSvKM1yJFDbvG33XGtcXPu89j1J
	 QJb7bOer+5dez/m1rBrmZVWWxF/YUaf2WX+kZMacyZz7U4q2em2wSuxxFmHxQSTs5Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046058;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=C3YpwYz9Ogx6umnciIxcL7ODZ/4uA+WWQLJVz+8MopA=;
	b=c0wYy1gBULeJXXFASlceCvpb14zebatbNpUKNjfsqtGmEmfQbgJiR2KQpAeyPH7Xfghx
	 Zjs36uvsDaswQ/GHwKeu7m9hLrdjJbZrm1pxmxce/aEkzuPY/NFOeHx2VHodgS7Elupvd
	 YRoV3sT/oUMeJwc5Rwf/9wuREHWGOEqUEEUbT+yoOjisIYbG+xAXdbyAm0TVMI4PDzdZD
	 CGfq5WHR5cxMz7e+2Oov936ReCZaoy241tBx08EMXDPdEZxNPBUiYI5UTNqKs0YL6EA/t
	 tWYwKwttKtk1+EJmDfc1aEk6quSq97XfBRSqKT6Oh3++6HAA6ZZKO46UsRd6Wf/FqMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X12h/dA5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8FA606A31C;
	Wed, 18 Nov 2026 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X12h/dA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4851F000C4;
	Wed, 18 Nov 2026 23:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795046057;
	bh=C3YpwYz9Ogx6umnciIxcL7ODZ/4uA+WWQLJVz+8MopA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X12h/dA5ascEyGb+a0dUAUBMzImtp7CsQkd2dh9aE/gxSJByju4n50hH+U91ALmEY
	 G42Qe3KxTxec+zqrpimHpvhtaF/PvYjJ7R4abScwtOqPOUIfk6V5FvMt3LK8zu8yB7
	 5VLx+HeWaTz7+JSulB9UCznyDVC3c5+4Hk+ibVOG9VY4UQ1stDU4ZaxviQPQxNjVIX
	 q2yuq/2GVSsrY9w8QUzTKjpG4G3edis3cuUjMzlYvO0idNqE6wuOjYXzR7nRMhM/ki
	 H1E0izh2Sq/69x+vluu8z52532A2unsGPfOf7CoDIQwpu1Sy8723dXet0TB1IaUGEq
	 T2WrOSE8p4XNQ==
Date: Wed, 18 Nov 2026 15:54:16 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: hexlabsecurity@proton.me, Mahanta Jambigi <mjambigi@linux.ibm.com>, Dust
 Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, "D.
 Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond
 <sidraya@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, Wenjia Zhang
 <wenjia@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Wen Gu
 <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, Simon Horman
 <horms@kernel.org>, Guangguan Wang <guangguan.wang@linux.alibaba.com>,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Hidayath Khan
 <hidayath@linux.ibm.com>
Subject: Re: [PATCH net v9 0/6] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <20261118155416.057f62ed@kernel.org>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Nov 2026 07:59:34 -0500 Bryam Vargas via B4 Relay wrote:
> Subject: [PATCH net v9 0/6] net/smc: bound wire-controlled CDC cursors against the local buffers

Please slow down, as a newcomer you're not supposed to have more than 8
patches outsending for review per tree. You are also supposed to answer
the AI feedback, and mark the patches as no longer applicable if you
plan to respin. Which I expect you will here given multiple high
severity issues
-- 
pw-bot: cr

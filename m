Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD157DA66;
	Tue, 15 Sep 2026 00:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433447; cv=none; b=eZpIbfoI0U4M/6Cu8yRCtdts7RRQ1+USceKTzu4r6/5bFajoU7JlVlAsJLge7XNKaVB80R1MRdFmN7PIhZRf82VOYkZEEiQg7gx6MTf5Ck8rwj5VqaWhii0l/nNWMNHUvE9DeEpeoARSUD2gcldWiYXHqBau1OWy9cFDK6+6a1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433447; c=relaxed/simple;
	bh=glZbkAdzl9o/gebqVbiu60g6TjSA0qLnpnPl0k4Tdr8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iHsk5tTTQZBFAWSaQW14vQSMWD1QzJZrRrX5rOukqvqXUcIKFmw631BqHq+x/+Gq5EG12oxr/oLxSUYW9qlMwTCYTWUkU6SQnFMQtFGnsxqjxF+5iqTyFsCgFxhx8Zh/XhzaO10+mm/waIEPBmDMLbY1SSugSSpuayd61osgLRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoKOt/9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoKOt/9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409C41F000FF;
	Tue, 15 Sep 2026 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789433446;
	bh=hiV219awBMXe3c+mWXpo87nzhG5UGhkydX5AfC45tws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aoKOt/9akz4JmfR70qnvBMs700iqTLTMkLJ5okFvYJkPZl8ry3HBIwusroQW+EYvE
	 kcN7PmHxTeBt5K2heJSduYvpiZ5N91hzgFyVMeSOuK4FFElHbGcrk+Z+g2925+tcuR
	 xzg/HG7PuRbAATUusPb7f3vInT/d0BIA5Ddl+984/vcyq5pJZY96A2yeSXeLiKD5x+
	 hFH/LDLwckH5nkDUUApZ2OEcV5Nhp7aX2s0HzR0u3rhWXJAMKrHcreXIOrntgXugCo
	 fD/O2eInxmAPC4Abe1mv0L5bVXJxvhrQoyIR/ZG+HpFkj2tYbimFWMcPAOhG02Mufk
	 X67okzxcDqAZQ==
Date: Mon, 14 Sep 2026 17:50:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Long Li <longli@kernel.org>, Konstantin Taranov
 <kotaranov@microsoft.com>, "David S . Miller" <davem@davemloft.net>, Paolo
 Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "K . Y .
 Srinivasan" <kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, shradhagupta@linux.microsoft.com, Simon Horman
 <horms@kernel.org>, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/4] net: mana: give each HWC message slot
 its own completion state
Message-ID: <20260914175044.2a26bb46@kernel.org>
In-Reply-To: <20260908035201.402424-3-longli@microsoft.com>
References: <20260908035201.402424-1-longli@microsoft.com>
	<20260908035201.402424-3-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  7 Sep 2026 20:51:56 -0700 Long Li wrote:
> +	status = ctx->status_code;
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +	hwc_ctx_put(hwc, ctx);
> +
> +check_status:
> +	if (err)
> +		goto done;
>  
> -	if (ctx->status_code && ctx->status_code != GDMA_STATUS_MORE_ENTRIES) {
> -		if (ctx->status_code == GDMA_STATUS_CMD_UNSUPPORTED) {
> +	if (status && status != GDMA_STATUS_MORE_ENTRIES) {

Please don't use goto to jump around functions.
This code needs to be refactored.
So does patch 4 at a glance.

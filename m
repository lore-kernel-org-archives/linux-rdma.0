Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777B432BD3;
	Thu, 16 Jul 2026 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212061; cv=none; b=bn4i4zbGiGSn1dGmfu+S3NEpk5wfmRfRN3XX+f64VELpRWKRG8v4THmoExTbQ/B/N5uh4wAEtTfa9IGJsUFxAvMIEl96F4zPjdx2QNlZa4j+QBKco7KW3YwSQ0cW/84miI6reiTLSYUD8sN6nRXgUM8u0WzZTp7pEulx6gWPDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212061; c=relaxed/simple;
	bh=0gJBTczmpmWFR+0rYkNAd0Rz9dzhAWX0o/hIpULzmCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=antbjD7xC8Demj3EXK1Wgqh4adivI5l2KRyEzadgIyhynL+3EqDxpuIVLjvcI8g0pxRoh8Orvh+34vOyc2Lvrgm8+1xrhbmvQzKqdRE/cPXW9PgFyH+HlY8cNw1nH5oT15PtJYno5zN5z0W7QV3IfgynWnW3KagNvGlpBGwj5lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lglD5EKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lglD5EKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D206E1F000E9;
	Thu, 16 Jul 2026 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784212060;
	bh=ZFIDYm55M3Veb0MUxUqI8ilXNjUSkEp3G2f9uAGfdsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lglD5EKop3xI1KvqwKHAEKUvmGfpO73DbkPY157lY2Fbb5mAwujxYu00t+Znr+Usa
	 UzfK2fwJWXPcVQW/xKqnpNIypYuqVyocp3y0hgH/ra90WUrwvqax+XuBClwiBH2ghv
	 bZoqhtk/OnR2knsLP/v0hX9nV/qzfSULHHQu6W8sEY0qD8WRUp15tg0SWCefacfEKc
	 ee34Egwi+OZaOrtClpxQO+eTPyXTdOEhxwU36Ek1B13Mkt4a+e1TNH1Sd4f+enFo+3
	 x8n4nIX8YxqDYYShHW11e2ORjVCIWlqLmvw4gN5A21KRFZDh9FsHrjBiXTmJf9RAAi
	 nYlFMvKsRk7yw==
Date: Thu, 16 Jul 2026 15:27:34 +0100
From: Simon Horman <horms@kernel.org>
To: Aditya Garg <gargaditya@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	ernis@linux.microsoft.com, dipayanroy@linux.microsoft.com,
	ssengar@linux.microsoft.com, gargaditya@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add debug knob to skip TX timeout
 recovery reset
Message-ID: <20260716142734.GL95246@horms.kernel.org>
References: <20260710132229.2851441-1-gargaditya@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710132229.2851441-1-gargaditya@linux.microsoft.com>

On Fri, Jul 10, 2026 at 06:22:29AM -0700, Aditya Garg wrote:
> Add a per-port debugfs boolean "tx_timeout_skip_reset" that, when
> enabled, makes mana_tx_timeout() log the TX timeout and return without
> queueing the per-port detach/attach recovery work.
> 
> This is a debug-only aid for bringup and qualification: skipping the
> recovery reset keeps the device and queue state intact so a TX timeout
> can be correlated with hardware telemetry. The knob defaults to false,
> so production recovery behaviour is unchanged.
> 
> Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>

Reviewed-by: Simon Horman <horms@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE33DAAB9;
	Sun, 18 Oct 2026 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792326922; cv=none; b=n94WwbhTibFDOr213OL7rF1YTgh3eS0rLcM3CVEKxVng9bF4czbCjGMN50t+FsxhSJjMEgnfT9x11krn+ympEIYQZ6KUbi07VpmS3Bl+21YkMTw3N/hXVZAUT//knXN60XI72r4HUvqaPrZ/VSgSRznCKCYLlih0pH52puC4Sz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792326922; c=relaxed/simple;
	bh=Tk6fSf6VC//cgaYsAOTP5zu4p9jY1xX6q3jPZfcN20g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3mVOJOw7gGk3g7HLjaIQ68LPONuZeKrBovtUwinjfC0G2/NBggscx9e6d25gfDl7vHuVei8Z/YGRg9IndzNurLNjEdzJWZY2hxzy6RM4rLT29NQa4nb/song1R2scyC/dcu+r4Zgrjv4J2ai2KsJsBFmmkrgVC7LzB0OU6J/cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/TQNYXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/TQNYXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E50A1F000C5;
	Sun, 18 Oct 2026 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792326920;
	bh=zxY+jnuszN6Gi8YXmVZRdY2Gy8q5uxVokWAXww2xgCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/TQNYXb5k8QgXkB600ume6kDzxLI2G6CCbDG0dOFHcYv877vhsjDdTKxKXwXO889
	 EmRgYpwlw7NY45XQ1MJMZW4qQI9upZgzyatvk/W30R/hnuUWrrPA48YX1QOT9Wzm9x
	 FA986qgx1Ua3WBKh20EX6TBC1GtZem9V/AjuTb46llfCKEAycCInZkFexYeImtfZyo
	 qM4MsPWwij5XlV6VjYHJ2zU6N/i6ydBwNHC5bAGGM5ZGdn4dqpTY5Ae5WEAyfzFJ3F
	 NXYqiiXbqoOx2/7PPhJ2SQM+YWlFW8UlwbeZa7HpPcBtctZP7N5DxCnI9yby28woAc
	 cFp9m5MYd1jyA==
Date: Sun, 18 Oct 2026 15:35:17 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	andrew+netdev@lunn.ch, jgg@ziepe.ca, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com,
	shradhagupta@linux.microsoft.com, horms@kernel.org,
	ernis@linux.microsoft.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net,
	hawk@kernel.org, ast@kernel.org, john.fastabend@gmail.com,
	weh@microsoft.com, edumazet@kernel.org
Subject: Re: [PATCH net-next v7 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20261018123517.GD64621@unreal>
References: <cover.1791710735.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791710735.git.weh@linux.microsoft.com>

On Fri, Oct 16, 2026 at 03:38:33PM +0000, Wei Hu wrote:

<...>

>  drivers/infiniband/hw/mana/cq.c               |    3 +-

The RDMA changes are negligible.

Thanks,
Acked-by: Leon Romanovsky <leon@kernel.org>

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB54548EC8B;
	Thu,  8 Oct 2026 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791487259; cv=none; b=Uqfa8yA1jNzOhjDfnwB4xfoZf1TmFiDwFFjIJWIScwmbb9YWv6tqVIfml9ziQEWZ2h+c0xMfqt/4OA2lTeGrQDNrIunjCzOgkoqd5kOoG0xZKEJi0RshFO5AQklHb7plAhJbqav6+LE3QgMzMvy7yM2Uhnw3GakkmXWEZqBAql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791487259; c=relaxed/simple;
	bh=mbvsrsVUKtCafdQ3QvuCGcItv30vrU227ABhEONtLaE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvwNDIgEwjivqqTfkAUv2L5fnHbvAMgOiQA/5gR7k7wwiH1z7yyWh2JkimaAQXNmyvxzBfA9io+MSHWpAz/5kSdaY8NH0wkA1TVNqG+BA8CVWlwva9YCbk4hOkLON2f+rDmOTZ1H2up+HoT+mSr8E73L4wYp1TMfl+SQSAnspNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEs1WpNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEs1WpNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D955F1F000FF;
	Thu,  8 Oct 2026 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791487258;
	bh=rpVKMjFu1azIBxdVZStpnRGBIUPwp58FEAbhEAmTZTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hEs1WpNMzlN7zQQhTNb+7VsMK6Jitkk1glEjCKdqRKxqGDAKhHImz9B7abxDWMV+h
	 i6uLMi8JjLwN0oH0WXPn0A8KW2POq8nN9lAt/up5w9J7aKjUmlQvUQcGlhDnADQ0fc
	 c8MrAbQS19vYhjdij6go4xdHl3JioC2pHJcUB4jLHWS4pE3TGvUmh2BwhV++B8iqXV
	 kQ3msea3dYnQ2KBhz3kYSTWnUAVpOrzTzUGhSQDXSn8Ss49XMN/T2FqSy3c9Ar1yCz
	 C4Mx5DoUH5hw9KmfoeTikVBjeJoXu2ZSt6fGpPfk4ojo495ZrNU/u/s2/fLq71Nl3a
	 Pru0AhDi8xc/A==
Date: Thu, 8 Oct 2026 12:20:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: netdev-bot+sashiko@kernel.org, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, netdev@vger.kernel.org,
 pabeni@redhat.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, roman.gushchin@linux.dev
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
Message-ID: <20261008122057.6314bba8@kernel.org>
In-Reply-To: <3b650188-f8f1-4d73-bde7-5ca877a9dfe9@nvidia.com>
References: <20261004070246.215239-1-tariqt@nvidia.com>
	<179118614831.434549.13938965801473464638@kernel.org>
	<20261008094847.46b9b72f@kernel.org>
	<3b650188-f8f1-4d73-bde7-5ca877a9dfe9@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Oct 2026 20:41:16 +0300 Tariq Toukan wrote:
> We received 3 different emails from Sashiko bots for this single patch.
> Or replied to a similar issue in another Sashiko mail, but now I see it 
> wasn't the netdev one.
> 
> Anyway, sorry for the delay.

Ugh, this is so annoying. The main sashiko instance insists on trimming
the CC list, so we didn't see the Sashiko.dev email or Or's reply :(
The trimming is really hugely silly, netdev patches are very often
cross-posted to other MLs.

Roman, our instance has been using the full CC list form months now
and I haven't received a single complaint (well, I have, but about 
the format of the reply and its metadata, not the CC list). Please
reconsider?

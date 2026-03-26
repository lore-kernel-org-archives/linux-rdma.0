Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D72B21B9DA;
	Thu, 26 Mar 2026 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774512628; cv=none; b=ke1aLHHlHrPsEGgiT5iYYHUG5M6d4u9Wd/1vTJJRasVQOmdT49T03dAmMKgo/HnTmjF51pQ5JgCcGk5CKe1HdBFxhZdjIbdyInqTRLdCBXtT9eRBDTJ3YBQClhMKNjYR9hVJ1B9rXjvVCqDEH8YKeYR663FPRhbQYHz3/hLUpag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774512628; c=relaxed/simple;
	bh=xfFEKv17loP30SrC7cWhhtbDnFkWd+C91A7IeKhYo0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xx3uMWC4gMqqm50GQInAxkXtWzz4WsWTlBYqrxJhNKEUGZPQn0c0wfqOsqhrY6ERu1KEOwiYBLpitBQsjN0st66PljdvASaZog0UJuUdAqZoSjyfLxclqVEpOzlWb0L7tH+BpWpoLnBPALa4OyQUs5FpyEkO7HA6pev0mENjniQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dtcG/SBG; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dtcG/SBG"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id A4AC94E42802;
	Thu, 26 Mar 2026 08:10:24 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 74FF45FDEB;
	Thu, 26 Mar 2026 08:10:24 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 94DC810451A91;
	Thu, 26 Mar 2026 09:10:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774512623; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=tplubauM5XPYH1+NwHZU2eW2Vvb2T+VFr9o7tSiEOdk=;
	b=dtcG/SBGJQnIUb6YKGEo2CLWWx+Xa/vJblinzgN14Ce3kNXAWHxUawqPFmJ2s6ns+asCxQ
	AxGLt1CsbAvtcwJVLp+IhAXM28dTj5l2gXjkSZ3YQ2+TSzstWFr67XrQycvUnJ9cOgbDL2
	YcaeRxpgkoq3SWq9fRqZ2LjJCkDKSK8PEupTL2ZFnZxJQ2KOF+kFpL9iOcSn8qfxV+/a3P
	ZBssIWJKcxPXsxj97BR/Sc2mbmKWRzwnasxnyAmDBpUcjZBGaJRDgwLtOiBoS33OG/YnvM
	9aHazLS/P7PEDTG4Wv78V44ZELuBW0YmDCYEJmoz4uGav5aHR0RPprO4RRMubA==
Message-ID: <2859dddf-a7b7-46f8-b97d-45d8be242cde@bootlin.com>
Date: Thu, 26 Mar 2026 09:10:13 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 03/12] ethtool: Add loopback netlink UAPI
 definitions
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Donald Hunter
 <donald.hunter@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Naveen Mamindlapalli
 <naveenm@marvell.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>
Cc: Danielle Ratson <danieller@nvidia.com>,
 Hariprasad Kelam <hkelam@marvell.com>, Ido Schimmel <idosch@nvidia.com>,
 Kory Maincent <kory.maincent@bootlin.com>, Leon Romanovsky
 <leon@kernel.org>, Michael Chan <michael.chan@broadcom.com>,
 Oleksij Rempel <o.rempel@pengutronix.de>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20260325145022.2607545-1-bjorn@kernel.org>
 <20260325145022.2607545-4-bjorn@kernel.org>
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Content-Language: en-US
In-Reply-To: <20260325145022.2607545-4-bjorn@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Björn,

On 25/03/2026 15:50, Björn Töpel wrote:
> Add the netlink YAML spec and auto-generated UAPI header for a unified
> loopback interface covering MAC, PHY, and pluggable module components.
> 
> Each loopback point is described by a nested entry attribute

Is the nest actually needed ? if everything is under the nest, you might
as well just drop it and return all the attributes directly ?

Maxime

> containing:
> 
>  - component  where in the path (MAC, PHY, MODULE)
>  - name       subsystem label, e.g. "cmis-host" or "cmis-media"
>  - id         optional instance selector (e.g. PHY id, port id)
>  - depth      ordering index within a component (0 = first/only)
>  - supported  bitmask of supported directions
>  - direction  LOCAL, REMOTE, or 0 (disabled)
> 
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
>

Maxime

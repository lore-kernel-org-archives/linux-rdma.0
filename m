Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DF374192;
	Fri, 17 Jul 2026 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784311188; cv=none; b=bzk06AGoT8jPk4aG67C/Tt8arGN7qWOkRQk4pVtZ/NElmNwqTxX2RVQKIHcbS6s7a3JK6/RaCPGm6xZSjUuzWo8yhMIORzpqeGjwhmai0kEzLPSiUiinQADqTSzRRmr56TAJZDymfnuHu+kmvuYE2wMvBviV9iIRT6OycxQQH+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784311188; c=relaxed/simple;
	bh=XAvQ9ZYz+dZ+4urxFQKBgI5vRPMIn06ibceXBGvbyhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PNjKAARIY12aEE7WNDkProhvnQmy7pZQp/DoiqGDK8SuF+byqDkCuaSzd+K2QgdCOS+Iw8O1DSVh0UpIRlo+lGpp9C4inzj4e0r80yM9BD/Z2wkEDtKkFJE+S34+2T6cmrX64iq4SUy6pEAOV8r9EnSN63ETHz79vfaXPl85fms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SHVwOixn; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SHVwOixn"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1yNX13qCzlh2yx;
	Fri, 17 Jul 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784311177; x=1786903178; bh=MNVE+tHrogf4IgrRA90UVCEw
	un1g5X8wCM6Q2Scep7A=; b=SHVwOixnly8OZ4hnGQmNieTB2BoRTiU18ib8sJUa
	Tgd/AyY/fSr3clTUZId4b5xRunG7pIas9uvJvv+s4n9O2qFOT/78gO1QRvPNUSpM
	D5J6g8RepbY9Y9+6TW4J+G1pJwgMumNgAa9mR34g61HI1Cy6UZlTW5ZPeulqlqAb
	PcPaOA9tBajiMw+AJ7+XQZWvWRtqJSfX4Cf47ETZPH7H8GJMiYuqQW7VcnAshFqJ
	vt3oX5CMEx8We9QlWFItdLFvWlsvehLXPYsnpmOt5lS6optZvx+jkntX8xe8+cbn
	WIinwfbTZW07r7DObp2VV3vMVe5OcxINXVTqHONzLxBbzA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pPRsK0Ep_4YA; Fri, 17 Jul 2026 17:59:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1yNS0FB5zlh2r8;
	Fri, 17 Jul 2026 17:59:35 +0000 (UTC)
Message-ID: <9f5875f8-2ab0-4272-a8a3-d6cf711978b5@acm.org>
Date: Fri, 17 Jul 2026 10:59:35 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [QUESTION] RDMA/srpt: is target_send_busy() safe before
 target_init_cmd()?
To: kensanya@163.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org
References: <20260717025402.64054-1-kensanya@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260717025402.64054-1-kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 7:54 PM, kensanya@163.com wrote:
> 1. Is calling target_send_busy() before target_init_cmd() intentional /
>     known-safe?

I think that's a bug.

> 2. If not, should ib_srpt.c send a fabric-local SRP_RSP BUSY (or otherwise
>     free the send ioctx) when se_tfo is unset, and keep target_send_busy()
>     only for the post-init failure path?

How about swapping the order of the target_init_cmd() and
srp_get_desc_tbl() calls and initializing .data_length and 
.data_direction after the srp_get_desc_tbl() call?

Thanks,

Bart.

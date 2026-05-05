Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDB3EF0DA;
	Tue,  5 May 2026 08:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969208; cv=none; b=eGFSS4X+wXbVcgiMAbnjEZIit4+urx/fZ+mlmq8hOxgsYT0Cwdx6HiG/YG9O2vU4/4LCcYITTmGD09yRgJJRA43RYoLth3fT+7PiYi2KM2273EapH+8ppJQwW5VvObaOZMDpkZC4hKIpQ4vZ7woupcgBkl/1YBMqkBFDrEW6aI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969208; c=relaxed/simple;
	bh=o9I8R4ykhawPwL7TUfA7kqPV2OOTYA6gQ/zyz+O0Udg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WonVOfRcLIhrk8mPoLf4knLgv3gIf6sf/3NFEYkALXR20Qp6R/6lrwjb5BEDWvjOBwS9Py1/PzZ1x+pI05dAQjztp9MCVzFrtGtdUVWVlxy6iTfXlCBEEYwZ+79jV5EJA0mL7R/Fk4AwUfBNQXTwl4QeWmZl841e3GiVaY0mYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QmeTUJjA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QmeTUJjA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g8rzS698zz1XM6JG;
	Tue,  5 May 2026 08:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777969201; x=1780561202; bh=x1/xhG5InhxqNp2gmwf7KwSF
	7yoc52gdNUL64u114kY=; b=QmeTUJjAdOkY2nI8DYRk2wrKstUxKjq+Ojp+UAeu
	i2OwSWR0mVVIMqA8fpyNonGO9hfuV9wlXu23GQRQS3BIP/Rmh2brqvSa7yAf56Fr
	STf4OTJxboGBMIe6BiONjvXyk+eAFPXdK8DyNbIRR8D3evvtFCZR2gRhzoS/3HS7
	SXeVLsgC++SMnm5o25eLxHlUYmtqtMpCYtx0TsEnoj/hlkSZo3qFMeLcsoz/Dwpx
	xUTK53PNK50JiP0R6y6cFBBpaXv54zSbv7dZdGcCvrkNzZNl1aTtMvbBukHRW0bJ
	SPxENoHyomtSGybG2JI2uapnYdGV81/46YgPhZdvLpkHRw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vFlzf1RHxyJo; Tue,  5 May 2026 08:20:01 +0000 (UTC)
Received: from [10.211.9.52] (unknown [213.147.98.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g8rzK3Hyjz1XM5kD;
	Tue,  5 May 2026 08:19:56 +0000 (UTC)
Message-ID: <ef60eb35-deb8-4703-bcdf-0a2cf26de45d@acm.org>
Date: Tue, 5 May 2026 10:19:54 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srpt: fix integer overflow in immediate data length
 check
To: Sara Venkatesh <sarajvenkatesh@gmail.com>, jgg@ziepe.ca
Cc: leon@kernel.org, dledford@redhat.com, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 carlos.bilbao@kernel.org
References: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 10:00 AM, Sara Venkatesh wrote:
> imm_buf->len is a user-controlled uint32_t received from the network.
> Adding it to imm_data_offset without overflow checking allows a
> malicious initiator to send len=0xFFFFFFFF, causing req_size to wrap
> around to a small value, bypassing the bounds check, and subsequently
> passing a ~4GB length to sg_init_one().
> 
> Use check_add_overflow() to detect wrapping before the comparison.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

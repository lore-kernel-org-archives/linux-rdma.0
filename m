Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828244399EC;
	Wed, 22 Jul 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784743820; cv=none; b=isVREfzHxiiT/uPaPIbIl3nt9Z3xV/vX3k6xLqCIWtl2xIkVeGHRvkYwlQpZWNf3V9k4OXxeW9zThbGzixtpvLv6pozdIJi+f8hm94Gppbr8/JxkEsAluISIJ6vCMSwghShhuF/aH55UY2D4T6sjsq9rFN3CYLe5n8vmRgjJFPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784743820; c=relaxed/simple;
	bh=2Jsvod3GMh/rFXKIs9yWSJlr9g99E7uyFIJPKfb4kvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p9O485P0mFGY9uAvIPnrw9fOjxHie10OzbeqLGFLxCHfaK0ClZRBTzaozFgYcjGDjKh4kj1jIeRzCLGo0PC7UgcJlUmgU/0Wz3a8+GTrgj2G/A3Ins3nCeXtlGrQ2yBNxX+Caz3kr/UHFoc7hOGj4VvUfUktludgG5gkRmmFAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jyliDZf1; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jyliDZf1"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h52NV6bC5z1XM6JW;
	Wed, 22 Jul 2026 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784743815; x=1787335816; bh=Gy/8v+2DIP9b8Wj1V1x4XhVa
	Yr/joa/XgaKadAyN+XU=; b=jyliDZf1I/QaHD8YZgj8CeQuOoOCsbuYGo5TTDOx
	x2SMj7bewiY2RMp4Pqp400ry5o/ABYoIMX4ICzvMU1+MMSV6lATVW2/xuMC8xE0o
	Cvjy6Ds2Oy70Xr8NtubGpVFS9onjMlXv0WQaJFrhqHhA+JJkySGRicJ/oeND+Jkh
	LyUtfd0YXo2+iVoHBnklS2Vd3n8tPMt+p4LK8Q1iTuxdg2V1P+wGzmMYE8wktyPy
	/2GEnJ/rk9e38hxCYa5vEeG6xvbVx6a1XOiJ5WMC2xAF3Kgj5UpidxwgGcGjRzSh
	GizyEn4pJXLl6gD+lkkfZi/G20LEjgRhKMEhDZEcbCKjjQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MXvRyn8iSePk; Wed, 22 Jul 2026 18:10:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h52NQ1qTLz1XM5kD;
	Wed, 22 Jul 2026 18:10:13 +0000 (UTC)
Message-ID: <1ab82159-e644-46ac-9af8-a482e2b0f951@acm.org>
Date: Wed, 22 Jul 2026 11:10:13 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srpt: fix NULL deref when sending BUSY before
 target_init_cmd()
To: kensanya <kensanya@163.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 TanZheng <tanzheng@kylinos.cn>
References: <20260720025941.69809-1-kensanya@163.com>
 <e5c8e258-8c57-40c8-88a9-04173392e9ae@acm.org>
 <41ddb3a1.16d1.19f87866fa1.Coremail.kensanya@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41ddb3a1.16d1.19f87866fa1.Coremail.kensanya@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 6:52 PM, kensanya wrote:
> How about the following plan?
>    - If target_init_cmd() fails:
>        release the send ioctx locally via target_free_tag(ch->sess, cmd)
>        and do not call target_send_busy()
>    - If target_init_cmd() succeeds but a later step fails
>      (e.g. srpt_get_desc_tbl()):
>        keep using target_send_busy(cmd)

That sounds good to me.

Thanks,

Bart.

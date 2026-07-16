Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3833F2F3C3E;
	Thu, 16 Jul 2026 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784227581; cv=none; b=ZMfIvhhsadWfHwKoqkQzHEfMIFHN9UiPJSk2ffkiGBXatiK2amA+3nBPdSPAIprhIGUM1J34hJCetJhbeJWmzrkXIGChk3TBmEO/ykuk/ZwmVFjBhqViforI4GPyRSRZHOQuDX4GvWwLtgRe60sa6LD9ZuO/44eTdVUlia7yL0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784227581; c=relaxed/simple;
	bh=ONwwGWOVTJgFD2N8fzWsxFKNc6FQEI4FlMGVjvaDpFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jt9JQ2ToF8SHG/cFeOB/0aCQfHU02IeCqvbutHYT9Trxwp7oFsM4EEMc7nfz06XIkz2UbLIT2s9dLzSbD7zuKbybWgGG6dDVV3dKjIpcaL1BUw6f8LZDMaGD2IgYX4kTvzA5EgrFKqWCOAROjXQ5sCusghSlwHYfMd6Ec6qbW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=maArWnE5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="maArWnE5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1MSq4dV4z1XM6Jm;
	Thu, 16 Jul 2026 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784227576; x=1786819577; bh=ONwwGWOVTJgFD2N8fzWsxFKN
	c6FQEI4FlMGVjvaDpFI=; b=maArWnE5jTQyWd+scQ+Jmsk2yeHcEqFoQQoAwy+g
	/aQejl2YUoPvm7cHpy1UaooywSzMVEMBcVFVbAYBaLdCVXwqA4EHe6eccO4TraAR
	egvcFIGnEjA+uYs7w3q2FG8gMEr7U0beDXOhhSQZW93/eCxlW+I6axN+924Xx6C3
	9/sW5hcXbYm9QE2/HUQcBJARUJSYju49h9dMbaug1GEbypsyellUhokZeYoqro1E
	GCU1hjq9GSSIpbLZSaAupUmWxdR6GkZ/ptWZD0gK3uZPYV56isJOXHqXNLoddBWC
	ojO4wYir3TG7TDu0ezBUCS+9lbGswyh5kNb2ol9RUAbwEQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f6_kLKZSp5ph; Thu, 16 Jul 2026 18:46:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1MSl0t2Dz1XM5jn;
	Thu, 16 Jul 2026 18:46:14 +0000 (UTC)
Message-ID: <65e50f3a-a414-42c8-9840-31d9910f98c5@acm.org>
Date: Thu, 16 Jul 2026 11:46:13 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters
To: Leon Romanovsky <leon@kernel.org>
Cc: kensanya@163.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 TanZheng <tanzheng@kylinos.cn>
References: <20260715101550.45345-1-kensanya@163.com>
 <e29b0d9f-177f-431d-9411-66057f536bf1@acm.org>
 <20260716182200.GA110966@unreal> <20260716182448.GB110966@unreal>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260716182448.GB110966@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 11:24 AM, Leon Romanovsky wrote:
> I'm sorry, this one
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/leon-for-next&id=07f5f0308bef

Looks good to me. Thanks Leon!

Bart.

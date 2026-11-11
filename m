Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794417391;
	b=ljz9GXQWmimp3PSRUf4KLpS1z+aqDrKDr/rtbPd+K5M0uPCbn8oXJPZnyoo3u+Jeww22
	 lSKJcVgi7G8d4+nF6TXJo2QmwTGO28aBG8HqX4IzmmhwtUKqsk/A3n75xL2JHTChZHOBY
	 LOHa3/N6jqPC8taCE841JiWLhrbwl+CXLKmZ9M7pqY2A2zaaTkNP8cs2SJMIVjuiEPIwr
	 dZKTFQPRh7iqJ3UKNlEfiD6XWiqcMPdZ9ET+WqTA1DrZHwTl95eYw4cMLEYiIZ1KIG+AY
	 Utco4sd0sYkMZZKF7LmUmf0932R14C1+EJ/1bjyrBv83b5oX6u4zooH0LlCQEZ9WrlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794417391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fIig/BffyB+5s2LgRQY15XBehMPojYoZakjb4TFNRbA=;
	b=kUKbpF4TuDVhv0BppgjoH2kKEia7JpyhuqWiFnvW3oP8h3BouwelWJ/LtcxWgvdLXRIB
	 k8X4yq6w7wWkJwbom1Jg7bQn7Vj0cxl01KhlLluvNegSNU5vS74GD/3xvcxlV5Wgt0bLD
	 4AO8KLb+V8ySQEvymnDXtDx++Q1EkTOeLGrWWE+7GDtauCZX9F9cqd5/YHPDO5CJAVOPG
	 y9Hgesw0tL/MkobjJEof89afe9quPCb55AVDy3MmTIaDnpv13Rsbfdeh2pIDsW3279fha
	 Dtd1dpxdTUDYsOMip+fbaXXTMQ1bXv4/qQDtlW8/aTb7Q0U0yhNat6Sh4yJQdp10nsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UgbqS+NC;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2EF606A31C;
	Wed, 11 Nov 2026 17:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A2EF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=UgbqS+NC
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jPqtl04qmzlfclm;
	Wed, 11 Nov 2026 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794417389; x=1797009390; bh=fIig/BffyB+5s2LgRQY15XBe
	hMPojYoZakjb4TFNRbA=; b=UgbqS+NCyQ7MwJ62Q4AbrCJgjXTcW6a/2qjYJAEY
	Nvcwb1DD56EEaZa1Xvalo0jZwAalZ4ao0hztob2BzTa9UQNNXdgTVISvfXWsgvvq
	wwPpb6ORp1bQnsPztj5LwXRWi4zUY4hBMYSbF5beG+38Dk04JAcy3Px68eQn0lPo
	i0W++jn1WvH7VqEYk/Xc2isKR++nDSRgfDZPTogQs2170CqQyB3FI3/o5nL3Nh/+
	efnafxwB46QOngMCOSzS3L960pxFCHu5waEPbhriCVh1fC860QSljSBsTnLoAT/n
	JXnpgu7cBg+MlbFX9u7FoQXx2nBqj0mFYqB+E5fMN7fS0w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id znNemOVvdqkv; Wed, 11 Nov 2026 17:16:29 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jPqtj44Wxzlfcld;
	Wed, 11 Nov 2026 17:16:29 +0000 (UTC)
Message-ID: <f455d1e9-f925-4300-9785-2f59059e449b@acm.org>
Date: Wed, 11 Nov 2026 09:16:28 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srp: Fix potential fast registration list leak
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/26 4:23 AM, Guangshuo Li wrote:
> If the indirect descriptor allocation fails, srp_init_cmd_priv() returns
> without freeing the fast registration list. The failed request does not
> receive an exit_cmd_priv callback. Release the list on this error path.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

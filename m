Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8662C224D6;
	Sat, 27 Jun 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782583465; cv=none; b=LJvAYV7UrdW40r3VbCcyd7f/7Z8EewuN6RMQrD39d+Ajh/6CCsVHRW9v5ljeGiqo6FYHJE1UnpG1UJDcUrFLT0EKCYEZbYjN2NhhzH7Fxw2gbyne4fGOHri/qpsMLq7nwbOwWMSzsQhaTueY72hQ7SZbXEUD7kXbf8dmreatWvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782583465; c=relaxed/simple;
	bh=JF3ezJGmIUbCzbTZZh1iMwNS0gncg1+qjiT39DgGUWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GXhbUdR+C8lLRApFd/56c3iiqasx2OB2Md/vwsy0nOKZyibDW1aDUnjlNYx2WhHglyyr4hehbHJaAugSLY9Mkew2uPcgWcL6LCq2rh6H1QpuwnXdGYRC61vPLwmQ44kZb9hu0Zz5kv/uGQTvy6tTv/MIwzNmCJUPLehKO606we4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iU93BIW1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iU93BIW1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=iI1HGH2OmlTH74rtlWGKjmoWeUyzUswLrDENDldi/+w=; b=iU93BIW1wUaGojfy98WAMgrWVg
	efY/zGXBHPdV9ItNwLjN/U4hACFI8ldqkmK2fZgYoXSuwqH2/qGClObNYHjBt2x1yqAqLP8+hR4sJ
	Okiw3Zom8Wleq1vyeGZ6yKmNO7ASFChAfS36E86+5hU1LQ4XpckOZH5wjeO71rNjs5dSkwnIwDvp8
	p/XVyY8MEeF9Tig5lpu7q0SucV1ytrEp3wjp2hGchs5uD0hJcCGcSFLWAsCtANwmT7QBHdWipAljj
	b4y+drY+3hehML8FmvMvkiBosb8SeUkclUi6zDF0K54lztCJEDc1VE+8pTOBnJk5yY9lV33AbU3cj
	sLX/F7cw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wdXO5-0000000Ch3b-2Uhj;
	Sat, 27 Jun 2026 18:04:17 +0000
Message-ID: <525c1a77-c727-4c61-9372-bb7595f27290@infradead.org>
Date: Sat, 27 Jun 2026 11:04:17 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: infiniband: fix bracket
To: Manuel Ebner <manuelebner@mailbox.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 "open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260627093107.31068-2-manuelebner@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260627093107.31068-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/27/26 2:31 AM, Manuel Ebner wrote:
> Remove needless ')'.
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/infiniband/user_mad.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/infiniband/user_mad.rst b/Documentation/infiniband/user_mad.rst
> index d88abfc0e370..cd66e7623d66 100644
> --- a/Documentation/infiniband/user_mad.rst
> +++ b/Documentation/infiniband/user_mad.rst
> @@ -62,7 +62,7 @@ Receiving MADs
>  	struct ib_user_mad *mad;
>  	mad = malloc(sizeof *mad + 256);
>  	ret = read(fd, mad, sizeof *mad + 256);
> -	if (ret == -ENOSPC)) {
> +	if (ret == -ENOSPC) {
>  		length = mad.length;
>  		free(mad);
>  		mad = malloc(sizeof *mad + length);

-- 
~Randy

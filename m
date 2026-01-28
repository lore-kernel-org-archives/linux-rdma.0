Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A831885A5
	for <linux-rdma@vger.kernel.org>; Wed, 28 Jan 2026 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614426; cv=none; b=AChjgYp1Tql2QMb+pC5eT3oX3+ygBzF8bCYtIsIO1hpJXN9drF3xa0y2JkRLmmlZu6tbORtj0B3A8lza15JeMkmIAxxoXy1vtDsnBr2T71hnJTSCOmEcjRu/7alsglFNINm36N3BXFMtAcjTKYNQxNpLfReQDHPpRbEFvBpAX9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614426; c=relaxed/simple;
	bh=rED1shE3b23QIFIe9t5eJr2m4KOCA0OZsL5aI7oFkHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQTuzsfGmmU5uf958CzSZi0ruV4iouaoGZJq8WYzwdDpIeyzupeVmV8gVU+UB3Eo9N/JaXUDqCCBlpRyVRHYesp8KjOPsTOo6usnrBhmhzdu/NlycOeNpCriK6IYXDLLsBbUuZOJX2ptyc8VmiMUzKY+RTkgRavJUjDj8eDYS1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kzgB4ED0; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kzgB4ED0"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c70daf9c94so1369785a.0
        for <linux-rdma@vger.kernel.org>; Wed, 28 Jan 2026 07:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769614424; x=1770219224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AHBjPzeDSZxtUThA83Qdz3H9FGkzEcXWR6nIn1GCBig=;
        b=kzgB4ED0Cim0kYr1bmK2480d9C7wyMvF9zv3b9+qPJ5JykzMm9yVY7vpxTB/A8sFiI
         vpitJfHhj0oyfrqyHCmpwqTL1SSE3FyuCwEJfYCKTha3T+KYb3MXZ/jqHCKtC78mSi5k
         SwLZ5tF4ikD+N+mDpdXajY3omaSdzb6Ta4GcbNW630vOQF+9+Vnynwfp41Be3wtmweed
         J9S2xwBS6k6MshE1e3qK6Hmuqj7uZuvsfjRScvZNJGIeR0GmgDjXMtevM+6ATyBqFyl2
         hj9TexWjlhlwSJx9mDNnuiXLJnCgLA0Wg/sAzF+B1ceUTesZy1RkCrM6+5granHj9XRT
         PYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769614424; x=1770219224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHBjPzeDSZxtUThA83Qdz3H9FGkzEcXWR6nIn1GCBig=;
        b=uQ+V5f+l33i/pl2dvm2Ha8vYHlTXwaAqx96pMv/zWGg9KI+JjlcxgFCqYMS9DVOLbN
         pVZW1E94HUlLT+jz8alCcNa/yEe4eMLPMYkquYNUqJA+IuiteTd2/bVCXGBjFTM+gZYY
         Sufd1guAkpOvpA1rOhNXQ0O/3PmiFjJ41XD56i3shZ2DmJve4FOSt5cBQYSwBu3F46Ag
         sz0cxsgmWbcbVdOhPDEq1xNmKlXAvYrILjfQKLcnQWzyaYpwMiVsrLC0FUcjKvkNe8er
         ktudEo0vQ2POU1RGqqzLd5Nu7vbcIOeeewbHpViZSQFdVZjfpEvc/AsvK1Nln4vqzscQ
         OOtw==
X-Forwarded-Encrypted: i=1; AJvYcCWQmBZUfr6l9a4FgKLMYgucrSs8uxJpw9xSz1uIJjuMwqZjOxjBEeOPtZDkusMLB75tZqqf0s2Hje1F@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1OqKykhGNNMrUkynu+uKg3YmKxZGP9oEQpkp20Lne4PSSloHf
	TgLHmNop3+AuOAPvyTPZpCCPDcqe5Ayf/IUULtw9q5uZ+jwkLQ+/iwo933qlMT/LTrI=
X-Gm-Gg: AZuq6aL72Fddi0YNwweGMbYALU5zHj3gEGBsrDGhkFTFjCCM6pjUmXb3vD8V98HWMbW
	o0u1TLWTMTVaSCNa7bersX9IMuL6e+AGgGBArZV/WKw72M4NKukz5MZsTBeYEFrriEG2CHv28wB
	zAl2uCaFX4Q8LltqoLHHSaBoT6GfhyOzbLGwIsJlhl6YOpIUh/Gr3oESmvUmHUMzg7DV3BAcmPG
	uvDeqZ33ugBZhbsfKkcDF0Uv4Eap50INHQ2PlXDJJMGhX7KizMWKVpZVazDasWQGbW9F3EvAWge
	1+tNunhLE3h05KNeat1LZlRb41i1fRomb+y1QgoAuYFUaDimOuI6wkvZ7khWYQ1mb6c0i8HzAAx
	dMdSDpyGRpAJ7AkfjjJ8ai/3jUdre71oA/IDC2/eImRZLrBRx7f3g+KSlHqKkNaiSZgm2VgCgNA
	3sNq9VW0CUosj3C9qSBg1ikV1FZy75gq058Vt8PJLGSK8mTLC3uLrbZGkdS5YvL3uUrtI=
X-Received: by 2002:a05:620a:7103:b0:8c5:1fb5:1631 with SMTP id af79cd13be357-8c70b91a286mr640859885a.76.1769614423744;
        Wed, 28 Jan 2026 07:33:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36ad309sm19405436d6.6.2026.01.28.07.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 07:33:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vl7Y6-00000009JUP-2bTL;
	Wed, 28 Jan 2026 11:33:42 -0400
Date: Wed, 28 Jan 2026 11:33:42 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v9 4/5] RDMA/bnxt_re: Direct Verbs: Support DBR
 verbs
Message-ID: <20260128153342.GL1641016@ziepe.ca>
References: <20260127103109.32163-1-sriharsha.basavapatna@broadcom.com>
 <20260127103109.32163-5-sriharsha.basavapatna@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127103109.32163-5-sriharsha.basavapatna@broadcom.com>

On Tue, Jan 27, 2026 at 04:01:08PM +0530, Sriharsha Basavapatna wrote:
> From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> 
> The following Direct Verbs (DV) methods have been implemented in
> this patch.
> 
> Doorbell Region Direct Verbs:
> -----------------------------
> - BNXT_RE_METHOD_DBR_ALLOC:
>   This will allow the appliation to create extra doorbell regions
>   and use the associated doorbell page index in DV_CREATE_QP and
>   use the associated DB address while ringing the doorbell.
> 
> - BNXT_RE_METHOD_DBR_FREE:
>   Free the allocated doorbell region.
> 
> - BNXT_RE_METHOD_GET_DEFAULT_DBR:
>   Return the default doorbell page index and doorbell page address
>   associated with the ucontext.
> 
> Co-developed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
> ---
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h   |   1 +
>  drivers/infiniband/hw/bnxt_re/dv.c        | 130 ++++++++++++++++++++++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h  |   7 ++
>  drivers/infiniband/hw/bnxt_re/qplib_res.c |  43 +++++++
>  drivers/infiniband/hw/bnxt_re/qplib_res.h |   4 +
>  include/uapi/rdma/bnxt_re-abi.h           |  29 +++++
>  6 files changed, 214 insertions(+)

This one looks OK

Jason

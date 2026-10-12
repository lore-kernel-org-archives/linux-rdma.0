Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3437F33A
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 18:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791831014; cv=none; b=sSxtWa9jMTfV4E4JkJrVq7I/YDaD2KvonbEB7iLoLbtlcUS5PNvfBqk61rJBqVgzPhRHUegX0HzAIUprKuYjL6EIrKgHf9TIrDr4jQPf05HDe+3Q1o1guhfb9YLQsGhtrsPodUhKgUt1n+CGTvqAWpjBjalBsVWD8GvFSOlR9Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791831014; c=relaxed/simple;
	bh=HvdsLGTZoy6rsM3hzAGflrzYRNNGd13Lv4Ldak0unso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhvjGKzX7IfE93jugy8yh0ep/u+zdmdyoLDsSvfEK1NaEueDDd6xgtG2GLeW1cmGXFfWWHcstRmkFWAMdAh8coQtH4XqlZxC9DfbxRf1EPa0j+e93pDi6ofBFmpCckLgs6wXm0ZsXlj99DDh4JRK/CGd7uP+A17OWYSne0LciPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=NrrKeNx1; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NrrKeNx1"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e6fb35f91so217920085a.2
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1791831011; x=1792435811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4kBAi0wJm90FtDnhP+L3RisnhRY+6lKVwLThIsStiQg=;
        b=NrrKeNx1Ncu3zfI951ptAo211U0i+vAnJPOgdlaLQtn3OKGO+ti5veW0olZqK2fkJO
         AoKIrb6YusY5orf71r6N9o1m0nH52HPu3/k5e+cG3JdQipHKCS9lr8cpKHQvQjOaY+bX
         Fsi9UXAZcR4LOOGgEYvKEkEP2N9prlFJPZD6DoKNStSfpAj1V0pl2VuWrIX78FJVxUUM
         ayTk6EW5dAzG+K3xOu0REOfwJVR9mIatCHi1hn+IfOkssQMPVOSLjUuoH0KECTMCYJgO
         pxi7+yEirtCLTBHgYUNaSJBGaVeHB62bKrkHELoNlyYHEAlrcu39wYPHbU5rMlafC5xW
         M8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791831011; x=1792435811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4kBAi0wJm90FtDnhP+L3RisnhRY+6lKVwLThIsStiQg=;
        b=S+aWmoZfiKpkmyNozNSe7zCJ9Iuq/jqHll8zpwt+gn8fkOwlM18G5BvVH6K/jQtEhl
         VMmysZc2/pzbRYxbQjbdAuVjtuEYjFF9QPSoJdRWei/CFxy8U1XY97+51zW7C/1jtgTX
         scuxPSX4+XceItjF8b7km92tFqAPON8jCj4STcrh863pZaRnfFQ5J4DQvuXmySFhgJff
         Ctny1Leutf3v/x8qaEivXBYEqRDa9eZ1hE4Q+QxHbHeQHsN3lIBwi4ynbynXudxk61Pd
         +8U+WSsAx5qCcfYcirHxHH4aj4Zq3pSDTYRp1z6MNegnEYkE5VeS1cLZBAh1UhYhStUd
         e1gg==
X-Forwarded-Encrypted: i=1; AKwUvBwTrpo/e4G+UFtSGL5XWGyRuhDqt5N37KDw7ZhihElckE7MXETlfKNEUIrNeIG4usTFymxwIrQFt0NL@vger.kernel.org
X-Gm-Message-State: AFq9FYLqK/1OS5v4BMGEH0BbaL4PSRzY9dGUuzagZiynLNStjnsb1LMX
	FEmkJcJ/wOREqZSYGSYI/HB8gpk6GwlKMw/XgQAIyE/4/oXjjNYXOelhb8ahxgfaTRsph8JDy7e
	vZX+s
X-Gm-Gg: AYBFou00W9Xkuq+YVSzO6keopYpV3t+y7Ca7oAZRq1LDEmesV5HmeTX8lQj1RYhYKI0
	htnUuZnEaifow9hjExi/rerEMUQSn5WqRpJR1wJgB8IVoqjCI7uDoSJgwVnJzTQdnPwWRFPbLV/
	vPnubcn6OcIRJPWp9k4LSMlazqO32Nr97VliY8Obl88aS+9GJZvzmLplTdlUa3WB/KLKWcIjPRx
	sSlW/mpf9EqtDATXintxCFfMIj3ZU9698gmUHW6jrDLvzZJD5nE/nykTwEk3DWIbLY1PW2xdI+v
	+zrb05/+pijjnEuPww/RZPiusndRUQLnF9Hxg5JYMdCWKHC+LafGmrW3JxFVyh+LdkT9F/HeE7M
	3D7/fBvUjEWS7UMJ8rNQQ5Bhc7TXspsbcOHBpHk8hHxMrJ82I3XVIoGe3h2t7QlwW8/LtA9+HI+
	HMxpMQV8Ky/yk8VRK+ZIUR8kJyBOJxGFvLIMNx2ctXdGHBIVbdhloBNaMtm0493UBRMBb1cLyZO
	o8602QGFXfUgkqjGCEr7YBhEf2wm9Z3Ub8hzFFaZc9iqROiCN0f5y/I
X-Received: by 2002:a05:620a:4407:b0:93e:942f:b8b1 with SMTP id af79cd13be357-93ebd292a3fmr1754067585a.64.1791831011514;
        Mon, 12 Oct 2026 11:50:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm50796785a.47.2026.10.12.11.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 11:50:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xGL6A-000000076jK-1j4D;
	Mon, 12 Oct 2026 15:50:10 -0300
Date: Mon, 12 Oct 2026 15:50:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, leon@kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE
 alloc
Message-ID: <20261012185010.GH14213@ziepe.ca>
References: <20261010194832.2415477-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010194832.2415477-1-jmoroni@google.com>

On Sat, Oct 10, 2026 at 07:48:32PM +0000, Jacob Moroni wrote:
> @@ -3487,6 +3442,8 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
>  	pgsz_bitmap = (reg_type == IRDMA_MEMREG_TYPE_MEM) ?
>  		iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
>  
> +	iwmr->is_contig = ib_umem_is_contiguous(region);
> +	/* Call best_pgsz after is_contiguous to restore correct umem->iova. */
>  	iwmr->page_size = ib_umem_find_best_pgsz(region, pgsz_bitmap, virt);
>  	if (unlikely(!iwmr->page_size)) {
>  		kfree(iwmr);
> @@ -3846,6 +3803,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
>  	iwmr->region = region;
>  	iwmr->ibmr.iova = virt;
>  	iwmr->ibmr.pd = pd;
> +	iwmr->is_contig = ib_umem_is_contiguous(region);
>  	iwmr->page_size = ib_umem_find_best_pgsz(region,
>  				iwdev->rf->sc_dev.hw_attrs.page_size_cap,
>  				virt);

You should not call ib_umem_find_best_pgsz() after
ib_umem_is_contiguous(), it is nonsense to compute a page_size once
the contiguous optimization is being used.

Once you decide to use contiguous the start dma address should go
straight into the MR structure and just avoid all the pbl stuff.

Jason

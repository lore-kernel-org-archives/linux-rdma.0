Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795452691;
	b=2mdPcWa0/YZTxisqurYswwr7JxpZaLuBd3t2y1kkTcBhiDVGNAl+oL8IFZ1+vcE52a0N
	 BE/Z2VWQKoXXuqz83qADEteRS369UHKE8FruhD5uRjI4t/ypqMW4fYAxXk/eICsn1faDn
	 mk4x5nxECF2uPy2SMA5jdbtcWHUOII+1FmvGO+U8/uZJcvSNu/07lBF3E0LzqdPZN0PFB
	 m9ZC32IlTa7IkBBAqw2TCCdwtG61zVi+IOzEOZeyfIONM/VfMqHQbidaXDTeIkgPPiD1h
	 0a3d6o+c2cFqWVeHqjYsu8lwubLq7c1izUtVmDyjauHY4B4fKvNsnBl+y10LgOFBg0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795452691;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=i8m3St/33fP2QE3sVDWlAViGW9u6eVfEV+msFg0eCIU=;
	b=Byjad3F5MAv35eJ3u7r/CC38TdvUwLiSwt/xOdnQTUTBq9tlnL9JDUeMAZBsjU5aSgAN
	 sqM2NAyfeq1ryverWNlA1cVDFLU36ioM9QgczMpcRuud0QW5uzU2yD8u4I85HrKOH/0Xi
	 U/DIxxzUhEbP9RYJCxV3+xWtK2rOmkEiHxlVyChseyIrCP2jOVupZ1tvOil5oadVelwKm
	 MDmGkhkIrF+ynEEvyd1h9cmOMig7Kr/5GH+ToP7+kArm+JMtjxgCxmGcIjx2PVSPTfWQk
	 uBAUoo7sE7UOCdlcoJlb3cONjx4BwAkk8qR/KzgCJdcIOz2/hUGA0viOapjslqoqlOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AuBd6OMz;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0F606A330
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 16:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26E0F606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AuBd6OMz
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5361e313e63so48562141cf.3
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 08:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795452690; x=1796057490; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i8m3St/33fP2QE3sVDWlAViGW9u6eVfEV+msFg0eCIU=;
        b=AuBd6OMzXlSQGhqGzEU8BKBmVBfAeOXmvQBVAqY4L2BWD09YjoBzzOgJ4ybDaUAd3Z
         bv50ZDj5WX+DG7K0g1CxlJGfhVhfRxsRRWV1uYkqltMcTzDw5nYynaqPmMDGIe9XEmT0
         WEsJ2dpJm3OZbtWHWK0uJ0Uy1Asapxd2k/+ZXQeP6FEIyZk7iuwt3mxruhznElKyskXb
         J+sP6uOLuWZ8bwVmpfKy6JfUdpMUPj4sztd7Zpc9yp+OfklIchnz2VfloxHzX8Mkx5w4
         UpWfnTGFPk/7yqPEz55gFNALVJLhbWr6aABLhlRnc7ZQ4lg7ESq8dEzhOKtsyWHZ5X4Z
         AIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795452690; x=1796057490;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i8m3St/33fP2QE3sVDWlAViGW9u6eVfEV+msFg0eCIU=;
        b=fi71NSwKLNnKZK7+3e8ObGNIpHBAwrVCupiJfklJDMHm2hzife6CTcvMuUnxM9J5JM
         VZtRk6ZIDzO+t/Mnv3wBmP8Bc+z5f2CaPJQrwqIMM2d/JS/YZv1yVkbEouFKA9b34PVj
         CgLTBL4BY0MSg4s46LAUhHtPHXcPfI9IfgbBRSDhXhYoTCNoUrSexLxzOVrrox4V6zjr
         F21/mcdMuJd4qhcKv2/0Uov2vZA/PlYCWdizUexX2vgMjS08p6upE+CfokERkDrkh8Yb
         RBl9Bz3h4uDzDTUUm6Gq1vKV9Oa+2L9ksT1h2Lzrj7EWUokPJnPgiPXg2OBDdQoY8VUO
         Iw2A==
X-Gm-Message-State: APuU4Z/JQnRMNk1HRLq6NEWNlV3+4rWCCjWwhhgfny1g44gGuzWOiV5Q
	vE+3keutPg/CU3UVDckD1H2/oJvaJXwY42Qr9FyQ9pXqITj9vRAqFE+gB13w6up79nw=
X-Gm-Gg: AZFdTZfHqscDbdhotA96C8D0EQB5GsyLykPQ+gsjnzHy1Bo+GXqTZK3HrDUJnvqvyL8
	QyIYyU7S+lHDmioPLKlppMMhNbHwqdWXWaqwP8Evk0dZuY2BvIMFhG7igDduLsF9F4vJflFfksQ
	Xd8n344qtYMjxD0s7YcHp8yZGXdrM3jY8nwd+FQgkb18nJHwKirCCGX3c4xXWkBqkX0CkGQiXSZ
	WfYHy3mE3AG/gt9qoBo0VoHemnUSSRKGOJPP0HNoDAWnVYvDBEY9LXR13S1H0DSsFRDpDpViszK
	62d6ZHnip9kA+0gfYNa92kNABxVbnGNVfMyBHaLZRefLCDNmZ7LX/owojYil034JpzMhxqNneQz
	ZP05dA9vj9INOuirHqyoAwgUjzTXyXOzlPr6h5LnwWz9yn1FuMapOmxc1AlkW8boriE0sTT/tnu
	7BWMDlB/GMzrgghfxwX7+BJTYv8E2rtI7SNXv5xZiN7eYeE23/exETp2Rz8xH7xFzcYiApc9BjT
	uNxG/69YmF42pZ9NnwsFgSBNX8rihESO+BH9evsL0Y5LZhOu0ZUqihjOpONkdI/ZN5v8V2KlvQO
	bvI4BzTsw2lJHkbtVK73ScRHjwBl9Zi+KAGDuPVOgk9ZeO6KLU9eq2mCedPo6fPYk7KNkqcjEgD
	NraI=
X-Received: by 2002:a05:620a:2949:b0:949:7de2:fe29 with SMTP id af79cd13be357-949bab0fbb9mr1904435185a.62.1795452690006;
        Mon, 23 Nov 2026 08:51:30 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb34a38bsm835809185a.13.2026.11.23.08.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:51:29 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVXGK-00000000wbY-3KaM;
	Mon, 23 Nov 2026 12:51:28 -0400
Date: Mon, 23 Nov 2026 12:51:28 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Roland Dreier <rolanddreier@rivian.com>,
	Steve Wise <larrystevenwise@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Unmap BAR2 when c4iw_rdev_open() fails
Message-ID: <20261123165128.GL179082@ziepe.ca>
References: <20261122135413.93813-1-serhatkumral1@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122135413.93813-1-serhatkumral1@gmail.com>

On Sun, Nov 22, 2026 at 04:54:13PM +0300, Serhat Kumral wrote:
> c4iw_alloc() maps BAR2 on T5/T6 devices or its on-chip queue region
> on T4 devices. If c4iw_rdev_open() fails, c4iw_alloc() releases the
> IB device but leaves the mapping in place.
> 
> Unmap the mapped region before releasing the IB device.
> 
> Fixes: c6d7b26791a2 ("RDMA/cxgb4: Support on-chip SQs")
> Fixes: fa658a98a2d0 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 24ac9871ce67..35dacf379294 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -1046,6 +1046,10 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>  	ret = c4iw_rdev_open(&devp->rdev);
>  	if (ret) {
>  		pr_err("Unable to open CXIO rdev err %d\n", ret);
> +		if (devp->rdev.bar2_kva)
> +			iounmap(devp->rdev.bar2_kva);
> +		if (devp->rdev.oc_mw_kva)
> +			iounmap(devp->rdev.oc_mw_kva);
>  		ib_dealloc_device(&devp->ibdev);
>  		return ERR_PTR(ret);

You should refactor things so c4iw uses the 
		device->ops.dealloc_driver(device);

Call and puts stuff like this in there

Existing c4iw_dealloc() is possibly close to what should be in the op.

Jason

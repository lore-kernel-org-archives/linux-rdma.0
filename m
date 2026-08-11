Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4934F34040D
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786457909; cv=none; b=tefB7+S57XEBP9ywn2oIipM/zJvtxda+qXUbvXfN8Kuu3eh7evbOhNe++plzQHPfOHa1J2NlATPcDmQb5XUT1/MAnnCSroLPLoTR/57LHQaSbQkjQfa8+RETAFKT/Qrl/wmIXLvwUR5XQycdjLeYDt2IIvfEWU0YYAVF+lMMQ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786457909; c=relaxed/simple;
	bh=TVFkoydAlznXR5A7IXPCTxUN7qahHWix2wvBiuB3NUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWB+7m+BxdBtljuDUv1CZAonFbsNDXxQX+6mQwCeG1PQjtkP/Krz0y3r+xhELlFxf4IbONtPndZRqh1oy6gavOOwXpnZYPYXZVj0F5dHrnlgdSpJArwARzZMS/u6alr+GAIaxJ6oLyMKHgtQv0wwb1jMBDkuwgauD9YjrexMGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jpNcLLNn; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jpNcLLNn"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f23e851626so5848546d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 07:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786457907; x=1787062707; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tCDsBFzkZJqhcWUDi/0LzMxGU8EldkuTj969HWAWJKc=;
        b=jpNcLLNnbDe0ehALjTx2e+bX13C7fJOSdWkrHwLY9IM7xxA4hXx0RchS8VUMUBpe/Q
         shLQHa7mSUVMRDOPm0ybOFeoH4rP0uuD74CGPC/Dgazp4TITiIJ/5v4P4o/HsnviN+H8
         Z9XAdrk49NF387TDyFLyQEIGeA3uJG+DG/HbHjmFPpPEX+CnhINTTB/ysx8uhAKclsb7
         JHz8+axYN1VNiH9WQ2VUtDRKF7vW1U0H9cyZr5WrTevwq3ipggoKB85WEMF4aCZoTnKh
         OH71tIJARCtUgNMBJNsgOpm776jCJy4OOT5kJWUO3Kk8t20ab6w4/5guMePDqoxxCQzu
         ik+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457907; x=1787062707;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tCDsBFzkZJqhcWUDi/0LzMxGU8EldkuTj969HWAWJKc=;
        b=qSz6+Hzp4xqwxIMHe5H1Zks0fHl8znUhOK1xOjDhq+xNFbdnG4Wau65COtDgt48QkA
         AqLekLPilOh1IUgKGIo3baeLNfEWkLVk37dVOHs/plTw3Qky2JNNgbUC8OIXrtF6XXMB
         VRsrbPE4Tl+XD3qEaL5yL7Z6A7JXqOffoUNDGWnqdcUseVFYy7GwpApZoUFkWT9NWkgh
         baLeQ/5hICqGL6vcAqImTMz3DLMgrzrg0TsPbA2Mhf36vInDuVF4Eqj0/OCM6JPydeWx
         9lCIWx5RHEJw3rIcQSlGtDl7BwOtJ5IDvL4UqKtvmu9734avKafJtNjBMef2PfnXAZKL
         jlNQ==
X-Forwarded-Encrypted: i=1; AHgh+RoVB4sz8BWirY3Cef52Iqau78M7H7QSt61L17huGoTCLF4YJtnjm8L0zFU22966eSgiISt2UCaX3CIv@vger.kernel.org
X-Gm-Message-State: AOJu0YzPwZHMmaNpJ6binpf504eEo+PNa/1Wt3B1f84nfaRtuG4GvpSc
	8riwOIzEDT2fyA+2oRfU5KBS1in/CA83NRvLB9P+ufIIV8nYX61EbUzqEtdkBfsxI0ZZdoiBv27
	cmRwV
X-Gm-Gg: AR+sD10I6+aGsMTSdNu0OYVFxAc4LEAj8itIe60ptp3NDlOsbG23AN+yFpVXSeAun8e
	qeyrZlgFGiu4vWymo2rddr4f/6ZxlnEaW8Wlz+G/COf1U0tOMXAc1YkTT7A26mfv1ZlScYhXom7
	o/cFS3MpKmDmto1D14eNspEepYT7ACCqs6eZuCey/P5hqY2XdW/RjD618j4Y2TG3asF7HVyDVJJ
	zxpI4w3W3Fq1mMbX34x8WiAbGnnrR9tnSlkfvmjhEPwhtmAjIKxw9+rTT2g9ZHAzNS+zflDVTCO
	zwr+7llxyXYgcYl+iay7eKWckk5WBdUKrR7p6IjnbqUr/GZXufhw/l3aYJGp5Pre31/G6CVv/Yh
	vaVHOVNpebQnsV04hQuECpKWHS8wXyUgzXcmvgQr0AUbfgUcPWGuOQUGWKtVN6WoyFw0BXGCEGw
	6yyf2LuELuQxMc9aJxDBgXcUh/u2FI8XHjOPuFHXs=
X-Received: by 2002:a05:6214:2302:b0:8f1:323a:fc45 with SMTP id 6a1803df08f44-90a6c1a0f4bmr2335066d6.15.1786457907128;
        Tue, 11 Aug 2026 07:18:27 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c17a2sm102366d6.33.2026.08.11.07.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 07:18:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtnJB-00000002VEo-3AUh;
	Tue, 11 Aug 2026 11:18:25 -0300
Date: Tue, 11 Aug 2026 11:18:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yili Zhang <zhangyili01@baidu.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA/core: Untrack resources before driver destroy
Message-ID: <20260811141825.GE544626@ziepe.ca>
References: <6a7affe3.26268144.122abf.417fSMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7affe3.26268144.122abf.417fSMTPIN_ADDED_BROKEN@mx.google.com>

On Tue, Aug 11, 2026 at 06:56:22PM +0800, Yili Zhang wrote:
> From: Yili Zhang <zhangyili01@baidu.com>
> 
> When a userspace RDMA object cannot be destroyed by the driver during
> ib_uverbs_close() (e.g. mlx5 destroy_cq/destroy_qp fails because the
> hardware is in a transient error state),

That's a bug in of itself, if the HW is erroring then the destroy
should wait for the error to progress past flr and then let the
destroy continue.

> Fix it by moving rdma_restrack_del() to *before* the driver's destroy
> callback, so the restrack entry is removed at the moment we commit to
> destroying the object rather than only on success.  

No, that messes up legitimate cases where the destroy is allowed to
fail.

AFAICT the issue here is the netlink is not allowed to access the
context without proper locking.

Jason

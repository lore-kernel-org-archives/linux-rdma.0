Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FB34F279
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656327; cv=pass; b=FQHWmGN2NQhYyDDpK70Dw0zTs+l+kmO6KvhDRxzZQYajWmneN01igbAqsSrSp/CxLe6Ww7qGKd+0qz8YDYqA6vJo2EY1LqowMOt/9yshgi/2w/BPXV9CNQU8+B+wuikdJXab4vdRtb3hJ2mOa7+WRTALt3FecSXzguwQFYtE2Xc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656327; c=relaxed/simple;
	bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbw//QCaz7HfgvLe2fGzMKiNn8e6vs1JUPaJhS9+RPrzchQ8j+XVdRStfVaL9cg/K6XTo5EpgbBBan/124aO+oYwqC4qIO2TZgpMblpLWaOE5gzKWDo+tGRVu8M9vo29hV8uW0VqoOn0BrEKXt7VVHCwEjMqkkklxM+uo9CV4u4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ciM98YPw; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ciM98YPw"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38511175ad3so9466844a91.2
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656326; cv=none;
        d=google.com; s=arc-20260327;
        b=cvdDM+wV9Zk7LNGPPmPyYR1DGjWyFn8heq7AxswmVVFes/qLZQTMxH4eTMcLRl60A0
         32IsKcBVChAikSzL/LlaXZUSriFrOpSDpNiA+7bFgKbM4MJ4y4YSczc+aWHk2xZ1NSU7
         XMuqijjpI03IFIvgsIyDD871/nuD9QtlYyH/Jg3yi17ujpXK1ERDdrplBZ+Y4D4BV7F2
         wDChXtOLwh32ST3BD2PioUPVl00pUJewcgw/QR4zzaXziekHiHkrhS0oo0dcA3SwmLyb
         oqjifHL7/zxKI/ROdpMbwgVRLwsMrIoHmfPPtLThztt9oL1NKQxIU4ZrwnAhBRWymIZD
         BLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        fh=JAEl8EYv+lya9LoE8ya3dPpaFYLyxfSFapsWKjGQMUA=;
        b=Ti5Sr5kxGOFG0tIVgOl18fZIoCNaPR6SMHyI+m/IFp1yXp6GVf/jkRxicmkiGmOZph
         RYhwSCC4C0kVmt3FfAuryRFP0Kako1xjynT93uraU13+szfkJLkNctfXtNmDfF88pKcT
         P2sRMH5zFD2anQ/2ctFm7by13QiiftJK/bZaa7LzPBkqdtm/16bzHZcTCpkt5PCPEAXG
         NvFrD3/SJg+0Ng5gm67CaqWl3COnUq1Fakbwny+YRtWjNndfVRHb1EFVgjwJCTPIhrcL
         P6E7yTHyfE6w1MQpFXz4asplDRcLzwnKaKpyDo8tXk+js1ThCM7xWSILmTiUv8/kglzN
         8B4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656326; x=1785261126; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        b=ciM98YPwwqhVDh39wBw+AH4bzjh7xU/N/H9aik3M5yBvwF1UCf4YAQy5msJ+4GYErU
         GuzrwUMPXRtMbduUVSvtYyerXesojT+AKo6LuobEd3zGS3krQ0v3K3CiO0MoGDlvRR2d
         YwQWsf92fTVscp0PI6EsFqtvArWWi6JlPi+0lXIbcva2+LjMWSheh2y+qebh1iwX6nlv
         /zue2udrnV4TyGi1x/P02OjHk7AWixl7D0avY02fPtazPCrtdPjGHrczQoJgYws2T32j
         ci6WxZ4oInTDjyHSWWDQIN0Y9wR5ZuXOLLouoEKSkL29s6p+QTsUV+pD5bCx2RTmybWX
         MQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656326; x=1785261126;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        b=T9SiGdpI/LOFWz8+XPWLb7lEZT/IbqBuGrCUt0mKLHFizMgNduOrOQB3fqvP/oFFko
         KbMcJBOax190DIJEjePHSkEZVGCY286XSqOGB5fU1+YV5RlaPDOrlHKzlMQjNy74v02n
         xwOdWH88UFbI1KqHi+R4QQo6AM5q2wAyA5VYm6ml5r3UbAB3B95Q+mxav6V2j36U8tJY
         JsX4Vi6wNGKa8BcMEt/iHWxP3udTTnOsTtTobUnD1U4sM3ITcJB+MbLsXeN6xcc1CU10
         OUHsHEI+Hs4PNNLupumRk+Xy6t1fdB7ADSCXUAo23U0SeOEOevpB3mqwEo6C0xG1pEdk
         K7DA==
X-Forwarded-Encrypted: i=1; AHgh+RoqPiXngcsXD3tnxyeIbZvJla6l3vGnT3LBdITr3qhVzbKNo3o8/2xLOqpJSBOX3olL7LWk6Ryj3Jwb@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjk22ljVzIdP27o7RNYZI6PZNFS5v7iJAur9vxvyP4ZId6QchX
	VdIvxErrNF2vpOaVHPhfXuO5m5eHAVBovuKoD0GExsn9PtXE+x0wew/bHTzDVUuP2SzQdwf720C
	/A+gI2kt610mAqmrhvarWmU7QXgKRBYU+R8MyzNLW
X-Gm-Gg: AR+sD11B90+okxCFYXbden4uT/G9vOQOskwiBdlJrD/XtowPLbrNqkYYcN4jvTbUtle
	Pi7UC+Z6gSnMWxrPXKHmsueokgqdtkTprW2aFC8NCanJbFjnJQ8ny4rVRbGYdtJg5FFqkVp7oXN
	b875du/w5odqluS/+M1hcMSVSMOS8oK1dbejKXqmKQXjLqzgwNYkTddkEVn312nw/oa35oa3Jwo
	cUyh1U74S0/V47L+enhAhbsC0FZ4/ch/tRssVMXGnyopcPCd4U1INf712+LoIqe/zNOaP/OOcT/
	vO0WFfeBUQ+x03Ulc8QdICxE/smU8Y3skIRHZ63U3T4=
X-Received: by 2002:a17:90a:d2cb:b0:37f:ad36:8fc5 with SMTP id
 98e67ed59e1d1-38e4b515bfamr20269142a91.23.1784656326031; Tue, 21 Jul 2026
 10:52:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260718162547.448892-1-mykola@meshstor.io> <20260720124304.GE110966@unreal>
 <al5IJb-L0FpztnYz@kbusch-mbp> <20260721124944.GL110966@unreal>
In-Reply-To: <20260721124944.GL110966@unreal>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:51:53 +0200
X-Gm-Features: AUfX_mzytkhLoaPSiTn9RmB0hwu7xEFpMpTLbojjFKRzqIcqMRM-jx5SaIRHGbs
Message-ID: <CAPzsNDuY9OB8FWb8aPTpxpVYC0u1ewCmFnvQXfSKQO6xqEJhBA@mail.gmail.com>
Subject: Re: [PATCH 0/6] block,md,nvme: correct handling of unsupported P2PDMA transfers
To: Leon Romanovsky <leon@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 21, 2026 at 03:49:44PM +0300, Leon Romanovsky wrote:
> Yeah, too verbose and conveys almost no useful information.
>
> Lately, I've started ignoring such submissions to prioritize commits
> from people who put real effort into explaining what they are doing.

Point taken, thank you. Please check v3, I reworked descriptions.

In any case, the problem is real, Leon, I would really appreciate if
you could review the RDMA changes.

Mykola

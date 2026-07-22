Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D93C1097
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746798; cv=pass; b=hShs4+sMdKZjoXWf+5QwH24hOHQcxfHIXWMryL2uHhI+xL3qsuSOFuMSR9DtOxb/EZwCCDjCA6kDOd/tN/yA4HxUZFilVGo5AoXcf7LbhFwpaCvICHmHUr/e/A18HEO6tQPfhcCmUTJSb+7ervD0+CmCBhITw1GTsFpXXdXJwEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746798; c=relaxed/simple;
	bh=OR8lGDmhaAeDCR6cUrkUghEFDERBizZRwyMQlhX/9RA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pf4/NOMdTjB+SXVzP0/ijrUHJyRVn78CM6mTQzelQG2ei8nMMnNoj3vSvgr3jORzvFe/DcSffO8vdUbLp/XvazaT1yn9qR2w19tIiOll2McLG01OBmpCt6KO0KrvFlLZlrvCOBSf51wtjZcoI9HUYpdVcpnR6T4bPlIytO8q4Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=GZRDblSJ; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="GZRDblSJ"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbb973e6749so292002a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:59:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784746796; cv=none;
        d=google.com; s=arc-20260327;
        b=jjxDSHn4pPdDdFaG5s5VF5r+Gdv9GvjVuRHy5IpylIgjo1ucO289kLBXhlWiIumWhh
         RzZ0UJaD2sIoIKURuBCtNbGkHZKtN3CxhlmciF+0+CwEp31uehJ1aq1tyh6ajmQ4m2Xr
         LZGJw3BU/5Wvit12nHseAO9bZ9UsagGsIYTXegURWAw5qJjZGwNzWJg9ebD12ZUBstx2
         ninNQytDobBEvbsMoP/JjILGg6BfJHTsu2QKQ9bhjrhner/X//uRhrvJRWs9xML+v9dw
         Rf+ipbJuj8ks+d2NITYbek6OgzUbfmx9LJON8nv7ZfIEKcTzBwblzNhCO5dukrQy0L9N
         /bjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        fh=8yRZGIjA362R35+SjyDB4WQN5LCh2MEQIqaH2p81Fe0=;
        b=eWdjlUhayiU1+7UmfgZi/kngvNDzicaGndkpdSExia0XvBBWzHjVQqJBGOvrnU3v5R
         vzXONWHM+iorsCQIGYlxL48zQ/Uwm8TPz3veMQpwDqIIPGH8b+XBkHcO8hEqrGMAUl4k
         tCMEFhRq+H3Yuagyl4imjRzKDljnW+Wp9C0KFCzboCFXDbQtX/r0LhY1B9gyJNURnlJa
         OyKXe16pKVCbjYxLhsqFxg9MFWtN3coF9lzjnV00oQ2oPKQrxz4zlg9lHDFIcPipkZLX
         bGIaRXk6BhMAZdMQFqjH2UmSIgoCIo/YF9Vsa2mphBiDFImEe2+8r6/R0Jd2Csrc04Zd
         IXjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746796; x=1785351596; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        b=GZRDblSJxpfkVu9OGLvPcpIF+Kx0S/dsdjtNVu12StBiM7IsmYk0fqos/LFja1aYKI
         tKYDIun9sCkcalPO1n1bkURwucUBbDwX883OP9/S5tABONs5MQanLk+jOr0Q9paXm2iS
         nQi2t2d5DbK3i3t9+McpUf5NlC4diEkR7GQYVe6318h3OWfb8X4rHgEAr/Dt67rw6xQB
         3d8YXlUNTab6GEEdyHMkfxiL03YARUCqOgU+QOuHHyMEeBSdGvwEPF0NeW0l9f8tVjCd
         S2SkWby3p7TMdwgOgvbrjH0sxNwW/CKTnDRF+0yrt5ukgNkMTW+AX9/qX8ZybTy3srwx
         zk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746796; x=1785351596;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        b=FGhJe6krgNCHWKfWBYXqdYg+Lk+Gwe7OuZrBgNTRLM1g79mrFZEN9ls5Nohuszctq2
         fUKpvUH3EuI8IviObzu+LQ1jK3uRcO3CDdLeciVaLne0kC54KgIMnIYH8HLM1AxcFAnT
         tfAYrYNgnAuYo4TaynjIjPiDvo145Dv33WSrUhZB66tofVRWSo8inZ9eAVvpBRRNQqdH
         Men6gcdvxAf3i6ZkZKGE6AyV7VWIVRkUI48XHaeZHKaOcXb/VYwR5RhbzU+fANaKy1uF
         50UIGDHWUintcO43es/6B1fnAULGOhQE3D+knlUcGYDPmtd5lkXgd0PS0uVhsXTBViRb
         BIZg==
X-Forwarded-Encrypted: i=1; AHgh+RpLfWcuj46FoH/N+dF5+6CLxwchopIlfDOZ9U1Q5w/qS84we1dWlqRcU4mElOukQEJ1Wo7k4MUB+sw6@vger.kernel.org
X-Gm-Message-State: AOJu0YwN7Pls9Te/r0x/K0F1dVwGb1OeOCcLZI0kkGF2725rSwKiQjay
	s/xi/T8Dg3+0tW2cA125wotyjwoE9PIpR0wA50A435jz2UBCOzN2bBLwhPpg0bLxW7eMDQ5Wk/3
	XfKgQkGyt0KMdj44JIlHnqZ6D7lCgURK/TbJ2KB80
X-Gm-Gg: AR+sD13h4AmMZiTZabALLy+Z6awkI8x4IGhz2p57DsH2BgNcjFr0u96/FkOI0S3q8mM
	HZEd29Ffj1pVPtb5aftE2dKNJnqV86cC69iOM2XsQgHaG09Ed4I5E8IE7LQcrkk9VBAAVByBpM9
	ZWvsGypP6p0boYtqTG7ltZavzsHih3LBvk+lanlmzcfdfv6Ia8JaboH7TqlWR1ltOtrH0FlRbvS
	qiTdstZqyjtwKqJPFI+TSRPbO0JzqZW7PWInoKWNwKZfBuqlO6EuIZLXl8ELNt4FLvLJKQpty45
	HD8NR94HO0H6alOvy40qFjVhHs170MvmUq01h8+tr+geyFLSNULm200eCjx50rEbEmOwVYSobd+
	gZ6re6Qz2a99HdKGUNrM9uEcv73ZQ
X-Received: by 2002:a05:6a20:c70b:b0:3c3:7427:5ed8 with SMTP id
 adf61e73a8af0-3c3ad5fc1cdmr27667795637.8.1784746796289; Wed, 22 Jul 2026
 11:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com> <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
 <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
In-Reply-To: <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 20:59:44 +0200
X-Gm-Features: AUfX_mwIJDNeayLFRjPiK4AAbt3mZyBzoLHgFDE5c__6SI0eByKP37ZQz-8Pukc
Message-ID: <CAPzsNDvv9eavB73xZt+LxjqLkah4CfiCJsAq-4vxDrhW13z6uw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Instead, I think it makes more sense to introduce a new BLK_STS_P2PDMA
> error and use that. ... simplifies patch 6 and 7 significantly.
> https://github.com/lsgunth/linux blk-sts-p2p-err
> Feel free to run with that.

Thank you, it is much cleaner now! v4 is built on your branch,
your patches kept under your authorship.

Two things I changed in them:
1) read patch reads bio->bi_status after bio_put(); v4 moves it
   above the put.
2) for the narrow_write_error(): a P2PDMA failure is whole-range
   and deterministic, so v4 records the whole range as a bad block
   in the completion handler instead of retrying block by block.

Mykola

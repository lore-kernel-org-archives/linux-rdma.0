Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348C46D579
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656194; cv=pass; b=Ew0TJ0MK6FqSumZSLVR54mdoFJWAvtSUYH6dEQM8A2wxnDkKGox61knpI3zBm5hb9P7SjLnpuanwmQB1sKgCvdN7zgyyBNJLTpGrkZ6iun6AmWmqX7adntpGo0LgbbOAcMaIrJxvQ38t/lSpV5nELJ4TAXfvQqQc8IK+QEnHmv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656194; c=relaxed/simple;
	bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rzv9GAiPwBRPqrzj0H4vgHUulW/OsXHY7EwahK4HuQURrQo9LOGigDtSW77NvdNhpUSSMVAtXoY2Ax/sfi8UuNY+8tCsi7FwslYpDU6+YCYXUZ77SxORwr8XCg9jsApKS3qNAF7xiHS5ZvAXLEsLivyuaUoiGOHZCtmG3Wt3EKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ZgMFuTFb; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ZgMFuTFb"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38175907a56so4054834a91.0
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 10:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656192; cv=none;
        d=google.com; s=arc-20260327;
        b=FxqG3D88tqY2299h0GhCBipfVhm+FYj+5AolYsWl72JhpwmvlL1W25BNLGbtMgDBG+
         hzOeuxgu++bXaA72QRCVRD3dF504nPXMCmuIZE28O1IGkmFjo/avf/G7PoRVb8T4LdxW
         1b18Jyv1v77Wmg7m8xmGyuwkzpGgGVej1Zw4sCsYJ1TXtoInrYQmZ9dfkILzynYQgVj4
         cx6iAcIDMyjvhRmabW2tufxI02A/cI4XXyp3EMw20O9xVgtl6oVUMa8D1862RsmaPUTC
         0RzhjVmLyEwgt+K4wpDg3TO+ZEbcYJ3qnTaILLIXg4DDRQFZV8YQnXNhYT0rUEICO4Dt
         HmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        fh=V65iIPQGDH1PEVGcZ2/x9urfD5WBJpXNXH/XRBpS/M4=;
        b=IT2g8HD/uafFhGZ2XKC6SKUNU2zKHqOERQSGiMAU/26gWFWfla/k/HsytvFHfYV/rZ
         hPLi9cQOrC5XUX9ZCBzZvxAIEBB9LXR2bVtAxWaMIQKy5W74F4N+hxj1z5d7wATNZdP5
         Cs+quU+zfvLgM1aIuaQqgDjyEMKZECLOIW63iaKnLayrMHOBdJ2IRso8wBbddxQarz1X
         OMeQy2CMSKl6/BfqDUdvj/bObQyAyhuStH1fDL2vGct5fz5/F4V0RGaWPKcSiPhBq1Bt
         gFKifXj4yTdLvvarXUs52uu2/zI9csL6mVOZchMIYydboXtKwilWACrl/HjBLXMvWY5S
         jvWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656192; x=1785260992; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        b=ZgMFuTFbW5QBVbDFT61DhLd/4BDvDw+gMzT8IBfdZZyGNH7U85jgysPP/UtOAsD8p1
         oQrDrEYYRQFGxDVWr2sNBrJ94LZZTjaHXd/7R8oX2iwvJ2yg+lcDGDggsUQgYcKMfty8
         asaPy468x4LdKAkguJctYH6ex+3gzJO74Lmj3b6yXxjL32RL6t4f6yW4FAaSzc70Aguz
         aUpyzzhfTxpSFH834H8daZ1SSFazWD69lfychzxJ0ve3AiiQQ5yCMVNtrB55MKE3D9yc
         bTJAxyy+rU7Of6yjIMIFJIBu0k1wJoK0Kayo1TjvTF1xxM5u46bPspr8LeDVN0niLMQS
         l/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656192; x=1785260992;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        b=cj3m8vdGC/5Ji0oD/RurBP2tL5HIYBEP9oj6zFhogu/lG26J7MUrNkIT+xnHEkPIiC
         FNz/UWuT5KS/88hdexGpm3J5ldM69VRAVVHvLIDVPBbYpM4eveEQ1JfIWYb/8Lcb2sjY
         Osd+1OJCPsbM3x3w8jCDw9ntdlSFC8bPufcbTba1E/Hepv9HZAyYRcwot8nmP0J67HPs
         IDgCNmDqNxWTz+s4qoJ6djneUX762KOVy4Owd+27pv6FmqsR1W0hfKbj7g5ysMm09kFP
         8hlGGPesZDt7sp56IUjVEXYgLbSxS9uDeu8O4FcVT7Zd3MbcpwJEuM8YjZg+qxtwh3xp
         3CnA==
X-Forwarded-Encrypted: i=1; AHgh+Rq00ZYXX1+3qXxixcXqtXsLNMjkvGmqu9TCHLFxSb9Q5gVxrU9pAESxf9dl7B2L71X8s+6b1tuBJzU9@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo8UGVGBderW8zGYqFAMU0oQY4kn4DxpfikedGK5ZFMmy7tMmz
	7y8Zb15fQwEDVHoTpwDGpkiRFrw6tEeXijrL9KGaixAfcCxtccRoNNUzXRdkP80DvUNJm3ScKN7
	iKfL7EGM/giIVkDSXoKrqg9xZCcJb5Yh8qKftDUPZ
X-Gm-Gg: AR+sD10WBNS8OUa9psMAiwLHW9/+q9SpUfnP54MQWLGyKE+XJu6ApmGDkm8ifPOyrEh
	Dy8Y8Q/Yd7Or6WjCpTCtE1rAnrYZ02DANkdO4A/Mlr8q9xDf1Z4pMBgCsv/VtjMbIndOdbXIMfH
	nRcqnqKdqQ1cWrBoS0GBZ+Z69phc/mVy0vHtsAzIiHEnm55eUfJzjmq16gwOTHytOIX0UbLCjH4
	wE8MUk4B/2cAxEPvtMlKs6u+qH/wzyClyQrP3doNqwawFEOEtgIR+/zNXHgLY1fXfp1N+08Q4ll
	dkvbxY3LzuNYG6dykmvsjxekbe5t+iyS9Lu8M9mDGexi6Nf/SMxkKA==
X-Received: by 2002:a17:90b:4c81:b0:380:86d8:8162 with SMTP id
 98e67ed59e1d1-38ea37ddacbmr527514a91.18.1784656191610; Tue, 21 Jul 2026
 10:49:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-2-mykola@meshstor.io>
 <20260720144943.GA17375@lst.de> <CAPzsNDv6hUV3gHdaxuwjRcr4couUKq_M5DKObFNaYqCHnm7ZMw@mail.gmail.com>
 <b2c37f4f-79dd-428f-915a-2a862d20924c@deltatee.com> <cb297ebf-3731-425a-8f48-6be3c7944366@deltatee.com>
In-Reply-To: <cb297ebf-3731-425a-8f48-6be3c7944366@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:49:39 +0200
X-Gm-Features: AUfX_mzYRDnXZ96aQ_20QUIhDQu3bcp65YEqla-rQQb3UzXkujG9BSCJpITYkqE
Message-ID: <CAPzsNDvKwg1SCDyd2Cf4SVeCMQicUPYRgBmq-0ZN9m6QjQQ74g@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for unsupported
 P2P transfers
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
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

Thank you for review!

> (Arguably it might have been clearer if the switch case explicitly
> stated PCI_P2PDMA_MAP_NOT_SUPPORTED instead of relying on the
> default).

Unchanged in v3 to keep the stable backport minimal.

Mykola

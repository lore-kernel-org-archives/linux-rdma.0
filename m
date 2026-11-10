Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271553;
	b=eQ1Fgz4Ne9WMxwVtq/JBEB6PlS1TKVPqGUey2EVHWhhwYB+/qKH9T7/epkuzp/sti25u
	 BH26VCnQJNPfkKVDwIWgkWPH5vNHrpe0q+o+VniEltobHi0ctsJ/VfpmvPYiV6HzzFeJm
	 goRg4smjfrkj/KrJZwKXk4A0qB/Nx2YYS7EwCvUha9MaFZm/z+0vyqEUnOqtb9/E5YuiU
	 YuGIV7kzzTzlsII2R+aIUPlSLc0+tpqfm74F8Dplh5MqweIx507d/bECKDkCOqjZ/LKC3
	 +CfDmWOgijRVTWADut8NWPT0/8uGBLwb0GcYwjOxBlZPF63cDglsF2bpFCAhWZRRrHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ZkmTpzpvYUC7ntJzmKPOJ6Gzor9QviyvVoNYRgK5Xt4=;
	b=ex7u6Uyjd5tKCsujJ6MzV2CTlcafi0relG4XU/HBrJSfMAe97Czr9Op2vxCcgx5Ziq7v
	 4BWAENhjMUqwHYVC1frLhOnYNVVlwRaxO4frKKNYUsg1hBT0CdClZ6gFrV6T0FQLKsm9p
	 H/vDGCSowgkSZXS/QokqzZP0C94pTXooKMGq+OGDC9OyX34NAtMmTtk4vpIerYbq9oCU1
	 lej/mnMvpyki+hxXUSIEYGp6n+UxHpjgqi0UCZySsNl+IHDf7a0tVGARRA5zNUq5m4OG4
	 FTGS8+6zb342dcH5d0Oo5lEobmyJrzDqWDmMWjrp1082TuMFUDsiY+x0KYnV/LUnSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=KENk10Ex;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153CC606A321
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 00:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 153CC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=KENk10Ex
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5365f9a04c5so18890441cf.1
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 16:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794271552; x=1794876352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZkmTpzpvYUC7ntJzmKPOJ6Gzor9QviyvVoNYRgK5Xt4=;
        b=KENk10ExSThPjvJIbaRaSz12k7D0dwtjtTSi8PUD6FLJH49GtS9Y6UtKu9xmF5uxwO
         eI+rY9S/jjkWoOzplgjXCMqTcClA0ndKp35QlMr6KWBTpmFf9OsInuafRL0utB+LlIBU
         /vdJUikbjsT7x6f4H3veFQHzkOFyfCqId1BwR74P3uhqroyQc0kb2gIo5q+u1ZVXwhEK
         fjp2LYYz/3ukm0c7tvaGhqCCZ7o6z9mw7DifmV/xvMwNpi8yeNpAkh2/XRhyS16xLrdJ
         jBgXCYfzW8pci3DknpzuhmuQyFXC4miXUUHjOC3zP3ZqF9wUmlM5lrxmkUs21LJ/ZL+n
         ddbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794271552; x=1794876352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZkmTpzpvYUC7ntJzmKPOJ6Gzor9QviyvVoNYRgK5Xt4=;
        b=FckIgoD0JDMituxJXN+hBvBiHvvCZuBAxTYmaPphOh4PAVEE+7jrvCeiUouFGtCwhZ
         PrzddezvbcUH3phSn3mw3SEHjTCbLFhjcIO/tMsHMt5DENV8ZwwO0UG/Eyp4Ki9mHBSt
         npK09yLCiRzX13mJrznXHcRAhFouAn5tXohNAcXhu7vTMefWlbho2d1A8KeLkmLe1Slo
         53YgKNsZxpKFSPSZhoooDCJbsRezBNB9AvZwAqCW9vSbO1vjRs9p4b6KZ+d3wROUZGmB
         uXCzdhKcIPY6cK2qgB1Ig1+GsxmKTNKAHBR6Q67uM6Wryehqs1SyhDgDw90DSMf9mTuT
         EeYQ==
X-Forwarded-Encrypted: i=1; AL+hErGuW7njWgcpw7SWgk7dmql2LeURZxdCwDZ2xP3vGYG3PwFCyqA3kyg3Ze+V7pd9+fOaLV+Nq38K1Q1q@vger.kernel.org
X-Gm-Message-State: APuU4Z+7GJ2irDCVvLsMd/JukeEl7TedawyP/xGkOQdOyX2xMSCLJToE
	myi7aMEfu9f8Gjs3iapmxL4e+HtB6Ertx2pkjOqjw3b0WD749FVhVc86JYxMfhLYjis=
X-Gm-Gg: AYBFou0mWgNTPV/gFI8Wjug2a+NL+3LxULHQ49ZBDxozUPl7IGWRHHuZWYu7LeBrn5V
	F32LdHj07l0ZyHrlRWbxuYEpCSL7ms3wpVQYokWDJvmsFLe7YwVLQIIbIpjQcy4lPsVbJ+iB78M
	5J1CfxUQFOCRdKx8oGXnHTa8ubCJBS+FcHpgl6CBPpI7j84gqh45MlGjevBhajaovbEcmfU4+YC
	PAhLscgugqMheMog/MdRTQ7IuloRJbP5QOzSo4GqsnaPGg1RsA3yxDmQy5/pVjPVjGju/Yft412
	c6xIAer4wxEBGp3a14qYjbw5W6zbpYFapEfpGah0V0w+uS4AHgzW3ffchZ0jVEYpvadm+hywkUZ
	FctJlf2Q47U0utzOYt25wfPimXHuLk0+C7NPQXZl+gpLCCj0L/MmutTweIoT3a5dKtGw7uAQfdl
	WjFNgW3aSB/41yQ1rHM1mPrV+ad398qntWrSd9zw8MCMaw5+KT9r95RSqN7XcMhif0hqmiotvDN
	K65y5WQkwCO2xIB2+WkOgIhl/sB6UE1lQH5cTomNxPn6fHzHbyImOIKN5XyuzUSKYHA7dygM64V
	iU9TXjkoirlKlWhSDsb4UXgsCeySylmOZee7aTQ9CbMNAUloSRyi/YlQp5U3Cdxo0vkV63MU/wj
	mDsB78cV2891H65HC4atj9AoNyEjhMuoz
X-Received: by 2002:a05:622a:17ce:b0:538:10e7:da7f with SMTP id d75a77b69052e-55528109297mr16657431cf.46.1794271551944;
        Mon, 09 Nov 2026 16:45:51 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b9425c5sm10544221cf.17.2026.11.09.16.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 16:45:51 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xQZzi-00000003MI6-1peu;
	Mon, 09 Nov 2026 20:45:50 -0400
Date: Mon, 9 Nov 2026 20:45:50 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: leon@kernel.org, hemanth.selam@gmail.com, yishaih@nvidia.com,
	edwards@nvidia.com, mrgolin@amazon.com, michael.j.ruhl@intel.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()
Message-ID: <20261110004550.GT663069@ziepe.ca>
References: <20261106013908.21789-1-kartikey406@gmail.com>
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
In-Reply-To: <20261106013908.21789-1-kartikey406@gmail.com>

On Fri, Nov 06, 2026 at 07:09:08AM +0530, Deepanshu Kartikey wrote:
> syzbot reported a memory leak of radix_tree_node objects allocated
> while registering a siw device:
> 
>   unreferenced object 0xffff88810d78f488 (size 576):
>     radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
>     radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
>     uapi_add_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
>     uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:659
>     ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c:1196
>     ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:1503
>     siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:433
> 
> radix_tree_insert() can fail with -ENOMEM after __radix_tree_create()
> has already linked intermediate nodes into the tree, leaving them with
> no entries. uapi_add_elm() frees the element on failure, but nothing
> frees these empty nodes: uverbs_destroy_api() only removes populated
> slots, and radix tree nodes are freed only as a side effect of
> deleting an entry. The nodes are therefore leaked when the uapi is
> destroyed.
> 
> On -ENOMEM, populate the same key with a dummy entry and delete it
> again so that radix_tree_delete() reclaims the empty node chain.

That seems like an absurd thing to do, can we fix
uverbs_destroy_api() to free the entire tree rather just populated
slots somehow?

Jason

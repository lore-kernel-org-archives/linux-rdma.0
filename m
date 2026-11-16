Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840512;
	b=vt2zWVdvj1p0pNJxzqxcBgo0bpKXHjxpg+eKroxf2H91szMIOULC56QD4bP6VC2rj7a8
	 TP+ej1lNXBzqHJ6N5B/rVso/02p54mn49IggXt11cZ4oa9sLvW6b5TqxboYB7+e/hIfwC
	 Bq851EkP0r0JI9nonF39CUJYGnugv+VC/BEWN9mvhcs/p+uOw+RnAX5ACY7GTgnqLz5/n
	 zr8IhHoaCW8oeofhuKTbZ2A0ULzXypaltLiiNvKKeNSEkfiP/yricvcSFSgHljifYSAey
	 ZO4AofXrSxHxPNHQoIF2gVfEIU9ITAzgwR3zWR5CLtq1u15dWtbFMCOavQO4m9nOxEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GAMK2IKmSQFM9lcd0nuhN/Aow9O/KJwswXygVZN7m9U=;
	b=A3YFJbF9Tsmzf5xN6On/Nhwu+z+VXo0q/ykKno6F7slA068143nY8I1V1TqcQ2O7PD0q
	 TYzktPL+4GJbhZUH3tnsNfPPGf/Xz6grD95nptKeiG+w8Zwiprpc/khYyk2c/lB5M3pkn
	 ZOQslyK4u6mL3PM/38SSiTWHuZBUXlrVtVrAkfULeG2KGVEMvk3XpxEJZeni766UMubjb
	 abUj3kxOhWIXhpgtwtAALldzfmHr7puxdmnYfEu6Pr7cIiio6wDwp1X0nxIobNlUAgPVA
	 fAC2GyIpY4nfzii6f3QntDx+b/dvm6K6pZn3/ubs6h8HIemiz181uNNDqBNJjdQgWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AV28oKdl;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4EF606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F4EF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=AV28oKdl
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91e8938fd01so46327396d6.3
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 06:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794840511; x=1795445311; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GAMK2IKmSQFM9lcd0nuhN/Aow9O/KJwswXygVZN7m9U=;
        b=AV28oKdlXv05lYmzcPsRuahm9kiZ5E4rTL1sCib31eH1IpWzIPwxjWUnNdO3TxTTbF
         c1McWywJ5YR/ITdvCtz4fsW+Tkr1mxwkZUgewgS569StmuMmlBwQTYBeXPJxtchW0e3i
         1t4hTD0DIuq+/upZUQonqL5fwifm3eilNLGJgzh/kkUbOraJKZ9Q0dGwZzJLahkfZXiI
         WRhcRkwWfTTdg1XLz890ezCNWzxgbvq4pILm8Vgq59YrLrAW3MMdA0yeZnv8gp2pYLzz
         2LWMNT+vvLo/RQBmYLCXXKWjtidVelpbhcnE96AzoWmlwxzx4pHvzyOSOK5xkEEH7tAA
         7zlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794840511; x=1795445311;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GAMK2IKmSQFM9lcd0nuhN/Aow9O/KJwswXygVZN7m9U=;
        b=C7YJt9IZ4j8Axk77ypyImWFbUUmZtnEulMRNM3aaGBJTABGVQ4CoG0n4KcxESOU/bI
         x6UquSzbflW90WU7ut7nzF/07ztxZ0yeIIohnAVgrWyJ+5ipT8hobzHp3WRw7rx09kAK
         2dAFqEmsP9jasBfr89X9c0nLkdrB6y68Onb2oPTdL2mUp+HNcapZuVqXi3Xm9PjYCJjf
         jQCDfW0iVBEldQMGeUSB9e0zjGkPdvuyyk5z1SyWrIuXbMXRCOthWOfiIukAer0zXe3E
         wYtWz6zOWDAbhwqn/uJcH4JnZAgKwSslIdbU2b5rgS+d8oNroXufEU2Ik3pnzbNPWPxF
         CM1g==
X-Forwarded-Encrypted: i=1; AL+hErEgQDWLtEuheMxUEG4YjzCynLhXSLSjFQGLlaulZCxMYAjIusazacJr2C+RP4ypdEJw77uq3s7JZRH1@vger.kernel.org
X-Gm-Message-State: APuU4Z8PsKl5e2f6ZvDoPJQJdER/2mre1jEq6+GJsa8Wp08AQjQDXh1I
	pgBYPHLJ11M827eSRvjGdNxWYaFY0LO4W4jcRhJdN3xcFqeq6Z5VEzwLejv8a7jvNh3V77KQNSd
	+JuBr
X-Gm-Gg: AYBFou0GmEVeisu6nLcTts8Lwt6eOdIJMg0p0Dcv3wiwxePafciax2Vvy26RJGqJokI
	8vx4XusYObLIEnBSUxQRELLhqSFskU6+6a6cLPW7c4WgT5l8DONIY9WmyiGr15qcJLiQ407+/e0
	8mvDv0H54RLJzSv6MDyzkQtawhUok/qzDInIFJ6kcstYKvKhISesWcvUzUtDx72yEJPnXj+P6PS
	ZbQnARy9NdZcm5XMAZT4bHMtAxx/nIra03VI+sgpO+jBdEcMMQ/sgc6XIk8Co4KJ4ed2r6ZcudP
	QLFmphGV9jM1Scznxti5ZZx1RkID2oYH0YYe17LuiDf35h+B8Ok9S2JkAh/JhnkDk8Bas9nJJ8R
	8KiXPo1ZeMvxeU4K/FINIv7oS2U1/xVDJBHFMKBrFysMP2rFWRS6MIY4M5RsJfgm9sqQY+/55LN
	BrPAlT9Jk6fDqIWY4b4xH8EC9cG3I9Y22055yBS576sSwvBiXECqHyFs3k/zjYVY3Wu0MoNn5us
	2OkdyipvYC5s/HUy0zyCel84VrMmQJcXi/qZeQ8tqeRFSxL4MYV+NFNsXas9O5h45e2UsxQW9ZV
	BRAoLgI=
X-Received: by 2002:a05:622a:588e:b0:55d:37d8:5037 with SMTP id d75a77b69052e-55d37d85330mr62183291cf.77.1794840511508;
        Mon, 16 Nov 2026 06:48:31 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d70918sm86997276d6.22.2026.11.16.06.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:48:31 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSy0U-00000009VVo-10EN;
	Mon, 16 Nov 2026 10:48:30 -0400
Date: Mon, 16 Nov 2026 10:48:30 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Eric Davis <eric.davis@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Message-ID: <20261116144830.GN2532299@ziepe.ca>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261116143656.GA34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
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
In-Reply-To: <20261116143656.GA34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Mon, Nov 16, 2026 at 02:36:56PM +0000, Michael Margolin wrote:
> On Mon, Nov 09, 2026 at 08:00:33PM -0800, Eric Davis wrote:
> > Ultra Ethernet defines a reliable unconnected transport. A queue pair
> > sends to any peer in its job without a connection, incoming traffic is
> > demultiplexed on a JobID rather than on a connection, and what a device
> > orders is far weaker than IB or RoCE and varies between devices. None of
> > that has a home in the current uverbs ABI.
> > 
> > This series adds the generic half. The objects, methods, and attributes
> > any UET device implements. No driver is part of it, though two already
> > exist against this ABI. A reference device model that implements all of
> > it, and HPE's Slingshot driver implementing a large subset. That is the
> > argument for ib_core carrying this. What is device specific should come
> > from private interfaces per vendor.
> 
> Hey Eric,
> 
> Thanks for posting this. EFA's SRD is also a reliable unconnected
> transport (one QP reaches any peer, delivery isn't ordered), so we
> looked at the series as a possible second implementor of IB_QPT_RU
> that isn't a UET device. Other vendors might also want to support
> this interface in the future.

I'm not sure about this. If you have exactly UET programming
semantics, including the job, then sure.

But squeezing some EFA specific thing that doesn't follow the spec
isn't a good way to build the APIs.. Persumably EFA has its own
job-like mechanism for security that is different?

Jason

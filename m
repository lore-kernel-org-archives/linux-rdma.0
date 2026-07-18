Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FA538F254
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784389180; cv=none; b=hAE4qawS8+HexCMVG9xyinl9P9WtIgmGKxu4XzuFPto+3ZqQ/LFi+4f/G2SoH28T00B+V6ELlQdnX/qbRO99b12IEosRNcNUC1bwRdcb2B5WSF4UTFBi0uo2PeJJWOkFkWp9IIomo+ch8s9sripps9qvy5Y4yLnDj9gnQlcq+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784389180; c=relaxed/simple;
	bh=w/cQSSJw+CwXZdc2ipK0ZWSqiyw6IFQdC7x01sXck00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RF55tjOCWQgsEDhIgUQgPhXvSplbU6qPtKU/QqZ5GKW3Z0uJQgw1ZlpnYSPa1AACzz/l4cM1VpU1lMCNFyuVBNP3OpclZnZwGyh3RS6Ycl4DqwpFoYy404rvK6j6l/MYBnS9DxW7LjWeco3EOb3LXD3fQeyGzuEn9XTMaJlkxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Qt2742rv; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Qt2742rv"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e602d2c0fso215508185a.0
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 08:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1784389168; x=1784993968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tUgLi2+x5V7Fq31NyBOiMexpXFIl8ZrVq5R+BsxDVFg=;
        b=Qt2742rv7tCLsL+dvpVYlrQqJ0xS+7k2IhaE4PUxgmYBegt3jJndWIzU5SJ/ZUQCO7
         AUbucSpRHpFJ2s57obnuzRIJoGGcbSqUwz0920x1im7MHELUUWAaSkFVP5qpnl0FMIhJ
         5/EEHG8Wcays/d5M+DzNIVZyPA0alKM/jP1HwR3UvQrBTkczHz2BReWHx2BSsDYh4nCJ
         XwCTljSPn1oJlluD7Z/TK76fzHTi2VpQlPQke0P5Iw8zuZw39rr7m+3dg1uvTmeV6n2H
         loQvGJD8WcR7kCKLiHHbVnxV+6rkW62CP/WtqIHlX5eKUk5RxPrTmPvSgZ4UyS9apngq
         QFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784389168; x=1784993968;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUgLi2+x5V7Fq31NyBOiMexpXFIl8ZrVq5R+BsxDVFg=;
        b=UNcxPnDI6RGPnOUL6WoCVk1erQ7ONEwwvwvQMGC405DBPJBP8Qz/gAtdUctcQkCkhq
         vtbJMfDN+yAP+ewkO0GUsok1m7H6oAw934hBwMGWw4iVpQML72Yo4HlwGWKe1tCnx6CF
         UMN72VhWWYdYr9IwnzIVND8bhsu+9lr7AIwVBXZKzsCZGlioLY1mlh6v1spxn3ZdaW57
         xiAXA1NpeQd+zbKpL7FkhxTTu4LWFCVgVmyOyVpx/7b3xvA9Ultq/VyZIUs9aFGM60hk
         sP+Ozqx17uV1zYmZkInuK1R1zq+BZHjUQFdeUY/wyv5fMkX5ctJ7L4Xu7/J2Gw1qDTS8
         UciA==
X-Forwarded-Encrypted: i=1; AHgh+RrE5MW6QOlwMVjREMJblzz0NSEl5zcaRnfAx81s/JkXa7FML1jCyn91SYoE6cZx7D7Dux2NfLojAFvJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzEnfKB3R7bvwzCo/GecKHiikSXVrNP0qVk6OGRpAvXbflwfKPy
	Z9OuitwAqpbgCV0mEQ45c1Fbt/c1MngtJsgl6duaw7NcZY7iel/WIFi5fC3jN++MMNw=
X-Gm-Gg: AfdE7clozfR/3T5ZL6hC9qKHueDyi/MHSvf6rHftQ8mPnT23qM2ib6AaGZGNtCsBGD9
	N711UsMdMENERvjHGvgwGs6rzPZNeueFzUflOJ8YfHPdUkaavsL7GREkLshVNkCslWHp0e4qRRb
	23vMA3nZQAaEakiLNvGykQiO5K4Ke0yQ3lDMj7pO6YE0bszWCGfgM2qdnyqPj6uq1F3NtQKCfM2
	Wi9HSMUQej3cssFxybMunP8HbDiZEEjt4K0UgVtIjXdnIlicVm4mV8j24zI3Lvj2x/jWCJeZohO
	4LcrNargltcdkxD4kdAieuy9ZsUgrwhaheOULsMCdkLvIFsa2xfEHwqovpxm5bPAr2EIjGj16Hg
	Cr6mTxPkwgsXBZJn1AoQqCIpvObdLvPTS/R9ljzzQl/phiY53Ew==
X-Received: by 2002:a05:620a:45a4:b0:915:e426:8198 with SMTP id af79cd13be357-930b48654d2mr746661585a.15.1784389168217;
        Sat, 18 Jul 2026 08:39:28 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52fa8dfsm430088085a.11.2026.07.18.08.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 08:39:27 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wl78R-00000006Ycv-0IpF;
	Sat, 18 Jul 2026 12:39:27 -0300
Date: Sat, 18 Jul 2026 12:39:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>, David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
Message-ID: <20260718153927.GF701389@ziepe.ca>
References: <20260718142642.102924-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718142642.102924-1-serhatkumral1@gmail.com>

On Sat, Jul 18, 2026 at 05:26:41PM +0300, Serhat Kumral wrote:
> I first tried the literal reading, one bound socket per GID entry,
> but real addresses get in the way: default GIDs derived from the MAC
> are not bindable addresses, IPv6 GIDs are added while still tentative
> so bind() fails and nothing re-adds them after DAD, and multicast RX
> cannot match address-bound sockets. So this version keeps the
> wildcard sockets as they are today and only moves their lifetime to
> add_gid/del_gid, which is where the actual bugs were.

That is unfortunate, but this still a big step forward.

FWIW the tx side also looks really weird, it creates a sock per QP in
the init_net but that can't be right. It seems to me it should be
sending using the per-GID socket instead.. That's nothing to do with
this series though

> The pernet exit hook survives in a reduced form, as a backstop only:
> event-triggered GID removal is asynchronous, so a netns can be gone
> before the last del_gid runs (most easily by moving the netdev to
> another netns and deleting the old one), and something has to close
> the kernel sockets before the net they live in is freed. 

Don't get this, GID removal is asynchronous, so it will eventually
complete, what is wrong with leaving the socks around but unsuable for
a little bit? Does something break?

Jason

Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D3320CA7
	for <linux-rdma@vger.kernel.org>; Thu, 22 Jan 2026 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769090897; cv=none; b=livxNf0PDUa5hqJPHEV8hcANdvj1lCQ4N5xrDQxmQMPRx2Jn6G0jkyPz6Qpxq2lfJRqH/67YTji2kd8JnRf9idDoJ6+X8Pdxs4JgW0yeM640Oui2QUndRhQnTmqV0iYLm0Vk0lvd1txhLAR2zAapYNW7qUUGCIghVeqYOe4AHMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769090897; c=relaxed/simple;
	bh=OhR9Fws/m8KkhPyoy/s2nyPSurtBYOgALRwZAV0u/to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shI0BbAJC3bPoXs42kLaD6CssfnrkY00EeunHi9L3E+p6n181nzSe9JxLhnmtOA4TFdwE1x+gTZhkmpWYDv0UrhPCiTfbwvGT7Ob5w9dd70lpqh9IZus9/lOKKUNsV7J0sF/VOpB/reiea1e4SgkFl7zRc7AkY4YsnbOPTtU3JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ChusM5na; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ChusM5na"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c6ac42b91eso99941185a.3
        for <linux-rdma@vger.kernel.org>; Thu, 22 Jan 2026 06:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769090895; x=1769695695; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OhR9Fws/m8KkhPyoy/s2nyPSurtBYOgALRwZAV0u/to=;
        b=ChusM5naIBJXvJJbGrgN9lWLCmOG5OQc1vbGue/KVwIXgJKbkrZDcU+ZFzIDlrL0nE
         7u69/2GEvJoVMCLhUUPjiMgmVZ0+38sz32JEaeWc7OwoqFIsHoK9breKEvpL+oUjWsu2
         d+CQ+Orh04LGq5IMnVLrmLKKS7jVNMBJpvnOhINaXb8Jihnssll5c65S3pxydFLTwtj2
         cQz5sGa+dHjReY10hIYknxQ00IK7A8DIPkmVZ95I2Psk1o3+lnD0M0kl2q/DJQnYIY2A
         k+WqJ+AoFeyT6AMt5dI+ZH9jr0CRF36qEZ+4EDsPSwn7aygpT0O1j2Eli9IEefoKS+bd
         cSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769090895; x=1769695695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OhR9Fws/m8KkhPyoy/s2nyPSurtBYOgALRwZAV0u/to=;
        b=q2u+z5zChMrDF1eeUXyVGJLIi+U7abaVBm0xYM8rnkkWe9u18+dmaVoceMJ0ODag5Z
         VKH2JhHqpeNdGrtZOefFA+CCd6asMmGaQGR/Ymb9dD/2Yaa2pAuoCt710kefNBVtbQI8
         Nuuzornbv4VV7ELaxKYNYTOACvNC4WA4d2JwqLZ35Ghqnq2ui5SXaJOGeTHNb2ubk5AL
         Bm+X0zWPnd0Wn8rZT6Tgl3ifrdE9kY7i4hmFx4VW2ucI+tMCs1m9ZT0s1UtzCL70pMzg
         o3unTlCDM6ztrDzlJxZ7mh9CAEOnbjl9zmpe2efko6T51FQc6LBwXx5M1OG5IcL/Ms/O
         AUWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW34FXswJ5R47SzgcwOOWgdUDR1sMSmR3WP5/lpY1+TBUS5HKc6hHsd1FQqAKDfmtU+R19ctf/bwRwM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9ngASltFhybwEq+YXBXh4DRv0ld4BWmVWPxZEBGcxxcqIai9f
	Yti030Yd9iLgrBTUp+GyMoQf2SkejnYtrdi+NGeBy6s+TcgkmfewHsRJei/LNwO24YU=
X-Gm-Gg: AZuq6aKtDySb1dAZXT/d0yFn7ZzHCEYjxM6SEOhlit1a/PJ91Ev7OJoXAoZCX6MvLnj
	f0VYo8CaFic97LkIeMVetq73lL3qIRdN7kwfZ/TmH791cDxJdqnGJf95fSXlwtbFDA6ceR/533Q
	5BvgZDoM9sf6WpPG8XaA8cfWFZ5gDBGBFY3DLtSPU4P0M3efb2qtiD17XAjPzlI5qC4GCZoa5PL
	qxPxKdbi5OtKo+xa3YNfmWwy4Tv6zt0Y+mlbGJ7ynO1sOSWMCr8Z8bn+Y5au1p5UyEd1XP94ZQl
	qM9PMz1xlZ665jlqy/gTi2a7OLHOvn1NZnscLgxAcW6PM9ortutq9dLSkAaSXShuw4iDDHpPrWr
	jv5SYzrdppkL6WNGYBvmaMjhQZpZJMD8nKXEfIkoymQANQZo2vhdvzAWeJVgOHV2UFNITnfwjh8
	TGkyPLbUCmimIfcJLdZgNHAdPwAWGFELCQM7H90BAFLKAp3kY+YQkdNP4N6Ntky20hZCo=
X-Received: by 2002:a05:620a:4693:b0:8b2:dabe:de32 with SMTP id af79cd13be357-8c6a6764a50mr2785126585a.42.1769090894650;
        Thu, 22 Jan 2026 06:08:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e60428dsm157923986d6.22.2026.01.22.06.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 06:08:13 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vivM5-00000006a95-1Z7k;
	Thu, 22 Jan 2026 10:08:13 -0400
Date: Thu, 22 Jan 2026 10:08:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v8 3/4] RDMA/bnxt_re: Direct Verbs: Support DBR
 verbs
Message-ID: <20260122140813.GJ961572@ziepe.ca>
References: <20260117080052.43279-1-sriharsha.basavapatna@broadcom.com>
 <20260117080052.43279-4-sriharsha.basavapatna@broadcom.com>
 <20260120185419.GU961572@ziepe.ca>
 <CAHHeUGXtiDezOVwmFJ3y-0daHD_3ENayqtDJUSHnDE9rVRiAKA@mail.gmail.com>
 <20260121165216.GH961572@ziepe.ca>
 <CAHHeUGUGGQHRySzgwM5Orjgj3GYLUQHB2LCzZDj1CBGyZJX3wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHHeUGUGGQHRySzgwM5Orjgj3GYLUQHB2LCzZDj1CBGyZJX3wg@mail.gmail.com>

On Wed, Jan 21, 2026 at 11:04:48PM +0530, Sriharsha Basavapatna wrote:
> It is in the next patch, you probably missed it? Pasted below for reference.

Yes, somehow my search missed it when I was looking

So it is OK.

Jason

Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183104322FF
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385199; cv=none; b=g1XDbudflz0sn7BKRail4eTvxaWtZQIz8CBNANpc3r3+xFqwJKrdT/KfM+NmsVN2Vr0ODvmWpPhPP0Z/u5aeiISzNA/kIkxybvIlNKcfG+7rUudYBXJayUWXNKLjdzBqoWkLjSH+f312ppZKp6K8uziG5K8YY93dOOIqBcSFFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385199; c=relaxed/simple;
	bh=3XQTEl87rcT7K0YPM4FaaHiDM8iol1edcE+ahPjC2vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtYPaTozJaKXpW5ZWvYZ5GxqZYwLknARzZbBhptIC6ykD+QaTE4GB/Zj/fywULYw1zLRO5dzr89ZST10o+jPFln+2kg7dRB016EVsYIxXPyCSnA9HusK/KkGuvCgWV2H+G9g4+xXlOoFxa34ux2wXiPOXCqXz0h2wajWrFDQKnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bCHMhydq; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bCHMhydq"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e67555e24so92412785a.3
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 11:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786385197; x=1786989997; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CueWrjGWlIutspn/0GdpWJ3R73teZZOqTJVEIETVfz0=;
        b=bCHMhydqZp+PyUiXrYYdXn/KyYfS4v6F+VFc/c+syQiJ6pm0fSAD2KG4ucu8ITnxfm
         jHbqbHr4VcW/xRiqEUgi2Pi6F1Qy92UoaTWF9pm/ip0h2vTwj3e/8o9Z21akDrcOgPtT
         RhsBp1K9a05jWhcjnCO+5jKXME+pFSq8BTiuQyKux8mnGR0gT/CpnJM6dUHXxHwwd+K6
         jIn9X3ef/67kw+Jl40JxB2F2tnPwzXGkWMFcyp7Wmv1n1VrRM6Is8fs0co1Jv5Caxnzo
         o3cvFbhKtB2IhHXghgbmGBU95DKt6JWApkGMpZVvPkNCTgDl2WBVS7eC94kM4heNHaFW
         yqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786385197; x=1786989997;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CueWrjGWlIutspn/0GdpWJ3R73teZZOqTJVEIETVfz0=;
        b=XEriS3kerKiEiAzbbUDs6SZ8HfrecQWal+nZfVrqAlNW4abh6zvKMLpiGdJNhgY2cM
         //Bb/cVZV2MXGFBueTz6itzth/2jHZ2sL3mgTDtjYuT/ACUi7Y5Vn/T/ddz331uLM/aL
         7VWZf/Ripnt6NTwvDrRrRhWr2YCnVllQ30cPNSJ9mLY2c9m2gJWoox/MbEakqLJEhwPN
         SlDdnoP2+qeCjtfDQ6XSMxKxFF9FAsucce8TG/6U9bHCHWkphA4CCjkWTTJUF1IGUGlE
         Zf2GTg4U39o9oe84jvktJ1rzeN6KYYh+Ml4wBIuqKGSCHH88ZKhkJfoAhhaEq5b0frhU
         JsNg==
X-Forwarded-Encrypted: i=1; AHgh+Rqehko973kyBDnPBPO2oFgTjgU6d2nz3dHWzcPYH2TlZNeHSOeA1zPZIuNWH0ZFgaQvWkhedrMrrO+p@vger.kernel.org
X-Gm-Message-State: AOJu0YyP+2vVTiIPIpdl77/iDqdmja2rZFnaANhqHb7ytGC3VZdwQEf0
	VEJONHqRWnqqQmyWyDPIqTOAxReqgppDddcAVPzV96OO842L0Gj9M7XKMH51vyIOzHM=
X-Gm-Gg: AR+sD13TfgnMAaYtK4FfoP+BeCCA8D5JBuw5YxavL2gZYIXrwxRIa5X5Fs2nya/5SC6
	bAUUusnPEBeZNcegi56l2TrX6PqOB84BEys/vLjIwQ3Y9KkKodNYXz6UEkpvI3hPCMD/baLPJBU
	lCG4hsjUsldKcl/rckwQjzmRg6WLgkpOFFyajOZ1Haio+EQwyPbPJqdu812pzRRgiQC5EdJ7Hmy
	bjwZ2a3BRuMbB1WNwg5sR1tWM9L//DbC0lnG4V7MsL7KRKXnUfQVHr6F3c9Jnt8NV9NhS7o2mLr
	hwGqLbLMVLPgrG3lez8JGeZ83/qUDTYD6H4nUHvouEudGCHf1+ZMYw15aywRMg3MDknzdkzzVTV
	f3WkfpEobR8Ijs9mlaA7CEKlNJbsCa8HhsdcyCpWh0PXS8vp00ssP0xolhTKcZ76j3N8M4WtlQc
	IjtAJ04FCKFNBiIpXFYAeGY0zqnoGMmx0UDtkKzg==
X-Received: by 2002:a05:620a:a29b:10b0:92e:57ae:3a53 with SMTP id af79cd13be357-9367973c997mr1812148085a.9.1786385196871;
        Mon, 10 Aug 2026 11:06:36 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e0ad602sm847231085a.20.2026.08.10.11.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:06:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtUOR-000000028kl-0kmm;
	Mon, 10 Aug 2026 15:06:35 -0300
Date: Mon, 10 Aug 2026 15:06:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>, David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from
 the GID table
Message-ID: <20260810180635.GB507588@ziepe.ca>
References: <20260718153927.GF701389@ziepe.ca>
 <20260719175447.196499-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719175447.196499-1-serhatkumral1@gmail.com>

On Sun, Jul 19, 2026 at 08:54:47PM +0300, Serhat Kumral wrote:
> > Don't get this, GID removal is asynchronous, so it will eventually
> > complete, what is wrong with leaving the socks around but unsuable for
> > a little bit? Does something break?
> 
> I checked this more closely. You are right that a kernel socket's
> passive net reference keeps struct net itself allocated, so my
> wording about closing the sockets before the net is freed was
> inaccurate.
> 
> However, the passive reference does not defer the pernet exit
> callbacks. cleanup_net runs those callbacks before dropping its base
> passive reference. With CONFIG_PROC_FS, sock_inuse_exit_net() frees
> net->core.prot_inuse; when per-netns UDP hash tables are enabled,
> udp_pernet_table_free() also frees net->ipv4.udp_table. The eventual
> udp_tunnel_sock_release() reaches udp_lib_unhash(), which accesses
> this state while unhashing a still-hashed socket. A sufficiently
> delayed close can therefore access freed pernet storage even though
> struct net itself remains allocated.

I'm skeptical this AI conclusion is right? Or at least a leaking sock
crashing the kernel sounds like a netdev bug, not something to avoid here.

Jason

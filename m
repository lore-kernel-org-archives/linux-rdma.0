Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEAD33D6FD
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 11:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787399248; cv=none; b=C5p19tmSa5/kM8v5JQk3GTt9OkdbmJEdSJzNk7wiFmscHEwA0Q06l8TCE8lz1LnnviKCoPulazL826yzfWi1lOMixzVTjhqHzzEMqxscu5sMla2G7l0SHUnMl0lu1kYLyBae3Q4PhdS7JbCn44EBqPdAOVBpwvOU6QXw30g2py4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787399248; c=relaxed/simple;
	bh=Ffeo/1lcOYASE/v12HMQ2b/sOz5g/7qcf+xhVlwLQVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYPkSUz/yE7ZEmz1e9oIyzpAkIJTNWQFHy8cTnSyfDy3I60y+CFbeTI0DwYi6SJ1NvDTsXL4pBOZHxXsgOcl9orQv+S44Fi0fDF7ZdHBn8e0Mowyw5p5OypFp6yU41CvoRjnQTvx7sk3Sv2wvJ8SPxPlGMuehKUQILCDq1P2Y6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mm7dxCEM; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mm7dxCEM"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9061a795d76so20737446d6.3
        for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 04:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1787399246; x=1788004046; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8rW3ecT0AZniCJ1PdocTqb0+9uR2+UDPN17LvBLXUT0=;
        b=mm7dxCEMHRpkOk5/gu6ts0yPR9d+69dRZ/IbzN07CA2VukddScGF43TdpRxtuNBqLH
         213mtKcRSB6M8rUUX1T+ujZYVevPvTt+txIwUmsKnY3IufU21wngsYS9AteqLkiAIpGn
         9+knVG1buJHrFM4F8i3P4PaW/egKG21vHS2ItZFoENEQyGC6Dx6qmA9q3A5TALroW6e0
         D3csYBSP5OzmyM5JzcADaAaiBnnLm2RT9YC4ODTQK55m+tWqHzHuBlPSUUoiF94TvHXz
         AmogE/IUE1GTV0JIXrans2dk73gQo6K44XbMi9qn7LEXu4QMPPK942QncShHBCRl2Y7B
         FCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787399246; x=1788004046;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8rW3ecT0AZniCJ1PdocTqb0+9uR2+UDPN17LvBLXUT0=;
        b=PdapHxAiW9uFczOqA41nFfVRH0S1jK0F2JKRAjW1D8i7f7iqbMbA9D2dVbC0r60Sp1
         R4CmC7N5lT7Jzi2s0LZjxxERR95Gg4fxJHu95LzfZN2t/Z3v6E5WmESEQzOw6Bef/7Fc
         8HXNwDRrTqIWHofZ+hIpuub/WbvwsmjFVO9+9MF+1xEgjSINW16XdZ4IraEhJkbcXRun
         1N9x221cfKaew8/SlvSSjQf2UwupoHHuooR65zyYRWgPHk8mOXQyHiCKDcm+/eVDYhF0
         9lz3yJkbJNVlt0bX2jbXP4b2+V+o+sJZooqnBbb7E3VO83iGyuWdeOWWF1I4UIC23flC
         4aVA==
X-Forwarded-Encrypted: i=1; AHgh+Roi8nbwGX8Y4FYSJ5ym25Ahhj/sCzF5Veg0KT4ISQ70C+ruQyN9bLhi4KkwdLX++XGiKyG/aOFeZ3i7@vger.kernel.org
X-Gm-Message-State: AFuF++njsIYXZKlBDNqPRJ1IzMETLNXSt2SYqhDhLFECl8IA6KXUSu5q
	q13kawhyueHS51WguNyT/u0OCZQvFr6A/GaS1oJiUwasy2FLqHbN+d4+/W8vkKZL+uU=
X-Gm-Gg: AR+sD11cqZrcs2H3WOh9n+FF2+dFNdF6RNA4T0XoSdWjCZb2nWDkcX7zltKsZR8EHvk
	TlhZJ6vRDrMbk2xvCbrPMVkHWGUNw/+yzgcNYW1szYwc0Ag6wwYpNPufDE8awodM6DgiPB0MF3U
	gPiEHCubv9hexjaGPA2Tr9n/KCuwTLM+0NoBEsCdvqYSU2M/o7pOp83KrCRCgsvWG6xFBdvv3hB
	ev+h/t88f8giPzcr2Y6ZRUFuofmBAvZUo54GLuPeortNbDxsbc3nsrepvlCnEHf9OZhZSyvwq3v
	BpjBahMUuw0YbJuRj2ExIBqnsFH9WOSC1NQVOTH9JRrWI2/xYQq9AKgixHgVco0XHcV+Doyy+MR
	vGUPdmjvGO6DhQS+1Ywm11xboDly1l0AKYzISOt28FqP9QA6VK9FX1yHXXzZ/pV4yiJIrcj85Lk
	X8c2FfRV8vgijWZsi+15mOEDlXi8yTb7hZmhcy34h1DPjwOyepgzoouvfFlw+0AdOyNwH1ZbOhI
	Bsrr4zwyQ2h6fs+Fd6Qk6Y2oV9JCI9077KzTE7mTAm3tL/B+XQ=
X-Received: by 2002:a05:6214:5191:b0:8f1:2607:ad86 with SMTP id 6a1803df08f44-90c80943ba0mr118771166d6.4.1787399245756;
        Sat, 22 Aug 2026 04:47:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c9393202esm12628166d6.27.2026.08.22.04.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 04:47:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wxkC3-00000008DOW-0dnn;
	Sat, 22 Aug 2026 08:47:23 -0300
Date: Sat, 22 Aug 2026 08:47:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yanze Zhang <zhang.yanze@zte.com.cn>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma v5 0/7] RDMA/zrdma: Add ZTE Dinghai Ethernet
 Protocol Driver for RDMA
Message-ID: <20260822114723.GB1449020@ziepe.ca>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
 <20260822080723.3166603-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822080723.3166603-1-zhang.yanze@zte.com.cn>

On Sat, Aug 22, 2026 at 04:07:23PM +0800, Yanze Zhang wrote:
> Hi Jason, Leon,
> 
> Apologies, my previous ping was sent to an incorrect address for Jason.
> Resending with the correct maintainer address from MAINTAINERS.
> 
> Gentle ping on this series [1]. I understand we are in the rc phase
> and new drivers will likely be queued for the v7.3 merge window.
> Just wanted to make sure nothing was missed or needs further action
> from my side.
>
> [1] https://lore.kernel.org/linux-rdma/20260811093740.2607476-1-zhang.yanze@zte.com.cn/

Nobody has looked at it, you should be reviewing your sashiko remarks

https://sashiko.dev/#/patchset/20260811093740.2607476-1-zhang.yanze%40zte.com.cn

Lots of good points in there.

Jason

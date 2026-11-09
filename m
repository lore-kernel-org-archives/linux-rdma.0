Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794207198;
	b=ajm3je0QbMVLSOyIpYVM5PWftuWCi4gIRlgziVWa8eAXR4JYZhOM9P/g/e7N0Y4nzqcX
	 /QzO8bRMeIeGx0kkcr/YNqWD9Cbrh+0Dt49ES/vfquIjXxga6N2HMVe4Ptq2upJGaqrbm
	 2G0rwHyYTJPtfUOOzlTinnAtdbGgQedFD5JCM+tB+vm6UCH3jCGlG+avno11v8CnhR2HH
	 CRPl9Ji+N9FBb6u8w4FscMRTlzmhVWhGFDBdm/ZCqoScU/qJKGTysiZNbIdQrcPs8x8xE
	 SjTKGhYxc6uvFF6XgwzJP1cdZY0pAenel4SFpOUZyUSevpN0scXVD0ihk8ajTZGhCxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
	b=ulgYTRzCssZEv8AbOkZ2qgEIFIUuJJH91HohYEOCTzdINqSVKCsgJJHsG1eDJCUcZIEk
	 dYfnpCk4vpS7hShZeFsrZbqktEs7nPiFne2EGfAvTtxy8mvTldW3jKyR3JOrn6Hdhcqgb
	 nnjTjWvSb0zw5o9OMaOg4/N+9otDKciOizvOw7z9knw48E5vlFOB+7GU/7ObmFcNFxxa1
	 SVeIaG9FGGilccR4YKbY/EP+L8EzCEInL+RizAuiyR7/3xq2rpdOs/VYpQlj1JhVK6z1E
	 j8RprEtgeTdx3HPXIlp2sMU+evHOlCrAjtgvy0Vu8ualvDgt76quPOw087C29r2J3Cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB;
	arc=fail smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C16B606A330
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 06:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C16B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sgWujCEB
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c14f3dab0cso293178e87.1
        for <linux-rdma@vger.kernel.org>; Sun, 08 Nov 2026 22:53:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794207196; cv=none;
        d=google.com; s=arc-20260327;
        b=gJM/O9MuBYro6FBSTw1RVWZ7awbS97tGevtyzW8byAC/jSY+fSBgkEESKIN6CUw2cS
         Q2zRdl4RArU7AKx3rmq4TKLv+1C4vRjzLlq7T96xBHQeD+xsekAAbBxceBxYR77anAfq
         jt88Dq3Wpp9ZcSIQFcdJhT/De60+tdu9cI2zm/hmn0aWGF/kxVEtmahju/NV5scX4thc
         KjB+EijndDfYTg44H53SpdSyB+/TQkEuixtE06Fba2pVUlttH+gBij5TcwfOY0LtahA4
         3+K9O8Mm7zhqMJmJWgrJkjV5WtZs2PiWZcrBeEAkbTAmPigKWoVb+563kCCyVWfFCbr/
         G18A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        fh=+NbApAniQxgmy2xiVBZD4jnsO7lUXnKjGRtkmgVHYJ0=;
        b=Y5+HH2MWeSZfwCzQ6dRkjm0Y8wna5DMUWu9Ji/aWRG5ek9dOq2hL4Ofh2bMTNyYCe1
         Izl46WSk+VnnkNVFvevHoqwuVeXhsmEfbqK05qL8aDL9eZanH+S/44Fz7ikiXTeDHVdH
         slLmvpateOQSe+YkpVc4HLLaCw9o0CUY81h8eYbjAfDnbbBxLitznSKg/HP6E21AhGsC
         hvL6yaQ02vwliDPRundBO4Jgty6morMoEkQ1q7L2U/eXKyLYbgPF3CXsPqep/IpRItr+
         HezRHSYyIa32giSnfCYoszfg8ltA6wSvKnjDjKqtI1vUcjcSi+jlT42qrz0RQzuhjyBh
         wjXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794207196; x=1794811996; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=sgWujCEBcLnI2rCZx2+HrV0hdHuKHGWZkbP/T95hfWdHOsdro1qJU1Fvk+8OO9MdfB
         0BqsBZTh492PGUlz+uiD5cFVvZc+vlVmSZhYzi+w/tlD80Sl6tEzuWFCWZhv/N6pbH35
         rLWt1UHkkGkHK24Z/h6vBhtLRJVzr1jbqDl3LlT+eJtmAmj2BiR6ABZnJcxKkIEwjeuj
         rKb8qVeksOei/N1ZYTOxCXuIYcRzPS0XXno11fSFmwYvkRxmBZ3+yYmHEczZNKiPx5RZ
         oHt9g8LUVuNFkbZtPXFWBtwsCaMo3xAJFO6XAxUED9WmEkoDJbCWdP6YC+ZT/ijPGBxT
         E53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794207196; x=1794811996;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdfSMn5qmUAvXVccrNmls1DypVGRaJ++jbiwGI14+kg=;
        b=Odwxl7sxeCLjGkf2sXruIp4CHTp9Teld9GSKV9Ki8hcvhqzlWOrsYNUwvK17G0vP0b
         MtUbmu6LrBdKBybTt9CgyNUGKGZQFfc8YfXf2u6HSNrsCunLC9fXuXuEJMlnXJkYywsy
         V9kNql2ZLUw0lHFCWQyKN6MciGDDdQ8zG5DIzOVgCKqtW1+mA157cZ4Mz0zZTgLh2UuL
         fv2krc+O7h3z1mKHaR/IrVwSmFsM/+UB1AIFTppLUAN6YRei0IQy/rl+eQolTiQdZlGQ
         Pb0PuwL9P7Spm8+CDXmfCUMxd2hixodgVrb1wE7a6vbYjctSr6zQZlrmLN6ZtqXh7Uzm
         m2tA==
X-Forwarded-Encrypted: i=1; AL+hErEHKwSp7jp4/wfPtv8hxoYXXXryP5tsTbebmO5H21waVrE69ApTR4ZIR7sAWRIoobS/ULUHp0LhcY0w@vger.kernel.org
X-Gm-Message-State: APuU4Z91txfzHFUtwQlzcpEiLShAEAQJvr9Rped4bS+pk0Fjh8U4v9ws
	eizDJHqjfbWn0I+Jadzj8Sln2rGCoLVslcPrJAurM8/va5rTrNF2xD9j/4lj2o/Gx5gi3y8f+xV
	fIqVREhc6sbxqZptL63+AhgpxM6kIE50=
X-Gm-Gg: AYBFou0sHUUiF9Ex/Z51XK1zioB2XZgGTyQtrc+kqC95/1HXHF8CYDdjtFq62Rw1Yhs
	DKg/FIG0Sqkbgh7UioeB6qFn7osqJqs7qWNTM2KcZznxNmSYSo+h2aA3cy/TYDOQBBkqP/tkEI5
	8i9AP5Q3ygnveYT4owIl8aphji70hwTCGD9fT45AMJveBBpEmgMNBO6G5mSUrqmftxv5m3ESxzw
	GMgFq1DrFE9NjhL0dG8p1ExDyNazzP6BN3qHYVoWFgcqrHnSOW0JmqTH3SGdk9seSjGxZHyHDVf
	6gMJJd5SdG06VxUVVmDPnDW7J8f97hNuc0A34YCPrpWDmWqEOeVH73WZyjbhv3oEodMZiwX1ItQ
	t4V/b6EkvuKHaaLi1oLw0OpvHQz7d5C195n3YvrMPSi3uM3cOl9bJBrBEV3ZrKWSYhSQMsFDDdQ
	7qz4on1O+G5lBVBl2XgajuWQe6IdpGvE6rbNCzw/myLDY4XICFcEk=
X-Received: by 2002:a05:6512:3e1c:b0:5c1:4a48:c2db with SMTP id
 2adb3069b0e04-5c14c01f805mr810751e87.43.1794207196170; Sun, 08 Nov 2026
 22:53:16 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com> <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
In-Reply-To: <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 9 Nov 2026 14:52:37 +0800
X-Gm-Features: AclHuK9hO_h4FFhel_M7AacjBweA615sygy6vgIfEMNG5ukVHhzyCYoysXzMOxw
Message-ID: <CAL+tcoA6_gROiprd7YgxvwbaiuzEUPfuWTNMjKu6vDkbUJ5KPw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/14] net: annotate data-races around sysctl knobs
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, Paul Moore <paul@paul-moore.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Julian Anastasov <ja@ssi.bg>, Allison Henderson <achender@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	"D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev, 
	linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, 
	lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 11:33=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 11/9/26 11:11 AM, Jason Xing wrote:
> > On Mon, Nov 9, 2026 at 10:55=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linu=
x.dev> wrote:
> >> While testing the recent sysctl range fixes I noticed that a lot of ou=
r
> >> sysctl knobs are read with plain loads while the handlers update them
> >> with WRITE_ONCE() and no lock, so KCSAN reports them as data races. I
> >> then used an LLM to go through every ctl_table under net/ and list the
> >> readers that were left behind. This series annotates them with
> >> READ_ONCE(), and adds WRITE_ONCE() to a few custom handlers and netlin=
k
> >> paths that store to the same fields with plain writes. Most of it is a
> >> plain READ_ONCE() at each read; where a function reads the same knob
> >> twice to make one decision, it now reads it once into a local, so the
> >> comparison and the value it acts on cannot come from two different
> >> writes.
> >>
> >> There are no Fixes tags. Done one knob per patch this would be well ov=
er
> >> a hundred commits, so I grouped them by subsystem and feature instead =
to
> >> keep the review manageable. If maintainers prefer, I can split it up
> >> further with a Fixes tag on each one, as several smaller series.
> > Over the last year, I've been thinking about the annotation stuff
> > especially around sysctls, which, I suppose, shouldn't actually affect
> > the real workload but does affect the outcome of the syzbot.
> >
> > Out of sheer curiosity, my question would be what is the point of
> > trying to change all of them? Or what kind of benefits can we get from
> > the big series?
>
>
> Three things:
>
> 1. A plain load may be emitted twice by the compiler. ip_error() compares
> peer->rate_tokens against ip_rt_error_cost and then subtracts it again;
> if the sysctl changes in between, the u32 wraps. A few readers have that
> shape and now read the knob once into a local.
>
> 2. Tearing is not involved here, all the fields are at most word sized.
>
> 3. The rest is the memory model: a lockless read of a field written with
> WRITE_ONCE() is a data race unless it is marked
> (tools/memory-model/Documentation/access-marking.txt). That is what KCSAN
> reports, and why most of the series is plain READ_ONCE().
>
>
> I think the benefit is doing it in one pass.
>
>

I was curious about the REAL impact. If this thing really matters, we
have a lot of work to do even not only in the networking subsystem.
Sorry, I still think none of those points are convincing enough, but
that doesn't mean I object to this series. Anyway, it's just my
2-cents.

Thanks,
Jason

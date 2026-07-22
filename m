Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235513909A9
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754302; cv=pass; b=EuQPOhaLTc9fqZWPVBskSxLYQmO8dwbNL0hjW0vnbuoL5S8xijfWv9d3N1ezx4iK5Wt+tjsr9VLDkgadWESVy+QGVBZM6SgCNvzW7ex4kulb64FyROO+CclRKDhYkXYDTLxP/evjZS7OqB3jYfpLT0bsN2WKQdfmEGqifkdBvPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754302; c=relaxed/simple;
	bh=3Ud/eJZ885DI0uvyEPBefXy7Bq89ORWUqmJr/QiDlnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GXCFRumUU8GPyHAS37/+CxpnfeJMCxMeRSLRaTEeRjHCKjipUHWCxOii+kxjsV5TvoHxJUBSm4+9y33pOL9GIjD+Y7gaeLtWII10E1JRk7eY7fFO01+uIAVupJsDqYLpOTQHRIbYCzjcLFIaaOorC+Z+cTJFTWMRliPgkYWLyAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Lg4410v6; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Lg4410v6"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8487088510aso13095171b3a.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 14:05:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784754300; cv=none;
        d=google.com; s=arc-20260327;
        b=eb2GoRvxfVjArqjyyh/4vuit/wLgBlRzepPnd95hnZE/3bCH1NKkyqzsOfHP/n11l6
         0IJYETJqvK7cEwcnFtouy1OefCX4QMdDTYx+ZRbo6TBa7uDo5ld+gvZ76o3UBNQ3jI6V
         kkLtDlwOuYKw7aO/dfMjQdWGGs8gdaLURqHEpWL+Z7mBT0Un/O3T8ylB8SNIftV/emJl
         ofyUwxZvv6SuQgOpcvjzOo+6jZcA+dbEFqIZ7Gi8CBZw9vdN3qiX8OXqZLxdI9CPL2VY
         nUTqURepVL0UKMnMYGPxbai3efxcWoNmAPAqWWCW3oKVHD29B0WlK7ksaCP5rjAM7OOE
         xlmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NCrGV/IvczFQuzgiCKvrMbx0iXp5RvXYGgSS+cNIwso=;
        fh=BepKMsrgl1kZcKNXH4DO4ZuLxvd1gH8eJvB1QK4WR04=;
        b=fjUvEAPTm9ok5scgTvLiZgMAUNuxhQUSjrvwzdEwbllLtpGqVttPEP39qxnfenOM38
         k0C5QLQVVkg5Czz78Ob+FlQurOQ+D0T/qMo4T/qJG/SWL/yh04GeVgB1dJMkIWBA8WtK
         MRJ4M4KCzkHFZpsSRM6IkP60kAv7OYxmSA9aHZXD1Zeudo2bFCsD50E180/Ch/AFE1ey
         0vJBQoMTZmv7mqxYYmB3SNnlUDxBwEy6K1vyA5K10nAdjkmaaaxlwbK8OIX99aeUIrWG
         pzaqKN1lhsahQCknOJ8S79Da5EM1fSPNfCgIRs9xLmFggaP3cOe+7YJ1UTlJ+khZfz1T
         hmfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784754300; x=1785359100; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NCrGV/IvczFQuzgiCKvrMbx0iXp5RvXYGgSS+cNIwso=;
        b=Lg4410v6uApZY1JYDXR+vObu2K3gd+LCTNjQI3Z+yBY8bsVyfEewLRxu0WEY+4Yq1L
         Y97VXwco5ZDKfJIZYOTWLjdt/OepwrEOw5Ls838BYJeVe21yyj3phdvbtYL9vZKKePTF
         oySTe5uzsfXI/ftKOp75cVYwr9e2kT3JM9rLJ9R5rU+3CzTGfZyUDtfXANDRDqPBnD7N
         H45cFpdbYPydNqpsP5MdU1goEE1WrpavBNLIwl2/4UgrefP2KarIhJ0Iez+IJ7sLj1Dx
         TUtkgb7nE6ocTfaPNBrwqsbiiiDWvX7PRNK14RHUMNl4x5qOC+Jgd9SjkCafd4cYAELV
         EoUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754300; x=1785359100;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NCrGV/IvczFQuzgiCKvrMbx0iXp5RvXYGgSS+cNIwso=;
        b=e5CjUti+rQw/KEI6sAxZV/YN8DxOF2vGMkRlYb/Ug/SntMbpNjMtndzThdevH5dVK1
         XybB3g9OHOU4IooRbK5A1q28cbdQOBbCwGKm/XYrFof7ZS80Wsc9y8/BGGxYBZlKYbBX
         xbLcDfMNtj1otBKCRWwS1M4XX4U56rb8JY/Et7GIvDWc4y1SkuHvh1SneMcU/XApntQm
         P+Ad+N9zSDAgFBy+948Gd9pAxsXnMeTVqDAi4jfs+QmHmaQoRZkos4Myw4myErVAh0e3
         UdMdfjJSvzoENCSgMz7NMXFhN9HwlHMGSs+1WygbqW3dHDTPgaLGwcyFqWW9oMOXjeni
         bDYg==
X-Forwarded-Encrypted: i=1; AHgh+RpimNfOfX8GByCdOTfAYFISP75aQtOM9h5UYOs11Mckg8Xl14dlwJxqGAxt3UQHEVzuiMEd+MvI3Wd5@vger.kernel.org
X-Gm-Message-State: AOJu0YxsBvq0M7S5v5Rq3uei0mT693f2jysb5gUb5reCzoaPbt4n/BMm
	Qwfcep/04CXumeY35Bb3mGv7tw0RVx/JsDN2F7LR/pyPhslrrnzc/DWzBHrDHuUYUjLC2DMtFWy
	iU6McGlTVIuxCQ0DP08y45ADkQwka7tEvWi531iUI
X-Gm-Gg: AR+sD10T5URq3cAbSZslM0DrmqwJGKv1agGVhBazE6yfaC17BINPeq+jid537LJFkfX
	t//AAoNb8ddf7aAVbXq4bwTuRvSOzJY+NPqYoD9mAnABQxcU6qkbIyz36DekdrGSfgCylbgaFOx
	Jd/V/3zrs2d85pEEf/HGai37hL7r8hi/8io48/7vRv5sq9CUhHSx4vXybRzXOjgvvPopKwcqcU0
	yl9HNDGQon5Qw0b2HR+Vv5lW1H83LelPafNnuSGWqoCmTwgjD/zIvDySsZ9czCxUu9PpyepJflt
	VN6tGoWzKch2v32ruUQ=
X-Received: by 2002:a05:6a00:3310:b0:847:8b1d:22fe with SMTP id
 d2e1a72fcca58-84e2c19f3d7mr503928b3a.50.1784754300526; Wed, 22 Jul 2026
 14:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714212239.1511269-1-xmei5@asu.edu> <20260722112719.17665461@kernel.org>
In-Reply-To: <20260722112719.17665461@kernel.org>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 22 Jul 2026 14:04:49 -0700
X-Gm-Features: AUfX_mwyaH3RhZqjpnNmvjQ0TEigTZvfj9fA5b9tOURP9AVDEXXsz1iach2-J_s
Message-ID: <CAPpSM+SHEG4w4L9idGS5Zws3ZXJngKJnTVb=Rpmw53W=LNLr0Q@mail.gmail.com>
Subject: Re: [PATCH net v3] rds: tcp: hold the RCU lock across ipv6_chk_addr()
 in rds_tcp_laddr_check()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org, 
	Santosh Shilimkar <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, 
	bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 11:27=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Tue, 14 Jul 2026 14:22:39 -0700 Xiang Mei wrote:
> > Changes since v1:
> >   Use rcu_read_locks instead of dev_hold/put
> >   Rebased on [PATCH net v2] rds: Fix inet6_addr_lst NULL dereference wh=
en IPv6 is disabled
> >
> > Changes since v2:
> >   Add change log
>
> Why did you(r LLM) leave this portion of the change log in here and the
> rest in the correct place below?

Sorry for the weird message. It was my misunderstanding; I
misunderstood Allison's message. I thought it was additional changelog
in the commit message. But it was that I forgot to have a changelog in
my v2. (I get used to v1:... and v2: ... so I thought Changes since v1
is like something I should put in the commit message.)

>
> > Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation =
to struct in6_addr")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> > ---
> > v2: Use rcu_read_locks and rebase on rds: Fix inet6_addr_lst NULL
> >     dereference when IPv6 is disabled
> > v3: Add change log to commit message as Allison suggested
>
> The patch does not apply, if it's still relevant please rebase and
> repost.

The v3 applies to the latest net.git (8e04823c120b). So no content is
changed in v4:
https://lore.kernel.org/netdev/20260722210203.565803-1-xmei5@asu.edu/T/#u

Thanks for your time.

Xiang
> --
> pw-bot: cr

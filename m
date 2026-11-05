Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899405;
	b=5djSTUBw2etXGP/1yCzaCKArpZeYFeHppzvMHE5peq59caMb+17zypAjiIwIT9Wp+Ss+
	 UnJtreTN69dvrMT8vTNw7hLE4qQFSDIyhqdPnh1jmmwM0lthoEomEaXdjOItsLG4AklHe
	 QV074aeT2c1U3WWE6NudEeLb1MZQ9MQSoQwk6yP75HlwJtYfbRwKoLElLRdVbX/40mB05
	 +iaiSvEMLXZ8+4KUGJGsWFZ6DfGuVqtfcADuMIQvJ4Jan781APe/8+Z0a199sIDpVMlJO
	 wYB1gB5I4Ol5uYrxVmAVRVCUgIQUniKNs9X2uYeQScrsIcVnhOL8+5/kcoVxMubO62Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CFnqRzQqmQXHusFkEdH7rWbWMrPyMXMFbRKiFoqARjk=;
	b=RfQcjuWYIcnXpCD9KqfBCEo4y9hTSrU3+UdnXtgvr5vhhm8yo1ORA68gp4uQJl2Iv8H9
	 agImozJ9h/ryK+avwJMT0gfRtj2yOjE6U48Bsxoja+0Yd+i+Gr7IlmFMD5xAd2zXZL2G2
	 FXuLJ/dwegIAlD/Bgr9KeBi74re6oLJG9yJkckpBmZd/9+/JeiAuNQrmJ9cTz85E0ZdRg
	 k1iu7btrlnADLZ/c+Sb8F9Vt2mexcSv3NmF109NxxLkJnF0OfB0LyKpvpDYVe0phO3T54
	 3f2CHaGsU9SZfqhOAXUj4GSZ+Zwo8CnQAb+5SRSAFnSH/R679BVYJ8T+PqGw2nq4Stg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVJt8IDJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2487606A333
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 17:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2487606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVJt8IDJ
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3ab3b29a210so10173401fa.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 09:23:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793899403; cv=none;
        d=google.com; s=arc-20260327;
        b=P4YodV2nh+4q2d98r5LYd/67EOoPl4sd1ZySN+xICR7e1IypnfjafhRrtpgApQoTz2
         EThEhnPMX8ejH0egPJxy/7a4LHWOrSzbq/GRXQ9O6obUMLGbXYYMNTOHMDWSz4admt4p
         tOlLA8mMx6SLrVT43EWcxiVlE3XxUcpqu+28DouvrfrkQ1J+E6oB+6nPDkKVAKvCuCUS
         hb07fKeyCEn8lllf90nuns8NxjY5Povogm8lpKPUWK6BOk+r0Ocyfk0sFZsLOPpZnyhf
         GRMGrU4Lz4xwg83iArkqTgnI3wDeVOzZYYfF4E8ErcOFl0tg7ejMP2eB5syH2br8cLeY
         L40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CFnqRzQqmQXHusFkEdH7rWbWMrPyMXMFbRKiFoqARjk=;
        fh=/m790M/Kb/9iDQy0njyMlAWC+R9VnDe1I3i4XBFZhIw=;
        b=D0En4yeiMr21v9DU1Hi3TKQ1TlcAl9JEFRjVYvE2WfWd8Nx2Fx6Sgo5yXEIg1Z4B8/
         xEEl5LOK/SmYFlcKbirNVRw1i0lT/RANTD+GHQcK27/hkGSztCzxqccCHcFmI9pWWaPU
         ucz8kaw+Ap/P3by2bb26/GmZbTfGhvAglf2HsJ/V0up0quCWXpkin6RbvweG7L9wyCnJ
         0F0jZAPMFCZ28Z+1A1yvcqjw/S1Uis/ZIoKHJ7ZB87NEqIZFrOPBAWqrXZpMszmfdmdo
         XHxiwiQTm5LCLfzWNk6DQgkFN0htvxL3IaRdT5CSzqhzMUIHT93nl/gc4uooppBVbyBl
         dNsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793899403; x=1794504203; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CFnqRzQqmQXHusFkEdH7rWbWMrPyMXMFbRKiFoqARjk=;
        b=wVJt8IDJDZGeVqj4HxxKUbofyuUUkSRMfuAIeSg42tUCGfvo07Lqs3mC6gy3q9CYZ2
         gAGNoP/OZZ16/jla6xmrzEm7YTnPgXZSss1saTjG1/pDACwtlYXceEA/7+XLd/w6VXgC
         G6nBWNAmC+683j3u3aytgiGw0RE5toKYFBHv8kH4HyTCVaf9/ThLv63sKMoyUdJDCm/d
         9Dqr9uNUTwiUH+Qg+7dL8ut4OlwSOOOz7GGkE/ioaNujo0cTjQyoLT1KRZwc9/zMc7+H
         e7xAnoarPJ4zj5ZDYc5YVCb7F3NbGqrjQVC5ygHpLbAM6w98lx0YvOdmkEUjBH9tV7wn
         zSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793899403; x=1794504203;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CFnqRzQqmQXHusFkEdH7rWbWMrPyMXMFbRKiFoqARjk=;
        b=RqwlJ93Thy/42D7voUbzf0osaKyFXS7qeeP5QZTBxMn1xlYTArQpXjb3O6/y7GfCrl
         1BxWHQ0SOf93F5sc8RyASPOz1hPX89AOqDLXbVPz2ceZFTY6slFUgomtGKbr1xYmjnDa
         2SYJtFMoHIoDW4UfoMjvODqCGRT9I7rBscqLAPsPf5HqwV4RelTgCPtoMf7v+cEQcgVP
         Lhm8J7E4NEQdE0/yWdd3k1RWd9/15M/F4yee7DqvzhDWtkIq5F0/i5ph3CcQCI990c2K
         eW3PtPQne1mNeMzEddsApEuVXviK2ayQ80Apx3AX+B1JGT044mp6lsYz01fVrLa3BTgE
         bPOg==
X-Forwarded-Encrypted: i=1; AKwUvByiJNb8MavZGmE/pPecZQsvA/hrBz4blomNVTaw0Ov9MBqbHZiP2tv82TE//fBbN82aBqpA6LOvXlOJ@vger.kernel.org
X-Gm-Message-State: APuU4Z83ZcuBr4oKCRcsBc9wLttCQCT0sZtGXfNJFvhnlPUbqnfQ9OfV
	0ihxmnFUztiyacaYf43TvZpht/WhY4nnr0oFuRg5tvd1+x/hyabRc4EPbnyOgg4vXGpU1cMD1Q0
	e8cow+MA1hzwqmihMk7vGDNZZQ/1KQB4=
X-Gm-Gg: AYBFou3eNZwRXH1zjywhkhBHMZDAFyYJzMbtxnceyUfPDns19eZu11ajQHyuPIEVFwL
	Xz+3AYOJfkSDZ1Mpmu7F0v6lvSNyjuwFF392PUWVrUFVrJ0yZXNMI2Q0x5WCThfn4LE2mF2qmk8
	y8wQt99muUuFsWChHORv2ydPozV4aPQDm//D41M8p6H0wwjGiXWMaFUKbP2fc0pGVJDDSb/uGNe
	3rzUUSKNZ8PN66p+g5P4vbWvuKNHkkipU2pyMWdhMvwODofx3tzLOIKzPW7hRuY6gN6/8ix9dBf
	g0TvaK8mUmGVizriIQQKR7dD+m/raNdsWqUDY7Aa3ZqZJm8pQXLfJxWuDGGEDX/AOMBDPP14vw4
	nzvounAs67xL+zBS4IBKU7oHys/TPNWFkUQQ3R6cy
X-Received: by 2002:a2e:a80a:0:b0:3a9:8775:5f11 with SMTP id
 38308e7fff4ca-3ace3027663mr6797811fa.4.1793899402792; Thu, 05 Nov 2026
 09:23:22 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com> <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
In-Reply-To: <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
From: Or Gerlitz <gerlitz.or@gmail.com>
Date: Thu, 5 Nov 2026 19:23:10 +0200
X-Gm-Features: AclHuK-Q7UtWMma8dQTSSHRotYZqNgjeLLpwfc8kfvFtzc8SmnvLT_gaM61dzA8
Message-ID: <CAJ3xEMiG55XUPtt7Zs2xON=EZtJ7Oriwt5m6qbsL-s2cVgZHyQ@mail.gmail.com>
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Mark Bloch <mbloch@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, "huangjunxian (C)" <huangjunxian6@hisilicon.com>, 
	Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 9:57=E2=80=AFAM Mark Bloch <mbloch@nvidia.com> wrote=
:
> On 03/11/2026 17:54, Or Gerlitz wrote:
> > On Sun, Feb 26, 2023 at 4:46=E2=80=AFPM Mark Bloch <mbloch@nvidia.com> =
wrote:
> >> On 26/02/2023 14:53, Leon Romanovsky wrote:
> >>> On Fri, Feb 24, 2023 at 11:14:47AM +0000, huangjunxian (C) wrote:
> >
> >>>> We've been working on LAG in hns RoCE driver, and we notice that whe=
n a FAILOVER event
> >>>> occurs in active-backup mode, all GIDs of the RDMA bond device are d=
eleted and new GIDs
> >>>> are added, triggered by the event handler listed below.
> >
> >>>> So, when a FAILOVER event occurs on a RDMA bond device with running =
traffic, does it make
> >>>> sense that the traffic is terminated since its GIDs are deleted?
> >
> >> Yep, please read the original commit message:
> >>
> >> commit 238fdf48f2b54a01cedb5774c3a1e81c94e1a3a0
> >> Author: Matan Barak <matanb@mellanox.com>
> >> Date:   Thu Jul 30 18:33:27 2015 +0300
> >>
> >>     IB/core: Add RoCE table bonding support
> >>
> >>     Handling bonding and other devices require us to all all GIDs of t=
he
> >>     net-devices which are upper-devices of the RoCE port related
> >>     net-device.
> >>
> >>     Active-backup configurations imposes even more challenges as the
> >>     default GID should only be set on the active devices (this is
> >>     necessary as otherwise the same MAC could be used for several
> >>     slaves and thus several slaves will have identical GIDs).
> >>
> >>     Managing these configurations are done by listening to:
> >>     (a) NETDEV_CHANGEUPPER event
> >>             (1) if a related net-device is linked, delete all inactive
> >>                 slaves default GIDs and add the upper device GIDs.
> >>             (2) if a related net-device is unlinked, delete all upper =
GIDs
> >>                 and add the default GIDs.
> >>     (b) NETDEV_BONDING_FAILOVER:
> >>             (1) delete the bond GIDs from inactive slaves
> >>             (2) delete the inactive slave's default GIDs
> >>             (3) Add the bond GIDs to the active slave.
> >
> > Hi Mark and team,
> >
> > (using modern & PC language of child devices)
> >
> > So I believe that the generic code which is pointed out in this reply
> > has to do with the general case
> > of applying bonding over two RoCE enabled netdevs (delete gid in child
> > A, add GID to child B).
> >
> > Wheres the special case of RoCE LAG - namely the mlx5 feature which
> > comes into play when
> > you bond two mlx5 Eth devices belonging to two ports of the same NIC
> > is slightly different - b/c
> > the two associated rdma devices are deleted and a bonded rdma device is=
 born.
> >
> > In that case, we saw this week that the connection breaks, likely b/c
> > of the GID add/delete
> > thing etc and for no reason user-experience wise - the user sees one
> > rdma device the device has
> > two rdma links below the cover, one is still functional, why break?
> >
> > Indeed for LACP mode the session doesn't break.
> >
> > Can some enhancement or fix be applied here to make it work also for
> > active-passive?
> >
> > Or.
>
> There might something we can do, can you please try the patch bellow?
> it assumes fail_over_mac=3Dnone is used with your bond device.

Well, in the env/lab I am working we are not really have the means or
allowed to
change the kernel..

> [PATCH RFC POC] RDMA: Preserve fixed-MAC bond GIDs across failover
> A provider supporting bonding failover can redirect existing QPs to the
> active physical port without replacing their GIDs. Deleting bond-owned
> GIDs on failover clears their hardware entries while live QPs still hold
> their indices.

So, indeed in my env, I noted that doing the bonding fail-over caused a cha=
nge
of the GID index for the RoCE v2 ipv4 based GID used by the app

> Add a per-port capability, advertised by mlx5 RoCE LAG at registration.
> For active-backup bonds using fail_over_mac=3Dnone, skip the failover GID
> purge and allow bond/VLAN address events through either associated
> child.
>
> Keep address-change, address-deletion and unlink handling in place.
> Policies active/follow and providers without the capability retain the
> existing behavior. mlx5 still removes old-child GIDs and updates its
> hardware LAG mapping through the existing paths.

so with the above RCA in mind, the patch should address the issue and LGTM.

Or.

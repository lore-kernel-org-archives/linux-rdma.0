Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793721266;
	b=18Rc6kM91FNWv5DCOw2rNr70Klw9KEl/7P1hUF9SxbFO7HEVVq+egIXqTvIBJzzbZ3vN
	 cOgSdq8erR3Z3QNI8GCPlRtLDOCDA+x4vNgactqtsWadXn7gz+lFGk8xoeO1u+orL1LU2
	 VifFfxAmqcc161PiDRFz8iwH2oFPCsarYuhmI4GdbjmFUo2maw4dOZZDpWA5jIsuSRTO/
	 OrMHt+wB9y28gS+9Y8koWy/fKu2W5tOCb4CWMm2Jaa0Gcs6XlO8bbmDdzNaVaLJOn0cuI
	 RIOqWod94hrlLy8t19uvI8uqkkGSQDjOHl0IMjSSng2NL8ZC/JZETfii4FwMs/zIxGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ETD3as3AOpp+9YlFrWmsKex0Hyc6feS0B3xsXicfTds=;
	b=y+qJoZfLKrX4VfXS4eC/xNBB6CB47LGazxVpMJMdcMnyf+eXy4FMEBi5fEo2dolCvi2k
	 ZqWNo2tqWCRAGzo3timOX6HbPkHtamED+oXi2k5NkgyR+OYV0qlEmWUphpxjSXyF2XPmN
	 I6nU1rzMq0gFjX0pywGW2krQKKW2fRin9baa1c6Ia/Qw6mUVFCP/UZcSJ9cerJexeXsnT
	 1SPcI/I1tt2dSYVC9qogf04/93Wb1a62YHL4fytZZgDjzx3AwUi+CCkyQAUvSZ+f/rUt3
	 leJjV2PQMfz/tDSgOBeJVb4e18Gqt4SdAP7d8LMWA2qd6bL3l/ONV2ff5UFdtayUR1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tCnSuc8R;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871A606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 15:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D871A606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tCnSuc8R
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-745497ac8fcso1768076137.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 07:54:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793721265; cv=none;
        d=google.com; s=arc-20260327;
        b=IH4POD2UcLsvXwkN0XZpbvb2V5bjw8bxtXHGaWdT5Z2KiUFhpBIt5BI2sRIzHikGcl
         Y4/3aX20eRKMoYZsqoRRrvj6YQ8oJcM1zxXdN2RPg25X+fCy5WjaY3SVX/2NvsXUUfnh
         gkxIW8Mx7bzHP3w+YVNAU5ksXiQhjqpA7RkRc8KbubOWPLxTyxa0/J2rPdtqurkLKfAE
         nDufFm5WHWlwv53oXHMkb9Mv4bbxESLTHEuPBjSGgTlO5ax1JpPWgvcqMEjwJ3wrP2b4
         YycM9Hx/drMheIGuNm3cePL1u4jP7YxQhy9WAmMyV5jhpE5rCMDXTu9Gj2UHNNq12GMk
         AKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ETD3as3AOpp+9YlFrWmsKex0Hyc6feS0B3xsXicfTds=;
        fh=xZapPQCCV5d4jFhXXmDnNzAEp6B5R0wmGOhjfxzQLbo=;
        b=VCB1mcMSL7u+bZaxqWiKhP6RZb14lEjVNJKhjdy1aqB+VkoRw2FHWcxZNodyKlgGsy
         u4TdlVYnA4Hmis7PVyowjUL0oeEd8VdWLMJ6/w9CKgY+MBgQH/87GEFMme/Iz8JfA2CQ
         LpIBu3YCi85icydtPEuO61PR2hd2rtzp9c8aIU86Tr/mdsy8Smr7aHms3FFUpwEYIIHp
         U3dTrjfMnQ0c/ZD05/cboCqCFc7kK7Kg8cdM/EXzWkfHE7lKtktaxzNsWcU/2hP38nU9
         7jb/CCxBao2c/Ka158VX47R3dmgRePP4VP+2vPA2VEv9Jk7LqmKDSOGzk6rMMNsLru83
         n7aA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793721265; x=1794326065; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ETD3as3AOpp+9YlFrWmsKex0Hyc6feS0B3xsXicfTds=;
        b=tCnSuc8RQ2uFDHB2RwoFy+4z3ocX78bGTD9EGjvko9JiD3c/+4eakYWES+KHgaDHCd
         /eHyEjyulBBGX0//sEDrULAHNKLlSUkX2gQvqNf6gQJDTQCe2SfupcQTwvsiok8enG/H
         dr7XjgxfQg791kbJ9CYAqlpiEKCaabNnySuhkeFZ/HMn765Ymaa9KRjUmQnQdsVXuxSp
         qTCFZTrO/bQ4HTeWTib396aTZsSlBOdkxrsytXFpINX73mJIjDo3V6tbY3uXv3AMc3Ym
         06UOsxIKY//Fho/SZ5XQfL/R9knuDdnYPFZS7RR4GgrmzyD+IWIq1QvMVPsTI64kBm6i
         pjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793721265; x=1794326065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ETD3as3AOpp+9YlFrWmsKex0Hyc6feS0B3xsXicfTds=;
        b=eM3SWvsXgUnGZO9231EpUpYO64uu+pNUZP+76S0dkjLjH4D7xn6TiVaKZoxDbOA5Aq
         nyzF5+WUkq8Ftqi+JnSQWo7w7PJAsYH95rN6/TwXaZKdbFra61nDUXF/XMlu3dV5djX+
         Ci+l5BWu8FzJDKBtwc1eC2llHK7j4Xk0apjbz6W8z0ja/uv90FobFJ4NC4K8Yxkbd9rb
         wxTR8Lq/i+DXf4mkcUgekqcTNWKGkYzge6wkLh4oPgltyT6qZOoVh20HEzYtiTK1cIV4
         jWGHDtdYO/nehIgBC+4M8Gh50Catjbll4ztiXAlKEF2fSKgZfPGIsml0RtJpwr++H9yo
         FwMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhI65Wk1gH1LNX2D0m9KxqO4d8zO64f73WoXWuZLesq3zO+cuAY8mf2W8yw+FE5gHfNqn4BUyF7m9t@vger.kernel.org
X-Gm-Message-State: APuU4Z/b7fhtsmLm8vw3VqZCAAFGOdU70P7UNeoCepPXv82dcuDWdgmF
	cn5lm5VK4Is8HpJA96Yt/yTzaS8yJtRd766A/+hzTzMZ+mr+CIZClxTqlG7kAB3Wtort7knUd/1
	d1fR07RuAGjDrXSuUqmXFUCf+T/9zRWQ=
X-Gm-Gg: AYBFou2HRDOnodZ6bUJqBPAwr+Fj2ie/Hs4k6BdjBlKmhFy0H5jvNeWDOneMBFj/C/6
	Kzy+4Kezvpze/TVB9uJnN0EFB/WpqalPCyFcybwQQCJOZgYGAFYiww4enA6dbr3h86iXkxCx6j4
	77Gs4E9r1GnTOHpo8cNMX+uTOgJv7/ENZCQIgw7d9uxaPpXidX62AEVtXSiSA8qgi74LDZ+al8J
	pP//ny8ym6VjTtsQ+56pyUY8R25ZPpQ5STX4FGskS24j1rODcE3aBYa3BLD3tv56P+BwX0e43V0
	8LFRIakedyEYx+uTKq0sG34u22tSbvOEj4yFiN1+BIVg8ADDXrpaQ3zGz+C+B2w5Os/85OdVME9
	f89w8mwPWcbq606Yqm3DTrcMomwf2DC9/NerQSoE=
X-Received: by 2002:a05:6102:2926:b0:7b2:7490:fd75 with SMTP id
 ada2fe7eead31-7d072baa797mr4769771137.7.1793721264772; Tue, 03 Nov 2026
 07:54:24 -0800 (PST)
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
In-Reply-To: <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
From: Or Gerlitz <gerlitz.or@gmail.com>
Date: Tue, 3 Nov 2026 17:54:07 +0200
X-Gm-Features: AclHuK8kaL50dhKQOBGni3YetztcEFbFaUOSo1nQ5wbvKBoZFYGgsM89R1b68Vg
Message-ID: <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: "huangjunxian (C)" <huangjunxian6@hisilicon.com>, Mark Bloch <markb@nvidia.com>, 
	"jgg@nvidia.com" <jgg@nvidia.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 26, 2023 at 4:46=E2=80=AFPM Mark Bloch <mbloch@nvidia.com> wrot=
e:
> On 26/02/2023 14:53, Leon Romanovsky wrote:
> > On Fri, Feb 24, 2023 at 11:14:47AM +0000, huangjunxian (C) wrote:

>>> We've been working on LAG in hns RoCE driver, and we notice that when a=
 FAILOVER event
>>> occurs in active-backup mode, all GIDs of the RDMA bond device are dele=
ted and new GIDs
>>> are added, triggered by the event handler listed below.

>>> So, when a FAILOVER event occurs on a RDMA bond device with running tra=
ffic, does it make
>>> sense that the traffic is terminated since its GIDs are deleted?

> Yep, please read the original commit message:
>
> commit 238fdf48f2b54a01cedb5774c3a1e81c94e1a3a0
> Author: Matan Barak <matanb@mellanox.com>
> Date:   Thu Jul 30 18:33:27 2015 +0300
>
>     IB/core: Add RoCE table bonding support
>
>     Handling bonding and other devices require us to all all GIDs of the
>     net-devices which are upper-devices of the RoCE port related
>     net-device.
>
>     Active-backup configurations imposes even more challenges as the
>     default GID should only be set on the active devices (this is
>     necessary as otherwise the same MAC could be used for several
>     slaves and thus several slaves will have identical GIDs).
>
>     Managing these configurations are done by listening to:
>     (a) NETDEV_CHANGEUPPER event
>             (1) if a related net-device is linked, delete all inactive
>                 slaves default GIDs and add the upper device GIDs.
>             (2) if a related net-device is unlinked, delete all upper GID=
s
>                 and add the default GIDs.
>     (b) NETDEV_BONDING_FAILOVER:
>             (1) delete the bond GIDs from inactive slaves
>             (2) delete the inactive slave's default GIDs
>             (3) Add the bond GIDs to the active slave.

Hi Mark and team,

(using modern & PC language of child devices)

So I believe that the generic code which is pointed out in this reply
has to do with the general case
of applying bonding over two RoCE enabled netdevs (delete gid in child
A, add GID to child B).

Wheres the special case of RoCE LAG - namely the mlx5 feature which
comes into play when
you bond two mlx5 Eth devices belonging to two ports of the same NIC
is slightly different - b/c
the two associated rdma devices are deleted and a bonded rdma device is bor=
n.

In that case, we saw this week that the connection breaks, likely b/c
of the GID add/delete
thing etc and for no reason user-experience wise - the user sees one
rdma device the device has
two rdma links below the cover, one is still functional, why break?

Indeed for LACP mode the session doesn't break.

Can some enhancement or fix be applied here to make it work also for
active-passive?

Or.

> and please read: https://wiki.linuxfoundation.org/networking/bonding
> especially the section that explains some of the restrictions of
> active-backup mode.
>

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827385;
	b=J2mW8oFua/12//UBuji69adkiF/05S0rNaUPXKrI5ry6A3ciFT6HsS8c0TO4svbo/fcD
	 vKggvu0asGUcZ5RGKWRTuYPIv85F+s4NfZpVRyjOVJri0r64MJ9teXFByCW+uK7QJSvGO
	 PXNvecpVd0Z0A/eLi546MsPBTGUEKOWIJUXKb3GGF4qj80c1LmFQ8OX7tY/rWUxCPgJDo
	 QgOHFo/O7yqbAY9jkIq5SdmU9RMxrRgDbDiVL8ibRqodKQ2ZBEEG3BvDnjD3HGs34+sE1
	 jphuv/w4M7+zT7ziDQc7sqkMSasKt/xYD18VOXbpuv6bmD/5hzJjH/DpXSBgBpfTghg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827385;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Tik/X9C/M+LTDcPTrDv1fehBxnuumv4ASRAalDHwJ7Q=;
	b=1/1G6kkAWgwJgukjawTEJ4GnvArIpV5x+u2PfHbRgZWEy00AiB1IDhJYJrCGNO9btejG
	 g9wa13RmZ64PYSj2Q/1P9/18kvY1UJZ/7rCZ23/93/n/I/IUvzOtr7LAaBbpKgNrGhLR2
	 EKlP4/jjslNHItgZzxsirUU+0NRi1gH+AHj4fkB8tQ7XWqseTS94VUqbBB/16yHht5/7q
	 BU3RCvu54v+65PExhwY6W+JT94YsbJ6/nK5V05QAynCotcpZ9Rby2LvFxm/DfPMv9Iumo
	 f7bt9/td/K5XjoAGB23gqume+IZ/4gt931MlVTcGoyXZqX8itmNTPAJ/VEvhIivGHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7Dtb9AY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D5606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7Dtb9AY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FE71F01825;
	Sat, 24 Oct 2026 07:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827385;
	bh=Tik/X9C/M+LTDcPTrDv1fehBxnuumv4ASRAalDHwJ7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K7Dtb9AYAYWtsq5mAunA+fUex2aWsCqcZ01xASpBQYy0JgAdAopgY8hCB8vl7MW+q
	 w0rRvvymv6hhMwyZerm0rqoguu5vvKjdaiFHAOAm1/SBEtRMiawPzCFJyIp7d1DxVL
	 zisjesCIpKxE3t4a7HdVdVsPG7VxjDg3ekNGFE0O2dx6LiFRikmK8GKwgohDGKO1wY
	 QcKgiOSbKHvXYnZgboAFR2FF1SCQGAV9F+3nOil2bSsxwwhwrJ156gLbJXknQZpWm0
	 ak5V5agGVF3S87S0pqIM9mR1DFBBo9NJUfh9ZPvUHY3wWMafKlP+eqUCuS8XeTkkBC
	 lUwekcR3Be5tw==
Message-ID: <sashiko-outbox-183587@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] RDMA/zrdma: Add hardware resource initialization
 and verbs skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-5-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-5-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:36:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/zrdma: accidental deletion of zrdma_main.c breaks build
--

commit e05483ee5929bdb338026257200504048dace255
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add hardware resource initialization and verbs skeleton

This commit adds hardware resource initialization routines in zrdma_hw.c
and a minimal verbs device registration skeleton in zrdma_verbs.c and
zrdma_verbs.h.

> diff --git a/drivers/infiniband/hw/zrdma/Makefile b/drivers/infiniband/hw=
/zrdma/Makefile
> index 2ddf50d1fd208..88be835f5c5c2 100644
> --- a/drivers/infiniband/hw/zrdma/Makefile
> +++ b/drivers/infiniband/hw/zrdma/Makefile
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> =20
>  obj-$(CONFIG_INFINIBAND_ZRDMA) +=3D zrdma.o
> -zrdma-y :=3D zrdma_main.o
> +zrdma-y :=3D \
> +	zrdma_main.o \
> +	zrdma_hw.o \
> +	zrdma_verbs.o
> \ No newline at end of file

[ ... ]

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniban=
d/hw/zrdma/zrdma_main.c
> deleted file mode 100644
> index af1d37be63362..0000000000000
> --- a/drivers/infiniband/hw/zrdma/zrdma_main.c
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> -/*
> - * ZTE DingHai Rdma driver
> - * Copyright (c) 2022-2026, ZTE Corporation
> - */
> -
> -#include <linux/module.h>
> -#include <linux/auxiliary_bus.h>

[ ... ]

> -static int __init zrdma_module_init(void)
> -{
> -	return auxiliary_driver_register(&zxdh_auxiliary_drv);
> -}
> -
> -static void __exit zrdma_module_exit(void)
> -{
> -	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
> -}
> -
> -module_init(zrdma_module_init);
> -module_exit(zrdma_module_exit);

[Severity: High]
Was drivers/infiniband/hw/zrdma/zrdma_main.c deleted here by mistake?

In drivers/infiniband/hw/zrdma/Makefile, zrdma-y still lists zrdma_main.o:

    zrdma-y :=3D \
            zrdma_main.o \
            zrdma_hw.o \
            zrdma_verbs.o

Deleting drivers/infiniband/hw/zrdma/zrdma_main.c in this commit removes
zrdma_module_init(), zrdma_module_exit(), zxdh_probe(), and zxdh_remove(),
and causes the build to fail when building drivers/infiniband/hw/zrdma/
because there is no rule to make target zrdma_main.o.

Although a later commit in the series ("RDMA/zrdma: Add device probe and
remove logic") re-adds drivers/infiniband/hw/zrdma/zrdma_main.c, leaving it
deleted here breaks the build and git bisection at this commit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D4

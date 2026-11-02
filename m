Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609139;
	b=kA/0DU4NM3x1Gr1sYUl+ZLHBfP9RTKdTRfxVAnPPifw7bL1PuaZVoTMqnBDvtQ9wxIhY
	 yCRXgygqKs5b6PjdHXMfo8ql7YSjY52UntSfRWC7NJuR1kzb+uowBZbzGzaxcREWDOynp
	 bFOtnwOLfRSeTA+dSEnNT5qWIy5lmtJGx+0ojseIB2/hJq1XMCx3BADG5LDlit2LO1zGp
	 JFVA5JyDtmZPkA8825V2hsO/833QClnT2IsiV/OP3ofxqJ/Bd5ImBJ3yrajUP4BhGWWWx
	 jYMzms65kTHzATy/vYwXp2IBr/yWMDt+quuzsMrV/hsdgAybRnbNlrm0lsT0p/o/3yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609139;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GEoP8p1u7+tQlnXZ6QlOaos4Cpv4KSHbS5iP+/R6UVw=;
	b=PuX8s/610z096YngEUOifP/odXU7S8xSr+Wdg679KQJFqJm9b5xGPQnFIDq/+vkyPaJO
	 fbpTXRqZMedaQrMp9TZzPxB0nBVOCDZ6+K+cY4bD6h7Q0Zibfiz85LG+ZE/pb7KH4ObCF
	 fSoxDf0h93cBNNy5VB8ojV+PtpCjEytyWdtqCDXmou2fKWRzqyovzcJf3zMAKBvyJXJ4W
	 xUbJhyc6Hbdy1L7h75fCpDGD6oIr51t75Q6rbs8CBxIyf9WZKm1SAMJnk3j4cYBC4l5t9
	 ALTo/pqL3ISAnsY4GjKZZ0HH8NYPGWcfDOUhIHe3tqpKSbuFbafCyClnObvDCJ9ezZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JUvkLV8T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C5606A326
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JUvkLV8T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B9F1F00919;
	Mon,  2 Nov 2026 08:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793609139;
	bh=GEoP8p1u7+tQlnXZ6QlOaos4Cpv4KSHbS5iP+/R6UVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JUvkLV8TQXI00YFf5J6WHLfi/xN9sNtu3dn1n5hDKuRTWoLoAeCElbN5OnCIlieyK
	 6svcd93hn5djPA04F5J5UROdoSZObLyaN7dWZ/AqCfIgnIlYaezRDMPDP2824+XxVi
	 tXRFMLmAZtD1R3w5d7RPwY5Hh4HPPNXW6wD4SPTFUKUsl8QwNulhPsH8U1aeA4H7sJ
	 G8d1iDViKyeCIQWMy+1XC0c70JPBJVHdtaFYqWeGtd82cXedxef/gyXbJdEUnU8TPK
	 gnl+8aFiIgWQYha8Z58stX7t4jWl+W1g7cXkhzNRxiifuW+8u7Ruk/6CUFHWF3p6sm
	 mz5Qm1jDiUWfA==
Message-ID: <sashiko-outbox-193136@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 1/7] RDMA/zrdma: Add build infrastructure and
 module skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-2-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-2-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 08:45:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] RDMA/zrdma: Kconfig depends on bool DINGHAI instead of tristate =
DINGHAI_PF
- [Low] RDMA/zrdma: open-coded zrdma_module_init() instead of module_auxili=
ary_driver()
--

commit 255288601ed5fbab9c26b7e4b182fd67e8a9395c
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add build infrastructure and module skeleton

This commit adds the MAINTAINERS entry, Kconfig, Makefile, and a minimal
auxiliary driver module skeleton for the ZTE DingHai RDMA (zrdma) driver.

> diff --git a/drivers/infiniband/hw/zrdma/Kconfig b/drivers/infiniband/hw/=
zrdma/Kconfig
> new file mode 100644
> index 0000000000000..43cb55ae9c93b
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +config INFINIBAND_ZRDMA
> +	tristate "ZTE Ethernet Protocol Driver for RDMA"
> +	depends on DINGHAI
> +	select AUXILIARY_BUS

[Severity: Medium]
As reported by Zhu Yanjun on v3 [1], should INFINIBAND_ZRDMA depend on
DINGHAI_PF instead of DINGHAI?

In drivers/net/ethernet/zte/dinghai/Kconfig, DINGHAI is only a boolean vend=
or
menu guard, whereas the DingHai PF driver (dinghai10e.o) that creates the
dinghai10e.rdma_aux auxiliary device is controlled by the tristate symbol
DINGHAI_PF:

drivers/net/ethernet/zte/dinghai/Kconfig:
    config DINGHAI_PF
        tristate "ZTE DingHai PF (Physical Function) driver"

drivers/net/ethernet/zte/dinghai/Makefile:
    obj-$(CONFIG_DINGHAI_PF) +=3D dinghai10e.o

Depending only on the bool DINGHAI symbol allows configuring
CONFIG_INFINIBAND_ZRDMA=3Dy when CONFIG_DINGHAI_PF=3Dn or CONFIG_DINGHAI_PF=
=3Dm.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniban=
d/hw/zrdma/zrdma_main.c
> new file mode 100644
> index 0000000000000..af1d37be63362
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
> @@ -0,0 +1,57 @@

[ ... ]

> +static struct auxiliary_driver zxdh_auxiliary_drv =3D {
> +	.name =3D ZXDH_RDMA_DEV_NAME,
> +	.id_table =3D zxdh_auxiliary_id_table,
> +	.probe =3D zxdh_probe,
> +	.remove =3D zxdh_remove,
> +};
> +
> +static int __init zrdma_module_init(void)
> +{
> +	return auxiliary_driver_register(&zxdh_auxiliary_drv);
> +}
> +
> +static void __exit zrdma_module_exit(void)
> +{
> +	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
> +}
> +
> +module_init(zrdma_module_init);
> +module_exit(zrdma_module_exit);

[Severity: Low]
This isn't a bug, but since zrdma_module_init() and zrdma_module_exit() only
register and unregister zxdh_auxiliary_drv, could this use
module_auxiliary_driver(zxdh_auxiliary_drv) instead of open-coding the modu=
le
init and exit functions?

[1] https://lore.kernel.org/r/21b7b324-9fd2-402d-8695-5dd061adb957@linux.dev

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D1

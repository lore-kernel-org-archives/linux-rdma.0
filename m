Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795070;
	b=whNg2FzMPfps1644jNfrcPrz/pOPdGEmlj2t1VOpymXXnBV0qENsmjuUAeZxT37BTDwj
	 0hXRem++Beel0xdfJhO3d5ILVjj0Sy7ckGrYwOMoybgndoX1KR8wzOMFFwzZjWylA8lFX
	 wfuISaX9KALprgTeZNV8xdQ0vAPsVp0l3A0ih5JTl0fCSYtgtUMGyfCqwzIyzKeQl7uAn
	 QQDisPhTC+lknk0cihVZTsAotqV7wEefixMW4M4nsMAPZXo57UAG62BLT2v/6aFk+HFLg
	 HiJjaMTgIoeIkxkNv8mMPx0Vna58gHcpL7mgUrpfrUvblNimI+fFUod0vs9hP0LYbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795070;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+aVL13Qr3JgDb37sN+rOtuVXCaAw1zLbwiW2aW4dOzo=;
	b=aJv5bO/mmm6qsq0ar5bHwMUdtNQCi88fRV92WSem6VchVf4KbK8yV6uHOb4Ngo1gg/3D
	 8ypYgLsT7PAs4F1IY79zreW5ePt8sXl0WjJjzthcnooJS6z/ZzDHRqOa9hweNJ8aAaAye
	 jjDw6wtazSlrUbkZklwQzwu9GK0zxKz5vaTrJX3H23IWggZ7QbEYr8SJ/EWpOS6XMcr7z
	 bzgNCFJCt5FbJdPwSXXaI07v7ozxhDdg1absLt7VnD148je7X24X6K/RAP+c1b2wUubOm
	 RgnChaZDNqqWCCChTwYBiaoTkq0FgYUlZ9CrTc5rTzpGkzjUSaRAtSkWOwtqpQiXVhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyPq3LRf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F79606A31C;
	Fri, 27 Nov 2026 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyPq3LRf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C001F00897;
	Fri, 27 Nov 2026 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795070;
	bh=+aVL13Qr3JgDb37sN+rOtuVXCaAw1zLbwiW2aW4dOzo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=EyPq3LRfO0U0DwHtirPMkkG3xCJK5HwM3anag+X51DjpebHN0LaQgYbY9q5BR0CTM
	 bhFlZIjpcJZ8kZ4URFPfEzUrajyrs0SQJbEEYJmPSEeP9yoJTdx+Cf6mYF4FkEbdJX
	 NALKnfMeKQ7sreNo4QKbxRv/XT4kOw8laofufvLdhIESYN5SbpJsiAzGHyvN5ixuZs
	 3Xmd1t3s7TU1cSoMB9E4+ogBWUsQoU9rEFtiKWWFd5wKiIkRoxqvjR4Axzw7l9qzGi
	 sS3yIBFAOIvknLFmYe2s/M2qTOwWK32m2aLKbx9Ee8HJ2VpVYRKopGKK+vPccNXfTY
	 oJRcNHjd95t6g==
Subject: Re: [PATCH v2 01/11] net/xsc: add Yunsilicon XSC ethernet PCI driver
From: netdev-bot+sashiko@kernel.org
To: tianx@yunsilicon.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com, weihg@yunsilicon.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, kerneljasonxing@gmail.com
Date: Fri, 27 Nov 2026 15:57:49 +0000
Message-ID: <179579506923.3135.15582286060392761620@kernel.org>
In-Reply-To: <20261126145711.70868-2-tianx@yunsilicon.com>
References: <20261126145711.70868-2-tianx@yunsilicon.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In xsc_pci_init(), BAR0 is mapped with pci_ioremap_bar(),
  which is a plain ioremap() of pdev->resource[0], but it is unmapped…
- [Low] The subject line is cut short.
- [Low] The new MAINTAINERS entry 'YUNSILICON XSC DRIVERS' has only 'F:
  drivers/net/ethernet/yunsilicon/xsc'.
- [Low] xsc_pci_driver.name is "xsc-pci".

--

net/xsc: add Yunsilicon XSC ethernet PCI driver

This commit adds the Yunsilicon vendor Kconfig/Makefile glue and a
skeleton PCI driver for XSC ethernet devices. The PCI core enables the
device, requests and maps BAR0, and sets the DMA masks. The doorbell,
command queue and netdev layers come in later patches.

> net/xsc: add Yunsilicon XSC ethernet PCI driver
>
> skeleton

[Severity: Low]
This isn't a bug, but the subject line seems to have been split. The word
"skeleton" is now the first line of the body.

As a result the shortlog reads "net/xsc: add Yunsilicon XSC ethernet PCI
driver". The commit only adds a PCI skeleton with no netdev. Could
"skeleton" go back into the subject line?

> diff --git a/MAINTAINERS b/MAINTAINERS
> index bde216003f428..1cd2a0a6477c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -30909,6 +30909,13 @@ S:	Maintained
>  F:	Documentation/input/devices/yealink.rst
>  F:	drivers/input/misc/yealink.*
>  
> +YUNSILICON XSC DRIVERS
> +M:	Honggang Wei <weihg@yunsilicon.com>
> +M:	Xin Tian <tianx@yunsilicon.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/ethernet/yunsilicon/xsc

[Severity: Low]
This isn't a bug, but should this F: entry be
drivers/net/ethernet/yunsilicon/ with a trailing slash?

As written it does not cover the vendor-level files this patch adds,
drivers/net/ethernet/yunsilicon/Kconfig and
drivers/net/ethernet/yunsilicon/Makefile. Changes to those files would not
be sent to the listed maintainers.

The new line in drivers/net/ethernet/Makefile is also out of order:

obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
obj-$(CONFIG_NET_VENDOR_YUNSILICON) += yunsilicon/
obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/

In drivers/net/ethernet/Kconfig the matching source line comes after
xircom. Both issues are still present at the end of the series.

> +
>  ZD1211RW WIRELESS DRIVER
>  L:	linux-wireless@vger.kernel.org
>  S:	Orphan

[ ... ]

> diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
> new file mode 100644
> index 0000000000000..c926507a74b04
> --- /dev/null
> +++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c

[ ... ]

> +	bar_base = pci_ioremap_bar(pdev, bar_num);
> +	if (!bar_base) {
> +		pci_err(pdev, "failed to ioremap %s bar%d\n", KBUILD_MODNAME,
> +			bar_num);
> +		err = -ENOMEM;
> +		goto err_clr_master;
> +	}
> +
> +	err = pci_save_state(pdev);
> +	if (err) {
> +		pci_err(pdev, "pci_save_state failed: err=%d\n", err);
> +		goto err_io_unmap;
> +	}
> +
> +	xdev->bar_num = bar_num;
> +	xdev->bar = bar_base;
> +
> +	return 0;
> +
> +err_io_unmap:
> +	pci_iounmap(pdev, bar_base);

[Severity: Medium]
Is pci_iounmap() the right call to undo pci_ioremap_bar()? It pairs with
pci_iomap(), while pci_ioremap_bar() is a plain ioremap(). xsc_pci_fini()
uses the same pairing on remove.

On s390 zPCI without MIO, the two calls are not symmetric.
zpci_map_resources() stores a cookie from pci_iomap_range_fh() in
resource[0].start, and that call takes the only reference.
pci_ioremap_bar() returns that cookie without taking a reference:

arch/s390/pci/pci.c:ioremap_prot() {
    ...
	if (!static_branch_unlikely(&have_mio))
		return (void __iomem *)phys_addr;
    ...
}

pci_iounmap() then calls pci_iounmap_fh(), which drops the reference that
zpci_map_resources() holds:

arch/s390/pci/pci.c:pci_iounmap_fh() {
    ...
	WARN_ON(!zpci_iomap_start[idx].count);
	if (!--zpci_iomap_start[idx].count) {
		zpci_iomap_start[idx].fh = 0;
		zpci_iomap_start[idx].bar = 0;
	}
    ...
}

After one unbind, or one probe failure that reaches err_io_unmap, would
the next probe get a cookie whose fh is 0? Then every BAR0 readl()/writel()
would go to the wrong function handle.

When the device is finally removed, zpci_unmap_resources() calls
pci_iounmap_fh() again. That would trigger WARN_ON(!count) and underflow
the counter.

Later patches in the series add more ways to reach err_io_unmap, such as
xsc_cmd_init() failing.

Could this pair pci_ioremap_bar() with iounmap() instead? Another option is
to use pci_iomap()/pci_iounmap() or pcim_iomap_region().

> +err_clr_master:
> +	pci_clear_master(pdev);
> +	pci_release_region(pdev, bar_num);
> +err_disable:
> +	pci_disable_device(pdev);
> +err_out:
> +	return err;
> +}
> +
> +static void xsc_pci_fini(struct xsc_core_device *xdev)
> +{
> +	struct pci_dev *pdev = xdev->pdev;
> +
> +	pci_iounmap(pdev, xdev->bar);
> +	pci_clear_master(pdev);
> +	pci_release_region(pdev, xdev->bar_num);
> +	pci_disable_device(pdev);
> +}

[ ... ]

> +static struct pci_driver xsc_pci_driver = {
> +	.name		= "xsc-pci",

[Severity: Low]
This isn't a bug, but the driver name here is "xsc-pci". The module is
called xsc_pci per the Kconfig help and the Makefile, and
pci_request_region() in xsc_pci_init() claims BAR0 under KBUILD_MODNAME
("xsc_pci").

So /sys/bus/pci/drivers/xsc-pci and the owner shown in /proc/iomem would
have different names. Later in the series xsc_core.h defines
XSC_PCI_DRV_NAME as "xsc_pci", but .name still uses the hyphenated string.

Would .name = KBUILD_MODNAME be more consistent?

> +	.id_table	= xsc_pci_id_table,
> +	.probe		= xsc_pci_probe,
> +	.remove		= xsc_pci_remove,
> +};

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126145711.70868-1-tianx%40yunsilicon.com

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6009E3BFE41;
	Sat, 10 Oct 2026 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791650726; cv=none; b=BbHs16xwR1cja9+yPODK/T7qNdUOLX1pBlPvnnzruKPofY4sAazrUOU4yVJlW58BbwhhQ9DgwatqEbeLIrJsiM60KqL84cVk8murP61FZi7/w97aFXHKt8ofcH9dX/O/PJdXbWShv9CjF2EXaaPm3Jj7xo1trg8b9dbbLnZ83Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791650726; c=relaxed/simple;
	bh=ADsm7uiEMCxBHs6X1kEtYy6VCQL+Q1sBBSVnXBZ3fi0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Szi3P+HrovtPm8WHtaj+hC7WSjzRbW79Lii6omTBrDLrHBfPJl54zuw84v8Lb7zp5kVEgu5wJYCEsNvatTAUZ6IiQ4HBwYkKsnXf6K8pVgZ6+sdrl3Tmcr6agA9uYQKf1BAfHpGujZybQi1lV05LfY2AYleLAqDD2wgNHO/JEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cW8daFep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cW8daFep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E546B1F000FF;
	Sat, 10 Oct 2026 16:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791650723;
	bh=pvsjiwZx+xIsJolf/NAt29QhFY341sWiNZv+tPj/ZoE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cW8daFep2Y6UyKJg4dcQNh74s6YaRYOl/kSBxCKTDYpc3oWQpevNIsXvDm/32764V
	 uGDNoRe/x/CnGDVhRhcuwc/WhkJVFpEyk37nfNt7cXOxw+FV6uS3WDUQH7/bk12k33
	 qfPUdF31VeLddmT4qhn2r1AjL15ZBcdX4aiahygO5TtdQ5dMIERytuYqrj5X2FEJNZ
	 rv6XbJSghQ6XsqwGJK+TrJCQHseo8QfJVk2GrRQS3ePr5kIsXP3HXDERt0bBV64qNM
	 OxYrHT3GfbQFiE1CpLSs/CMw7jBK0X4t1cX86rDf+aEoLyxlFLA61A62zNzlqqmaag
	 hKkU+dLDzg0lA==
Subject:
 Re: [net-next v2 1/3] bnge: Add infrastructure support for RoCE MPC channels
From: netdev-bot+sashiko@kernel.org
To: siva.kallam@broadcom.com
Cc: leonro@nvidia.com, jgg@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, vikas.gupta@broadcom.com,
 ajit.khaparde@broadcom.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 sachin.holla@broadcom.com, dharmender.garg@broadcom.com
Date: Sat, 10 Oct 2026 16:45:22 +0000
Message-ID: <179165072240.434549.10870506597507225182@kernel.org>
In-Reply-To: <20261006161256.1493672-2-siva.kallam@broadcom.com>
References: <20261006161256.1493672-2-siva.kallam@broadcom.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch has no consumer, and its subject and body promise more
  than it does.

--

bnge: Add infrastructure support for RoCE MPC channels

This patch adds a bar1 pointer to struct bnge_auxr_dev. It also fills that
pointer in from bd->bar1 in bnge_set_auxr_dev_info(), next to the existing
bar0. The commit message says follow-on patches will use it to send RoCE
commands to the firmware over the MPC channels.

> diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
> index 0955b488b6fea..87ae40eab5926 100644
> --- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
> +++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
> @@ -181,6 +181,7 @@ static void bnge_set_auxr_dev_info(struct bnge_auxr_dev *auxr_dev,
>  	auxr_dev->pf_port_id = bd->pf.port_id;
>  	auxr_dev->en_state = bd->state;
>  	auxr_dev->bar0 = bd->bar0;
> +	auxr_dev->bar1 = bd->bar1;
>  }
>  
>  void bnge_rdma_aux_device_add(struct bnge_dev *bd)
> diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
> index 6c5c15ef2b0a7..13cb9289f5b89 100644
> --- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
> +++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
> @@ -46,6 +46,7 @@ struct bnge_auxr_dev {
>  	struct net_device	*net;
>  	struct pci_dev		*pdev;
>  	void __iomem		*bar0;
> +	void __iomem		*bar1;

[Severity: Low]
Does anything read auxr_dev->bar1? This commit has no user of the new
field. The later patches in the series ("bnge: Update HSI" and "bnge:
reserve TX/completion rings for the RoCE MPC channel") don't add one either.

drivers/infiniband/hw/bng_re/ dereferences neither ->bar0 nor ->bar1. It
still maps its own regions, in bng_re_map_cmdq_mbox():

	mbox->reg.bar_base = pci_resource_start(pdev, mbox->reg.bar_id);

and in bng_re_map_creq_db():

	creq_db->reg.bar_base = pci_resource_start(pdev, creq_db->reg.bar_id);

Could this assignment and the new field move into the bng_re patch that
first uses auxr_dev->bar1?

The subject and body also describe more than the patch does:

    bnge: Add infrastructure support for RoCE MPC channels

    Add the initial L2 driver plumbing for RoCE MPC (PRIMATE channel)
    support:

Nothing in the change is specific to MPC or PRIMATE. The body also has a
bullet list with only one item.

If the field stays in this patch, could the message say that it only
passes the existing L2 BAR1 doorbell mapping to the RoCE auxiliary device?

>  
>  	struct bnge_msix_info	msix_info[BNGE_MAX_ROCE_MSIX];
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006161256.1493672-1-siva.kallam%40broadcom.com

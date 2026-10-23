Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785965;
	b=H8RTgqtHhcRQ7ZHULt/B/qfkQeAtcnpc5gvwJwyGkG8nxNgrGXQ3k5d+7FSwyWl8fQ1f
	 utdg/c5PJUTGDEJlmng8fTw7mR8KIoxFWEWzD25vGngpphMT8iKblEuXAvLpudih2ppvz
	 FiXfr5+tK+S/v1qe1XEfTHvOmcKA8zovgeNpsRw2ovXAe2dlHUGejodzqeeYQFx81cmmt
	 EQidYU5wBesUPLucPVChHqURkhwhbJVJSyDZUKkx26O/RGGVq+A9pj8qM7wDDsik7sfeq
	 Oz9DtwMhPZEKJpc4Cp3z7uIHBhRSXmEM7Zeh4xjbBeIGgaS4ijLZteemy9fGE2a7G1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785965;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/O0sZKTmVZ38poySSnSx6Ltu35wYmyj+OIfx4ivV2Qo=;
	b=fZ6KaNiehBcDWjHF1v/6CVOs5KlvFQKRGjVPkZziXVpGlHAzoIArnwU78crJFjoF4ZUH
	 1YHMD9eY4pIm7lgEjWM4EWjobVbRnkRZoKVKqfgcJj9eYooA0dQqtS10wZSvOfXaltkh8
	 GebvJPy0HZUsyMXn4rOP5F7g4hlydoG8z4JibTD5phe6hrBbhkRkhPg3snwcafNDTc5LZ
	 vGEiXXEhodtzEFV+mBjbjbq6OHVsfvXtK+M173bU1iJIq2SS9DsmaMt6ko8r3IMDfiGvL
	 avCdUUvbhL+Fx8iiy8i485k+jxzuOnQK3a7TZdhSz5FI218tnoBA0wkxdWw2Djhbi6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mWSCygvH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56CB606A31A;
	Fri, 23 Oct 2026 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mWSCygvH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544D71F01825;
	Fri, 23 Oct 2026 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785964;
	bh=/O0sZKTmVZ38poySSnSx6Ltu35wYmyj+OIfx4ivV2Qo=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=mWSCygvHqO2WyMvE0JSZL2L74ZcdvIqzapTk0tZrTGO+p1JsQtXrslUdPMgLJ1x5k
	 httC6LSsE+IzE2q04YnWeAjJgZ1Gm7geAKXAsO/xY6u7TGxnCAFFVMHhlgNVqUbd7X
	 yhGPDn0fKMlNnM+/5xA5bDmHHRY2I0Otl3DdNMNrwGrADE54PYMWnEKPG3b/chpBWk
	 pG/5Es8SuLuIyNZvAob1u83Ngu9BaYydorH5jnno0QVEvQSsYon3nj/1Owxd5yRhHM
	 vcZmDpFx7/UfayiK/ogL8qdJfPhJl9AyEvgePzC6UJidLShlxCRXAVIcaM0PlE7Ek8
	 7rqbJSNXMtjew==
Date: Fri, 23 Oct 2026 15:06:03 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	open list <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: Re: [PATCH net V2 2/4] net/mlx5: Lag, limit aggregated TX speed by
 PCIe bandwidth
Message-ID: <20261023200603.GA2734761@bhelgaas>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022193053.3815866-3-tariqt@nvidia.com>

On Thu, Oct 22, 2026 at 10:30:51PM +0300, Tariq Toukan wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> FW initializes max_tx_speed to the minimum of the port speed and the
> PCI bandwidth. Modifying it with a value computed by different rules
> changes the meaning of the field rather than updating it.
> 
> Limit the aggregated LAG TX speed by the PCIe bandwidth. Clamping each
> uplink separately and then summing could let the aggregate reach a
> multiple of the link's real bandwidth, so clamp the sum once instead,
> counting only the ports that contribute to it.
> 
> This assumes the bonded PFs share a single PCIe link, which holds when
> they are functions of the same device. In Socket Direct, each port spans
> multiple mdevs on separate PCIe links, so the PCIe budget for that port
> is the sum of its mdevs' PCIe bandwidths. Where Socket Direct ports do
> not have equal PCIe budgets, the aggregate is clamped to the narrowest
> port, which under-reports rather than over-reports the available
> bandwidth.
> 
> pcie_bandwidth_mbps() reads the endpoint link only, without traversing
> upstream bridges, and uses the nominal per-lane transfer rate times the
> link width, without encoding overhead. FW initializes max_tx_speed from
> the same endpoint-only link status, so using the same calculation keeps
> the clamp consistent with the value FW programs before LAG. Ethernet
> speeds and max_tx_speed are likewise nominal rates, so the comparison is
> like for like. A more accurate bandwidth estimate would make the
> aggregate differ from the per-vport value FW sets up for the same link.
> 
> If the PCIe bandwidth of a contributing port cannot be read, the speed
> calculation fails instead of returning an unclamped or partial result.
> A device that has no Link Status register, an RC integrated endpoint,
> has no PCIe budget to apply and is not clamped.
> 
> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ...

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8cc6a89130b5..064eef237d6f 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -6006,6 +6006,22 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pcie_link_speed_mbps);
>  
> +u32 pcie_bandwidth_mbps(struct pci_dev *pdev)
> +{
> +	u16 lnksta;
> +	u32 width;
> +	int speed;
> +
> +	if (pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta))
> +		return 0;
> +	speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
> +	if (speed <= 0)
> +		return 0;
> +	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
> +	return speed * width;
> +}
> +EXPORT_SYMBOL_GPL(pcie_bandwidth_mbps);

Can you split this into its own patch?

It looks like cxl_pci_get_bandwidth() and maybe even
pcie_bandwidth_available() could be refactored to use this.

>  /**
>   * pcie_bandwidth_available - determine minimum link settings of a PCIe
>   *			      device and its bandwidth limitation
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5ffcf5ce8c96..202bc8680601 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1479,6 +1479,8 @@ u32 pcie_bandwidth_available(struct pci_dev *dev, struct pci_dev **limiting_dev,
>  			     enum pci_bus_speed *speed,
>  			     enum pcie_link_width *width);
>  int pcie_link_speed_mbps(struct pci_dev *pdev);
> +u32 pcie_bandwidth_mbps(struct pci_dev *pdev);
> +
>  void pcie_print_link_status(struct pci_dev *dev);
>  int pcie_reset_flr(struct pci_dev *dev, bool probe);
>  int pcie_flr(struct pci_dev *dev);
> -- 
> 2.44.0
> 

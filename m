Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608CC3D953E;
	Tue, 29 Sep 2026 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790725515; cv=none; b=gpJ42LvNm0uAWEdqQZ/hR8H/jaO9ujFklSQBdJDHzRW+8kjxruJcd9GY9ieckKFaetN3TbSP9BfinhH0rLiAMegq9TJnFJxniA+IqkXH8Zr4hfl4Vj2BOpTJa4uaRd/eC5jbBAnld3UlZq8CObhJYSnJ3mBz4wCQmVnZyIJF1XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790725515; c=relaxed/simple;
	bh=qaD+oUK2DtSCtyltd/DU1cGOaw33iQMQ/3aJCRprPkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HUH+vUTkCHI3A3zK1va7Uh9M1jbrp2tFY/fzBROAad84lsNbtLMsMymZswTTvSDYTclFScsE3ZPtnu3feEE8Ggw1t8paZFzims5Ab1uAO3emkqlwP//3rjEcQLDOi616Lemnop0ZQyWfDx2SJB1yDUKyr5rHqqzRWumdaPvBW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NgkLEWKL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NgkLEWKL"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.35])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7D43D20B7166;
	Tue, 29 Sep 2026 16:44:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D43D20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790725461;
	bh=FuVEsT1W2BzsrFSye+6V6QlSXmi+gbYDtaB0fNAucQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgkLEWKLuqLGYVaKVKJ7I8Bkj6eL0gl4Q1U2MjjsFwhgNlaIbUv5JK5OMIT+x8Pl6
	 lGKr2yfpcP/5Tzdd2O1NR1GihuZyOqzj4aveKxpODnlW88Cb2G54QVnaNrva5m1TJN
	 amefGb0muT+7m1V/zMTU0UvxD8IJY9vtXfPwmP0o=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: horms@kernel.org
Cc: netdev-bot+sashiko@kernel.org,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	nipun.gupta@amd.com,
	nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com,
	Manish Awasthi <mawasthi@linux.microsoft.com>
Subject: Re: [PATCH net-next 4/4] net: mana: Add support for CDX device ID 0x00C2
Date: Tue, 29 Sep 2026 23:45:08 +0000
Message-ID: <20260929234508.10647-1-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260929135738.GT13925@horms.kernel.org>
References: <20260924173054.589291-5-mawasthi@linux.microsoft.com> <179035761944.2160803.12943182451050438147@kernel.org> <20260928202555.617331-1-mawasthi@linux.microsoft.com> <20260929135738.GT13925@horms.kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, Sep 28, 2026 at 08:25:55PM +0000, Manish Awasthi wrote:
> > thanks for review. Comments inline.
> > 
> > > Thank you for your contribution! Sashiko AI review found 3 potential
> > > issue(s) to consider.
> > > 
> > > Critical: 0 · High: 0 (1) · Medium: 1 · Low: 2
> > > 
> > > If you believe none of the issues are legitimate, please reply to each
> > > issue of Medium severity or higher and explain why the AI is wrong.
> > > If any of them are legitimate and you plan to respin, please let patchwork
> > > know by including "pw-bot: cr" as a separate line at the end of your reply
> > > (one such reply per series is enough).
> > > 
> > > - [Medium] The CDX transport installs `.dev_reset = mana_cdx_dev_reset`
> > >   (-> `cdx_dev_reset()`) but has no way to recover afterwards.
> > > - [Low] `mana_cdx_setup_hwc_irqs()` skips IRQ affinity hints.
> > > - [Low] The comment in `mana_gd_query_max_resources()` (gdma_main.c)
> > >   says: "Only reset on platforms that support dynamic MSI-X allocation;…
> > > 
> > > Pre-existing issues:
> > > - [High] This problem wasn't introduced by this patch, but the shared HWC
> > >   bootstrap path that the new CDX transport now reaches trusts a device-…
> > > 
> > > --
> > > 
> > > net: mana: Add support for CDX device ID 0x00C2
> > > 
> > > This adds a CDX bus transport for MANA, built as mana_cdx.ko on top of
> > > the shared gdma_core.ko, for device ID 0x00C2. It allocates the whole MSI
> > > pool at probe time, limits the queue count to the available vectors,
> > > restricts DMA to 32 bits, and adds a per-bus auxiliary device name prefix
> > > so the CDX auxiliary devices stay separate from the PCI ones.
> > > 
> > > > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > > > new file mode 100644
> > > > index 0000000000000..0d01e3d2f0d96
> > > > --- /dev/null
> > > > +++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > > > @@ -0,0 +1,340 @@
> > > 
> > > [ ... ]
> > > 
> > > > +static int mana_cdx_dev_reset(struct gdma_context *gc)
> > > > +{
> > > > +	return cdx_dev_reset(gc->dev);
> > > > +}
> > > 
> > > [Severity: Medium]
> > > Can this reset leave the whole function unusable, with no recovery short
> > > of a manual rebind?
> > > 
> > > mana_dealloc_queues() calls it when a TX queue still has pending_sends
> > > after the drain timeout:
> > > 
> > > mana_tx_timeout()
> > >   -> queue_reset_work
> > >     -> mana_per_port_queue_reset_work_handler()
> > >       -> mana_dealloc_queues()
> > >         -> mana_gd_dev_reset()
> > >           -> mana_cdx_dev_reset()
> > >             -> cdx_dev_reset()
> > > 
> > This version of the driver doesn't support recovery after mana_cdx_dev_reset.
> 
> I don't think it needs to delay progress of this patchset.
> But I am curious to know if there are plans to add such support.
> 
    It is possible to have similar recovery support as the pci in this path
    after cdx_dev_reset() and we do have plans to add it in future.
> ...

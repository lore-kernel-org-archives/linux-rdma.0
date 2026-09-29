Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E61152CCD1;
	Tue, 29 Sep 2026 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690266; cv=none; b=cf21iB0rQiMcGEEiMshVbwzDHVaO1U7Pf9e15ED7hdLJkC4UQgzdkxGFtcYHn7s0E6f4Qe5ZlgRj7WBDn9JZMpY3FWbyIOsbIfbp5T8agfsgbM7M9jj50ZwgGRWD9m9W34UIMQRRAJpf1twnjI5ICss3AESFLAiIPPcn7zg5JnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690266; c=relaxed/simple;
	bh=DTJbNYpfCBu5ooZqKtvFHwpHQFtn+LZmSu/i/H5nnx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/3J7UuQx9uVwfY/8qriI/vvJjO1PiWw7SsNHcz1kv4o14GfIszFvGCbaBDKAdAcJSy7Wi0QnbNJyhLm/N6Y/aHh4GyFUuSmAwVzAzRAlXWoz5AOFGt6OEnVhumU9SRsfrsGOsH2gASo3oN2oGpX7a2771g5/pL87ruo0RuIl50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCGE4C7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCGE4C7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4DA1F000FF;
	Tue, 29 Sep 2026 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790690264;
	bh=xBnytLQO3xzqaW+JhEfPfT8bcu2EnuDx1iy7C0tBPVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LCGE4C7sJVroiez6PTTMMq9W9U2n+UUuPUySac02C+z6iiFu0qfbqS95MrI2Bx9Tg
	 TCVmkJLeXDrjbkXDEohcdWU0kRcFuKs0ziNktkqe8tSjLk9YPXRxyViZuvYOGSxylp
	 25V0lMsTyjGqGhHFlSESB4tofar6dlzzeozneZh38+Bkix4T5Wf334OJiyBzz+3nT6
	 btNGEQLRqZh2lKb94tA80O8DjVuxep35kI/Y+8/fDjWlI0wQQe748i5LVJuqNUERTA
	 I5zYwzJXm5Dmapzgk2KzmIyB7x97FusSu8Zzr4JDOu8m/LtYqmF/X/SToZB8R+RLVe
	 Vly/BNAAM69oA==
Date: Tue, 29 Sep 2026 14:57:38 +0100
From: Simon Horman <horms@kernel.org>
To: Manish Awasthi <mawasthi@linux.microsoft.com>
Cc: netdev-bot+sashiko@kernel.org, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	kotaranov@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	nipun.gupta@amd.com, nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com, ernis@linux.microsoft.com,
	kees@kernel.org, paulros@microsoft.com, mawasthi@microsoft.com
Subject: Re: [PATCH net-next 4/4] net: mana: Add support for CDX device ID
 0x00C2
Message-ID: <20260929135738.GT13925@horms.kernel.org>
References: <20260924173054.589291-5-mawasthi@linux.microsoft.com>
 <179035761944.2160803.12943182451050438147@kernel.org>
 <20260928202555.617331-1-mawasthi@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928202555.617331-1-mawasthi@linux.microsoft.com>

On Mon, Sep 28, 2026 at 08:25:55PM +0000, Manish Awasthi wrote:
> thanks for review. Comments inline.
> 
> > Thank you for your contribution! Sashiko AI review found 3 potential
> > issue(s) to consider.
> > 
> > Critical: 0 · High: 0 (1) · Medium: 1 · Low: 2
> > 
> > If you believe none of the issues are legitimate, please reply to each
> > issue of Medium severity or higher and explain why the AI is wrong.
> > If any of them are legitimate and you plan to respin, please let patchwork
> > know by including "pw-bot: cr" as a separate line at the end of your reply
> > (one such reply per series is enough).
> > 
> > - [Medium] The CDX transport installs `.dev_reset = mana_cdx_dev_reset`
> >   (-> `cdx_dev_reset()`) but has no way to recover afterwards.
> > - [Low] `mana_cdx_setup_hwc_irqs()` skips IRQ affinity hints.
> > - [Low] The comment in `mana_gd_query_max_resources()` (gdma_main.c)
> >   says: "Only reset on platforms that support dynamic MSI-X allocation;…
> > 
> > Pre-existing issues:
> > - [High] This problem wasn't introduced by this patch, but the shared HWC
> >   bootstrap path that the new CDX transport now reaches trusts a device-…
> > 
> > --
> > 
> > net: mana: Add support for CDX device ID 0x00C2
> > 
> > This adds a CDX bus transport for MANA, built as mana_cdx.ko on top of
> > the shared gdma_core.ko, for device ID 0x00C2. It allocates the whole MSI
> > pool at probe time, limits the queue count to the available vectors,
> > restricts DMA to 32 bits, and adds a per-bus auxiliary device name prefix
> > so the CDX auxiliary devices stay separate from the PCI ones.
> > 
> > > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > > new file mode 100644
> > > index 0000000000000..0d01e3d2f0d96
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
> > > @@ -0,0 +1,340 @@
> > 
> > [ ... ]
> > 
> > > +static int mana_cdx_dev_reset(struct gdma_context *gc)
> > > +{
> > > +	return cdx_dev_reset(gc->dev);
> > > +}
> > 
> > [Severity: Medium]
> > Can this reset leave the whole function unusable, with no recovery short
> > of a manual rebind?
> > 
> > mana_dealloc_queues() calls it when a TX queue still has pending_sends
> > after the drain timeout:
> > 
> > mana_tx_timeout()
> >   -> queue_reset_work
> >     -> mana_per_port_queue_reset_work_handler()
> >       -> mana_dealloc_queues()
> >         -> mana_gd_dev_reset()
> >           -> mana_cdx_dev_reset()
> >             -> cdx_dev_reset()
> > 
> This version of the driver doesn't support recovery after mana_cdx_dev_reset.

I don't think it needs to delay progress of this patchset.
But I am curious to know if there are plans to add such support.

...

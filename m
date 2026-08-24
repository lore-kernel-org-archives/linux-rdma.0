Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882CF261B71;
	Mon, 24 Aug 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787588226; cv=none; b=MIqsjnksKOCe/P7GBXtIty0SmafG+EBhvkEfmZ2Fk2PahpgdTeExgggOa50qzHmVHMeyskHvQw0JsG7Jt4uCiWgGWLjZ35rNTp1JcPk66Jl3tJ6ihoHwF35hDRjCO3589LNFKPxwI5DrsRr5KePWXKVIR/cBnNw+183rViZRbh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787588226; c=relaxed/simple;
	bh=8dEj8LePs+Jjsfl/Wf7Ly8uQwZrYDvmNeWM/yRINtHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNagQOtVy2GqKYoVwOYypAiJdOv1dxWEcw+4iLCsYTVAyZgVSXomCRzH1scgTUE1lngGKIC0iJMiORxcAkQfBgFqIDtyeb3TdW3kfsBn14cn90824MxY0S72fZngH4NUsTJwcQWBFGsy2iS/ah5jTZCkNXoUMGC969IFhA4CAZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZz6bZQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZz6bZQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F313C1F000E9;
	Mon, 24 Aug 2026 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787588225;
	bh=ZAIjcODyQgZxYb92fmjrfGJfnu8GCL4CUSvPv8gPEKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NZz6bZQw2xjeH5QN/yO0MTqGyHSdDoIR09XRlgWqTY9Awo+ypQr/PCgRJKOQTjc/d
	 YMyXF63/2yTjLyY2ba8EesGqHawjdc7o6ycnhDDQRhxczPqvE4uC4zbb1nYpyPc09i
	 6Us4UNuUlx/JJ4AxNKrqQKigJu1XAc2+vnHAwnmwI/hGgKbm3ohAd0lBACTGA4F4Sq
	 HcqT+i9fObz2sIbQLVKCQkZuJEYl6wtfTFT35pb31QZPF/S51BspEf/tD0oZXlsat4
	 Bde5HMrWnkgTNpBLBtJlcC/hRPpPmTVmGnMPYUg9RRXEchOT9xIz5sTBotNQUsbE7I
	 nMkp/10yjq4hA==
Date: Mon, 24 Aug 2026 17:16:58 +0100
From: Simon Horman <horms@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com, ernis@linux.microsoft.com,
	stephen@networkplumber.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Cap MSI-X vectors to the device MSI-X
 table size
Message-ID: <20260824161658.GY265046@horms.kernel.org>
References: <20260821183736.733296-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821183736.733296-1-longli@microsoft.com>

On Fri, Aug 21, 2026 at 11:37:36AM -0700, Long Li wrote:
> mana_gd_query_max_resources() sizes gc->num_msix_usable from resp.max_msix
> and the CPU count, but never from the device MSI-X table. On a 1792 vCPU
> M-series VM that yields 1793 while the table has 1024 entries, and
> mana_gd_setup_remaining_irqs() then walks indices 1..1792, running off the
> end of the region mapped by msix_map_region():
> 
>   BUG: unable to handle page fault for address: ff8e347f8b99800c
>   RIP: 0010:msix_prepare_msi_desc+0x7a/0x90
>   RAX: 0000000000004000 RBX: ff4330cb164ea780 RCX: ff8e347f8b998000
>   Call Trace:
>    <TASK>
>    __msi_domain_alloc_irqs+0x13a/0x440
>    msi_domain_alloc_irq_at+0x149/0x1b0
>    mana_gd_setup+0x351/0x890
>    mana_gd_probe+0x274/0x390
>    </TASK>
> 
> RAX is index 1024 * PCI_MSIX_ENTRY_SIZE, one entry past the table.
> 
> msi_insert_desc() does range check the index, but only against the MSI
> domain hwsize, which matches the table only for devices on an MSI parent
> domain. With a global PCI/MSI domain hwsize is MSI_XA_DOMAIN_SIZE, so
> nothing bounds the request.
> 
> Cap num_msix_usable with pci_msix_vec_count().
> 
> Fixes: 755391121038 ("net: mana: Allocate MSI-X vectors dynamically")
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Simon Horman <horms@kernel.org>


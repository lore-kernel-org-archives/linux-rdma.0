Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF2552CCD1;
	Tue, 29 Sep 2026 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690306; cv=none; b=RiR6wkSHobTXnSWaZBv2ag3yDv501rQ70Tcaz53T+U+/rpc6AtJXBKMWG5GXRv03NDFS2mkVR+mmLfH3HdO2oG2btSyfrQeyEVWdwxrV8PFSLoTL0aX1r4ZKWMHw5jDfdpwbMVEciP8d8TJbwKCBWy33H8l9MSfHVBxYwDAbCt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690306; c=relaxed/simple;
	bh=82Al3bLKviLulvYmqsyZFVFB86RfcW1kpgUfJzTRgmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y91SC/rT0fLjj85YoB9tNxifdPBKy4q2Z9GGgvstcW5yg0OW+I5Fy1BanlLGJXolnemURqw8Hgab1HXc3ZmP8MRLhTF01EEUrt2coK+sRUTD5/8JBT6OvfhllKmAWZazIijHlounJSnAHF2wzzcBMBc07OGU2/nQ1UgUdyckZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWpcPF7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWpcPF7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AD01F00893;
	Tue, 29 Sep 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790690305;
	bh=NOA+b6mEHM0sTpPLnypkbzJb83RcP+f2mcfPVl+iRz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hWpcPF7jtiTrS34MrATNDSDRaM+DDhIFOjp7fgwCeEtvNUhOkO035XM/40TyhdTFx
	 pnWDQmOeaGeMNDGbJhC7E7MHb2jMH756cxoI0TBuQ1bmhiVMkslFgzvWAAO80CkMMG
	 6eZu1lCYfasSKoS0pxCW/cRx0n0GRQA9vUWZ1s6oOJ+qz7CW0MwxzmdKFFl2o3aDKm
	 iG20twHAdXwZsKi8Z4XqYgp0GRXhArQ3mm1iWbcn1LbLxtUFmgUsD02j+ei6IiXecO
	 wKA4bGO5kgvfcoTHZ7VFr/PBUZCLkB1CjVSZANmeDBhx9BmTJLCsfawqogHOsGao7Z
	 IQqoW66/SOpZg==
Date: Tue, 29 Sep 2026 14:58:19 +0100
From: Simon Horman <horms@kernel.org>
To: Manish Awasthi <mawasthi@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org, nipun.gupta@amd.com, nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com, ernis@linux.microsoft.com,
	kees@kernel.org, paulros@microsoft.com, mawasthi@microsoft.com
Subject: Re: [PATCH net-next 0/4] net: mana: Add support for the CDX bus
Message-ID: <20260929135819.GU13925@horms.kernel.org>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924173054.589291-1-mawasthi@linux.microsoft.com>

On Thu, Sep 24, 2026 at 05:30:50PM +0000, Manish Awasthi wrote:
> This series adds CDX bus support to the MANA driver.
> 
> The shared GDMA and Ethernet code currently builds together with the PCI
> transport. To add another bus without duplicating the driver or adding
> configuration checks throughout the shared code, this series separates the
> bus-specific operations and builds each transport independently.
> 
> Patch 1 introduces gdma_bus_ops and routes bus-specific interrupt, reset,
> service, and setup operations through it.
> 
> Patch 2 moves the PCI-specific code from gdma_main.c into gdma_pci.c
> without changing PCI behavior.
> 
> Patch 3 builds the shared code as gdma_core.ko and the PCI transport as
> mana.ko. The PCI module keeps its existing name, device table, and
> mana.eth/mana.rdma auxiliary-device identities.
> 
> Patch 4 adds the CDX transport as mana_cdx.ko for device ID 0x00C2.
> 
> Manish Awasthi (4):
>   net: mana: Introduce gdma_bus_ops for bus-specific operations
>   net: mana: Move PCI transport code into gdma_pci.c
>   net: mana: Build the PCI transport as a separate module
>   net: mana: Add support for CDX device ID 0x00C2

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>


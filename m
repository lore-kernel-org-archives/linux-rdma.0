Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B0F3CCFDF;
	Thu, 12 Mar 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338938; cv=none; b=cY2SnUskQP0ObDfR5djDqUt7xISh9+01S+XU6qOACqE55/zzc3echFdhPPuCRkkQ97Lbsa7E3a6JAzZG0F1U4O3VHgjkTfml+3KRL2TouQc9Sj5oIMmQtklmotSbXmFqhTg3NqfAXRWVSzEjcJC+VacQCcxRoHWze6Y1MuEZ4Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338938; c=relaxed/simple;
	bh=zKubwnE6WBFqFhMA7VdJVmmNgM5iok6L4iNXlYsPiJk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G66JpYxOnNjt53smc8vuy4uUY0Su8/PcOxZAnvnEYeJ1GJ1DShaTf+LvL9gVbVaUwogaBfI8fwBk8G5gj8kSXBDtGi/Unb5WaIGjHPcscybz7Y1fDi54hjb4Lobj6ykQwINGIGDqPl2RYFYo33JBOZ69jQoWyC4P8JkI+T/KyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=amCrJEYr; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="amCrJEYr"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id BBB5F20B710C; Thu, 12 Mar 2026 11:08:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BBB5F20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773338935;
	bh=YJqUVJBTcGYoYBP952Xegm6UMbj6eDAXix4l/bYt0+s=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=amCrJEYrHoBXsY8281kNYyzTHswa4TWOaiY0DklnOCpFzyJ5PjmDxeUT0rKBRdTFR
	 8kSIUquvlWuPNXcNilcfNWCc3wKcax50rqaLnEdvcLCmu9Dws3nx85dgDwUC4HPoO2
	 wfVlbsh7xpEsDpxRP02TU5aC5JU6RspY4F9dFZ48=
Date: Thu, 12 Mar 2026 11:08:55 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: longli@microsoft.com, kotaranov@microsoft.com,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: hardening: Clamp adapter capability
 values from MANA_IB_GET_ADAPTER_CAP
Message-ID: <abMBN3I4A0OrYtoD@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260312112538.966157-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312112538.966157-1-ernis@linux.microsoft.com>

On Thu, Mar 12, 2026 at 04:25:37AM -0700, Erni Sri Satya Vennela wrote:
> As part of MANA hardening for CVM, clamp hardware-reported adapter
> capability values from the MANA_IB_GET_ADAPTER_CAP response before
> they are used by the IB subsystem.
> 
> The response fields (max_qp_count, max_cq_count, max_mr_count,
> max_pd_count, max_inbound_read_limit, max_outbound_read_limit,
> max_qp_wr, max_send_sge_count, max_recv_sge_count) are u32 but are
> assigned to signed int members in struct ib_device_attr. If hardware
> returns a value exceeding INT_MAX, the implicit u32-to-int conversion
> produces a negative value, which can cause incorrect behavior in the
> IB core and userspace applications.
> 
> Clamp these fields to INT_MAX in mana_ib_gd_query_adapter_caps() so
> all downstream consumers receive safe values.
> 
> Additionally, fix an integer overflow in mana_ib_query_device() where
> max_res_rd_atom is computed as max_qp_rd_atom * max_qp. Both operands
> are int and the multiplication can overflow. Widen to s64 before
> multiplying and clamp the result to INT_MAX.
> 
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

I will be sending v2 for this patch since it requires change in the
title.

Thanks,
Vennela

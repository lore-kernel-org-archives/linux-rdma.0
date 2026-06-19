Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9B53B9DAD;
	Fri, 19 Jun 2026 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898103; cv=none; b=J0YAk/Dct9S7MKP/CZHhvjuVYLMKkFDpXfcLJcfcNYMRpHoz1ZV9etAIjaLqklJ+yL7J/2S6fKZIeTEOUK0m/3ZOXzNbF4QENPMmK++I3mdHxvok5gwJWzXBz9PJNddP2P7FLQYL3SA4uPuxEalc3s+fsUbgp9y9NvRbhHCQXGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898103; c=relaxed/simple;
	bh=aQaqEP2oOYF3BYd3WsTEnGHeidJGKAI5xZP4jpb2RmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpWYB+ujt+eay4wFjglY94JeBciYYfNTms5zVGVc44tVNbaE1E2ZZKANLIpZoaanP8wjnu5hZe0wY2WkcP/smlhvkW9/+XvsXtpFtTRx/f12CwNAVuSAq/Kzx0KN2DoEoF9pmLFq4hQlefrbvZKjRh5x0KbJII21BWqLtXduuTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=aWJDu0oh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aWJDu0oh"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id C02DB20B7168; Fri, 19 Jun 2026 12:41:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C02DB20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781898099;
	bh=gcWclnNH9OFtBIA6dfuYJBVCYP1vi/zTWtgJAjC6ylY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aWJDu0ohNkUA/izOjHPn4oJYUsltyAPYbADPV0lx2c3+NwX+JG+5I8R1YPcwqSzaI
	 54cIdE59F7DTgmGtV0H2Ll+oGls9qrHLhvkr4035X84TyyBMljzOXYffSeC3DwaAb8
	 hADfBs5haxlvfVFkcswdQ/V/7I/R4+vcLmw7OfQU=
Date: Fri, 19 Jun 2026 12:41:39 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: longli@microsoft.com, kotaranov@microsoft.com,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3] RDMA/mana_ib: Clamp adapter capabilities at
 the ib_device_attr boundary
Message-ID: <ajWbc1HNcMOy8xkE@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260525190101.1264185-1-ernis@linux.microsoft.com>
 <20260611111745.GM327369@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611111745.GM327369@unreal>

On Thu, Jun 11, 2026 at 02:17:45PM +0300, Leon Romanovsky wrote:
> On Mon, May 25, 2026 at 12:01:01PM -0700, Erni Sri Satya Vennela wrote:
> > mana_ib stores its adapter capabilities internally as u32 in
> > struct mana_ib_adapter_caps. The IB core, however, exposes the
> > corresponding device attributes through struct ib_device_attr, where
> > fields such as max_qp, max_qp_wr, max_send_sge, max_recv_sge,
> > max_sge_rd, max_cq, max_cqe, max_mr, max_pd, max_qp_rd_atom,
> > max_res_rd_atom and max_qp_init_rd_atom are signed int.
> > 
> > mana_ib_query_device() is the only place that copies the cached u32
> > caps into these int fields. If a cap exceeds INT_MAX, the implicit
> > u32-to-int narrowing yields a negative value. Clamp each cap to
> > INT_MAX at this boundary so the values handed to the IB core are always
> > non-negative.
> > 
> > While here, fix a related overflow in the computation of
> > max_res_rd_atom. It is derived as max_qp_rd_atom * max_qp, both of
> > which are int after the assignment above; the multiplication can
> > overflow an int even with the new clamps in place. Widen to s64
> > before multiplying and clamp the result to INT_MAX.
> > 
> > Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> > ---
> > Changes in v3:
> > * Drop clamping from mana_ib_gd_query_adapter_caps(). The internal u32
> >   caps cache does not need to be clamped.
> > * Move all clamping exclusively to mana_ib_query_device(), which is the
> >   only place the cached u32 values are narrowed into the signed int
> >   fields of struct ib_device_attr.
> > * Reframe commit message: this is a u32-to-int type boundary fix, not a
> >   CVM/untrusted-hardware hardening patch.
> 
> You should align all types to u32 and avoid hiding the issue behind  
> min_t().
> 
> Thanks
Yes Leon, I'm currently at v7 version of this patch.
I'm planning to completely avoid using min_t in the next version.

- Vennela

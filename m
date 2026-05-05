Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676DF48B367;
	Tue,  5 May 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998534; cv=none; b=C1aMZxqOv2kOkoUdS3QQ9FaOTHRK6cGFF7l6AT0rc9ro5J5KlIkFX9zIn7T2oXpUilu3t8kzwrl5GS6MoFffXNuTClNCl4adpGhii+i1wF0+Nh4C0q1m5DxtFMe/+JjX7YzBKu/4wbVl/8YgP7P5lL1F0b5TrZfsvCgsYpd58TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998534; c=relaxed/simple;
	bh=qpP5JJexx5FbkH/P8mJ5gw7/jHOXkN/yHbJmFS6aZK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJNBNeFiRIB/EVcxeiA2voKFKBrowI+jAADxH2Rl0ELQKUcHqFVn7yulQlw/TffBKHeMTIpVgKhnLhtHaAiWM3ZDAd2NuCG7WvTvUZl+k6+3QGW4mG/Rr17ZUjJHdvoG8Z822vZRYyx8ShWpckCtpNAmI3NGFgF4qD2N7aCTfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PUJNa2RE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PUJNa2RE"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id E9B0F20B7168; Tue,  5 May 2026 09:28:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E9B0F20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777998530;
	bh=yQ9B0+Murk+liHcUEGFo3TbZqnJLciO6uudJWzl4OMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PUJNa2REUMiWBad5gobyGUkXEJmQrPQDFgxtkL4tffBQtp/cN0EBDpCTv3zE/LJWz
	 8+SdQNQ5E6OEs5/4komCyIQ7DrLGLDJ3OQcY3u2+YQBt89Rhg4c5sbYf2bGIJjJnO0
	 pYwQ9owHP7vaWFWdWrxfjMJsPkKM5etMsiO2R5V4=
Date: Tue, 5 May 2026 09:28:50 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, leon@kernel.org,
	longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stephen@networkplumber.org, jacob.e.keller@intel.com,
	dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
	john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
	yury.norov@gmail.com
Subject: Re: [PATCH net, v3] net: mana: Fix crash from unvalidated SHM offset
 read from BAR0 during FLR
Message-ID: <afoawjLcpe++Cjsu@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <afQUMClyjmBVfD+u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <30f588ad-cf80-432b-bde3-13b3c0d5a124@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f588ad-cf80-432b-bde3-13b3c0d5a124@redhat.com>

On Tue, May 05, 2026 at 03:42:46PM +0200, Paolo Abeni wrote:
> On 5/1/26 4:47 AM, Dipayaan Roy wrote:
> > @@ -73,10 +74,28 @@ static int mana_gd_init_pf_regs(struct pci_dev *pdev)
> >  	gc->phys_db_page_base = gc->bar0_pa + gc->db_page_off;
> >  
> >  	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
> > +	if (sriov_base_off >= gc->bar0_size ||
> > +	    gc->bar0_size - sriov_base_off <
> > +		GDMA_PF_REG_SHM_OFF + sizeof(u64) ||
> > +	    !IS_ALIGNED(sriov_base_off, sizeof(u64))) {
> > +		dev_err(gc->dev,
> > +			"SRIOV base offset 0x%llx out of range or unaligned (BAR0 size 0x%llx)\n",
> > +			sriov_base_off, (u64)gc->bar0_size);
> > +		return -EPROTO;
> > +	}
> 
> I think that the additional fix suggested by sashiko is really worthy,
> but should go in a separate patch. @Dipayaan: please follow-up on that
> one, thanks!
> 
> Paolo
>
Hi Paolo,

Thanks for reviewing, and I will cross check and send out a separate patch for
issue pointed out by Sashiko(un-related to the current issue).

Regards
Dipayaan Roy



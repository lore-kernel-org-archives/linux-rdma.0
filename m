Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D43AA1A7
	for <linux-rdma@vger.kernel.org>; Wed, 18 Mar 2026 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829199; cv=none; b=KOnh3cA8HT7nGLwbJTFR7oYwVBPVeeOnXY9QkCX1wo11JpwUM0JimwXksyPxz8KjvtrPJqu2vxOV/Fxhhv/wut2dhOI5vxUztJg9c57m1CSIID9PMCKh88MrmffLhOsb6HZCKwRGFGBaCnUJRX0UYIZxhr9BsXpUzroNVld4Pvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829199; c=relaxed/simple;
	bh=j/trxIMFuf/elYQnnQzXiumqW9bTQ89j/pQJqMyFT20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DNCMhHduJJjaTAJ2GRrAH3tXNErBMxGSSKv3rxaPzGCud560MKjsZBOAM2VrjKw7wAIaPs+mT6jjDUq36nYeFCE1BWvwI8eAzPPB50ky9LHatXsWSNiYKTTECbem7nxE11/DbXSL2m8gR8gtj82kCsKuoWz7BShtBTxScJCLqx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsjoQqZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsjoQqZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31FBC19421;
	Wed, 18 Mar 2026 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773829198;
	bh=j/trxIMFuf/elYQnnQzXiumqW9bTQ89j/pQJqMyFT20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsjoQqZU+VbuElwgw1OXSgfePKQjFMRcHpxTToWiU2s5LvlTSgneAvR9hCAXodwTD
	 RdkfcuSVnRrFqE4EJutXMK+LrQsmayv6dssYzwAYzXtSkmyOk96kLujG4YGgOkaaIV
	 PnP90W44kb9uDpLGYa0a/A7Kl++NyIuxVUgTUGPbFNAsvbvR+22c8r3GhASR3y37Mv
	 Pcwpme5mg6AClRyukNYdJjcC136vCSgHKhhpu/UETbUcb06b/Rd/8qlgS2noU7xzZ/
	 lp+s1qDboxWcWkFgn5bfB0Ssg6xMpT9rLX1lyimJZG6ZmonQO8ePEQ7imjpWL0jZS0
	 AL3Nm+qgZ3w4Q==
Date: Wed, 18 Mar 2026 12:19:50 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
Cc: "Czurylo, Krzysztof" <krzysztof.czurylo@intel.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [for-next 02/12] RDMA/irdma: Fix data race on
 cqp_request->request_done
Message-ID: <20260318101950.GH61385@unreal>
References: <20260316183949.261-1-tatyana.e.nikolova@intel.com>
 <20260316183949.261-3-tatyana.e.nikolova@intel.com>
 <20260317111230.GW61385@unreal>
 <DS0PR11MB7736961A569FE56FDB09631EEB41A@DS0PR11MB7736.namprd11.prod.outlook.com>
 <20260317132253.GX61385@unreal>
 <DS7PR11MB7740083B561AB5756A48DB6FCB41A@DS7PR11MB7740.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR11MB7740083B561AB5756A48DB6FCB41A@DS7PR11MB7740.namprd11.prod.outlook.com>

On Tue, Mar 17, 2026 at 07:27:47PM +0000, Nikolova, Tatyana E wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, March 17, 2026 8:23 AM
> > To: Czurylo, Krzysztof <krzysztof.czurylo@intel.com>
> > Cc: jgg@nvidia.com; linux-rdma@vger.kernel.org; Nikolova, Tatyana E
> > <tatyana.e.nikolova@intel.com>
> > Subject: Re: [for-next 02/12] RDMA/irdma: Fix data race on cqp_request-
> > >request_done
> > 
> > On Tue, Mar 17, 2026 at 12:14:21PM +0000, Czurylo, Krzysztof wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: 17 March, 2026 12:13
> > > > To: Nikolova, Tatyana E <tatyana.e.nikolova@intel.com>
> > > > Cc: jgg@nvidia.com; linux-rdma@vger.kernel.org; Czurylo, Krzysztof
> > > > <krzysztof.czurylo@intel.com>
> > > > Subject: Re: [for-next 02/12] RDMA/irdma: Fix data race on cqp_request-
> > > > >request_done
> > > >
> > > > On Mon, Mar 16, 2026 at 01:39:39PM -0500, Tatyana Nikolova wrote:
> > > > > From: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
> > > > >
> > > > > Changes type of request_done flag from bool to atomic_t to fix
> > > > > data race in irdma_complete_cqp_request / irdma_wait_event
> > > > > reported by KCSAN:
> > > >
> > > > Again, this fix is wrong too.
> > >
> > > Could you please elaborate on what is wrong with this fix?
> > > And/or suggest how to fix it properly?
> > >
> > > Please note 'request_done' is _not_ a bitfield and we only do simple
> > > load/store operations on it.  There is no RMW.
> > > Despite this, KCSAN still reports a data race on it.
> > >
> > > Honestly, the original idea was just to change the type from
> > > 'bool' to 'u8'.  This is enough to silence KCSAN, but it is
> > > not clear why.  Perhaps it indicates a bug in KCSAN?
> > 
> > Yes, both u8 and atomic_t behave the same, they can't be interrupted
> > during read/write. This is why KCSAN doesn't warn you.
> > 
> > > I mean, maybe the report below is a false positive?
> > 
> > Sounds like that.
> 
> Leon,
> 
> Are you okay taking the rest of the patches in the series (they apply without the two KCSAN related patches) or you prefer that I resubmit the series?

Sure, let's me to pick them now.

> 
> For this specific patch, are you okay with dropping all atomic changes, but making request_done u8 (currently bool) to silence the KCSAN warning?

In general, I don't like changing code just to silence a tool, but in this
case it is justified. Switching to u8 not only quiets the warning, it also
reduces the size of struct irdma_cqp_request, just run pahole on it.

Thanks

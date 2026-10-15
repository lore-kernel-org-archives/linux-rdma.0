Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112E43B492
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 19:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094052; cv=none; b=fB2e+qCOHWDsXSBO6v8SoYgIdPDThl9yxM0kM+FMlB7OLd52Rxftd5eHo80p8vLiksxiXnCoO9f++rJHuk/teZkHktVwvhTsZ5h3q976gbiU/LhpgwTOT0ZkwBh26tgoGV7QQ/lH2ftSpS0ncT0iLRdFrgs+6YoTeTnLtZ8TKeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094052; c=relaxed/simple;
	bh=lamv/oWnH/WNaVd0xYfru+Uciw5oZNdonWGeFyBY37U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWORjRSwHWz1r3Za8GAjTGJ14UIJr4v3xHmYeO3s+BFeFacRYCVz6a3a2eXCct5kcLbQzgxkEPGupHkMwodsz22seDDgtSWdj4we50ZNVoC+HgT59cJqPJ5QUDR3ZKy06Hv4DJKixTSGKqOPf1SLSEJDDaA0Uq/ewHq8TUfuVi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cYUMSAHW; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cYUMSAHW"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91b63bd2030so68211146d6.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792094050; x=1792698850; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yz7tOCbp7wDhENSlXzMolHxr7bpwiFTGlAsANFk9cDs=;
        b=cYUMSAHWOzFVD3Ism2BM+ImlvaJJct2NJ+ouTAFhuVCaJXbUIjrSCU6WMvR0VzEE10
         hFZHMea5jNO8uPcQLPqjzRvBN357L1RFiAt4gtE67PbUgxNFrCm5yA1Tv+MltNcAXylQ
         SG5LFOZ08s1fLw9GAo++F3gE3Epar+5Q4OpidAJN8Q2gHJYoucAO2LqUBazYaLvctxi+
         c/81Z9ON1nImhPdX5GW1nRDJoa83dv6wXoJ8mNTnlmv/XhIge0NFjmblLiP1LnadZJho
         HYqQrBysPRsH4nnOmF55WlqN9rGcqPmoHhQyh31u7Y1LuAb048sSu37KDHdLaKm8aABo
         MdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094050; x=1792698850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yz7tOCbp7wDhENSlXzMolHxr7bpwiFTGlAsANFk9cDs=;
        b=Clj5NI0EabIlT/2knreFOQArnD6s2aSGRRxRdhZDeO+7OwgYPfqDSC1V2sx7N5xq6j
         DxtWtGdfZry93XsEweuzHV5fdaB+Mvj4Uxjbt59JhBQJMf5ilV+4aaqmDQ0mN7bl92D1
         4kd8IoyGFwUCz4LhsNTFxwVxeHA/ah5jRAmQ6QbE3cuIEegr9kwcNP+0MKMjRuf4LjE2
         0sG7Fhvhiq4zwzJJtyXTZHnqmJtM7Awo6ELUKqviCZsXK0EZCA7xOfUlpSqhK/NN+Cpd
         uNl7RmaPhrKTQOsR4Uj9UcnkVSvtin1BArOlr/y7tlvpaD+e2b0tzxuQumaKHNudiSVp
         6XhQ==
X-Forwarded-Encrypted: i=1; AKwUvBzM0gMV/CdyW08r1XVGrZH/bS9wBiMeu7sID0GUYPpqZHYvHWfwYR0dL0m6MFZI1w8xC2byKdGlYFrT@vger.kernel.org
X-Gm-Message-State: AFq9FYJnIt4qsrdwWEWdnx9MbYU1d+dciawJRCT8Oou/IvQBhufi74yz
	sF0sqWoP8QuR8SqdIId2mE0eQe5NTdstouNXaKPqhe61iZaJC9Af+ttlATyOtdJLXt3GHFTBvml
	B7PGo
X-Gm-Gg: AYBFou0aNeO9itmVBBO1WeXOjOq6zyI4FnmpNKdS/NPiHHj5mQ0aDyXRfeQkXR40wDR
	4sar5Vfk49vHcnQe2IEj0FXGWN3tqa0Jh3uIjH0s8sJroqUyt5WuGeLFEJHR/cNzY+5tgALzhCT
	Q+/WlMYyCA0NU1ArrtzQJ3/vw63418MYvXcOaeFZVA7ZgoTUo9r//LuCdWsq7dxls+AUmO2BTQ3
	ho/CKfeY9Q8/+N6x6Z1yUg6yGxbcLIo/IXojB1LdWkEW9u++cFuVPm0OehIWzTx/c69AcjK03vp
	2cH3oS1OpGyhJIltL4T+kp8Dplw1NQkvPv7I7JNBuHWOJeqKspYOPouE3lwTdPo9zGNXVrlzIPi
	Y59Pqm+ehBOGnlWW8t01jyRwR1XX3y94Oo0GKS8tZ8Smz01LM5jBAmDie6vilRTEjT+Eph8mgcJ
	rcGIyeOIWpSAhuHllUjXwvqap4i6puRXFWlgpFX3vq83AAksjK+5CHWm+ABnQDf+yVTL67pkbJi
	86zzpSJcOWz0bNqcUgcJifQMxK1OwS65DgIiKR6gOXIsawjXkufh8qr
X-Received: by 2002:a05:620a:2b9a:b0:939:a0f3:6aef with SMTP id af79cd13be357-93ebd1ba6eamr3282413485a.23.1792094049829;
        Thu, 15 Oct 2026 12:54:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a198853sm16982085a.28.2026.10.15.12.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 12:54:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHRWi-0000000HPMl-2XS4;
	Thu, 15 Oct 2026 16:54:08 -0300
Date: Thu, 15 Oct 2026 16:54:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Hefty <shefty@nvidia.com>
Cc: Eric Davis <eric.davis@broadcom.com>,
	"sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Message-ID: <20261015195408.GX14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
 <20261015173327.GU14213@ziepe.ca>
 <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>

On Thu, Oct 15, 2026 at 06:57:31PM +0000, Sean Hefty wrote:
> > On Thu, Oct 15, 2026 at 08:57:44AM -0700, Eric Davis wrote:
> > > On Wed, Oct 14, 2026 at 3:35 PM <sashiko-bot@kernel.org> wrote:
> > > > Sashiko AI review found 3 potential issue(s) to consider:
> > >
> > > Disagree with all three and no change planned. None of these paths
> > > runs on a UET port.
> > >
> > > A UET port's core_cap_flags are RDMA_CORE_CAP_PROT_UET_[UDP|IP] plus
> > > RDMA_CORE_CAP_ETH_AH. It has no IB_MAD, IB_CM, IB_SA or IB_MCAST
> > bit.
> > >
> > > > Does this explicitly fail Address Handle initialization for UET-only ports?
> > >
> > > Yes, deliberately. ib_init_ah_attr_from_wc() is called by the MAD
> > > agent, the CM, mad_rmpp, and user_mad. These all need IB_MAD, so none
> > > of them sees a completion from a UET-only port. The check is a guard
> > > as an unconnected peer is named through an extended address handle
> > > (patch 5) or the job's address table (patch 7), never from a WC.
> > 
> > How much of this follows the work Sean did in the consortium? I thought he
> > had defined AHs?
> 
> Eric and I worked closely.  Most of the UEC work focused on the user-space interfaces, but the overall structure should be aligned.
> 
> UEC defined an extended AH.  ib_init_ah_attr_from_wc() could probably be extended to support UET, I don't think it would be used, however.
> 
> > > > Could this cause incoming UET packets to be incorrectly mapped to a
> > > > RoCEv2 GID index, breaking the UET transport response?
> > >
> > > On a port that runs both RoCE and UET the MAD traffic is RoCE, so
> > > mapping it to RoCEv2 is correct.
> > 
> > You will need seperate ROCE and UET ib_devices with the current state of
> > affairs, we don't support multi-protocol today.
> 
> UEC intentionally considered multi-protocol devices, with a vendor deciding whether it would need to provide separate SW devices.  E.g. using UET for MPI, but RoCE for storage.  Protocol selection is via GID, same as RoCEv1 vs v2.
> 
> What blocks multi-protocol support?

Principally I don't think we have the APIs to discover and link the
GUID to protocol to QP type appropriately..

Jason

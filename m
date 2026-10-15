Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B949B5DE
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 22:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792104872; cv=none; b=eWWyZqy+Gv5brovg65+kSgPVZlYv5Dke57tClSWtL19WUsCJXo5aY33HomyXIlexQu5jRHk0kF/3HxYCfszssYYJqD7wWYToLEMrLJ6dP4BM+xLdTb5eyuAa2dyxCUtVOKJBXYKrt5lLQA97oeWju3nZu6mblK0SjvnKdxIl0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792104872; c=relaxed/simple;
	bh=lx6vLG67HDPtnRj90OjJRS6Cl5KXBnbsEtkIXD607PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9aksXC9gaZEJNe6dvs6I5BWIjdNETeuA+vpOEkqFO4l03XehLXm0lCscqGhGqW+AzPjKUYFz8iV1IG4ZqH8FarFT4HXydHhi39oiAsOOnxrmgKRZLXBAMQyuo5bRww59KGhX/v6AKXhQzQA0j/VqykSTy/HTdXE4Y7uWfZS6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=EMBNb3Xd; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EMBNb3Xd"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535f9de49fcso12774991cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 15:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792104869; x=1792709669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w5g/qpIgvj6wMX7CCQKIX7PAX2lJ6Da0UK3Xl6Ms4Rk=;
        b=EMBNb3XdsrG4v7GPEbcTvS4a6q4XOm3vxmwwwWzS9OArrzRNUlzLne/X9/iBZErxOu
         IPZ9LsTQwbaAHMm0IzPdEUh9pH812q8G4rt+/qvE0u+zTeQzGcN6KTt0OndY0hIGM/O8
         aThj/lFY4FRuxt6fLn7s47gvitXdAR09g2tJt1+NfrAazn2HfaND4P67FC0vS0ZlfuTU
         JQjUmJR8DhJd2Jd+8VxiOvV0PN0aZH3FLX65KwABS4q+yRf9QaFMd8kx45Gn4XTU0Gka
         tiFStXPD+T/34p3mPAZ0G37BTnAt3jcVHd9s+UIlrLStsQGLSD+lXHJWvV/Z0y5QWei0
         rrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104869; x=1792709669;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w5g/qpIgvj6wMX7CCQKIX7PAX2lJ6Da0UK3Xl6Ms4Rk=;
        b=fXKHgsun5t8Hv3GIV1n9Dp51bqgSzWATBgtt8m64yd1PHmOnRb9Qs9LlQLPTU01L2y
         hLi2gmejdNxJ896Rd1p8fJBriwKBOdDqaIJWoUnfvS8HPm/KHOCRg4e/SY9US5HYWase
         GhEdYdZXVDleAHxRUmlAF3Jnjjk6SKZQ1uf5rpShY9TnjrEEUs225IF+yltjO/nswNNb
         HeSjdM6DzxkstQ0cHi+9TGMdeuUD0HF+9r0AwDKjOK/BBNE2dPrQRT0PM0Cml26OqfVD
         VY6xOmyH7db0TSswZOnaz04ICNQGPMXq2c/Nxabh9nKHt9sJadkeQbNmyqVU+6g+/vIp
         cTDA==
X-Forwarded-Encrypted: i=1; AKwUvBzRlsW23ZejO1NEgNI/ABTZocILJbyZnfUZluWi4mszX6D7e6pDHZ18iiCbuFkgiQWRDq9WMYIUBmma@vger.kernel.org
X-Gm-Message-State: AFq9FYKpTVK9fINWTEd0lWyXwrF3ff3KB+IXkn9aWeyNpK22RVEsR0nZ
	NevhLnKD0bBfHC7mv4XLIeNdwM/dMNnOe8LKRZBnBSGJvtA4F29oNl7aYCHPAuQ/mlM=
X-Gm-Gg: AYBFou306AKIPdhy0bOjrvCCfMTvN24OXO5TrRjLF9DXswMwV67ebr1++95i1KzqCRJ
	AvpMbDHT+Wv4TVUnSPKs7FAUi3PmwAudLhiRKQJK0WhfrQlMplSC/y2ONNfeMJc3KeKzI3bg1Jt
	guXfmFY7jVSXo0wWSSfRg985WcR60q1utY64z70TzWREtJR8iQgZF1TlL3IjkXZtSuPjt6zP689
	Ks48EI1B8pypaBGkOqa2pGL4DwnQwfcoy83SIXLniBHalU3W7qMJUmWp56R0s+7BfYPSwhuNNyx
	+SOTvDuthXjhp8cQUYb2tfvH+Ov2iV6KdrJS1trLU67W8mleeh7/pVD2k+bkTnGDb3h/pDzzk2r
	hyrgotIMsHzMqm8cxtegZCkz6xzmbE6aGqocn6NCmeHnOS02byYkDVnXTxnFHsbe+czr1g/P71v
	3qQAosk4rCqNqBZhu6OSI5GPQr5pqmyvN2d3YvEy9hSOBmMUh2R2nQgnzkoEYO5mCJUFFz9hxkH
	bxFk2iGRvxBOKvzZqroF7LGNRndFToZolCqgJMPOwTLy8aZ4oIp3JMh
X-Received: by 2002:a05:622a:a16:b0:535:10be:7d5e with SMTP id d75a77b69052e-5359fb539bfmr310496441cf.46.1792104869371;
        Thu, 15 Oct 2026 15:54:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bccc721a8sm5238476d6.12.2026.10.15.15.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 15:54:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHULD-000000008uB-2yqn;
	Thu, 15 Oct 2026 19:54:27 -0300
Date: Thu, 15 Oct 2026 19:54:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Hefty <shefty@nvidia.com>
Cc: Eric Davis <eric.davis@broadcom.com>,
	"sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Message-ID: <20261015225427.GY14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
 <20261015173327.GU14213@ziepe.ca>
 <DS6PR12MB53456734E5A7CFFCDD7FBCCC0CBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
 <20261015195408.GX14213@ziepe.ca>
 <DS6PR12MB534567DB240CF76594BE5B5D0DBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS6PR12MB534567DB240CF76594BE5B5D0DBD9C2@DS6PR12MB534567.namprd12.prod.outlook.com>

On Thu, Oct 15, 2026 at 09:14:22PM +0000, Sean Hefty wrote:
> > > > > > Could this cause incoming UET packets to be incorrectly mapped
> > > > > > to a
> > > > > > RoCEv2 GID index, breaking the UET transport response?
> > > > >
> > > > > On a port that runs both RoCE and UET the MAD traffic is RoCE, so
> > > > > mapping it to RoCEv2 is correct.
> > > >
> > > > You will need seperate ROCE and UET ib_devices with the current
> > > > state of affairs, we don't support multi-protocol today.
> > >
> > > UEC intentionally considered multi-protocol devices, with a vendor deciding
> > whether it would need to provide separate SW devices.  E.g. using UET for
> > MPI, but RoCE for storage.  Protocol selection is via GID, same as RoCEv1 vs
> > v2.
> > >
> > > What blocks multi-protocol support?
> > 
> > Principally I don't think we have the APIs to discover and link the GUID to
> > protocol to QP type appropriately..
> 
> I'm missing something regarding the GUID comment.
> 
> The QP protocol comes from GID index, which is discoverable via
> ibv_gid_entry::gid_type.  (UET QPs require the GID index on create.)

Hmm, that's not the normal case, but I see what you are thinking

> E.g. a dual RoCE + UET device would report node_type = UNSPECIFIED &
> transport_type = UNSPECIFIED.  GID entries indicate supported
> protocols.

Ah, that would need some opt in scheme to get there, but I supppose it
may not be so bad.

I thought there were other issues like PDs not being entirely
compatible, MRs, and so on?

Jason

Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CB72DF137
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112304; cv=none; b=XaUAsIQaGHkSIFWjEk/I0Z1hhuc2DLsEm/dkDRLyfYL9F0nGVjJKLZ13/yktZrsRxrGmMNMg3DlLEPy3XICxPeVDno56XtadJK7xoKQvmjRHRP9vRHKh2s6+UpLSOAC35iBmzUDjnEXYcbwW9ZN8nKIHMt/9bPJm2yuQMevg7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112304; c=relaxed/simple;
	bh=LjxVXSPjAXa1jRpFVLlRYx1smTwULCMNBuuDv5VAbyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEuwPJY6zWsZtJ1vs45g2o0tMSL4UL5M8gsrMsQQSYaktB2EejlYpNcFJ6bfj+WQ3deCy/jF/G60DkoT1vZosQUTa+JClzqbtWOnFV/XWAma8JYPSf3Eyj5mHu1MdKJIaHWSWXD/37nRGiltJHngsfsb3u99K8pkpmjrwGYdX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=UB+6yuSq; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="UB+6yuSq"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso23130356d6.3
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 07:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786112302; x=1786717102; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LjxVXSPjAXa1jRpFVLlRYx1smTwULCMNBuuDv5VAbyA=;
        b=UB+6yuSq5MTKBkf9LV4xKilPlRJ1KN6eE6c+1JCFJijdW7phQeV2xpbuGG4L69/DXU
         xVdDpbPIGampUX6X1NAf45T2wsaRyVksABB2aJBhVsPKE9LvIPSAQIssJcV/hYM+RrtU
         gDGKBqnDyfJAQt+HCVy4QyyZ4J1+0Lx6qZr/w+S9hOYvQ0neV+9dJlepTNxEF+IzK4ZP
         kTF92TyBjZg0SQzsr93YaVoqSo9jb/I4yadJIFQoFNYufXAksKoCo5TX3UdOjtKnP9rF
         yLq19dq4xBkd3LOF7McpjiQD9Edb/cOp+y435tEe41tXzguO6yMzG5REgXBB0RoR7r7S
         rNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112302; x=1786717102;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjxVXSPjAXa1jRpFVLlRYx1smTwULCMNBuuDv5VAbyA=;
        b=iD1yUvc/xEBsKN+v04bFkMeVTNarVKTZghRrx+ZLMGa61aas/8l/sSq6bwKyyHvAq5
         MsVDlHrMygadoCr3luRZQeqhCWXSIjz+ufsCyyEwEd5nDuaM3jjr9tFOJ8wamnl2ucoe
         SXIDFB7EQ19gXq1oxHirXmxs2TqZQDMBqnA555lvwI+Ka70vqvX3BgZZ1v5tj2Ptr56F
         F2YWyCLn5xV6Gv4XQxHyzqAyS/F49IvIhKTznGAqnxlw8xGNi5+KaB5gau2L/DswGiya
         KdSbqJuoZ6r3KQ/HN5mHdJ7yNOmln10p6DlIn8U1O1Bsd5outup/UAiN+YrM6+OnAtUH
         YbIw==
X-Forwarded-Encrypted: i=1; AHgh+RrTF3O+TV7V0zGA0Myt+mBJcZ+wEIWP81wvem/8KFLq7w8WBiN9DrPCI45/8GS9zyzYwEVuuZRBRFeh@vger.kernel.org
X-Gm-Message-State: AOJu0YydbVCgeRE4xyuKgFwbiwt6PntBCU0IgQuT1RQNF44QDoRadUp8
	lyI4V9IFVq1hAbXI5ivshlf5Q4f06a/HkZPHC63cSGbm2CFZL1LQF/WCeqXFXmkpkhQECIQeDFs
	Qyp1t
X-Gm-Gg: AR+sD10j4ZDv3XBTZ43Py8vhfmopfRTqKM6X3VxMLNk1SSkMhBt83mpDJ/AFMhMKU8d
	p8C2UfljGZR5RbMjHlPtmFMhrcOhZGduuN6bTF8B16oa0M3uDePKNU9oOjDp3zB6x25Z0Q/pebq
	J9lPsFGdYFWfbkquKOyh82mZgOB/lp4/8V8FzlkiV+u+wk1ykJS7HQMd3P8LpygezN/lI/CsKkI
	Q1v1AwUEFP1d4V39c+KJO1+EyG5H9wM/icPnxQM3mS397NbFqCR8h80WoGkdVgEmns4KPe59cH8
	EtcoKdFq6d2auTwEub4fAvkTOZPWJ2kSDSzzuIb7w9CNmPMKlzaXMJBdrnO7O3JdR/IiTTVhiTi
	thHriWgKYSEx8exn700FSbNxztOnoQK6AJeLzuH9B/Uxa1+i1GAI8Su0eHeIBWy0tsjc4OqA9LC
	vO8GV6E9NCJNcyHy2KfTD4rJxrzC016LwIfbhaKA==
X-Received: by 2002:a05:622a:5905:b0:517:7e26:36a9 with SMTP id d75a77b69052e-52ce62036d0mr275290271cf.39.1786112301873;
        Fri, 07 Aug 2026 07:18:21 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16335bb4sm12949011cf.2.2026.08.07.07.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 07:18:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wsLOu-00000001343-2GOY;
	Fri, 07 Aug 2026 11:18:20 -0300
Date: Fri, 7 Aug 2026 11:18:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/hfi2: Add MAINTAINERS entry
Message-ID: <20260807141820.GC200537@ziepe.ca>
References: <178603994025.3611040.18003173777504573447.stgit@awdrv-04>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178603994025.3611040.18003173777504573447.stgit@awdrv-04>

On Thu, Aug 06, 2026 at 02:12:20PM -0400, Dennis Dalessandro wrote:
> The hfi2 driver was never given its own MAINTAINERS entry when it was
> added; only the pre-existing HFI1 DRIVER entry covers
> drivers/infiniband/hw/hfi1. Add a matching HFI2 DRIVER entry so that
> drivers/infiniband/hw/hfi2 is properly tracked.

Why all these fixup patches? Put all of them into the hfi2 series and
resend it?

I don't understand the RDMA/hfi2: Sync with upstream hfi1 fixes and
cleanups series either..

Jason

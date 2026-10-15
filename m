Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93149560AB5
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085621; cv=none; b=a0SBa7wz5QawggnDWqcx51WiU6/3xOnXOaoEWQVS6/ULdtoxjgTWfmyXFzngthJnCAks+GsUQN1iRz45JK07lBWen6hLmk/mFh2mxQZAPnqcqHGelqaNgV+DKyBXJ7VmH/gU7aPJs8T8n0XduIDPb6a6cjAtB8O30c3vjFi9pzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085621; c=relaxed/simple;
	bh=brRNWKnrLqwVE5T8M8LcZ6w1E1wZ91rPRMyhNVJXlts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkBEnsqKyxen7ml/2M3vb9iiCew85H22KKEEThwQXv6ErDIR8iKUc3Pf8gWAU+FbIFM1heKnh1H6toza6ogVnIF74TsgCqLuYP3vTrH+NvucAad4kDxRTD2TZUcNtxwSUo9MLuQ2gwT9e00dcTdkmVvfsb+0CfDOAukUZ2bMIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VoHL2CuB; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VoHL2CuB"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93e76469b93so118628185a.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792085610; x=1792690410; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eduX5UuEmhrtcI7x1q9okGgwM5pPRtmkh5WfBPoNnZI=;
        b=VoHL2CuBOJR4xsKsN92MG0Ieq66SR2jsYDbfQYjOPp8qnxVS9vDZ/BFfMnp2xVfxPG
         S8jfMAtRkgab7VjoNuI0XK1PbBVifpBrG0T92o6Mep0cdWHcgW/afoHICrJyxEfNquH2
         2dgS1NALfcFtijzuiqDCXZKPf5KoxE5XdvvIvshYuxlOEihle1PoGjYOuXt5jxAgFcwA
         yO+8reHFBsJeBYH/2w1eXCH6lmV1ewdLcZwi7UPx+BSj8hUXvtqqdON+JW10BSBAyC94
         SJlDch24FKS3QWZeJTc0n3loXGPJczoPSwriFvb6fE6qivXJVs7Jkt2rS6Z2+BDIeQtD
         5T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085610; x=1792690410;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eduX5UuEmhrtcI7x1q9okGgwM5pPRtmkh5WfBPoNnZI=;
        b=NcyS+ySx1Po599MMzrd6D0566q6US2QDmCWEK2QjERSfeRGeT+dfk7lpaTbfOKH3t2
         dilVJk/+cAxgZtsHRi2+B0jV8l5TBZzXJFJ20cMGBAWwPmwFAYlZzsE7KUOuUfofDJAi
         V6hixhmXHOb+ZLoghe6xH9pKNaGEzOH4+koGItapBX7L0cDXDs3LBAisDVjtw9VW42cP
         vdK5jCA8fNcWWte3q57Mv67GObvczhn0Ljdmozc40O161Q8A8uCxbGlgSgV9ObCIGvf7
         bejjarvjP5dw7278RUO10A0kHKayPwiTGz6y57D89al3wbcck4V4aFAEtcCfShIJtu6Q
         9C8Q==
X-Forwarded-Encrypted: i=1; AKwUvByAiyomkJ5iyCO5S+OE5WMCmo8cugFBp4Kon9VwWE5CM/MSX23cLC20Q0pbXWTBKhhNcub1xHfc5BDy@vger.kernel.org
X-Gm-Message-State: AFq9FYLIgEwsgkVZG/Ap8K67KJ/DLJOf09JmjyjcwT4zignbKjFgCal9
	lKvBLnLLxPrPpiWBkWyBSFixc8547vqpmMGMEdA45ZVSRAjDNp3FUKLu/snGYW+FwDQ=
X-Gm-Gg: AYBFou1V1OTwRxVjMKnixcfuqP+uZPdfHZoigx9ZQWe/Xq4yhvzjguWwaFsoEyJXaJ2
	oXVsoggTz55en3EpgYzOTbV1SqU/5AtTfz5VpkehW5i18ZfQesEXPuib3/lXQnWV0Bdx65AUZQq
	MoOqq+IVAg9PQ074bb9BNb+wGBcm6b4PLCdjleo75OT6X9foWX3TZY0sc9Rfl9ftpYAnzniYqsX
	rsY0TZs2oUGVe0C8BjcAGDAKNvQ5jX9SUPnxuOR/OS3corx29YDcQ0tDns7QAWmgx2aNmrFKFIv
	zXT/NWIc6r+kei5cCXW+w5Hq7uGbDqBMLZ1ICaelNxzMoy8uHvLzP0jAe6DaXXQ7pNp8H64j0O4
	0g30sDOFrn/kez44t/y9mHw6Bsz5UtIkl9+nMFRb7sM/4luPKI0/rveYSO28b9UX63030NXfFS5
	lS/ru91dCNPDDBbG3qqUSlenLeuRVTh50BZjyct2nTMXL+SIpf2DDxiLvYmII+x+TPQ7lkmjLYH
	SoJI1ZQNJD0naTHG9BwskTcO5o1H7zAib1YUxovfHfxqqVeJjtcrVJM
X-Received: by 2002:a05:620a:730e:20b0:93f:16d4:3bf0 with SMTP id af79cd13be357-93f16d4429fmr164733385a.42.1792085610273;
        Thu, 15 Oct 2026 10:33:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef502946fsm819330085a.24.2026.10.15.10.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:33:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHPKZ-0000000H5sg-3rcW;
	Thu, 15 Oct 2026 14:33:27 -0300
Date: Thu, 15 Oct 2026 14:33:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Eric Davis <eric.davis@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
Message-ID: <20261015173327.GU14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com>
 <sashiko-outbox-171976@kernel.org>
 <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>

On Thu, Oct 15, 2026 at 08:57:44AM -0700, Eric Davis wrote:
> On Wed, Oct 14, 2026 at 3:35 PM <sashiko-bot@kernel.org> wrote:
> > Sashiko AI review found 3 potential issue(s) to consider:
> 
> Disagree with all three and no change planned. None of these paths runs on
> a UET port.
> 
> A UET port's core_cap_flags are RDMA_CORE_CAP_PROT_UET_[UDP|IP] plus
> RDMA_CORE_CAP_ETH_AH. It has no IB_MAD, IB_CM, IB_SA or IB_MCAST bit.
> 
> > Does this explicitly fail Address Handle initialization for UET-only ports?
> 
> Yes, deliberately. ib_init_ah_attr_from_wc() is called by the MAD agent,
> the CM, mad_rmpp, and user_mad. These all need IB_MAD, so none of them
> sees a completion from a UET-only port. The check is a guard as an
> unconnected peer is named through an extended address handle (patch 5) or
> the job's address table (patch 7), never from a WC.

How much of this follows the work Sean did in the consortium? I
thought he had defined AHs?

> > Could this cause incoming UET packets to be incorrectly mapped to a RoCEv2
> > GID index, breaking the UET transport response?
> 
> On a port that runs both RoCE and UET the MAD traffic is RoCE, so mapping
> it to RoCEv2 is correct.

You will need seperate ROCE and UET ib_devices with the current state
of affairs, we don't support multi-protocol today.

Jason

Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E080374A01
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788773480; cv=none; b=jX49gxoqD8loeQ4RkxrlLxXpFjHi+k0+iqKi72e5PKfKYgPDsL6+UGgYe0Q2nc5k7RyIAOXzN5QJWIJ7xM7jz4mN1rctxCpvy8UsKYR7ufM+E1E3D9Af7GYY7WYzA8OVA+NuinNzYzoLupy4sssbrNkHrwroNZznGYBrFjte5KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788773480; c=relaxed/simple;
	bh=YW0gAUDwkvvZJn0XenT28cdinXoPV0s6KA1GbgLjbl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGJaT1sDuB2SRHT/6QQdfQK4LzEojp8/KQzNHOghMUPVwypypyGZCZBBwPkGl6vff0hd8PArX0jFNvmKpZDXDbEPk6rza+OnRcFE6CvyXtM68Wklv5sAkA9aMGPtRibIG5F6XHng4k5OqHL09OzlHLH3xE9njCKEkU3wYgtW0Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoNP3T7j; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoNP3T7j"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4ab70b882c5so2234841b6e.2
        for <linux-rdma@vger.kernel.org>; Mon, 07 Sep 2026 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788773478; x=1789378278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0wrOg4Aqb2hI92x0tRngos4S31Q42LPdhP4S5UqqDqA=;
        b=LoNP3T7jBczwYhCB6GqytMJwiWG2SmUJ8pEvl2BWpYpyABiSdj2MOoLI9I3jR4BH+s
         IwBb9lJzLgrJ3iJ5oX/evNqTJ6eFlWL7SPWQyLDkBBH8y3VoR4/M9PzaS9Npi/QsQ8t+
         wv7frP3pgzZrRqUSkUwCk8vSr0RrTnZoxdfV4PdHUeN5d52ypRYSFYfomMar015fSVVK
         wGla91AadYzB5Vh8PbtdOOGuYxMbqT+Punf4j5fodWBrWjyeHR9OCOQOkT7OZ14z+aag
         KJISPHNVwxYSTBqjvXOJI+bwFUt1D1PKqDDz4Qyo6wxrUAI4OD7eSagYNBMt07BeWulx
         2Zsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788773478; x=1789378278;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0wrOg4Aqb2hI92x0tRngos4S31Q42LPdhP4S5UqqDqA=;
        b=EUXKjTGOmriC0Kq1WLDf6SwriVso+z6dmqcELnzTWkEvKPqmsnoAHbDTKkUdCTeREG
         70z2mnP9paNdgCRsvFngmXRJgOMlSryiA4DFtdlgO4cnQeajXjfMuAo5YRdmXXJeLpYw
         5TtP7UCQ5FL+kWy9dZO1QFdteMkv6BUgeC6oDFKIZVvRdxmwyaS8ZBIWKcwHZfuWxt+j
         l5ICdWpe7MJ04k5XZK0nbrTcTqCqSm3oZs3ZHw8oQU2YvAGubxUsPo8CWEKgT5YWEEen
         oO+FEcmNZjO731EOdv9QtxMue4zzpCSSxL9ee7NIBo9j6DyATJKKKUx2jLgxAxYScwsL
         jLjg==
X-Forwarded-Encrypted: i=1; AKwUvBwM1OPNDITdIUs7HK0QKA3D9s3e1+7WBX/+n9Oyv8J1D/s1mHoQLvx6gghWUMcv7ePWgcWU25s4oyr+@vger.kernel.org
X-Gm-Message-State: AFuF++nSW2ZCzeeWC8IemuGpBaYHzaT6OlQPLo5Gvo15UqeqFB8GmpCL
	INpUyWrUcb+CTOtsez4cSiz8Nb3vh4LZD0l+Y+dNvZPZPlJtSN2haNE6
X-Gm-Gg: AYBFou30IWL+53YywmK9uVuf8f/+7mHG50qJvN8hwE8Ur9UydmNgT4aE4aonClF+exZ
	a+vLjcTluMqOw8TRKgpIGfg9OqgMHUzD439RYWPB/PHwkWsXBiBOK7/3eww+QL59OZlEj2+IqPE
	AoEouWt2fGcTscEdZu+ctyKebivzq4Z8ma7hr2YS03blRYjHxcZDrpSjf3qkLSV3u1OoLAHwcj7
	cpw8s7UHEVu394GSJHjDNSTuwosrtFawgoX0lAS8X7r9dtrwziyKrrb6GG/+0wJlLoib/aQdlm7
	Kkm2iDP/70Nk7MH58oVnzjkBF3PgiKo8P5ayyvfy6kVN0OFqBInTYEgiV0w42eyzf7To8CVIBcK
	sIvefWDJdBdmssLbCRKMsqlKm/eNUaw+hikfjwrCi0N0dTYhAqFoB1ccMZSzdcvy7S/ulyF9YBP
	NuizvS1W6h1hmaEx/o5ACKlcu/eSXcROc+kCXyr2YV5rV2bh+Z6ib84WqrNUDOIimRYAFLH6lr8
	cBysosWvQtKfE/lwXQ/c+h7
X-Received: by 2002:a05:6808:1920:b0:486:4892:d553 with SMTP id 5614622812f47-4b95cad07f1mr15166734b6e.0.1788773477623;
        Mon, 07 Sep 2026 02:31:17 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243f780csm23953277c88.13.2026.09.07.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:31:17 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA: fix typos in comments
Date: Mon,  7 Sep 2026 15:01:09 +0530
Message-ID: <20260907093109.24023-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907082728.GH13683@unreal>
References: <20260907065047.26773-1-hemanth.selam@gmail.com> <20260907065047.26773-2-hemanth.selam@gmail.com> <20260907082728.GH13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Mon, Sep 07, 2026 at 11:27:28AM +0300, Leon Romanovsky wrote:
> >  			 * release_cleanup is the exception because
> >  			 * uverbs_uobject_fd_release() needs it. In this case
> > -			 * the module reference held by the fops will guarentee
> > +			 * the module reference held by the fops will guarantee
> >  			 * the type_class remains valid too.
> >  			 */
>
> And what has changed here?

Sorry, that one is easy to miss: it is a single letter in the middle of
the word.

  guarentee
      ^
  guarantee
      ^

The fifth character goes from 'e' to 'a'.  "guarentee" is a misspelling
of "guarantee", and it is listed in scripts/spelling.txt, which is how
checkpatch.pl flagged it.

Hemanth

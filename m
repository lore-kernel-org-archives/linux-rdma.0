Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597C1D5151
	for <linux-rdma@vger.kernel.org>; Tue, 14 Apr 2026 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176384; cv=none; b=TElWPe0z0SV/KKJNNL+1R2YHgkyddggtzYGS/nnUjkFQptzRqAOymtmBNQG3iLO+pKzSUlgxEVA+VRoWorTJM5wT65mHQp6NgHkWBX80GBsoLG73b/2zRFuWUR44pEg+aWXvnfwTVu99p7hYEp+Pod5e2Oz4Umag/tXvT6xAMTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176384; c=relaxed/simple;
	bh=3nRCR85M9qvDsLIV2V0CHqSh9rM1y+aa4yYLmwz56BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGMOfZwKu7xBGg8jtO30ohEDddD4o5IicedRk+i8Ln87SQm5pUCB34fhy0oXq1pByquI87THlYgzQ6CQxL+fefLChhiZTJO38iszPNAP2NYMe3E+21WAvSb3Rs9HjS9G26cN5YrdSvsvdytLxiwKH8EtXqGha1WwAm349yQ6tDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gCYQNa3N; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gCYQNa3N"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8acb7f2586bso16377216d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 14 Apr 2026 07:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1776176381; x=1776781181; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3nRCR85M9qvDsLIV2V0CHqSh9rM1y+aa4yYLmwz56BU=;
        b=gCYQNa3N5MrbraT6p6+1esH3/a5RFXih7hZytRWArwjf952E5xhT3MWDPTr1kPLs+F
         GPMAf7tLhBTfUsxryfBrM7gp5B/egIPUNWQrJmt7bBE8Y0hW3laawyn5La97FM7nKE/a
         t45mVnuBXNWkC09vDNOG5iaKuzOn22e2FQdTvj0L53VDEFhnwiJgHxnKhITyRtvHo6QV
         GQcjqnKeHLEc501YKNH6UlAXEKQGECq4P6HBiwlJzn0q32FdLdmsUBATMrT3WmHR5ovK
         f4NtuBbimcy3L2J3GWwc6N0Yqqlu8Ng/ZVv4GQIlkCdqPJlkqahz3OTCdoSy6uJ1Pr1g
         uGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776176381; x=1776781181;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nRCR85M9qvDsLIV2V0CHqSh9rM1y+aa4yYLmwz56BU=;
        b=e3A1Gv8rKsxTqaW5/L7rW4O7xAaQthW8m20jeHpmi9iePIHupOoCFtC5ndV6SUlfwT
         bfzE8GHhaaG/OPLngUpydVwU/Cg50dl1HKGRIOK2KZXPlgtwQBl0WSoBeIRwyW6ejLr6
         8Xr8wgiq5fP2j/L0ahE4MlxRMeTuieA62SKm1Jt/He6hvx4EiRss8xwAPHUDPIQ7B7RF
         IBOlgfgrBCNkKGpif8upkw/b7yjcaq+26aiTc27liXL2dMYIhwkHalaaA8jtesyl+GPB
         FYgaZG7XYsVXJ4x4Okq4923SXTqmAWGHukBa+8t3EoWz161142zKKkGaFTDxx0/kUv0s
         E2dw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZAsTa08UxZAkrER9iUE9w+FsZqcEztSO4JLcn4oMiAqyiSjFIcv0mOHxqSZOZ34XTU+1U/yNKvL6k@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt6avg+J+SNx8LE2871erUShpLfSDCdMry4pMzf3ww4OcYTIgX
	FgJ9l9lbqXImWZz/4u9N5eU2X2ZhlwLKZ/77OW7YBwwSqh1d3S1v5xyz6mX4k6VbObo=
X-Gm-Gg: AeBDievy7NSV/Mc1m8qClszxexKk2LHvi5q2/uApHH5RJa5Y0aNlSCVSLKzTVuIg5YC
	ku7hA3LABKWPeNxMQtzPvEsiX51b1eXbz5vPJHeBmU3rZ5WWCnqGV3I/KTi6rO4QjJd2OJtK8q7
	5ycZwA1WSbY1qa3SF2V5yQQFxaHRRWf44r5nB9L7o1xHiR+X9RBBI2sO7TBQHFSnwB6S3c9PndO
	BR15neEMDIlAE+X2IAveWAZ6DLOZd48/nkqS8JFD9NzJtVTfrXAv0exvc6O4ikMp+dYUtd/wWYk
	MtRTRM/c3pPYbbb4o1BHM+5IzRoxriMMU9U0v/bVNNJ3ZDwvWB2aM3DRdq0lQO7+p8Nx22eYKVc
	Ki6YCv5Oqx6X1LIpPVW0Jg318svS8eM5QctKWsfjT5szEyTFfe8wNOzxqctmiq2DJeroQb8yjFc
	8HXcKxVrCUIv7HpZaEpXD9F6de8ewGL0bYY9n+mWVlbREckB5vUeo+UxFr1SY+Wh+fQG8gq2jAQ
	2p8Tw8fsQ5m8P0o
X-Received: by 2002:a05:6214:5f09:b0:8ac:ab3b:39f7 with SMTP id 6a1803df08f44-8acab3b3e47mr152707526d6.4.1776176381553;
        Tue, 14 Apr 2026 07:19:41 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca0054054sm73966116d6.24.2026.04.14.07.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 07:19:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wCec8-0000000B9ou-1YCe;
	Tue, 14 Apr 2026 11:19:40 -0300
Date: Tue, 14 Apr 2026 11:19:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com
Subject: Re: [PATCH rdma-next v2 8/8] RDMA/bnxt_re: Enable app allocated QPs
Message-ID: <20260414141940.GD2577880@ziepe.ca>
References: <20260327091755.47754-1-sriharsha.basavapatna@broadcom.com>
 <20260327091755.47754-9-sriharsha.basavapatna@broadcom.com>
 <20260410152752.GY2551565@ziepe.ca>
 <CAHHeUGUwCBjho3oJLJdOeTSF3cp1U_DYsN_satsCo4_aEKLWOQ@mail.gmail.com>
 <20260414123434.GX3694781@ziepe.ca>
 <CAHHeUGVTsMSCrVQ2uSa4_1DfctNYL7Cy2y2QRPF67nW0mPFXzQ@mail.gmail.com>
 <20260414135438.GC2577880@ziepe.ca>
 <CAHHeUGW_be95eHW55tFszfC753Zp2sJFJA781ywsXtSD+6XArQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHHeUGW_be95eHW55tFszfC753Zp2sJFJA781ywsXtSD+6XArQ@mail.gmail.com>

On Tue, Apr 14, 2026 at 07:36:48PM +0530, Sriharsha Basavapatna wrote:
> On Tue, Apr 14, 2026 at 7:24 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Tue, Apr 14, 2026 at 07:10:41PM +0530, Sriharsha Basavapatna wrote:
> >
> > > > Yes, and it's fine, you added app_qp and the only thing it does is
> > > > check that userspace set VARIABLE. Why?
> > > No, app_qp (boolean) is used to make other decisions too. It is passed
> > > down to other routines and all that logic is in earlier patches (2-7).
> > > This patch just enables it.
> >
> > So list what it actually does?
> That is described in the commit messages of prior patches. To summarize:
> - update rq depth
> - update sq depth
> - update msn table size
> - update hwq depth

What does "update" mean? All these parameters already exist in the input.

Jason

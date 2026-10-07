Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122FA233929;
	Wed,  7 Oct 2026 02:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791341516; cv=none; b=XG5Vk1s+2KvHq/oWop2Z3gHm7MXo1c5bMf1DL5j6Dudtdb1/QV9knpLm7givs0ElD+ghPaSLWbgOp5mZRmTocU0K/86UppAPR35lyWVoZNpWZghqFGzd+ih2dGUGlFLGSwCDymVprVwlQbOJVKkVDkqX5TSOb8vfGxBNBA12ndE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791341516; c=relaxed/simple;
	bh=S+RQ/UFyT3wOJmIHGwj5d1W72KYVGey0dtAqXC/IEQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyVLjbIDJNKTJNnV4I5L4GP5rXFS9zTRFW9nwVbNJ5IMXl41vpJPMsh3vhqBRJwr60cBIuygws7C7bg7Is+v3gCuyPbDphRmFNCtZosl15EaBXWbst6snnUnx5XLHTSxggLtdbiaWXcdI3+5Nrn5FQvBEYS3X74/lPxK3oH0y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=dNrVSYYQ; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="dNrVSYYQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1791341506; bh=qqU7USvv8WDZZkW1hT2YFAr8+ZDu8qhDuJ52PqEUFUk=;
	h=From:Message-ID:From;
	b=dNrVSYYQjA/j8Nd5Fo9tg7ukDv89kc7Z/iWoO/Cpp9E1MDJEdsw+ah76x7o2HBZfN
	 TxiV1p1tgpICokOTwEUvuJros2PQJY54UG6VgNjWTsbI/iSsqRkAHg1GF+EmhegP06
	 km1ei+MJgQ4bbG41DFawD/9CUGKvVydF2QL+Y/j8=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 111B7C090D;
	Wed, 07 Oct 2026 04:51:46 +0200 (CEST)
Date: Wed, 7 Oct 2026 04:51:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [BUG] RDMA/rxe: unchecked receive WQE cursor causes OOB access
Message-ID: <asWzwbYj7kVTiQ3L@1wt.eu>
References: <20261006091239.828415-1-tjdqudcks0424@naver.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006091239.828415-1-tjdqudcks0424@naver.com>

Hello,

On Tue, Oct 06, 2026 at 06:12:38PM +0900, sungbyeongchan wrote:
> This report was prepared with AI assistance and is being treated as
> public under Documentation/process/security-bugs.rst.  A tested source
> reproducer, logs, configuration, and proposed patch are available to the
> maintainers on request; the reproducer is intentionally not attached to
> this public report.

Please do *always* post a patch. Maintainers receive lots of messages
like this one every single day, there's no point sending a message
saying "you might be interested in a patch I have" without sending
the patch, it wastes time and effort doing round trips. Just send it.
Same for the reproducers, if they're not too big, just send them to
the maintainers (not the mailing lists) so they have everything to
start working on when they open their mailbox.

Thanks,
Willy

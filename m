Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13322313272
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 21:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775857700; cv=none; b=i8e38oLjhCIXfT1WxFa5SqaE5sk79ShVV0mYyF28cM5h9XPZQA5To9zDoJJB862EbQXr6X0lJrfWmzSn3TTIrjWlA7rXntUkXRaf4uWSjGvBrViJF2QdDEHTZA07qK8HG4YC92BYtS5wyFEYbFxXCEz5lZoHTrk4rJESwVPBHwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775857700; c=relaxed/simple;
	bh=TJv8FGun1HUQxSmvAKJDjPI10T9Lj3G39QAyamGQo0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScGP0YFnXjhKy8zMIbGKSnf0BfX6SBHBiAeDqwqpBQWSI2Fb9FF+2OH3A5+EMCWu1HM84p+OIO3lE2w/0cvYFfN+u/Ex/J8HJIovNWNAIBbcZMyN6/0wMIZZPPFpzutvx8UxUqt44y5PQ9tgun9V6HNJ2GDyfezW0MhtTM7rz0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gbQ8Dt9M; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gbQ8Dt9M"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89cc797547fso31218756d6.2
        for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 14:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1775857698; x=1776462498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXzOPjJ6xsvXhrTyUz0w4eis3xDyYjIh70RU1MfKQSs=;
        b=gbQ8Dt9Mpl4dWFsleTLMeDtJZCzIKIPJfh/BKH92taUSkq4QKsmSirMnZFRohzn0xn
         1rEomORTTcyUGaQ3LW1tEdy/GGxubHZZ/4SBYB3IGLEo1FThLgAaW+BFLljmgznLuHws
         3rjGONopYpsr3G5ZfVjUodvPGs+8m5TZXXgH8sJgcdjw0bWZ1W0qwxDbCZMU7ini+7pg
         Mb4hegDIkAdKMcV/gSiKgPN0YOnSsOOmhselVCe6R6peNq+ISyhogFuoTqZsPpt13S55
         yAyUBrAuwZyBejam8v0Uyjqdl7f1gnMH7NcTOKbZc3qwhD2GkURRVzEuGO+q70Q6mdr2
         Fs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775857698; x=1776462498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QXzOPjJ6xsvXhrTyUz0w4eis3xDyYjIh70RU1MfKQSs=;
        b=BMcllhmkgWyhm3PbJEdoZZyIthj49UBzGxb+/F80D6kNviltytu3DHxFjku1nVHlt2
         h3x8Wg++4R9ycJRokV54AliYv1Ql/AXJKjMHGxEhZ9sP/hfszbOz/kY57X6lNt3Fok6L
         aIUGuqyPH9TovX198VjUL1plWDrQuIQMaxbQ8eMZLloT5PwvvFO/EPsDsknWIAj9Jfdl
         8Sc5f8t2WTekobzzw5Cf3okVf1ihc5ztZ7wi5lOp2kfwIghzWP27yrvb5JA7iwspZ4rF
         NUf622xzmn9ElVt0Y2JSpfy7Os7CND4xCkwiK0m0mCy01KWBjE+lnYcxvFVTD7Nm3H8p
         sluA==
X-Forwarded-Encrypted: i=1; AJvYcCW3i3xbs0Jnm2PIDl5xIN4gArfGjkxKyyPYrDWPbHE2NAF+mS+LnJ+hLvAfcuz0+BfPfpOGy303zJts@vger.kernel.org
X-Gm-Message-State: AOJu0YwNN++jG9rV/AUDNsvCLv9cXe+KyAl5Ms0gKloy52r0ePv7dKPH
	DImdcqmihRXU3yjV26Sv6P1IbBpR9bCQ8ylsWc0/x+yYybJJXI477wl1kp4P0L9NKq0=
X-Gm-Gg: AeBDies3aBnpWxcx0eMWEX+MQi4D5VXNT9pYMVftPKQdfGjQTtaVgaspH7+60TZcJI/
	70pDGiSLvDqUVNLBCgzb9kvwIzWNwrdOe5q7FSoG8Iy81basPgU2DAOkYQMCYSED/DBhOHFrF+y
	9ees41VAXzypJ0PNFy1RQGBpYFrGWnceDTP4meB1FqCBAtYD0FcIE5jmGL82P2J9zJpQtd5NPp1
	vXeoqtz36gTkp16NifsRQ4CiAcWycG4zGWMoV4PbzZST21Ez3qnAOkRTGYWTfMbNJRFyzOm0Nhc
	vu76s0Yx57MEZD240Xdmd7epNkzboJqtoVYBBqlRzEoAJD36iZtcIvW7mdRIUEzkXYGN3kNQbos
	y7h/wTwFncwI8TDMH2OL94bj7r4csPAeymL4nrWtbh5lQZWiKxoyea+Tl+Ut0gM9GlTHxG3G11Q
	WKTI6YVab4gcWccy5xYxziKDsulLyR81uNl566Vk0lJ2ydALixUV6C9S0PmHzIVE/Ik/tmXg==
X-Received: by 2002:a05:6214:c2b:b0:8ac:8337:ca08 with SMTP id 6a1803df08f44-8ac86245532mr78356446d6.51.1775857698072;
        Fri, 10 Apr 2026 14:48:18 -0700 (PDT)
Received: from ziepe.ca (mctnnbsa70w-159-2-73-22.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.73.22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84c464a4sm33259956d6.28.2026.04.10.14.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:48:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wBJi5-0000000GMB4-0Agn;
	Fri, 10 Apr 2026 18:48:17 -0300
Date: Fri, 10 Apr 2026 18:48:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: leon@kernel.org, kees@kernel.org, eaujames@ddn.com, parav@nvidia.com,
	maorg@nvidia.com, rosenp@gmail.com, jiri@resnulli.us,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+4334f9a250019c1b79b4@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/cache: fix invalid-free of flex-array data_vec in
 release_gid_table
Message-ID: <20260410214817.GB3694781@ziepe.ca>
References: <20260401012810.11876-1-kartikey406@gmail.com>
 <CADhLXY4B7zkBQUv1ayicHXuSopy5AG0HrOPuNqcynPzs7R5CxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY4B7zkBQUv1ayicHXuSopy5AG0HrOPuNqcynPzs7R5CxA@mail.gmail.com>

On Fri, Apr 10, 2026 at 05:22:54PM +0530, Deepanshu Kartikey wrote:
> > diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> > index 896486fa6185..647a547e2d7f 100644
> > --- a/drivers/infiniband/core/cache.c
> > +++ b/drivers/infiniband/core/cache.c
> > @@ -801,7 +801,6 @@ static void release_gid_table(struct ib_device *device,
> >         }
> >
> >         mutex_destroy(&table->lock);
> > -       kfree(table->data_vec);
> >         kfree(table);
> >  }
> >
> >
> 
> Gentle ping on this patch. Please let me know the status of this patch.

Oh, I think a different version was picked up

Thanks,
Jason

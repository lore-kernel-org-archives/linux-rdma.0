Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2E9385D83
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 07:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788419988; cv=pass; b=WFcCqxayU84XLVNJcJeFUsxces8B5E6AB/Ep8FQjCXoRop7YrYk1+D/UDDxisZoqewohPsRS+gXQ5dJTd6VEZk2N2qd9M4H8oECNFr8kykHNuj5+kTCldTBXQ36MW4D4Gwc6lZnNuzPfy2CWCPvMluGlUU5ijFZX+HjOxAND3Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788419988; c=relaxed/simple;
	bh=mTUwZrU0fa1BpQL8pMtLVF+MklgAx+cCyMl43qVtU5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c5HqzYp5Sojp83o8XVKLtfYSguMenAnne46gflNXUgzAay2ZtsynbuORUqzac/b+6/ZH3kLJmuGP/yQ6ihQ+etQWqEBYeRyIYY7zuQIxkkqwAe+t8CYPxIx5z9/32ZOH/fm/86mGJUR60fbXRJw78PqVU9fBuU/KkpVdA+Qlke4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=S0XOO+T/; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="S0XOO+T/"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a6142b49aeso309028a12.0
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 00:19:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788419984; cv=none;
        d=google.com; s=arc-20260327;
        b=OW2eNHs+6Gg1tu/pFN7QwSmlqFDyNLk2YnIg6gH7DJHUME6inLGk3TIgvuMzko1g+g
         HRWIhUgVf6gRanP+3MMkxzBNrz8v1cL6YQqC79kpLedAhDYntg+qJdZsLaL9Uo+dfm36
         61QDDF31ZwK712imHcZT3zDc1UaL1Os7IacUIxvPRn4/dlrFVM0DaPxFRXpkDPU/tKJt
         i8w4gBsEjNe9uQs0Mr81P/W20e1Q2mWj60r8dR3Zn7oUrYWaeCk0QV5m6Tgo35hru0Yq
         7E1Hm082j3IYYxIlyLXWCQUMUI7kHIXC1oy6o2zilO2ohcXLaBrWkIh+SgrPWqalRnLI
         yQxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mTUwZrU0fa1BpQL8pMtLVF+MklgAx+cCyMl43qVtU5o=;
        fh=FUCy5tFMpUYfLx7wWEV/Lg8wd7isAG6DAR6XtiGmFGU=;
        b=s07CLCekEfhG5y22Nqn0AUvwJGsl9RF5D5lILT1UOVaXYjlhc39Di0JEGt8EJhgKEb
         OBpXdi+6VkP/4nzzNAwQZ+ntmLVH4ZJBqRXCi6JgriYHud9JxXf+5zrn0iVNkjj5NG/b
         PJdCbv6sITwqwwwGXOBJV/OPk2yTHi0i16NkA56O4vQjAQwjMSCoNzvO5fNOBHlOmWW7
         07FhC3KAobYfgw2yKoyHWjTkMB2i784tx96k8tWTEX3hkwUFKDan+0gV3ZqiGF4uG1eG
         p9RWoli+ObnifOIklDM0QTg/2WKq4BGo4SN9foyTAdSjlrKIVQKKGMKl19mDSfxkEbpV
         xWXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788419984; x=1789024784; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mTUwZrU0fa1BpQL8pMtLVF+MklgAx+cCyMl43qVtU5o=;
        b=S0XOO+T/3jlAu6HZkCe0sR2Q29omgMhekkacCQbw7c/UAZnKrgXgupMpv8/O6d+EkJ
         QqjB93RUGo3Y+Sbb547gcpqOpHL7qyCOPpN7Z20kS0DXXxVqhAyhpoUAqz9FXRTLeM95
         /O/6K+QoeGzVcJkTN7TPv+lqgUdnvQMj6bGVRRTzo8JsJBxM2rfyAulDs5BpHWfgawZh
         rkbqyGfL1L3oTQ7Az7btvla+Q/yfxneLpA5S1D3qK/uDhRuzm1LyPjZdOTPtg+YK/7bY
         ZfRindbXGe8Dwa5o7cmbecJ0ZpbHiSCFOSyfWQ1F/shLs/pTAg6cAbGvfmjuSri8HRvm
         XGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788419984; x=1789024784;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mTUwZrU0fa1BpQL8pMtLVF+MklgAx+cCyMl43qVtU5o=;
        b=rFnKyAAMn0LcQcU6k7/0+8//4rB10wm4TH3lplTEwE2nPDboQJJ200faiWh3F7lXvU
         3PIu9m1iib7qqLcsVxdOCsN87SSjHhJjzbcRI1SOcgJWgrhAIjy0XEqT6/VEkkdzNe+B
         Tl1dR2U/0+3DIy7Dq+v5Axwa1Yj6wEnqjpM2BV4Joay9Hu5rr04pRJ6WZi9fHn1mkYld
         80vYl+tvCKY6nXdfKELAHgI32bBQdzIBthK8Llc1Sf8oRL99MYkrn203u34yBr3w3RwF
         r1DSf1CN2ZmQH7O05NCQIaYOcO9OFzFrSNcKhtdID0c24awKQAjipRn80VtHDp1O2CNP
         kv1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwvoXJbpG2Q7oLNoEwb6wBJxSVcy5cwZJpjpCyhzuAPO6+roRrLQ/s8Ka5W/w0fJdYZ1kiSwM+4jTH9@vger.kernel.org
X-Gm-Message-State: AFuF++nGGUzfGd/6G9d1O7MkzsMpymAiV4keK5/mwZsuTyeCNAfwwRRm
	bwgduo1UM0nnskBJz96BxTc5Da7n92gnG2FCbnZkDCdAFCuCy3uMxGjYy4P3of4JS/XTRsKYlCZ
	zLs+wQM/Zw4DSdPDJeEpPfXZyfMHaQSErDx6OhA5yzg==
X-Gm-Gg: AYBFou2j/TpyH3talTvh7OabBk8EIaO1eGO6KKViO5BFzlATFc+AnWcfsEQqRWlurQP
	Q5nZAe7gmmulF7a9kKbNbGyJ8nMM3M+MFr528jv9TNmiGv6vF8B7bPZoDGom8L7gsAif9ELiFLh
	Br3bGAOgOer69bl5yQKp1PJtKwLjMXdiqKButViFtgc+lViyVo7sxXBJn85qJ8lWwieI8fSr4YE
	CJ12jE2XKZDTJRSY5ZMYpOnAHcWWUm05kJ1Z7shhJEjLDs762rkhhItPnvsaz0rDU+cBfTvQjX4
	iVimpOFBT4syF4gz6AtLEdtMfG9jB1u+Z2AZDVFBF1Ix
X-Received: by 2002:a05:6402:13d1:b0:6a6:32f9:d7d1 with SMTP id
 4fb4d7f45d1cf-6a682b02740mr3563571a12.3.1788419979857; Thu, 03 Sep 2026
 00:19:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>
 <20260902162518.GW24140@unreal> <CAMGffEmz_QSy2TLM5OBQ5GUaOiRozkLyuTNOXV8f9CnbvhPYSQ@mail.gmail.com>
 <ANOSEdInjxoti993P_wPWGuTPEEr-eZDjuLNMkXhG0yW63ECGVftgiFWetVMMKjLBrQc6dUiZtThzpFuEvDy4hqbNjooSjKeY2UW9qR7pk0=@proton.me>
In-Reply-To: <ANOSEdInjxoti993P_wPWGuTPEEr-eZDjuLNMkXhG0yW63ECGVftgiFWetVMMKjLBrQc6dUiZtThzpFuEvDy4hqbNjooSjKeY2UW9qR7pk0=@proton.me>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Thu, 3 Sep 2026 09:19:28 +0200
X-Gm-Features: AcwNN1WLR6sVn8LWmUEY-1AZlMCl9kDHNCc8_QEeroxJImRuBFKSXzx2kFxyB4U
Message-ID: <CAMGffEmj1qXRM8aR5ti9zzV2wQGnY+NSL5noqb8dSYYxNoFUGg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
To: quanyeyang <quanyeyang@proton.me>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 6:06=E2=80=AFAM quanyeyang <quanyeyang@proton.me> wr=
ote:
>
> On Thursday, September 3rd, 2026 at AM 12:48, Jinpu Wang <jinpu.wang@clou=
d.ionos.com> wrote:
>
> > Hi Leon, hi Quanye,
> >
> > I had a look at the report. The syzbot bug seems to be triggered with
> > smbdirect (ib_dev[syz2] removed), so I'm not sure how this change in
> > RTRS client would fix that issue.
>
> Hi Jinpu,
>
> The smbdirect line is from ib_client->remove() during disable_device(),
> which always runs before ib_cq_pool_cleanup(). smbdirect just logs that
> the IB device is going away; it does not use ib_cq_pool_get().
>
> rtrs is not an ib_client, so it does not appear in that remove loop.
> The leftover cqe_used comes from rtrs-clt borrowing pool credits in
> ADDR_RESOLVED and then dropping the con without PUT, which we hit
> locally with rnbd-client only (no smbdirect traffic): map_device with
> path=3Dip:127.0.0.1, interrupt create_cm(), then rdma link delete.
>
> The same "ib_dev[...] removed" line shows up in that repro right before
> the WARN, for the same reason it shows up on syzbot.
>
> Thanks,
> Quanye
>
> >
> > Thanks,
> > Jinpu
>
>
Hi Quanye,

Thanks for the detailed explanation. That makes sense now.

The patch looks good to me:

Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Thanks,

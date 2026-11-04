Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793813026;
	b=hzUGTi+rqH8O6P1E2AAvoT3Rp1PIDmoZl0v62Shka70GyGm03W/Fa2mWgWrONwWhfytL
	 MkadBZ0xqTtxJkC3GolH2yISmcxv97lfC3LjvmZZtYnGhPZKdjzdRZLJe9DU498lhonCW
	 9sXkbJcCNQSl3Xrwu0XXxPdcePc7d4ExLp0uLlbDnmipg9IMec+5De8/41fPYVzxFJjrc
	 jIO3SM9+SfjvwHqFZ6mBvpndQSfLsI1H5DhFSt8LrjigjekNXNZeeaelHHy1aNeQ+XvaZ
	 XoICOr5a8p/YtQb/YtkbcxmxKyTUV7sQ7Hw+kfU+zFR38A7+uQJiq03mAfRms7UPMVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fV8V1MxjeSoH0zVbQhUORe0/iwvgNHG47iPLCj2trrI=;
	b=kLkFjOqONQGL/iXOpauWnszcy3V0Bb/fnWYC2q0rY0GrcNWqAiWp7paG9FudIl1Z+1/I
	 z5qsh9ZOpOzbmNcPTPpvxjPHMm9yu+UIXc7eazNBxDymP9q/9o/wyqxjtNhD5kJppKXs4
	 iBQadbVNow03xBm0lHY8MXNvN5r4ExU7IqEdWGMTgKNnb01lWzsgAFLiIb6m+NZIsHCX6
	 Q+Kn4mLrOvyjgxWKllHEfBpcqqkGUCCirpSLjVqjZXgvAUS0d/z4GfdgjUbRQJ7rfc2cW
	 YdzILZQK0AyDhanrDMmuCt6Bw9e2Gwj/qibTsLTIvI7dALZFitFq6KIUtf/F6KBZo9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=IeCsH8mb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E316606D819
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E316606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=IeCsH8mb
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36a18fc7a38so2095976eec.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 09:23:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793813025; cv=none;
        d=google.com; s=arc-20260327;
        b=TeZ5QCeAPMobal9PKzaBqIlXCW25e6tKcf8ppJw9nbULpk2o/DTwV5PF0cLCAW/iXB
         AdTYrbLVXKXhcN/oiRAUICdoH+oRq9Y5SzaVBA/yL5KJ3pbwdv5pQx2UPxrw0UCvQIVt
         5rw7X/QZ21dvItq0DtOcJwslJL0yDX2q7pmSL8KSmRnwCcOnfC0D3ZwXGvkzCBiDyY2P
         L2PtKo7UImsNQj77ec3uFAQ/YUgiFZwwP3Aip0XhzE3FIXZTGKu2E7Kknz31CojCCNNR
         fwqZli8NyQ6kemPFeBd8CtDr5b9Ey0w6/VRuD6jem3O25HgP96wG+JmICO4Cpf9ULOWy
         K9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fV8V1MxjeSoH0zVbQhUORe0/iwvgNHG47iPLCj2trrI=;
        fh=s8fsyg+BYUT9BiK6zKAkEbifLVANoEK0OX/Qdqd9FcM=;
        b=GoIu0o9SWR4hRPhrKIJxaS80ThIABWVFoS5Gcly2ul6Y4dTu9jGTJ1Fx7yt66pksVn
         htPCk1UB6WHGyAVRIrju4XCjHqgmqP3UAE1W1Hojmw7VWZz6fuyJwz2BZvkbb97opBn1
         J6dFjbx4FluzV7mb5S9543AprNP6M2fbm7S/VwTGWSh4ulO8UAlwmUbbTMJZ+RY9hZQ4
         uPFmwPAe/9AMx1j/cC4qUMECXTdNDUanTMzh50j6QNG+EZlG+SucJQfZP+JMQYvHoVS2
         hoKqmOhTiviwFgdeXUlF6hKa7pVJDo4lNLRL8PAlrLNCUBogFcPp0WFU7kKv61AL6dyp
         aXbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793813025; x=1794417825; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fV8V1MxjeSoH0zVbQhUORe0/iwvgNHG47iPLCj2trrI=;
        b=IeCsH8mblSz9+LSUr4igndTlZrDiypoMepmdDkcl9TOJ+foMzddVjTHO9gVodHgf9Y
         rnMQUPJv73OJwtTJCU0qy9VCl9pIMHWJLJYOT9pdIBTJPnsdStM+kDAz/bf4kFj4efbn
         LOXdpLAtSfcLf/9ejkoBU7zNo56Fh8Xrv5s7cvVUkgnG2qgReIFw1Y2aFNjShTS6Klc5
         vXt4RnPbETZOjxNj+C3uregnmJjvQltrNDLZTeNfmHHaatyXELB2FUzWKsaicBRKGNmV
         Uy1oYCt1lVBLGm7wq51RaJy/GEKcb8+RsbOPqctSr506iGZ7v1Nwdy+xq6TvwPdS2O1A
         QZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793813025; x=1794417825;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fV8V1MxjeSoH0zVbQhUORe0/iwvgNHG47iPLCj2trrI=;
        b=ZmxAgZEk2eoa64ZmrlO6L9mNIlppY1ihRY0rGpp/a4MPbbhViYiOrZNLkXlDprBfNi
         p459Jvf2y/CdCkgYrdq0uJLs3E0M9POUY3BnbDmpup/Q2POwZZhrOBsnCTRyTkky2Neh
         s37yGN+uGo7OYiyLeJii3e+nuO9/U9VqCmOo/hFsAG52Mm3tAMOoDzbgyCFNIYTH9VFJ
         KLyVp9/MkOqsu4EbJW5FBbD9wHxq1rJMq7rf+gw8twvjSINusliqvKRBj57VpcOKHjkJ
         tW8uMwocgzpDhcTtQZACnuxse3uKUw87DAvQa1x7a/5tM6g2biglTwuMMl59CkaWR4aV
         Ei1A==
X-Forwarded-Encrypted: i=1; AKwUvBziLsToQEarCgkU/zlttDcjFDdGe1eEQEZvhsaaCY5Obj2/lLSXr4tXHCHCO0gCdB0bvoe6uxeHaVLm@vger.kernel.org
X-Gm-Message-State: APuU4Z97xoimic+9r/vhpI+tVEiTz6FsxX6tYK6cSgJiSEJ4WZH2Iz2P
	oP00wsjMHTRky5c5cG3MQB2deWno/OIA7FuYd8TqQD3S/Sf1aHu7+DgmIxfIQwect1Uuy/Acylo
	zh3Yx4ozsP1+aMHgzfAFWcVEy6ogrHrFmTFXS5zq+/Wu3b/6VmU/zxA==
X-Gm-Gg: AYBFou2VuVqP/MwlAr9uBvrEZHDE8l5aju7eJxjw1PL9MOVQaErw4lgzwh+uUKJE/hn
	dVuhkPD5fwA1XTwT0qR1AIB0eLFswyBqiym51UpIdsEMH3S1hjr1dI7OOod1INvp8aw60xipLwT
	O+EOYVQzM9XHnKSusnkUfL86AcEdblJoB0IhS1wBNIh9GXCRRRvIQu/o+RPETXLk0Gi4LOCcq3p
	s64NXUzPuPXs7UV8wFJxgwjqKt84HpGflwp5d4sI5NCmQEx4CfS30paclo6eE3TvcpjqHYOgI61
	+0tjAVM6M0Ff12NJofo+FXi5XvWtV6Mxr+EPBFOGHVITPWcKEwJNtRaSTresngUxO93kq7J3b28
	2Bu3rrPcXzeQxZoYJeWShTdJsaWNaO/Cv6auSCoPglEZmhpu10kjil3/iEZJTCZHqJ9qlxrWT8a
	9I519GMsEnf1UXsqTe71Chygg=
X-Received: by 2002:a05:693c:409c:b0:36a:30b:5dce with SMTP id
 5a478bee46e88-36a423a3232mr29173437eec.19.1793813025403; Wed, 04 Nov 2026
 09:23:45 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030181512.2056056-1-dhu@x6u.co> <20261104075055.GL264423@unreal>
In-Reply-To: <20261104075055.GL264423@unreal>
From: David Hu <dhu@x6u.co>
Date: Wed, 4 Nov 2026 12:23:33 -0500
X-Gm-Features: AclHuK83olO4raQSHoJpMQkVWHs8sTlJrNh8bRH_U14zxtqke8g6eqmj0i5zA-c
Message-ID: <CABdL-LS6u9im=DsjnEJPGS3-3r1CFnoqL_c1gEM4qhTECWagoA@mail.gmail.com>
Subject: Re: [PATCH rdma-next v4 0/6] RDMA/irdma: Add support for ioctl
To: Leon Romanovsky <leon@kernel.org>
Cc: Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>, intel-wired-lan@lists.osuosl.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hu <xuehaohu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 2:51=E2=80=AFAM Leon Romanovsky <leon@kernel.org> wr=
ote:
>
> On Fri, Oct 30, 2026 at 06:15:06PM +0000, David Hu wrote:
> > From: David Hu <xuehaohu@google.com>
...
>
> I applied the series, but I have a concern: the commit messages are
> not useful.
>

Hi Leon,  Thanks for applying the series and sharing the feedback!

Noted. I'll prioritize clearer context and rationale in future.

Best regards,
David

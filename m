Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7AF38F253
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 11:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300413; cv=none; b=iKLsPqn1mqzukpfI7Gu9F3a8iClMkgDwpCycGIinO2V8UrkyJdARUSmlW+MwQn3JYt9PGS9cdppAkVd/P5tO5FWuGHN6sCFNIdGlIgPmQALGjLB6sLYj0hOd4FfguUM45wEzXQR2Sk3Kn+2hmIYuuiR3aRLViiv6Vk/yfckA9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300413; c=relaxed/simple;
	bh=hFcc5IUBsp7LuuzDVvAup5go7TdJI4e/FsVLrCdqdF8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mdAnc7G5QQLoCwCJbvOdbc5rqB+SHgK1oMzynezs2qOkgOw9Vh6ykBepV3FGs1bDwCc5AqE/Mgids0TZ4RSr3VXPwC5lAC/s+FG5yLiZ5m8fKBbLK5s4joDqMtcTWj4/+v1FUKabdc/hx3spucDVITHR1syCqfNVP9DYRgKs2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=VHcIJPNC; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="VHcIJPNC"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c293c683202so142917966b.3
        for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 04:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1789300410; x=1789905210; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hFcc5IUBsp7LuuzDVvAup5go7TdJI4e/FsVLrCdqdF8=;
        b=VHcIJPNChMzm24LcUwgiPDZMaArtQjncU7bIw+Q9mcQklRw5UAtmDKPrqjJcyLrk78
         kbJA6OKW8QmGsdz5QccXQHWfaEY3k0Efwig00K/ZIpO/fiAVtwLtp8CoO9o3+jdmWr31
         7fwFu7H4MBMjhf54LjU9pCX9oD7svTbrKtagCy5l1fooLlu4L7xmotsQB82YG8EjGbXS
         tYK+zPxcl7edNTGInGi71eSrfYAFgFMkYuRywdykoAp7DjhSYhDu+l/KC/uHEZjAcWv0
         7zIccbYR4jXGNxLOO/xTQOCEqDC12S1Nd6k3TfIANbCCfam5EOQL+UjH37v/UlqT15LN
         iyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789300410; x=1789905210;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hFcc5IUBsp7LuuzDVvAup5go7TdJI4e/FsVLrCdqdF8=;
        b=mUaiDo8efYJwo0Q4DrDyocGQ+/5VMvZ56fRtsRYEhB6Id7b1cs0qu7a+/KRavjamh4
         WtkOKztcV6rqZeO1meelETT2I3VBmFdF5psE8k8AjiUKfaxQBiJmez7q9IjzPntF0Wzc
         hpzTDwKIxjc/QIKluxTeGMubJKhqYaFrs4ynnHpKoFRuCgjJlIRyGf2RBOvUiUgDA2NJ
         JFDvEgudl2ev+sGfNe3iXuQ31DU42pmtzIo4zR9ewEPvugZAz3NXl8bzypfsPClqCowR
         qsi40c1JRihOOV0v+DdOmaOnkY8dQG7i7wiv9ICHp/iwdN+BoVs4AeDI+ZvCepZW7h7p
         Bjkw==
X-Gm-Message-State: AFuF++kwN/VhhqjMag2Pk2qtkaplQ+0Tk+dD2T936qHBVvK0R5eHKHNO
	/p/Cd1+1iYqgh8N/MDwv0VvvzZR2j1oFyMKcL2SlvqZoHPph66E5aVDItfThgDKCrIZzWEu7cbx
	hI2JICOw=
X-Gm-Gg: AYBFou0gpJoiAcNmhmA6l3rDvUHBmlx9zQx3mOxde9yzVXxQs0cbX184WykAlpR8Lmp
	VQPnkqRdrwLtx7Vb5J/5V3VPmkUmXWEHUn22GTLVN8Q3wZNhgCHnL0SWUBEwLsWNvWfI56I16Pm
	3KO8o9yn6Z8Wnu2QTD2q5J2NHOGH0N1WPPLn8p9VsmT+gFsOyegEXv01Y8wSUUJU2VAoc+SnqgS
	i/SbVHgzjwhEB6KYYZgv7S7FdDy/VsOPtOWXfUiCYzDfeH27iPeVyYm1twx1jh6ac4FnpBh6o4/
	rB8O+jX8PSoZ2SOR2EkbjvT6iF2jFyQZAPMsMptMJ+/DvUwQCQKRCX8znfTMjkCjat7/OYOfWup
	MnNetNawHqv5bu3oB0K4sUt8GJhItp5zOTMuZUqyWJZBTBhT7MI6Yr57EcQRA6oAF7A4fSDWIHd
	wm1YRfTOgV60s/FP6N52/fHH7eNYcErjRCxZD3yDpd0E0modK4y/ZcNM9D2RpGKiixym1c1DhVp
	GuN4BVc+yGRu7cS/zJK7BiPB6oYXhURK103yx5fhHU+dR7H/Ej0/SkvaO2oDKU=
X-Received: by 2002:a17:907:97d0:b0:c26:19de:9ac3 with SMTP id a640c23a62f3a-c29858810c7mr355624066b.27.1789300409693;
        Sun, 13 Sep 2026 04:53:29 -0700 (PDT)
Received: from smtpclient.apple (80.49.147.201.ipv4.supernova.orange.pl. [80.49.147.201])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660ead51sm288527566b.49.2026.09.13.04.53.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2026 04:53:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
From: Norbert Szetei <norbert@doyensec.com>
In-Reply-To: <20260906090149.GB13683@unreal>
Date: Sun, 13 Sep 2026 13:53:17 +0200
Cc: linux-rdma@vger.kernel.org,
 Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <744A1792-201E-4D0F-B423-4D4EDDD3DF72@doyensec.com>
References: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
 <20260901075611.GG24140@unreal>
 <874DA83D-C81E-4858-B9E7-D2A3BFE0137D@doyensec.com>
 <20260906090149.GB13683@unreal>
To: Leon Romanovsky <leon@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

On Sep 6, 2026, at 11:01, Leon Romanovsky <leon@kernel.org> wrote:
>>>=20
>> Do you mean lookup_mr() should take IB_ACCESS_ON_DEMAND into account, =
so that
>> the existing (access & mr->access) !=3D access test rejects the =
non-ODP MR?
>=20
> I expected lookup_mr(..., IB_ACCESS_ON_DEMAND) to be called and to
> perform all the necessary checks internally.

Done in v2.

>> rxe_rereg_user_mr() with IB_MR_REREG_ACCESS assigns mr->access =
directly, and
>> IB_ACCESS_ON_DEMAND is part of RXE_ACCESS_SUPPORTED_MR. So userspace =
can set
>> that flag on a plain MR after registration, without the umem =
changing. Am I
>> missing something there?
>=20
> I assume this is a bug that needs to be fixed.

OK, I just sent the series that includes that too. It depends on =
ae36a5b609ae=20
("RDMA/rxe: validate access flags before swapping the MR's PD"), which =
moved=20
the validation above the mr->ibmr.pd swap. v2 is based on for-rc.

N.

> Thanks
>=20
>>=20
>> Thanks.
>>=20
>>>=20
>>> Thanks.



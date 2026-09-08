Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4293D7D67
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788906845; cv=none; b=YcIfMb3/d0W7hOsYY9LsfoNMIlJeaHAKv7CEa/zS9OCFYGR0+qzzNgcH0s1w8ejN0YwYU0z0uWGdw7LNm8+HiYIp5FAuSkNIc3jypu7ZgaRWueTuoXKO1Hwl03bK3cl61VHhwWQL8yEAk986Avln8+RkLQ2GCQlLvekxGFGg4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788906845; c=relaxed/simple;
	bh=vHvk+bjLs682I9QfsEUIDfLsqAAo2RU7OhlRf0yB+ME=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=m1ugyIh72i6Yo8p68Wk3w19naO0MbNsle37TC8+Ay1ligG6vwGP+pCWU5/waUero7xRbE9JLDHjCrDf49NEpvWNiYkoH9gOdOU9vJnNUD3ENzV0/VXgKMM5UA9ajNTwb52kjrcRv1wRiVk/3yDpU9gOQelvOq4E16xVhkHkSneE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DljRVbPi; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DljRVbPi"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-90cd8e45460so71874166d6.1
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 15:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788906843; x=1789511643; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vHvk+bjLs682I9QfsEUIDfLsqAAo2RU7OhlRf0yB+ME=;
        b=DljRVbPifgUvjuWLFQbaCpq67FIJ5poreDTjpy5CdSPqFaSR3ZvyEKTrB5oCYOgnqn
         /COz94phsyj7EI5aNcICP+2s2BDDCA2OcMqbCJth/qDNU2Pg0rX3HL46SxLfMh58aDPV
         g/Y44HLWm4RQ7XrHdyPW5nkG0E3KEohHOPlK1eUMn1tinTCGvVnkD1riGCNFHBFbORiK
         fiDbzr5bY9fXb2RIlukwWmP2bffFoUkuPTaknRZu6gc119R0HTyMKJgbwabCf+7KcMHb
         XX7BCGiyzgW4cZPCNTT4F2udZcu7DbEepGYVRBUq66Bl+OkvmTy5O93El+xHwxjscdIL
         o+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788906843; x=1789511643;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vHvk+bjLs682I9QfsEUIDfLsqAAo2RU7OhlRf0yB+ME=;
        b=RNwtFoRdUCnte7jC5NWjgNnudTv4YwZOTWu/orcsajJJ1uL4KLSi32IvQvzhdMNXHm
         GGa7RGhrs46TQ+TCktP9AvyowjM1jITCTKHpaQ4hU3NgvAC2tUtJjWZQYeNeR0OT/rOX
         O5/MrsXuZ9PpFBzaS/vVkjvm7aOTmxpukV5G0Pt2T7MAqeAaYt/4bKMxuO004Ac+d8uG
         ZlMgLTjSVMKmUxFmuwxHi/s414eRril5/gcrWO+lIIXhMswGkF1Zv4V4FZIr+SS20GbP
         9WVhPviPOgFj1np8aiASyU4ybjV97zUxPJkAhBFyWMZfcvo8D1Ypbgkxuhv6q3r+HcqZ
         NShQ==
X-Forwarded-Encrypted: i=1; AKwUvBya384euQrl2GWGatOg2sTVTqSsTjoCerHtMds0HYUckZ9LfPSJCi1xUL1ublLJHbGVZdu+71+xU8HX@vger.kernel.org
X-Gm-Message-State: AFuF++lDa03m5lIhGEIgSQFP+p740gh7kWjBjU4IAmlX0jSXZWbD+hfO
	N9Y2+fbCPDYCkH5c+F/vHrUKlMStOnRMonHH7SZkFfZpKRNfSyBs3Kc9
X-Gm-Gg: AYBFou24QNaE5uxnHnwWNADEgfClRRdJShoaPQW4ubsHgBxLSWhYWJ6x+xQmiDfatcG
	EmAz0hVNNvduT3jWXaq3StHfinCEMSTSmGPyiYdA2Da5jW5f9xxbwIo7kQIHyTlfvdb3ObeASCh
	Wvse74YsRmf19o1NToJUBNtGGWb5xVTUNGerRSwwVhhghfyXrASw4uN1t/HC2XpOmf0HKNY3PRt
	5OHUHfj1IeYgalrF1Y/8uZwHMW5tQbkQ5EAXNRLHMKegh8eVuQt6i/cyzrE8x57dPDyz5AdbGZn
	tfwS7otdkvjYFjymjC8sCFljj87OOaMDAY9bKyV7VZ+01aJmcJLApNdQzWUmb9vC4bo/zDiJoxj
	VHyMb8/ekPD0nlsQVhe6ggpLvucbFcJySu8c5ohdBoSp9tBZE6RXeZ5CJ/AFH4iAUnEpH6/V9wh
	exwYNInDpk+9Re4dgZyZBlUYt1Dw2gNzisFUKQsvAAITMOHUD9eaWaSA5udHB3/Eyjqg==
X-Received: by 2002:a05:620a:3711:b0:92e:541e:632b with SMTP id af79cd13be357-93980599abfmr3254114885a.2.1788906842594;
        Tue, 08 Sep 2026 15:34:02 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939b39dc1d4sm461648185a.47.2026.09.08.15.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 15:34:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 18:34:00 -0400
Message-Id: <DLAAJTBDGCKN.1B13MQ3OGWWBG@gmail.com>
Cc: "Bobby Eshleman" <bobbyeshleman@meta.com>, "Boris Pismenny"
 <borisp@nvidia.com>, "Carolina Jubran" <cjubran@nvidia.com>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Doruk Tan
 Ozturk" <doruk@0sec.ai>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, "Jianbo Liu" <jianbol@nvidia.com>, "Kees Cook"
 <kees@kernel.org>, "Leon Romanovsky" <leon@kernel.org>, "open list"
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Raed Salem" <raeds@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Shuah Khan" <shuah@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Simon Horman" <horms@kernel.org>, "Willem de Bruijn" <willemb@google.com>,
 "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next V4 12/14] selftests: drv-net: psp: Extract
 shared helpers into psp_lib.py
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-13-tariqt@nvidia.com>
In-Reply-To: <20260908065244.3799142-13-tariqt@nvidia.com>

On Tue Sep 8, 2026 at 2:52 AM EDT, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
>
> Put init_psp_dev() and the logic for requiring a psp version into a
> shared lib, since they will soon be used by a second test file.
>
> No functional change for psp.py.
>
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---

Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>

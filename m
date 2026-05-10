Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C53833D4E9
	for <linux-rdma@vger.kernel.org>; Sun, 10 May 2026 22:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778452525; cv=none; b=DOJwYm0+HJZfLh2rrxNgPyesoIUCv93eRynqW/Li2SjKwJuTOBqSuGd/kIFSSjZ057+RMNVM4BwK80J954t0Zd3FPQKU/kbJIWPkmyHGH3nRgxe7mZGi3kurLWGORO7n+b2Ad8SCuW7lPy4XYkdREWbgWXDz3R5ihdJ+zdWvzu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778452525; c=relaxed/simple;
	bh=dIfrgQ67qOJWBkkbWmsOPw/FtRhdZTlADnsvwQgsNCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuleR9RackBviK9AJcmP2uwvLEug9tfFWxiNO7izQvJGfX2BSkvsWodk1KxUsotstOcNf01c+UujN0opAZaCPQMbbOo5cFC07xGhCAUzvLahFXjBso43FAcbYGLyioeNiCBDBtWyYiYcT4ATGpZTCFLWewXUPE6NeUgDR+VvOI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dhxzopQm; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dhxzopQm"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43fe608cb92so2226760f8f.2
        for <linux-rdma@vger.kernel.org>; Sun, 10 May 2026 15:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778452523; x=1779057323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6Rw0uCr+6jo6sblrkSeH3OaYPMApzeUeQ+sCHvZxF8=;
        b=dhxzopQmIOnq3poYBsMFVtn6t3C3S6g7Y3rtcu1py6dZlGYR0Pl0wnUoPJAWR874Y5
         tX3jNTUXtg6DzU5/Y8yNX+RAzJZoSauiEJg6Wkv7H6qU4roi0vt0qVeRImtNeCfmnODe
         VRWIgo4uRpBJLdwGq7qngyvOTKJGpvYN2bN+OlzaQ1MeFL8925ljrJQkKSphrNVjSSdG
         H5yoqHcezbFfyMj/ySWKCCQHRLCmEgJ8UERjPQeh219InaAgvq47eD0ySTey9Pw/ZKhu
         72mVTvXOZvL7DMBCkTuPCG5LMc9Ov6SSgx4RkYW/UBe3lLYxryCz2KvcTmDtz1Hap5+d
         uWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778452523; x=1779057323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l6Rw0uCr+6jo6sblrkSeH3OaYPMApzeUeQ+sCHvZxF8=;
        b=TwsgTnthtVO1L1KPAZ19Ht7DEI3VZ1vp/PPtT0XeG4oZOsy+1EthfCC7oxsHDempMa
         szwhDnyW9DWhV39vfFkeQyIP61HUsD/2W8qz/Jjj95sHj++TtfYl3ToU++dhrSev9wk8
         TObAkEDYbbi7uayHI5ff3SfDZqFa7jgguwtWXuG1mYG1j3wLY1oRgVyhnN7Tou4E9enF
         sFOvTCw+S6jwVwKJq2brcKdAFgNxBUgmYUNZDZqQmUMVFXewPVSopIg8MZdvZTO0uaaD
         mx3TrFE90IDfy6LZ2wpbgP2SCnjklTnTtI6cddMBadSPD3O14DTBARpKms1jIpRYYmp8
         PXMA==
X-Forwarded-Encrypted: i=1; AFNElJ+4pf+WSH99ZbaK6cPQNF/a90cc8eS0Mxw3D6Gf75Q8d8Z5JEhD6wR/eIMLuYPxInIjlmFaJ8IB3Vib@vger.kernel.org
X-Gm-Message-State: AOJu0YwlR9ih6W6WNFCyo8l280dJEBua9URw8Dj7zH7HdA3W0te7auRN
	TRtlk0WxM2M636ib7fbteDGikcD0e7iK7CI8j6no2cpX1mCGZ6Dr97hb19oeoYBi
X-Gm-Gg: Acq92OFmx09yzOj2Ak9BPhN2h2v7Omh/i2szMgOtDGGJn8856w0PtgD2iMVe4JeCyGy
	t1D9djTjVAI0bcoLzqwI3iEMbD+kBZ4gHo9ymOS+HYpGuZLSXhBvavhfoY7mdjQ2+sLKTpiUQgb
	ZTdwrl4baQoB1GARuFjhJLTOikjKCtmM8669ykqTX4hRsDhfy12MwbiFV8QPysnYgC47TVr+Ngd
	MCuRr9Wcpi3Ufyvbx/VrlfcEmhqbof8tajWiWOZfi1JJcZuUo5cBEurhELlTDwwtATuAxFviMAD
	YACXEu0sBF5aBFXrD3cknxVLNAIItXb2QoQFQzOF1xnw6xKhItOg5xSeDSia57pDjYuwNjVhqV2
	n7HeBXMLvY8NutfLTjQBa9LG/zHF+yJ92xLgPDKU+OwF4P4mOQQl5VHnhvqkMquN8cOW1a1/q7d
	w6kJ7fbEEHXdB4f262S/M0VmKvlcV6mzeru+lmW1WmFBNephhhgQlDMjkbma4Ja9q72FhZbdldI
	ixDCXqUb0aEdex2frmGQZ44ZLfXfcsMakeTULcYZQ==
X-Received: by 2002:a05:6000:178c:b0:43e:a73e:cc8a with SMTP id ffacd0b85a97d-454636d22d1mr18174583f8f.36.1778452522668;
        Sun, 10 May 2026 15:35:22 -0700 (PDT)
Received: from SD.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b00fsm22945471f8f.11.2026.05.10.15.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 15:35:21 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: leon@kernel.org
Cc: dledford@redhat.com,
	haggaie@mellanox.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	prathameshdeshpande7@gmail.com
Subject: Re: [PATCH v9 0/2] IB/mlx5: Fix loopback rollback and locking
Date: Sun, 10 May 2026 23:35:06 +0100
Message-ID: <20260510223519.6787-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260510105531.GD15586@unreal>
References: <20260510105531.GD15586@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 10, 2026 at 13:55:31 +0300, Leon Romanovsky wrote:
> On Fri, Apr 10, 2026 at 01:52:16AM +0100, Prathamesh Deshpande wrote:
> > Prathamesh Deshpande (2):
> >   IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
> 
> I agree that this patch is needed.
> 
> >   IB/mlx5: Serialize force-enable state and preserve loopback accounting
> 
> This change does not appear to be justified. The commit message provides no
> clear explanation of why it is needed.
> 
> Thanks
 
Thanks, Leon.
 
v11 dropped the MP force-enable locking changes and kept MP helper behavior
unchanged. Patch 2 is now limited to the regular-path threshold/accounting
fixes.

I have also just sent a fresh v12 series that addresses your Patch 1 
review regarding the missing mutex cleanups. You can find the updated 
series here: https://lore.kernel.org/all/20260510222258.6654-1-prathameshdeshpande7@gmail.com/ 

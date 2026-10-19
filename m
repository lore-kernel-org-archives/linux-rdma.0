Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A84F649A
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417477; cv=pass; b=s9hFOqOg8/T7vEWoPnqbPpvyz+41TFR1vCo7DdtERV2jypUcFBuKz70XYcFvlsqT5+3Li104LRiZgKWO7IBlgQ8Is4lAvs8CY5jj/WIpvt3/lunwr/iWUTM/Gc93wx7yvGZ3vZoHyOirdBL1XDLWWltHPfAHxUiahClpaY7wwxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417477; c=relaxed/simple;
	bh=i2B+NxU0CZTK0xwM8OLVyFfmzdA22KKzORXTSg+xy+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKGkA9VRa1GFGc6XoZHwB2m0Ly9zYKG+z2gkipMIR0OJfGlqdrRJMi3p0MdA6cMd8h/IE0KGn6JiwtwGVsoqGW65EzZM0sa3ATcqF9GiCetRCldWtBgPh31bXfvfwL0a+oROOA/Xkpk4FKFuPIu2q6e0pEH/A8XRZjkTkDhltbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ExeJGAPW; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ExeJGAPW"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-702fd86d674so1289481eaf.2
        for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 06:44:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792417475; cv=none;
        d=google.com; s=arc-20260327;
        b=WRgzqgKdypV/FUJE4G4gkMVr7CP/6j0mwGHbxEP9GLXEEq8JQKYa4SaGHMC1fak+58
         4b61iLgV9c3keTzJXuJCDM6LdYzAmdrDDDfe0/3dQdao1jwossK8e/zv4GNlsWbgWdzb
         +k3NHCMCqni5ld9W2LChotP64X1etrs4tC0j89pb30ym9bhirisq698Cha3NhAFUAXxn
         IH+MZv74S0r7Dc0WNI1ePkookEzk/XOdfmNA6rlgzGzlC55wMRUR664BhxzUPGuH1/s6
         DKgS0Kiiwwdrn3X4fi6pTTGmbYvXWaoIIhyWXdM2+NIYUDVCmKtDebb5m3hAR0iBlJPN
         fAvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i2B+NxU0CZTK0xwM8OLVyFfmzdA22KKzORXTSg+xy+M=;
        fh=nZv0WCVTmVUeucdg9XClmXopSkhhMeJ6XCv6qKtnJ+s=;
        b=oUIutQDAHx9KvjUszIwN8um+X6b6/X4ijmGbBDpnrBFG7DBGE3zGBEuuLHEyS6oujA
         /+8nsKX+vJ1Y9Aec8loEnmYYNoezTkPBTbiEhpThfa2IdK4YstIwNbYdcmCOkq5x35LI
         +/RL4yfq/4E+IkaqzPyKIjvarMnZncItDoMXM30mLZkaJEuNXzvY8M8N3RNm4nE+BSx/
         JZB4Ill8FBaVkbwqOlMegHCuIGyBw0TehwlCDcRIYVhvByPRIUeIoO6n0esgUEsUEPJ1
         F54PF4bQmxzgNX3Xiwlrz+2GNrfUH3y6e0QOAwsFI4LhjjVAe9le4tn4L/QDHTOvDALx
         BpSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792417475; x=1793022275; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i2B+NxU0CZTK0xwM8OLVyFfmzdA22KKzORXTSg+xy+M=;
        b=ExeJGAPWsWRCHqM9WyrNcP0oyezbKExyS64KjjRIUbLg61c4+dQt8lM1K7BGDyo+V1
         TuhG4l3eqRWHq/DDAer46z0FrvD+5n+sMmBLr3xcX/NapCYrlWITADQopJpMW/55sH5n
         AQoWdwYu06+4Pnthy9GJudS3wHC6UX8um5vbjHolA0M9iltrxEl82Rjfjz+95dINsBFC
         r3O+lsdLD7haciZlhzfZJSWxAeCUkF2xMdijK53VLyWCxkX4ZqJ1RiCXC323XbsYxg2X
         Ayt7KCl0FLUJCFgjzTkA/gouS1LGjU1tjrS39LQljzTimQGc1Uz3NKnhwCS3ChAkJBjI
         iFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417475; x=1793022275;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i2B+NxU0CZTK0xwM8OLVyFfmzdA22KKzORXTSg+xy+M=;
        b=rwfD8h+hkcLtI1D6MOHKvn2Fb1o5FVoS4f90jChivGvv2n5r7L9OE5K4v6/NQbPBuK
         DSbideJx3Gmi9ztmu49EYTH2YAu98TXqnrtCaJeLv8Mna4beWlIYN0Ig5Fb6yF2PaCST
         K2rUByvZnMDKn969cSZBq4Xrl6W61uv2DwW6YWwDss8sltn1vqok0jSff0A9Rtoa2OIJ
         lXmlDT22bEXkNnPlpM86WPEupatzk7lxAAEFoE/Oy8r3dlKuB7i6K1atuqK9smVihgCO
         MPXME6G+/E/n1VCAcfCgPSrSjXM2G5lHiTUVIIQYdxlqBTOTnsM8WvdmwZhyIaxPY6/X
         6lzA==
X-Forwarded-Encrypted: i=1; AKwUvBzUaerLqnpohMcjX6fLdARYpUgUg7mfs8Ylxx4yB3LIY0A5tL+/OpgllK7aobrLF+MjJ9D/fPgI9M6F@vger.kernel.org
X-Gm-Message-State: AFq9FYKf8pZ+5ES69UaoMXhpHFJuGGdVSmdxRw3O/zE52UB78XyHv/vZ
	mT1cw+H32j62ceqqiKEHmqIOAt06yE+NMeNBzwOibDfViVJhb70ujj8cBAttYIxb/ufZ+l0wxn8
	eFWWHXX1DhrfjD7cYy3Gm6ktcZm8oAjsYMOumSXNW
X-Gm-Gg: AYBFou2BzABMqgG8IavN3TjEOpJecBV8uErUomR53b2dgn91vWJ9q2D4Bn/hQN8Iynv
	2eHD9wYCm+EyjP0q3DBR+yCpAqmj5e65CzHDn622IweoL0ZZTmk2+660P39mFRC7sAJ0kW4vFlS
	KjytWTJr+3rF2XSDhJLxEOny+de9idpuzmA0+nrDLlTOYulv6E6cOt7QWN6fBS0dgCfSMAvvxx8
	jC/yrB7GGPyAmnyDrzkr3m8Pc70MjMCuVShRcbzHliyzBOLVAfjURTt6/NDEqW02ZXyAMwx4bxO
	UF2iFUlNILGaBDQOq9sTK4cBbiWB789nB1xz9VExQOefKPhg4UNUmW9lazf9mqBZ0PO9VIyAJ6X
	qSwhq8QsJew/UHRWn/Ygm6KMg
X-Received: by 2002:a05:6820:1887:b0:6f5:467a:aebf with SMTP id
 006d021491bc7-70352a740cemr5304207eaf.1.1792417474385; Mon, 19 Oct 2026
 06:44:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261017052856.3570063-1-sunnytiwari@google.com>
In-Reply-To: <20261017052856.3570063-1-sunnytiwari@google.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Mon, 19 Oct 2026 09:44:22 -0400
X-Gm-Features: AclHuK8CLfS2jb-qgjiUfTLjbar3Vvg_fq27zoTaqj2ZFVJNnyD_OfeIfTfIoqo
Message-ID: <CAHYDg1R=GKp6DRXBTcsD46pLmahnVhGAoKEYgzfskoo68iLcBA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Bound in-flight CQP ops across deferred completions
To: Sunny Tiwari <sunnytiwari@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Jacob Moroni <jmoroni@google.com>

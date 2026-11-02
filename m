Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600496;
	b=XEu4AydSJ3SdUEk11VEg+G44z7a7yxMpEUg4bm147XBL45Yg9rapnyebl1CUvgbz7wRF
	 l1DLS7gvnBu1fH3jsC/u1KZfy3CZ0+43zw8kUOhLAk9sIFqqP8GHtSZqG/yZS30XiyOVl
	 fJI3iuohLdelJd5OEqIa/zAFLYC+s2xMcwdSnHizIKcK5F4b+D2ZeKjohQKGQiGEhultL
	 +cy60Di4oRT4sCRnDrLyMDcoCG2/Offx3uExyhq2ToW7DgmXXjgLDExjnHFrDgWMKpuZC
	 w4DWFLHiD8n65fHhKdba41Kz+VNQ26caSRebZoW7/ilBxBC1jFw20pxG9Zj32yK83WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600496;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6I5GZeUN2pAjlsmZQiQqPXA5FlW6woKT3gvbw936o5s=;
	b=pcDosL9iT3zTRajj5FLKQJXsiOCZMxLA2ZZIJV8qgaFM3ttFEHFjcjJ9xfIEytyEDMGX
	 PePy48+OYRsDej8/A71Xoc4eqj/rvGvKtdx2LzpW9Hs6BIIgKl0BXC9UkSS9FZmmeLlA8
	 KZZoBlwOZcmQ1CAWsg/ARF36roF6czmVjiqtBoFAd3tqw/E4vycs08pWrhzLRjdLu1v70
	 7EPQodEL+X7T/9cXIhNWXOer+CrPv0/9N+ITXWqNZG+CXtqNqMFr7F88yim4SO0r5vvgn
	 79Gdv0pOZ12GBYWzirZ0fMxPPC17H8mxw3P23vZ7j20gqRgPeGEdpY3hjMKtVVyRaCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ag3Wv27h;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2821606A337
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2821606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ag3Wv27h
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so1575682a91.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600495; x=1794205295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6I5GZeUN2pAjlsmZQiQqPXA5FlW6woKT3gvbw936o5s=;
        b=ag3Wv27hyHXbOvgVVdI4F3IuF8G5IR1L3U+Yzi18VBgKxoROt9UdlY4DTa1xsvNAkA
         T8LQKEj+LfTg8ypiLjhqMzIGFPNNyn1La1sy390vILU++K4gZmR7TQbG5/doOenuW623
         9zo1P4HsmyPj7T1VqyZBgb29C0biXt6zBOm4cWvcqd+84wVIKIFFgDptjONcYTeG/DAb
         OfBRQAKfd6BilcH3Hl2G9q3Kwel/4LT3XvFP33jrtrGk9feZwkRwd/1A8o3MAePQrC26
         KfR1qiX0TpCv9CTQ3PCv+L8SbfVwt/WVZlPww7+RW8WZ83ZDt9iYblXF223EjdspGgS5
         TQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600495; x=1794205295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6I5GZeUN2pAjlsmZQiQqPXA5FlW6woKT3gvbw936o5s=;
        b=uxFNHa+jrwr32BqkZbA1nYCFgxdKniHrC0G3xNtK6cdMgDnYQ17tiv/hh0RMUfP3By
         mtKeVPIXyGpfii+jOg3DIYhnE/ccCVeju83efdLlKgTPby0vAJTUBTfMypssLIIEBO7k
         97f9zin6DYuo7F/Ga4y8em+u9+G+JfxAp0+lKsNMrYwpii78i62+FVwlAm1TL1Tvt9lH
         cbiOcACvPDOGyGd3D1WOhNMJivAYOqWt0fu3MGxj5g6rF+6CT4RZkz7JUQlcNU1/DwJI
         7nFNPqzESgs1h0PNhgnztAyo2b9xkj4sf6MBI6Q6ITS2jWdLZRH9Bq2pb/uz/qSenFeS
         jplg==
X-Forwarded-Encrypted: i=1; AKwUvByrdvyMo6A0cFgKPR2F/MfKmV5ifAgBrL8TljlA9nmdiz/nKgqtuknPic4oM64s362t3U8Ngz74/6uS@vger.kernel.org
X-Gm-Message-State: APuU4Z+FK4XUiA/WXJvAbzclXn1BW34EN5q7SKu8LWEbJbDfuNrA5BJQ
	G358/T1XJiTHkcBZzMZY1HPkXXyEhuBcirIJAWKVg64bcx+9R8s8twpe5IL7+st/Pmg=
X-Gm-Gg: AYBFou2jovNbSiSlsU+lFEbJ3N3kDYaNP5C6o5KaAXem+aoHcwWMawgqYMik0jZ1m6X
	lzcI/ZeZamDTkWCIDDr9kES0Jc+TwQcQ6qTeSdEIa+EnokepxYGBx2+vQLEgjZ0MlBc8HB2MaSk
	VR9UiHnv2U4tp4OTQfiWQ6noOe3rrzrlYTcwLspVerHV2jLS0UWcD08CaMUIdnPXmEUHInoJFpt
	M+fbPDhP5FlM7MB8C9+VMM3ZyvpjE8znepOkp/yRELWfuiMxJrSH3vULAKJMRYw7MHXcmxIb2ud
	HqF2x5thDgBxFyFiho/a8gJ7qogm1ELIScC6OAPVc6fuKXmRp1z6aDrXzADqaPpb1nAmLw+hm3X
	FFriGBsRGLf+ogf2k1DubhzwpfGGaSnZkNu7m6JmgfYu/PRdlexEISun2YH65mvWO5NdEeFCARS
	j4+G88wngcLDk4JpHWYnx4OeKgdr5REJzWVvSVNa0x2xADqjZawaovRoD+qrxDUCzMftZIS2YMQ
	lFdgb6FpqCyHXUorUzvgwzAuf2B3bFgTvgdw6iL24/JK7SytJBEdusXhEz+4r3xHd7p1tctpWBZ
	bEik+zexYWLouyJhYJwIZjaa08hA9gfQsVGlznTibB1a95MIZZJGuXLCPFcGFgXtUBGABIMWMur
	BB6P09q0BB4J56L68/7Ofw3Hv9P2bhK4MaJzP7Q==
X-Received: by 2002:a17:90b:35c8:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3ae897aa7aemr7805282a91.49.1793600495142;
        Sun, 01 Nov 2026 22:21:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9bc6f7sm16685858a91.16.2026.11.01.22.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:21:34 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2 RESEND 0/2] RDMA/srp: bound the receive IU the target asks for
Date: Mon,  2 Nov 2026 15:21:25 +0900
Message-ID: <20261102062125.617482-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <418587e0-f727-4089-bc98-faaeb88ec308@acm.org>
References: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr> <418587e0-f727-4089-bc98-faaeb88ec308@acm.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reposted on top of v7.4-rc1 as v3. Only the commit message of 1/2 changed;
its KASAN report now comes from a real rxe connection. No code changes:

  https://lore.kernel.org/r/20261102061938.617371-1-yhlee@isslab.korea.ac.kr

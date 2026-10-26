Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989840;
	b=Z+S+Yju8S+3zkGf3egwP4Efi1lsRZg/in3ZOXgXrnjFXxKMCBwLUD/B2AgZEYPt1izAe
	 uiVxp03czjp15bczwZsX+FJwvLZ/u3S+3Spi7DH1XTsuoS0YFcR+RdVSKOKW60G1EmGpm
	 WnvRRVcgSJ52n5mN1nMvrEW/jBp5RswQjSaE9OuaLov3hdDVLp+106XO/V7sedRnv+swf
	 DI7Insw7O6m9dycUo0EMEm/2EGOXj98kOLhknTHdxP3tv+cjuRJMxMdJgTqOGXMcG8pGC
	 Q1a+pYUzLuHhS0MnOUDEtIT6E0pb5scyJLgIe7GuzUhslLRYLsH5uX3GbQJOyqUPKLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
	b=1uAXoVUhg9hl9H0oehIjKYw+TWsaENgxukUnIKr98Ob2g/f9howyLVaXFGNpfBTJ49mq
	 zLPFfpeVfwoilJqufZMCPYH7/C85+ArsRzbHVD3wmbn92vN/GXygXl81B4uI1l2GMqo1X
	 QIVLKl947KxC7UqmJDK5063GHDSh7VJYpapM0Kd//9GuLire0ZrCz1uY64Lcz15VMXXwo
	 vs860/v01Qhyk++tR4yd6L+7g2vAYQvNK2ObjAj85SH8Qpd2Uv5bghaSHOzk0sqMm0p+M
	 VuIFxguhn65HBSHhf4E06F/GdvBXveayddeArn85okAFJDAvWhdsi9KzF5xvZi3ZNBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K2+282uj;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F78606A31D
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 04:43:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47F78606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K2+282uj
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1870149a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792989838; x=1793594638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
        b=K2+282uj4+65sW2u7QpDwK8BnRjSppx8kCjYc6j7Qxo7xAilpRb0U83O4UdiJw0gT6
         kHjW/+k3+7oo/rBEdDnJ6OLmXTcKdNrPSOQVkL+xCKIpMy69TsvoesMa4BwTuhcJ4Xug
         GKibOXF4f35qA+u67DgVQWZixx0X+jaQ9yeeW/RIlBaEI96Es2u4Gq96rGYyM/ZU0sNu
         3asOQVBpNMN12yVhTR7wji9AoUG5R0vrDWnZQRQz8rbArIsrz92mKtKnMXkB9DAHxJ+x
         Ou313egELNyZ0boc75MMKTRGdKngOfagBdRm/+IOlin+eoHfMK0NmDx3FL/u3uXulTEz
         nhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792989838; x=1793594638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
        b=syaKtI/oMQCusMj77NFnVbBKKZDRBSO6+oqvWDhk7RxuLmpVDW81c6rJlGfvOxg4hy
         KrYOPnIbTbsy4x6Jr4fBCsLXq1wQh8vFKiVaPtj9gdcE1qazcPGABgQCzwdMoarBClP4
         5ZmMJsAyRDErL+bsW8Aki60X4eXLXWYLWg4y/g6sZLBtpv98PTcdXzlc63d2Rm08CGaZ
         V3ztISbnYJwOaiFZehDgxPI+zaWsHByE2F0f4v/h/l2GjvzHqdnjx437vsf6Ns3Ux5Bf
         1swrKzDs9P0qWSuva7+mDu8mVXTF2onECnwwCvVFW8uOi2oVybcEZYFNmANJQOZZnjOu
         lnSg==
X-Gm-Message-State: AFq9FYJpeP4OHiMuo6T8hiMMam89yrvJYBj0jqeccEPntOThICFuP8Pc
	6oPwAexsWVZQpfAmLHzYRlawZ37weNPkcE3/Qtev5qMqAGEizuAk8+lP45DtfkAD45ST0GjIXMd
	01OcT
X-Gm-Gg: AYBFou0RaGl2YnGiBsIdzR3chYcpq0Vv9eYJ8txyMoLMq3/nj3WReNvbYsi3jbmDxQD
	olcfIJ6lDiVfLJJPAbpnv1Kn27bpfPF9V2w6tUHlYWkcv65FEWLAnSx0HXAyoYvMlbhovnTJPZX
	UqIb62bwe10Dprv/jY+es+nUPtLLOdNmRukQshJM/FYD/S0YMoZMfYE3yGLGD+9a0/mFR0V117f
	k67ydZ9settvGmtdHhBs+oQbQHJXdM37EBpYqegg1xG7OxyZiw5XkMjkBNr9DDifZS4fCxxDap0
	/BrrIwMeYg2/btV7y+o+lXkfPJbj74cFVYou7MTTWhNFLJ6ZZf2hEwQ4Y8un3VFNdlEbgDxMGJM
	GN7u5brtVAz1GXCY0Ozli5VbaSdw0epWFwyT475nuYLdT8GzQsdwNy2qjxPdws0Lu97WNB7xn8F
	jyk2QCrP7jjTv4DPg4WLawSOWTZ9SEKkI02WTzEjFtzrdiL0K3uP35F1c7Z2OyDYKDuklP22Cn0
	etfzZcixknGq9kuPCJiRZOSVBfH8di2m8XGswfpcIp1EEf2yjnKHeYWLW56GDnX5+IpkqrL1Ixb
	pqOZPdoq/u1GodS9zfvUctPLa0GODlHp5DH8tvih2sDGIs6a
X-Received: by 2002:a17:90b:50cb:b0:3ad:a462:f07f with SMTP id 98e67ed59e1d1-3adeae7796emr4934481a91.45.1792989838351;
        Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaca7casm6810650a91.4.2026.10.25.21.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH] IB/isert: set ISER_CONN_DOWN only after the connection has been released
Date: Mon, 26 Oct 2026 13:43:36 +0900
Message-ID: <20261026044336.228447-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-184560@kernel.org>
References: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-184560@kernel.org>
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

Thanks for the review. Both are real. v2 drops the rem_wait wait entirely
and tears the connections down from an ib_client removal callback, so
neither the use-after-free nor the handler_mutex deadlock can happen:

  https://lore.kernel.org/linux-rdma/20261026041949.225619-1-yhlee@isslab.korea.ac.kr/

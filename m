Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1992948EC74
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 20:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010758; cv=pass; b=ZziK89gnjv+Uc1f9u+XH+iBMGl0GVLN7Mm+kO2xm23/mv7LtbI02EznH0PLhzI7HanS+/645OQDQOYN9bDfzteQwibvFWMDURdPCq5w6xS2D3GGriN9Oua4JDNF10UgswYAYLwPHTLG5y83j0uXMVPpVCiVOw3QF9wVE2Bs7FIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010758; c=relaxed/simple;
	bh=2etocRQt3pnlAXRWdwTTQS7UEFqNVfVCOoEDKOcfG4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3k4zLvhAxdeUCyiwVd6M2ooFUG0ioWgx7mlZVVs0wOd0Swb0wqfxu+PhXmFnHxb4vJS/WYsGrqv6spXBTS+JDG8jL6eYAXrqNjWdyRp9qYONcdKfwC2M7rasDhkd9e1HtbNksLIoGB+5kcImS+w0f7yZk7sxiTj6ImbvmKCFak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IepOhaTk; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IepOhaTk"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6cf995766a3so3676910eaf.2
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 13:45:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792010756; cv=none;
        d=google.com; s=arc-20260327;
        b=QW5uJRQluF6+kIfTnteFJnd6OmPoPSJc72oaVvNdiDt/EVsx4pPhLFYRSX6riS8oVP
         SZUL4DKIwwHbotgnObBUXw5TlycVtLWtjTw0q8VxCE1FfWajymCe6Wa2SkVRyPIfXYz0
         Nld5eF9KUja6wzQm9hpo4IhTIai/myFWnRHsk/B0M/98J50OXKtep/xLByP1saJSQlfg
         zGNGNOlyyi4NXpVTg1+QHMYouYSdwK2JkRXuvFm2VF6d88Rc5dCDZPHeDQFVOKqRCTVU
         rESBx5Cau7eak8tztFuKdYelIxa+AIeq0Arwq0ADA50Dl196UgFVouvKWEg1+5x3gUl6
         3f8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2etocRQt3pnlAXRWdwTTQS7UEFqNVfVCOoEDKOcfG4I=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=J54vZ+IBvL8AHieeDaxfke/yb1ui26Rpdy0ILL2jObXYSE9i1Zk+9zZe4ZKy7otEgY
         8mjd3XZAC1ZfnvYSP3o+lB0ZY5Mebs49tGQNcDPVrK2N6XCaG5UMLtS3ha2B4V2gjj8B
         rD+SDj0K6/cyObMBZxcQRH6/ie8bmcknG0MSK4F0cZOMZW44/XHNd+DTWffJMRJjmmkY
         OmniwZ2qka+2D+KMo5CuKAYfpowQNSNwDDpqBV86X+ttN44ZtahmqNqLe+UP3AXH/1JP
         nHm2UqlyTSIlhuKg+R62hqjZuMIRkbiNXz6+rhq+pnUVd89c8pAXlT4US2IylKiR/4QV
         /9DQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792010756; x=1792615556; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2etocRQt3pnlAXRWdwTTQS7UEFqNVfVCOoEDKOcfG4I=;
        b=IepOhaTkQZ0k0yqtK2b1jYMd37wTjK90KibC0dMKbVcp5wu9gN5XceV9muY/dH/QKd
         zTDBWfsqkNBLlg31vtX+nB7zsd42IvWE5cOTrzTqH06DuhnBiCJ4Kbd5od9tS4TOZ1Bh
         RkSLdlxkOcW3g6oHt2m45IOGtJBBli5tgou6jE2K77HEIhtgp2WTeme1T2wllDXkJvVd
         cfk9BIGlXNA3lgo1Hh+aeKHxT9GUApNaslp02rDnzm+dCIUlM3d5C1pSzqUOnH5haurx
         2X+basPjrkrLEfA+WPqlEQKqh/vbGelfEocgd1XBhnj7PG/z1QjvQIUAyQaYyJ3oo2KT
         gBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792010756; x=1792615556;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2etocRQt3pnlAXRWdwTTQS7UEFqNVfVCOoEDKOcfG4I=;
        b=qC5VM5gullyqtDNFzMUkXFRPBKGlRG78s9CBQvHFVCSx5qE+QfwuX4grsDpGceU4AP
         pt1U/lCFfCjQ4W1dMl1NxsZ8qJuxLha5GW6y0NLlcZwuO8k9UFR5GhssdZHYr1UYdFR0
         /wUZt/iR/9Upp089xZtK1RvJC0qNj6t6o9wpY4BcYrVgGyQyPrn2KMH6xjt/dNJUHUww
         1HS9JcDJJ/k4ZN/dIGiecomD1a8tULUT2VOakVqFqZSriWSg6bbLqMvqT0BPJvUs9m5T
         FeYNl3O+311NneDjPhOaGcBtSOzP/kAqIi6ahooO3pGko6Te5YC84ms0DQc27gpv5gpc
         ktug==
X-Gm-Message-State: AFq9FYIU7xB2nS7GdQN1eUzAwCMte+SZY0ctgE0Pw3pt7ZrBoHhsxBY4
	V0xM6ZF9AHB7HhT9S90wPSxHJ6A5XiXRTBEU3OrKyjPnVkzDfjuKxTtgDZY6ZmzXTHuuA9tA95x
	fUjltN0U4yfD+KyRUGY5m/LjLOpMQ9+6suep7P9u+KVd6opvX8aaWBIRl
X-Gm-Gg: AYBFou3k6p5793SmFf+5qSFue9Umk/u9cW7+roC/llObx25FHHmRApAw0ZDCZMeZRJ/
	7HwZeDtatsFRbaQkghfN0WOLQD/r02sZfKujWHja+z7hybkdHfNcSy+pAWtLkxWrjmbhrfzd59C
	iyucKQZ/DzpLZrE8MltLAiIhcBbqOIoVEQe0ACblzL1te9/F2IOBkPYgU5NliPvR54qTN3Mc98m
	MuIqeFF6Mnk2OHRO7Nt0Tm4wamLO+0pfbK0s/k9Pi3KyRskqI3e+U9tMCXyJVaGUTA5t24CqgD5
	iKWYsoZwQ6w2jcirSLnKt3T3eG6Ai86+pQ3FHF6mw94puGxsecedrwYwxl6eGkS3f9GHaxLLowX
	ERdyyAWAwznh1WoQBB1TH/qXZ
X-Received: by 2002:a05:6820:c85:b0:6d9:4c33:64fa with SMTP id
 006d021491bc7-6ef0e2e2752mr12643841eaf.37.1792010755328; Wed, 14 Oct 2026
 13:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014162144.4053279-1-jmoroni@google.com> <sashiko-outbox-171546@kernel.org>
In-Reply-To: <sashiko-outbox-171546@kernel.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Wed, 14 Oct 2026 16:45:43 -0400
X-Gm-Features: AclHuK-iwztzR3eQTfvwV5eUJGwUE0EG1rrr7G4kwg3b4DgtUadOalfCGYHX5Yw
Message-ID: <CAHYDg1QA__BNuAnprKLWLpNoCy3Q8jCaNLZ3wSPxyvHLUKtxLw@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2] RDMA/irdma: Check MR contiguity before PBLE alloc
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This is a pre-existing issue and not caused by this patch.

I will send a separate follow-up patch to fix this by switching IRDMA
over to the newer "allocate a brand new MR" rereg_mr flow that Jason
mentioned in a different patch a while ago. That will eliminate this entire
class of "halfway torn down MR" bugs, if that's okay?

- Jake

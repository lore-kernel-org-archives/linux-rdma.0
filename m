Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795720455;
	b=OGILlFP22fxYl61Hm81SoUfe4ofRry4FDPZS/W6PncbFCCwKL4Xf+FbEKhSDJ4EFCegM
	 le1W52xEvhWYXA6CfMC/jq4JVnuS9KbLgO6RDUpivf4krWSuYydT8rj/mSd+O5BwszymH
	 sKsi2o6Np1gLIvOZt6wFU4t1kcgJ8wmR9HiCz59/p8Dwzn2F9MBcOpmEaMqTKNiEolKf0
	 M4cMrIF/JyF/dTUi0hHmoq/vEnCN4dHZftDDKh2yY2/TIMbD9gU1WJJA9eMViSkeuDrA3
	 CZ4il6WRbuj2XujmEXy6QPH6kFB518nljuIPGbbvJDwp+QDcHgQtE1zN7CjJEZTLYDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795720455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=Z+HrvYkLsnq/67deomAXM5gTuzGmxqPOZTXghSZHfhI=;
	b=JSsLxFRTHLoOX7USgqDJ13oSGNKezOjE6WKlRK7Ywii7VMmgpl/jJg5jfhE8i/r/mtdm
	 4clTJMs3X3dcMG2dZ+jNYraoI5XuL/gcQIu1sp2HXD8Y11RX1uQ9jO11azx0r7YhhWkOa
	 3EoWS1mk4kJL/t9vfnEbQi5ZxeHnOxClz/Z+Fu/DtgQmuCydowPwZEoktG/hYY2Pn8xIm
	 xW5vst1JS8vbC+qpyv+1NdDmcoljmmTjFkAs3k9gZgsBxrgH6/U+noT4RQ8/iOTQgW1Ma
	 nTB0Zv+GozIxKlyXvoUF7vucNDxe8gJaU+E04MosMKwSZIdnZrxZ186cbv+67ZpMdBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kVBuB+4d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48E7606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 19:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B48E7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kVBuB+4d
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-844a8bf7e25so3940388a34.1
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 11:14:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795720454; cv=none;
        d=google.com; s=arc-20260327;
        b=sPahAqyIYCva849LxxIpiqIuP8oyCoBCmbCqYPybue4asHb3j/AyIdIiN7mNzITqGZ
         GwCrydHTo4QSmyqhKVvdDbzpcGhWroSqbZDbrtQn/4Wti+idoXPq7KXLh0Klm5jaoQkQ
         6Z2v+lw5lewnqesjE4b31s/WHDScePsFMU3zDCbTTpEdnWoMK9X4hKCdGrYhSm2kYdCJ
         N+/ChZJrcNnLifdJt3R/YiJ0NmKXw0J3gMnOCLbTVoC3zdA4RFYctPzxFAawlyjpk1de
         wudHSdYcBEZpb7lLQrxsuQbwAfwmrs1CG0e8rnX3E0DTBmua7zI7zF11ogTjeXqwbDPU
         SaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Z+HrvYkLsnq/67deomAXM5gTuzGmxqPOZTXghSZHfhI=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=K3BRVTIqomkPTvsrEGX4kX6XIaGWzOM9NexGUj9NbBo7a+fawNWUjvC5wr9k6ypSSd
         /xFfoUGYxUn/mZqquTQ2UvRLT0UfVlVGVMP8hrzVHLvjEBLY0QGJDx0Neec5f1pX1fhk
         1inr7W88rFjHrIa8lKENFRakgpnR5ynOOi3Tb4V9EpjEvqpFhExR9aQTi5Mo9SBVKJgE
         y+9VOVRufWUFeAXECfYqLzz+V0QbIh7EPTRidsKp7313+OPy2a+urQNz6+932DdnvGlV
         XqGlV+Phy8qxCCN/REnCWHr7fKmixUFQ3ZDfVU7ErR+V6C5ialkrNmZo0pVki9Ofnmpc
         QBTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795720454; x=1796325254; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z+HrvYkLsnq/67deomAXM5gTuzGmxqPOZTXghSZHfhI=;
        b=kVBuB+4dcZu7MU+j+WlkW8py0hMZPyHlyGymJPFyOK2fCI2i2x+OtYYGbGpZe7Rpqj
         GlsRgpt9/VTeY+zD3QQVWOYEekrEYBE+xBGnkJe2gkiBjhWzPe7CbkyEMuevNfIvKqfF
         kGRIH/ZK82yTI356Lgw0L3ob1Ahvk+4dCek16KaCD1LDLaM7+4/ewoJ2IMaqD6YT39vU
         VxNTt6c6o9rqPu74NXauErOU1UGny+uGtKxX1jmaNml0nKzaSG9fgSSAmb2tKz8WTGIh
         +qLHahbKAk1F7R7gelCFYQfkRfwsg7WiVgIahWcOgAlqmC/Ovofpl9qbWoF5hgsBdWAz
         lwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795720454; x=1796325254;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z+HrvYkLsnq/67deomAXM5gTuzGmxqPOZTXghSZHfhI=;
        b=wPiggtyGIF3cgYU1genzCEcNe076zcf5AxUmRPItTxk8r06pT/lDc9qG+bHrA3P7PT
         MqmL16rJg5aD0mmpGAgAn+hRmVDXs4bgffLaDeZGQHRVYZfmIP+zpcdBy3Am3O2+0kJ4
         Nyc7OcKw3CwU4DwHPxXrDXb0L8CBIgBOrIomnF33QaGc+OImLbrkImWThkZsgSvb6KGg
         uVlemShBb42Qy/XJ1ZQX0tHBnhZGtkXACHKjfkN9zAJFgcqjN2RVKlG2p3dcsY2mjFgK
         CJDq6eIHVeOVZkyZ9CRFN0TD+0Td4RuU+4eNtxLlsgVIuwk73EYigfm3EAGONYhn6kQV
         4RjQ==
X-Gm-Message-State: APuU4Z9QGPVLu1g1uxOR8g2Akq1eB4C4GZMr7uDj2TlfEnikoH5CTKCB
	rfcnpHjkk5PE/iqvlYXna5iVRchfdGxJxHkVKCx8zwlFbv3QYBMMV6ImFzP+1/YiPaiXNd4gk/E
	OI+Uu8yGm+9kpkQTW0P3+UiYzn4TK0Mv/DqSBm32dZn0P7vsAvZTUKyaL5GY=
X-Gm-Gg: AZFdTZdVHJ9y2oXIpGCmRJqRwpwjAXYe3ReIdJdDAHcoP6kK+2FSYNJBjZDUrU6K9nA
	6c3OPTXcQ5Of/UlS9wfR4Q39TzFtabj25rOfJ0lh6nd6OuI5RZZdLmgMZ/mpGzVBMjmQO2hjdWb
	It2lOsI3RhZODoBXntTLHbcW7dArhqcalLggNMY94+/a4bJRUc6I7Re2Dry3ZUJk4da8NCTwUch
	pUFF1jfFP4fla1O8afGDXgDbEEYHWHOy2FwezBBoXiByxT7wWIS6qXNUdH8wh3Cyf9rTciVaccZ
	6F+jE2lPnDwQ4/TLmBf7VoU+kAavrYxfT7u3rTRupm+1VALSt63hUS/gSQ5KM9EKJlOIvFIyvdf
	E+sRdnRjT3w43bCCDbxvq+jlOHCPJuU9oLGAtKp4mPlNGrKwRUv2C9oallEz8JdN4YUn2r0laDa
	nhhY5xLg==
X-Received: by 2002:a05:6830:719f:b0:862:c685:84bf with SMTP id
 46e09a7af769-863152f7117mr21481338a34.4.1795720453104; Thu, 26 Nov 2026
 11:14:13 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126185344.2784303-1-jmoroni@google.com> <sashiko-outbox-236047@kernel.org>
In-Reply-To: <sashiko-outbox-236047@kernel.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Thu, 26 Nov 2026 14:14:01 -0500
X-Gm-Features: Aa3M54p1wd51trqoh2-IhNw4UneDMSp3yOhrSTLJWQNF6Os4pbacuIGx2Jk7Uk8
Message-ID: <CAHYDg1QULQELHrxpbDevy7LTA_OP7Cubf_z9YH9JuUwVfj_ATw@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Wait for all refs to drop when
 destroying RoCE QPs
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The cmpl_generated part is what patch 2/2 of this series fixes. It disables
the flush work before the QP is moved to error and then scrubs the QP's
entries from cmpl_generated.

The resize_list part is not reachable. Entries are only added there when
irdma_resize_cq() is called without udata, i.e. for a kernel CQ, and there
is no caller for that since commit 6c45efd8f9bb ("RDMA/core: Remove unused
ib_resize_cq() implementation").

In fact, a lot of "resize CQ" related logic can be removed from IRDMA now
that it's not a supported kernel verb. I'll add it to my TODOs.

Thanks,
Jake

Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B89841440A
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855394; cv=pass; b=t/yq+55kADdLJzNLbWibJvkUTJuOiRLVFtQV3iSeql9La8a0S64/ewJZJFLZUeilbwT00LSl5LKEhhL3uKmiloUcPYqJuxg+iQwJx0UrHfRF3lmVAXZo2purIip3A7bve7o/IMX/zit+z3Dp3msarfNEcyc2hf0RHd1m9s3k1WA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855394; c=relaxed/simple;
	bh=EkzJMcykE7vjth+duXi+zPnQKK1JLwAYUVof6xmbNqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ebXTdmvzkB8mz8RsD58aQ4V7NneRYzQZZ/L1ZKxBy1cra0n85m156ORNiSuQ+XCB2G8o/Mwj8Ff6nIiwloSso0BBJfNhLO6BLTPW2Gw7M5ggmwauSdLY2p2xJguYj7oEFYF4c7xcEVq+rec+DHsTKNawLGQ4CzdkyGysXTOtz9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s4Vbn7mW; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s4Vbn7mW"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6df1eeb43feso966643eaf.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 18:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791855392; cv=none;
        d=google.com; s=arc-20260327;
        b=DQookqNcZsqpDQt11/x3xqaMnTkzXtUgLCj9H6Ga+tmNTYxwjOoC9bhrOkG6/HxZYO
         VUdZc2qzxLR2VPdx0/oM2/Drw8sgzN/FgQNwmzdrg3JEX5LaLaSkYLX2I3cV90ENFbDO
         uCgVeuOMZG6TlR+igK9BKbF3KGKA8T9nDXXbr3fZoJJgYvF7a2nidqkEYTF8NafWRc2P
         YAFJnz3hGYBaJ/CjQW1mBe2Ad1zuUBmiZSNvKdwBph2Tc83gwgMd7JB2wbG/KS9uFclE
         F50PPk+VRdIggxh6qQFL0gZXSEPG9n0McOPWmC/Ww2k44Ohlncvw8vZsSZlpmm6tLcyH
         oP0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pKqXzmebTfUCdHJlGAfv7ABK7ZHzZC9G3vJbb2Gw7Zs=;
        fh=g2/tPmxZ35w2CXitVZNxlq57UD6V4ot0y10U7lVmRD0=;
        b=PxZ4tFhkQsn3D2ZJXTNo8AkpcTUcbA26Dr4iPWfvkYzNwO4yLigO6EMWqZoHjqe3+q
         NRawsPXse2Y62ZmZQySFPLf2ysCv2iA4Dw2gwfP/pjl4y8qTgWekWP2vOokl7BNicxrp
         VwwPCyRuYPKEScV40n9z18jxG/AI4Gi+D5xCqW9fwe1poGyKolUCW5eCgBt6uDslvq+G
         UB7y/YsHnHJVnasLgblhV112k9MrWuQTSyuqb+5C+0T+3022RgTGAev1ZsROpAHjZoOh
         PhzX9WBYiHR80u6dYJBlFp6Dfl+vukA//R4ro/W+KOk9AGRzF+C3H0sRf4QSTw576RbR
         68Vg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791855392; x=1792460192; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pKqXzmebTfUCdHJlGAfv7ABK7ZHzZC9G3vJbb2Gw7Zs=;
        b=s4Vbn7mW8nB1sA/Rju1EhZcsxOH3fgHYvKEuzZqsOMPEIhh5CuhowphxTwSck8nyFX
         eTQ/j6Dblh+Mq8RaX0+pZFZ2FTyjvc6sqS4/QfsWkkIfrQ93EoRhjEw9tuzV5kyLxlNs
         46nIWCMUeSvt6YKsxkSnNoAXZWRkREuWDs28lfcCyZhH1sfZ6z5c56tqJrGaCWnEqc6C
         GqU/t4bih8iJmb86isOo3i1tSsYoIKlSpn/edOImxOUfwTZPgSnDp0fLeRszr0KlwV3T
         PIGmkduJJVijYPs/vZohuJQyOU7tyu6XvzxOHvsUGUfvvxy7hv3hMKcR5c/ncn3VNf3G
         D4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791855392; x=1792460192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pKqXzmebTfUCdHJlGAfv7ABK7ZHzZC9G3vJbb2Gw7Zs=;
        b=bEqIb+y9KQloy4HGr77ezIoODTYBHcjA8fldBytVeBa1Oa7bJo8iHqx2dtJdBjs9of
         8NWDzXydnbRabLX2mzLYvUmEKg03KGCYGcKfhOr+pAGfPkhN5PnEx3M3atwTWB6KOv6z
         FRDhWMzKUEGXSKa9Unu8jitI5LTQx3EoZMhdoCAEziz3vrobpG9NE+nZYIUOJ3tJZwQH
         kB3O85dnCLMT2M/zJy1uXZmQcD4hKeqQ3t1PP9+V7br9Kem7QC1xnUrS+hi+jsNruxm5
         RNEicCa9JsCBXpMXVoOjDz52Qd/kzdSJnaPQC0taAQf5TCk/oCDQhYpSsnUzLYZaEgc5
         QO7g==
X-Forwarded-Encrypted: i=1; AKwUvBzRFo5F/RRWOcySOvBuk6xQfwNvqLtzQYAGycSZeq5dxIX9nIm/kmij+BdTdUHRXCdYWMku91LxNSiu@vger.kernel.org
X-Gm-Message-State: AFq9FYIQbYDt59aDg4v3wMWG72ffRA83zAaug4Ckkv7brMIkMVVzjZsA
	Y0ys4cAe1KL+YwPNxxfaxjv+oFV4O6yXE/ENYTcZoAKqQWSJT4kGW7/osI1+x06qSsuxi26S2NI
	kAAC1ukyK6xKyxz0k9lLf2IUsRcDhDf6cHQCHeG2xDLd61HHEC7iUAke0+0o=
X-Gm-Gg: AYBFou17kj13l7ko1xj86yoKl0frGcsje8dOEBeeTPklX9Z+fNm5BB40ZUP5TwTfK/a
	rZ3Ocu5X0R/99IRZXsXCiM9Y6D0CHy0UNhHqpSCzWXqOlmLxCH9wTLfON7RwtbuMZ64EIgYigx6
	fyMt86Uiydm4upYCQ8wggssxJKQvCuQ66a6cTgKvRv1uWwvbn9ILcWZ0O0NC8XRFRF6FoRSL1hF
	OfDSqOEgO7Q9KLJ6Onwhl5CFiZ2JHjMvR7BRue4J2DUjv2WkanseKCTS6s9JXRox4GL2rgvBHUv
	g3wX/iOh0KaRqzuWOT3CHQH27THR938+dWbiD/kQzMQFVBrAVs3TDjrVgAJxheBiMgm5HlA1Jnu
	j48VpuFv9tUI09fSTxGMxX61y
X-Received: by 2002:a05:6820:f016:b0:6f9:59ee:cfa3 with SMTP id
 006d021491bc7-6f959eedee0mr915580eaf.32.1791855391403; Mon, 12 Oct 2026
 18:36:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012161135.494544-1-metze@samba.org> <sashiko-outbox-168385@kernel.org>
In-Reply-To: <sashiko-outbox-168385@kernel.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Mon, 12 Oct 2026 21:36:19 -0400
X-Gm-Features: AclHuK-jVCvZe8_OBvJgwJYuqaxwdrpyyQzaU__GwwI_h3hVSQDw_8kD632addk
Message-ID: <CAHYDg1SOnqkLT6rfJCu8=gB=s_NY4xR-BpbpN9E4VS-h_nRaoQ@mail.gmail.com>
Subject: Re: [PATCH v2] RDMA/irdma: always route IB_WR_REG_MR through the
 allocated PBL
To: sashiko-reviews@lists.linux.dev
Cc: Stefan Metzmacher <metze@samba.org>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Nice find. I was curious why I have not hit this and I think it's because
the problem might be elsewhere. Or rather, there may be two
problems. Looking at ctrl.c:

    set_64bit_val(wqe, 8,
        FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
        FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT,
info->reg_addr_pa));

I bet that second FIELD_PREP is supposed to be shifting
`info->reg_addr_pa` and not `IRDMAQPSQ_PBLADDR`.

That incorrectly chops off the upper 12 bits of the DMA addr that the
HW uses when in direct mode for FRWRs. I think it just so happens
to work as long as your DMA addresses/IOVAs are all less than 52 bits
and the lower 12 bits are 0.

If that was fixed, then I think the direct mode would work fine
as long as the MR was originally allocated as PBLE_LEVEL_1.

However, if it was allocated with PBLE_LEVEL_2 (as it would be
for smbdirect which uses max_num_sg == 2048), then it ends up
using a completely incorrect value for `reg_addr_pa` because
`*palloc->level1.addr` ends up being the leaf PBL's HMC index
rather than the page's DMA address like in the level 1 case.

So, I think if you did:

-  FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+ FIELD_PREP(IRDMAQPSQ_PBLADDR, info->reg_addr_pa >> IRDMA_HW_PAGE_SHIFT));

and made the post_send like:

    if (iwmr->npages <= IRDMA_MIN_PAGES_PER_FMR) {
        stag_info.reg_addr_pa = (palloc->level == PBLE_LEVEL_1) ?
            *palloc->level1.addr : *palloc->level2.leaf[0].addr;
    } else if (palloc->level == PBLE_LEVEL_2) {
        stag_info.chunk_size = 3;
        stag_info.first_pm_pbl_index = palloc->level2.root.idx;
    } else {
        stag_info.chunk_size = 1;
        stag_info.first_pm_pbl_index = palloc->level1.idx;
    }

...then it may all just work, and we don't have to give up the direct
mode optimization.

I'll give it a try later.

Thanks,
Jake

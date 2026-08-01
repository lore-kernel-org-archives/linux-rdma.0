Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A3360EEE
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 00:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785544543; cv=pass; b=IvfbW+tZmGKAALJv7d+V2kZLrhPlpRUducTwtWzi/7l04hCo9tWN9bGv/7RfjJDaB/fPKGTj1jIDU75IxZkFe3MxIeO2PrRd5ShEbzIUA8JrIcIVWN/RRhdDP9B7YzR5+Bc8LPzzi7hlKQ5TAj1xuIFynbyMhMJlVmuB4w5hVXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785544543; c=relaxed/simple;
	bh=/c9rs9s8aUUWrL+u4O1/14+O1bWwnH7EdFf1+dobLQM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=cu6/LC+KMrepjxZ+JSn/+TNbq/rqhdLFDjnx8TNSJH4acx2PuhiwFHR6TugT3ZWYJpsdVz/xddhI7zDAT6orK689Ch7nQmsEqjin1vM0SNHQcMs2Z/YlH9NPK2/VZULeD45ZqMhlLrApC+6cMCitm+MTNUiqIaPzNIQU5BBOxvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hx1l3nSo; arc=pass smtp.client-ip=74.125.230.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hx1l3nSo"
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-39ec123fb26so7610101fa.1
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 17:35:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785544540; cv=none;
        d=google.com; s=arc-20260327;
        b=pRAvoKOSGwqTcMTanWRAwrwqQPX96/QWTFOHeDHbLhRgn1oo82hl87yjGIugF+BeY4
         c/X0WDTFRSfvRjK1vLtZCmH0nEE1rm3HsVgbUoQKOBXRZgDifUAHphRYxpNH+aPhXXZn
         Sm1iKAVEC6m9Quymy+UxE+5Qg+IKO9FMi+QcApWLqjjAe7kfEi0GoAcvaDA+293rSe4f
         gqro1TLtJFSUNvXsqbMDP5YHRotRg4RwTGKXV914jNucNl887r2gtLOerK2jWbLIlfZz
         +69rbGz89Omq3x775iGYBS8ho94OfLaWd/Z4z/wQ3M4HkzpUbTh1yXb2pIMuFANzaatE
         zFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/c9rs9s8aUUWrL+u4O1/14+O1bWwnH7EdFf1+dobLQM=;
        fh=kKD4ZcK7EiBbpPvy8fBui+gbh4y+MCKzWSOkLnEd924=;
        b=S81Ox9r/ed6oy4zojCRgCHFB094RvUmWcNau8howBRPElGySfrad7Cse66LyIrxXZO
         wKW5KmAbGofiKTWABVQdLaBGO1VB/CcO+hLzvvDklWQb26qFf+XwlM4P1MFy+tY3EW9t
         pksjzHCTTVB1wgECXlBTPypWS63Tb7bp9yBN7dOQFzq4kj67md0fyA/IuLTarIuc94jJ
         Dj8rkWvaVp7LKWu72K2z3mgHPJceO3Bxl0ylVRktubbGwZcu19w5eHfZclMT/XK97ge4
         bmzgEM2dBgmXeptpch2OeUHXeW7eInOwrsaxfmO9cyqHy19wRunwnLe8LM/lbaWoziU8
         7Org==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785544540; x=1786149340; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/c9rs9s8aUUWrL+u4O1/14+O1bWwnH7EdFf1+dobLQM=;
        b=hx1l3nSoN8hH7WoTewQh9qvw00GhI4VRxn6F/e61aJ4kOERzpUdwPjh/7YQwsTUbUF
         40aYyzdcBskXCXfziFoAE3xTuWNWBYbKWbnXtSjdskjPHOdHafc4qP6UmUxZpidDAFbM
         YtSmKtmo1wzBJVj45r8kd3elppOdcqXa1tTWGvB0GlFLIhFnuTMI6fJZkf5fGicDDWsM
         nB582GQT1Z2SKv+xsnzF5BsTKBirtqePlY2y1LFsLryELaSoTJSlZUraYdz5YIDxE3kv
         JgcvfO1uACwS0BrTGVhqDmd9UbU950nyUBk4Jj7dQ8d0irTIwvRNZKsM1zpc6nbcQs8A
         OR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785544540; x=1786149340;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/c9rs9s8aUUWrL+u4O1/14+O1bWwnH7EdFf1+dobLQM=;
        b=LVlpec0YNK2kBUPeoEviYGmjHZDTQcLlevs/6fLM7xoR0AQ8p9Uks0JRhsC1BPK14O
         gkUTlZVUpeUZ7tqk+2Q64xsGWCVi2Dco+3vfWiS4O6dBnjv4FnXzMdXGygwWxUNxJxx9
         sHn3m/EzNfu37nAZoFo7EyALekcyqq7YJEW83KzwBuoEq1aPR+lAEygQJWm8tefOKVVj
         pDibyKbimdfZjeQVAOZawQIt53azjaJZGZRRVJgmhCpZ/6cmvhhEDrW1U3driKmp1akX
         krIMPJ9iJ+JY+uox7aypWDGf0Id68kY7jhbjNKm4RhhrAxxA9qjNDTdXdZhwq4MU7zPQ
         Ozmw==
X-Gm-Message-State: AOJu0Yzwfyp25GnKJWnwouHkjie5LISSeRBBcPekiQyIi0Jhesbam6hu
	7M4xSHIEMLd/FKJYHgW4038G5NP+WnjJR+xODdmrv6ni8MAJLRxjZMx8lc30mPt+gqtfIPQv9M1
	KtoJLBQJcEhIKvTfL1Ugd3chtsWoGjimvR/Rb
X-Gm-Gg: AR+sD10LABT9BiFALEDsbBS/XrLQlL2PEOW+8a43+NTgdCI0SJtK6uykCH+sTAEqYpD
	TPUZpAmSM66g9VFeqKHPJZT4UlvdBa8qDcpO3/x8REk0VqvKVkScFDNmv6z0apjIahYpvJZP0yP
	4hOBIERPYJjn5YGh5pw2j3a3hpQ5K9m8GTq1icF3qAjP8F2weR8vCt8YtltQz5X7QOtnXDIWWFn
	FkRHm11zAvpE5yQvywZXY5NqQiFDDK3vwblJ8ipL34/41gw8ZRUod8qTHqATCghH/6wXvGOpvop
	8l6C83S6PvwkY+4nLTEGesAPD2cDmFfxh+MFHMImxKO/
X-Received: by 2002:a05:6512:1387:b0:5b1:5829:b8ca with SMTP id
 2adb3069b0e04-5b2e4f3b602mr310416e87.26.1785544539579; Fri, 31 Jul 2026
 17:35:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Sat, 1 Aug 2026 08:35:28 +0800
X-Gm-Features: AUfX_mxwNdsjOUWKtlIArSHo8w6pPtSfHJVDoxv3Q6RD7nBZkvFdMSJkQlJzFyQ
Message-ID: <CAH+L_5asmdxZ95ctx6nj79OB83kZGzECbSKz321dr52mRwA06g@mail.gmail.com>
Subject: [BUG?] RDMA/siw: remote invalidate may accept an invalid STag
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Resending in plain text because the previous copy was rejected by the
mailing list.

RFC 5040 Section 7.2 requires an implementation receiving a Send with
Invalidate message to validate that the Invalidate STag is valid and
associated with the corresponding RDMAP stream.

On Linux master commit
8ba098e6b6ff0db8edf28528d1552be261af30d4, siw_rdmap_complete()
passes the peer-provided STag directly to siw_invalidate_stag():

https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L1248-L1259

siw_invalidate_stag() looks up the object using stag >> 8 and checks
its protection domain, but it does not check mem->stag_valid or compare
the complete supplied STag with mem->stag:

https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_mem.c#L258-L282

Based on static source analysis, repeated invalidation of an already
invalid STag, or use of a stale key with the same index, appears to
return success rather than produce an RDMAP error.

I have not reproduced this at runtime. Is there an earlier validation
path I missed, or should incoming remote invalidation use stricter
validation than the local verbs invalidation path?

This finding came from an academic source-level RFC consistency review.

Best regards

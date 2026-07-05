Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753835BDC2
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 20:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282193; cv=pass; b=erPJKa8s5X1Bgeb3hUTwpR16trVH1LCNT/GFMbBmR1DaO+bQ7SZezLtXklr/qUvqMBxDp1Sj9RGHQlNRJgAVuQnosIqrCiwri+vJsgdp/rGx+7yEJkO2INXqm1v3rneJUF4h+6CfK1kl+N/w/13aN45h8EA1lIoM5kKLVJvqo5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282193; c=relaxed/simple;
	bh=pTcfv8ZsxUF8iAwL2NsQdJ6roazjybyn9DERzjJtitk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ir7vqj3XEqbNtOucZQBkETn3Vn66CwgJ6wRDT8KdOJNXt1gXN6Boq4cX0mYY0rYeXySjxEa6d0rghodpxNo1wacJMfbXJv6Ti27HtQNgUhKz9LCmMvqYmLz1EoWT41rgd5PnD/xL4r5uRJME9rDWStTax8R0YySvsami54Os3TY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mCwgyG4c; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mCwgyG4c"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-447a81776e9so557777fac.0
        for <linux-rdma@vger.kernel.org>; Sun, 05 Jul 2026 13:09:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783282191; cv=none;
        d=google.com; s=arc-20260327;
        b=NC/AXrK7Ujb8zkhnZmVSkb8WqurjpY3Hps5fj1DcyWvKEzcotd1OWXy06Seg/pvlUb
         OhW+elOGWnqeDEZ5Ko04hoQvqa4bx6T+lJsVRMU29UF+2Cj833KN/ldI7l+U5neNjdGi
         g06Iz3d3dtFdHaGe/ZT213RmzRaFUTktjVtBjrHKZklg6hY+8t3YuhPqAAGUbVN5cEIb
         l9+jeIvEi2WD3d05Nm1NNzwlWC8SZGe8o2RA6hCqfji/dqa8Hl3ZsY+R+ehphatrIyhe
         SD3xkTG96m0MRDmhbYVFQpI/RJVp7H1uHPzcebfrQEE4LvjjUsyX8Cw5iDeLcWmZMGW/
         0F3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pTcfv8ZsxUF8iAwL2NsQdJ6roazjybyn9DERzjJtitk=;
        fh=Xm9JBxTzCPQnciNgDPK4p1G2OQt9UwgyD/NHPeIbh/w=;
        b=dsrPOWDjSJgcCQUJzP+KvkH/Hf/cacvV8kuYLWAmzedo9U+SIhaf7q+B6HziRX1wWV
         YFlY7DTEh4Wh8DgJiO+pM6ayFrmna/Lsp9u3L03elZx2kYjMR90T5/UO3VqNvCPC0CkB
         +x5iYqmLsEzzF1MxD4rD40dxGaEN6/MaE3xBN0oNRSXk3rZCU6c/ya3waZuVGsVhgQyN
         Hl21y88qDlBloWZ0KbP0S9weLx4vnt3mFFObiCPLLG2naTwV8YWMatyreUeJuFOy8THd
         BSNSqOWWsmeGmv+rla9G3c4mi3/AoaNZBGHWfiuP8pYURbglQGLhck/HjDIMH+qSoeQJ
         6o/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783282191; x=1783886991; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pTcfv8ZsxUF8iAwL2NsQdJ6roazjybyn9DERzjJtitk=;
        b=mCwgyG4cojstkSEczI9HT0tJEf19ofV27M7xKIRqruj8YbaP+FwH6+Rr1nDctcpfzb
         5CntpYK62agvpckiXq9PY8FJusJeQ5FwcSmb/O0pszhzL7n2sjsbMFA05N72ehQ7dNRS
         yXXySRP+AiF7582S19Nz3oYT5juyxi7Q/F6qMOCjZhSYUHk0gqSn+fJ0nFx+0hyl0e9R
         K8y5CLYQMgWLJzICZpAg67tte4t/KO8L7SUnQzymP3ATf3M1/HETOxMXprCfjQOCFR0I
         x4KE+pvcVQYFCdgEj+zzzeGirk/HVUD0jkDt3JPKw7u1e1If97hzWkm+PsQ+0Zl5bN17
         06zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783282191; x=1783886991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pTcfv8ZsxUF8iAwL2NsQdJ6roazjybyn9DERzjJtitk=;
        b=CJvAcF+GEkWOZ9OKxVLnziOFhbpa70JGqu/DMeYW7MA3lzHgcp5ozU1tZYiQor/awV
         lf/XbllRjaNVmE97nX4LgBoAm1qFrTy8TVbj7mQpEhvdbiA/XFsizj7WnTkwjqDB2jPA
         PPfSvVHJw9nXPYl0HBWDiZ6bZ8cAnSV2/YoQ8I7y9vgFKvqWIN+BlhhGfSNG9wrHZyp9
         C1dTHCUCUEEFchDYl0djiKjzcPIxb1P5u6k9pEm7aZtEkrWdc5bDQZdADH/oIZjkz+R0
         kglJtzpfPGIQLNnAgTv7svH5Xsl/suKuBp+K1Dd/+L58n31CIzxFrYmmTm/Z2quWRz5Y
         haUw==
X-Forwarded-Encrypted: i=1; AFNElJ+V9nUqYKhSZLEicB4svHgBd8Cc+Zk9ebinkzGN0mmiVg7peBJDZLvQhAUHurcHy5Xel72lyGYRoy+N@vger.kernel.org
X-Gm-Message-State: AOJu0YziT47y/TXhpV1Hgi2LV5kwNG8F2oLb26LUO4KuhYAKmfMgLj+T
	5k5fNOQh3GgWLN906iKRyY2/UjTWWQ56RJyRJ5qHffxiVVL3UZhbvVno0Fjet0x0kQvnLRzDvDU
	USj2jwKt+PEOxLdHajQt3/MX+nZwRA3miMnBaMhsS
X-Gm-Gg: AfdE7clW7wdIszahgYZ6OfoD+Gp2zs6lSALAiF6wvH5zSBxqRS2lkHqKRp1t3Lnh/uP
	WiAW/oWVTxgqZmMk2zhsraRjTRhEBTS6g+WFRX4miOtddcFnXwC7QFmn+t5h4q95eJkwOCb9/Ti
	sz2/fxkVm6+a23zBiFN0BBChv0jOeS7SP5lEhh1V4DdwilA9xkNOGinFBpI+Kn5d+xn0DxQdlNB
	0jZQpA5DNn0lfnbYKI70vZOHQ8finqdnHGF+XYd39VQABKCEpGToqo9dQM=
X-Received: by 2002:a05:6809:20d:20b0:49b:37df:64db with SMTP id
 5614622812f47-49b37df78bfmr2308914b6e.22.1783282190575; Sun, 05 Jul 2026
 13:09:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260627025642.4064973-1-jmoroni@google.com> <20260627025642.4064973-4-jmoroni@google.com>
 <20260705121454.GC15188@unreal>
In-Reply-To: <20260705121454.GC15188@unreal>
From: Jacob Moroni <jmoroni@google.com>
Date: Sun, 5 Jul 2026 16:09:39 -0400
X-Gm-Features: AVVi8CdiyCAp0lyKJZ-upBGhpMxSxKrlecMI5vz5SHgK0P0qTe1Nwz_ySgDDcwk
Message-ID: <CAHYDg1R_hzpSVkAO+Zw06MRPhOfYkqbSsQd4xSxCNA_e4TukmA@mail.gmail.com>
Subject: Re: [PATCH rdma-next 3/5] RDMA/irdma: Use ib_respond_empty_udata
 where applicable
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, tatyana.e.nikolova@intel.com, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yeah, returning the value directly from ib_respond_empty_udata was
problematic, especially for those destruction ops where the driver has
already destroyed a bunch of state and doesn't have any unwind logic.

I sent a v3 a few days ago which reworked this a bit to add a new helper
that does the combined equivalent of "ib_is_udata_in_empty" and
"ib_respond_empty_udata".

This is now called at the very beginning of these ops to fail early and avoid
the need to unwind.

I will probably need to rebase that series after the recent merges;
will send soon.

The v3 series, for reference:

https://patchwork.kernel.org/project/linux-rdma/list/?series=1120628

Thanks,
Jake

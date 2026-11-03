Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793713185;
	b=VozraXfAI6MT2+mn5JgDdRifJ3zfrSE0PZa3Or97eKTPAyGbUY7LlRg6nZRZkFJO6kSY
	 +Valb8knXVSqnDroyv2FqrDhkShyPkn9FeqOK2/HcvamK0ZMmpwxZ99sdNgNdxsPxnAY8
	 wHvaBMZSb9qIb82DpzDhPZuYNkZTM9jWaVv9hGUqznvEdJWK85ADzSvJB34FaMoSJA2lq
	 u5sgu57WaV+2h2zXqgGZBRS8C3fEYZFsNYWLwqRZiR8mNmqxdUK88OmVQdMS9SPMMyHhO
	 nM7X5IF7h+OfvFI6SRe7a7R+xO6nbolUXCSVRT49KbqN8fzaAFgJld8TFw6ZAVINecQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713185;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/oxafh7awXR5i1GsoelPeB40J3SQDLME59T6OKDqgS8=;
	b=3ZPicb8ZBkn804HnZaGsnMhUHr+qgr9gT+NW4Q8PGPSU+41rfuE6F7+ZwP0/4VzhhpSW
	 //vMUEd/y4dkmTKFvStScWgASTV2hxhLcLuUxyAHHKzFZh+1WcqrBcde/JQ1UVJBddpsJ
	 G1MAcnKFpmTFZUrR2cHbc5omTuBYqmrfCZbOKdu6kO6WRZRrAlSBMC/Vw7s8PCo7Wxeuy
	 eQqSO4CPIK3WpY9yjgFh+aFCmBL2sFJ1c+VGWqDsuxuZWoik4HUctzDBWFk7YTviEx3kf
	 RGgc61ey0vcg05/Cl2kGF2fTTAAFaOmxmglbWmIe9yVcdjkbwKYpOxEgXKQ4pzE9Iow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WtfoQMnL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.50
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1076D606A328
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1076D606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WtfoQMnL
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6deb848ddd7so3143306eaf.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:39:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793713184; cv=none;
        d=google.com; s=arc-20260327;
        b=Ttet+qsQf44tIxtXqgGtinroWdSaxfII9d/L2KdZjpo6sLYd7SAHDbhv6rafyh7/T/
         SxS6IDNdpuUOVTFFrlT22SAPntDJ4dKE/jcMd7BFaZ9Fx/S2G1yVsqXVEQZVtLOcyMxn
         2BHsxt6zwvyRoWr1UQEzbbsBGqZi0XLnv/bt7i42sUpMDmIHRc99KOKu49oqt59jfJbo
         dsHiyVWutNcdZcpZdu7+A6+FFPhgfCuBTDgib1XMaxiKuUWq4o/lK17IMYrn9pX+MtbN
         dyxDu+mcnl5huH5e2FmlFdgeTbbAsSdQTHNcKoGiAlyVpL2OCD893p1RmLHCCaemGNjj
         bw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/oxafh7awXR5i1GsoelPeB40J3SQDLME59T6OKDqgS8=;
        fh=8gcIGEKWI6X1lpeAZLuNM1klIgh2MiGANVnCajd98Yg=;
        b=e+DK40UgY6wKcvBA5wGojkEDyw9hb6KbmpfUCZSQBxKGGD/ZghrzamSR1Rg1L9otqT
         AImK4iP8JK1i33i1z7CyY3l/NcsiYMFOnnJ+cdkHniNeLjeh2BauKu3ZLK3mJO3f2Q5f
         cHDbXEH6MOZsXgE69XazeFnIxgplihoH674onybFGaWoEa31W0ASfzynYCsJIbu2/M1A
         elYC0ZVmE/LezA38xDmDiIHd3mszf55bRvnHMCzK9mIe5QMlqsX6BWISUxLfPighuRlw
         OI6nlNaum8VYwnZh929wBuVb7eiJsI0nX+Deo/ssgZLYFDRmoDj8iUYy8ANIznuCEqzm
         AnkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793713184; x=1794317984; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/oxafh7awXR5i1GsoelPeB40J3SQDLME59T6OKDqgS8=;
        b=WtfoQMnLUn9aEo7i00BdRUm6ILI+/k4nX90bJMbEjWu6MpkRpHQ6Z5UJqPWzhs4I3y
         7lzcr1PcpBoXKfaykkP1gApCJERBuJqcSog8zDkk/PIKKPGEEdiM66uAspNy4oybhe7h
         mTnlbuXK9WI0KJ/TCkilndniylDvTRGqf6BKvn7nLgTnQyr4LUZE3cTPjUPlcxYnF2nB
         qbHz46vO1hYqHLskjRsLw6lYxYXui8btIPzx0oxOqWmxtxL1w2SNP9mShFd3Nq8Gvmaf
         wODEkFUoOzVjxbzOaNIXKDkOREz3f4yk1rxBpzBxENzTposzQjJSvPZBqKYhlswOezLU
         v6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713184; x=1794317984;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/oxafh7awXR5i1GsoelPeB40J3SQDLME59T6OKDqgS8=;
        b=YDXVSg9naM6YirGS9g+RlyejomCz1G28ok7TwwweiHNFL7cmPYostSjG/9jqPRB12w
         WN5S/PsX2yQV2r35uEbxpL0t20nKzlt+K1Fdu1ai1qN2Tw420ud9elN3SDzKlHj3JcmL
         4v/C0seHSyWVgwajF89ehpGuorfD0uND0gC5ObG1+Mjc4ZymH0H82u3eARwsVGI9fuef
         XHh/bL8F/U2UnVRrhNvbS3VL+69zkUFcd3+ogV0WgLOmlGZzcHer5rj0vavvlymBcCDq
         piXgpwaXNjFXyzuDKhfcMo7hcxcSvUNXW4mU1ptO1+kyVUoG1xcXMkuf2SBMzcZBX/mR
         zB9g==
X-Forwarded-Encrypted: i=1; AKwUvBznrtYXn5NwVtdnABLkWHrH4gepnP6+tUF5GHCrNYZ8u1fCfNaX8qTEel399NT7NDCUNpiwZaJiZDax@vger.kernel.org
X-Gm-Message-State: APuU4Z+ALQ0kXkqZAHtILfEL1+Dlagnjjqo5Wjii01Np+tzWJAbcJ9OC
	2oo3D9l3GlrHJ4+2otNfT2t022jZQjEYQq7EWaGSWPwo+D+nMAZTSc140CYjD5BgMNrMfRb3cLA
	NY38wtSRwUfmTI+x36lHtqh+EK68kyt5dAQte4W4S
X-Gm-Gg: AYBFou0CA1JEKvJHLRSL1sEda998yJCE1e1lXXAo8xi50grKrI6W4ZY/eHdmP+WovCO
	2qRjMEpwivRc0ziidKsuDUskSuBaNIbKcF01Aly5zJIbrKMa434TvPfQQo5R6Hf4BKGQQ1wzKmU
	Uv+zPZfze/Hhrpj1jNY5glAv4OO6KuV8mBdU40C4nXNKt3bQ8O2MujhaWkHDpqaufjhLOd/6h29
	OeE535xsoTEvuawNKmkWAqFQRF+rxqhdBYFcidtQmL8mZ3FR/91h0XGWfCa3Rw1y27gDVFocybO
	BlD4BDADXV3rxa6naZh3Mq99JS/E5fQLGAeJeQKVkBqoPwK5Afy984saLxtqB9EkcOsGcQW4brI
	3wN7yTbTzck88flu5YKkeFguBAk0Q3U9rlkUvIL9CQInN0CUPTNqYSkkn1DEdnOUI5PxB53yRXO
	wsQ5hgoslOl3bWI0hOpoJ3we6u8/6FJPkBVxE=
X-Received: by 2002:a05:6820:2203:b0:6d7:a325:35f7 with SMTP id
 006d021491bc7-714f27636fbmr6991110eaf.81.1793713183276; Tue, 03 Nov 2026
 05:39:43 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAAp7fgvKfLqxsZrvmq2+xtq=_AuGOmKLYijAsMk=bKCJFkSGQ@mail.gmail.com>
 <20261103121246.GF264423@unreal>
In-Reply-To: <20261103121246.GF264423@unreal>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 3 Nov 2026 08:39:31 -0500
X-Gm-Features: AclHuK_IH91pNQwsfxW_2ftVqBeFkAm2sS3UZv8e9ZxirxXy29Tbwv5H-aXYATU
Message-ID: <CAHYDg1RCL-TKjig0_X-wSNHEGKNXJA+K-SnCUdOkDZh_4rswQg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Restore original PD on rereg_user_mr failure
To: Leon Romanovsky <leon@kernel.org>
Cc: Mohamad Pishdar <mohamadpishdar@gmail.com>, security@kernel.org, jgg@ziepe.ca, 
	linux-rdma@vger.kernel.org, shiraz.saleem@intel.com, 
	tatyana.e.nikolova@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Looks like we discovered the same thing at around the same time.

I think this patch which was just merged should fix it:

https://lore.kernel.org/linux-rdma/179371200572.1726055.11640512427251640287.b4-ty@kernel.org/T/#m8e7c4a912cb2539b08e2603cf751fcf16d13b291

Thanks,
Jake

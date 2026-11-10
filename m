Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794352132;
	b=pdIJRuv3H5EzOS4muR7vKRdUjZO90MPdOanPvmUuWMPj1VRYyxRiLz5+CqOX3EuEOucI
	 5J/0+j6Etqoi/Kjf6sbH57HSWQpii0iCIg1oqPYjSHcJMnGs1RsvBR71jBL9ZBLH/sZt7
	 o3YcbrNfDYktGw7snaK0q+qeen/OrpgeKGu6qUA59If28XrTz6vL36l2Wd4RrJWPKc4Rt
	 8notApafipwmFamOPfSST225BIQgqDx7Hp7KWUg0Iu+ulp3w0I+9If4+0yRMmwME+bv3i
	 1UPZBkN7mT5NMBt8jQvyFos92Vi4hkyEzO/g5XRe5Dss5DwY6xThliljhXWdSuw7a/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=8v76H01hx/tjenKmmNr+sD7wqgSfvmTZwe541dWzYbE=;
	b=XO0pYu7dl5yWEtHONLzIEgY9Gtlubbqc/e2q3weyFEhRzg1KXZeomdGuAJijFRbqvVv/
	 FcOGtT26kOygZoqS3RkPu5UyfOFGjQrWciJBwhnN9r7K47pc3bGEXE542ia5olP3hcUx9
	 9EfaQxIvVD+hhzP6tmlbVW/Rj9/sZ1bPxCwM9qQaEgqlCYI0Y1qZTxH7hB6CQaoykAzuf
	 zhMstC+9Q+L+9JTOXY4S7ccaSOmigrp+URJiY+b/q/eb03cLaSwncdK3i4vTgzbBacuny
	 ZEs1k/lrcJLJROAlOajUN/hFeH8VC/aII/TYDF7JO83gt4eWAHqPSCdLpcaMa3Hvnqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LZtnUvsf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.49
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C68606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69C68606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LZtnUvsf
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6f8a519e215so2263636eaf.1
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:08:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794352131; cv=none;
        d=google.com; s=arc-20260327;
        b=H2cH12WzjNLpP3KEdwCw94s6NPR5gAQQ40DeOX2cIGXZWS2zRoCqrfSoE6p0SaKvoV
         FR+5j34a1cRDBmljiMHuoADcew2bAP/WDNRFAKx/XQtoR6qUlNqObWxhatpWCTk6TzIW
         WKyhbzZmj2XYTIl8740a7iUyhfwfQKEl1zx30uIKK5+qWr0y9uqegucR3Na2ap2nR9Tw
         H1DhJ4+Dcnbwv1iFDAzuGc2OAhU90vXcKmUFx+fEubqf9o3zQlkq1h4D+CRHk21ucIuX
         Ze8xNjW71rpc6XybjmQnWuDHia7sVK2zX2hdg97mDgtaUAQrHeOpERmq6CWiiScZN4iY
         Tb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8v76H01hx/tjenKmmNr+sD7wqgSfvmTZwe541dWzYbE=;
        fh=f412erSc+BoPeC19uA/q9Foq8Y16hy20slYp+LBr/04=;
        b=pHNr23d5dTHG5iU8Go8IAiyXve7TRkjyd1u1KlxaWj8h189QRUSKtA+xanRC89V+ml
         w2b/xezM+UoMGlBylU7CRUT4SbXGb+7U4IEg3HV6okhDFJghf6HIlemlAf7VUFDocYVa
         RdtpXn052lXKEjpngTEAn6bI3OwcTz3GE5BZIS81XWq9YOzbNhOn2WacS/miED5tZX+/
         yQ1HtpnXFJKsOcPY3xkOkxqps0At0zqUtMGFZWUrlU7AuFJnvxv88v34Xgfdt92WjQue
         gtT/ig+Y9xIBz4m4zceSroE71zeM1hInyWWSyzTW69JDDL81XOuawL9BhMQnYSQ6ZRrg
         I7WQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794352131; x=1794956931; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8v76H01hx/tjenKmmNr+sD7wqgSfvmTZwe541dWzYbE=;
        b=LZtnUvsfjzj4DjHz0yvS3N96Fb7oK/LRO0r505TK4QJu+J9lsLBX/Mv3Yoa2AKS4I/
         Su44EOQb3dJbuoNGLsal4H/fmLCQqOutfp9yNGb+0Cqw9zcqdXmKjT2qLXUQOjl8JMrZ
         6Vxe8KJRMc1d2I8ZMIYTTKdG7H8rigZG3NOo9N3onmpoNE/+z3MiqupozqeKadFzQMpx
         hjUtAOCvQOsavVnTJdDggXsFGqB6gt1FqNoDx2Jc0l0bJhLwBJv5w2J9MHjPOOW+QLF2
         ZNVLpCZ8wr0JHF5sECXLK05TZLs9n4HJ1KXaqE45b/D2pKrTAPFerE90sNczGGE7qWCZ
         M09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352131; x=1794956931;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8v76H01hx/tjenKmmNr+sD7wqgSfvmTZwe541dWzYbE=;
        b=2vzzM1UST1zpSI595Vas4Jd21Q1C9gHnZ+RLoR3CEFKLIX4Z6v4U7upCpVSKGXCxi6
         axjl/IrZP4eNT+ke4G9ZzvOBKFxXkJlo8eo4PynA3sfGeSSHSoIzNr2TAdm5Y+phGuLo
         qRKQxyBj/O/eocHSneWRw5nAAFsJVwbmp/kFXRRE0cjxtM8XiDKM37lnzTpaVCtT/FE3
         OxjITsx+3T63n+QuyWMlphQRJ5318ctRpxbrkEzl3yW/k79QqF3Rknl1DRtUmkLhbdv/
         EADy7BbQOVxFJA6yxukrd4FtCkgxYc1DbOvOWMYs5YOO4TkeO3swHTJJ1ehySoP76Eyx
         xivQ==
X-Forwarded-Encrypted: i=1; AL+hErHmdPDXrAMuAjRD2dlXevOPDrxf11rF9SFT2uMcp72u+bKg71Vi8w3smU9BxcIEOeuU9zIOFd1JA9O4@vger.kernel.org
X-Gm-Message-State: APuU4Z9o499q0/Riirf+1MNL2DCs8mqtD9OlqUl5mZhIhgMVh9SLPi0Y
	gIgBchRmQ6UuedQ0hkgf5p4KAN2P98JqyNqLRFsuvyOhznzOL/zMUQZwVn52ejh8+XL1qlEShBm
	sDyCpZL1cfhfuXOBgcti8XzgmIIOvi9oTmHqBS/wH
X-Gm-Gg: AYBFou2SsBB1mLGpS3DO9iOWRoVO5hYjfFgpqP5c7Eq2tQVtPLLLbs++iQicJRMd1f6
	FxieQukiG1iZ84dGNXydh1bxj44av5mhgycrr+MeDZVzvlyJ6OTFz+oI2eFY+EBI5LBKqgubVR7
	Va3rEH8Z8cPOafToUMIU0sw3y9+WWuR9VrSPwWinVHySdJmp3bot84yPfLpA8jcA4o0z9qVNE1k
	dQeWDm4VSQvIyQFmImjMZjm9kkQZWay/lzFgdxOMphcC5++2WT4Y6VR7WC0g+z1hpoKjS3pgxbX
	jq249ty08uNk7XLT0frgTyhtXGyRIg9V7Pn0DYOMJLK4xhhW8rXeJe11YVvOTLdoYuWxYXhZ6x5
	bibNiUMiU4dcJv2pdNchAm+vLccUuqY57XgRrup0ARyW7BSy27UeN+93VAvzI/bsyurFrZyKRmr
	XPAo+Chw==
X-Received: by 2002:a05:6820:5601:b0:716:b6c0:79fa with SMTP id
 006d021491bc7-719178932dfmr172244eaf.18.1794352130845; Tue, 10 Nov 2026
 15:08:50 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com> <20261106221201.2266301-2-jmoroni@google.com>
 <CAPd9Lg-242fV-2NhvXA-Ya2v7tZ0CHFLdwOBV7yK5aEHpkiULQ@mail.gmail.com>
In-Reply-To: <CAPd9Lg-242fV-2NhvXA-Ya2v7tZ0CHFLdwOBV7yK5aEHpkiULQ@mail.gmail.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 10 Nov 2026 18:08:39 -0500
X-Gm-Features: AclHuK_WR8yuPCyOudmMpYRoWPXkcM6WrQXTXmI72G3D_5QwjLhX53-owREWzSc
Message-ID: <CAHYDg1Q9MKJATZHcZ+-J7kRZUsW-bkP9FA7PGYDEzi==XO=A6A@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/4] RDMA/irdma: Fix QP handle assignment for
 SRQ completions
To: David Hu <xuehaohu@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Thanks for taking a look. It is not really necessary to check avoid_mem_cflct
in this case because SRQs are only supported on GEN3+, which always
use 64B CQEs. The reason I added the check in the clean loop is because
that loop walks every ring slot, so with 32B CQEs it can land on the second
half of an extended CQE, where bit 52 isn't the SRQ bit (it's undefined) and
reading offset 40 would run into the next slot (or past the end of the ring).
The poll path always skips the extension slot, so it doesn't have this problem.

Thanks,
Jake

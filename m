Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827168;
	b=VVYKRUbtRn/m9NC/Z2h5LAFKVl7xctPkIXGOkKa24QopSP/OEoQesgHybSXAKNt4NfY6
	 t7LSbrRWBIXJ4OmTk/Wh7wqj/Gq1gH0VBB05vY0NMSzxLGehzwd/U6R6jagqvfaPQqLxu
	 usqND58ZUgGysK3OAHF7SVN8Lv/7GkXc00veKrcFPW5glG5tXiWJBvaaQDgPzOOraNp0F
	 OnIQbA5h3fWQeEQ4dTCve82qX5AlwJYWMYwmkv/eyCoYnPweCrJ+5xaEPyCC83445v0Oc
	 bZirOoK3ZoG4SIIhY3x56GVViTjb3z2aCxPvmchqXJ/cdirPysgioMIJJx2ory+Zp0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827168;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jBFvhWGdG0n9425aZ4hG92c7FJsVRkXSALMLUsSU4XQ=;
	b=jfuj+xsR0MZmDQG8J9CGnFkQeIhL1gIQGYaba13jQ5MIf+iY2zEkTAB9kqEhvuA80X1B
	 RIT6lR+kzjfslDdnZm6a7YIikRRl7XYIXKmBCe0ZsceQfF0z7MXGxCItjQHyLp1r/+LsW
	 8jRGew0qzovOtaCufr7YiFHLd61uKYj5Aw/nlMRGr7ga+/4KJhUM22Desdb24OzCRz4S4
	 9xoTuXRdcwLCCXpXUTBQjAuoh3A8x0dV+K2KqNy7oWqX+afEo8p68xJezjYWvD3p1cAor
	 FMRlkzx+JtskuodVEpf8uqju7X5QqWijJ+YldO/LTJviTSWy39YGGZgapMY/UxAQYIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxN8p+wj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C16606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxN8p+wj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA351F01825;
	Sat, 24 Oct 2026 07:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827167;
	bh=jBFvhWGdG0n9425aZ4hG92c7FJsVRkXSALMLUsSU4XQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RxN8p+wjoFs4Vk4gI1pXV2uuK3BveAIPZqYIKbn1Ng34P8YoOytGHupXsovOddDAD
	 kyb9dITUAp9op+4WOU9zaQWaCtMJVivTHrFa3ek/yFcgDge8rUNI2UUWf0EH6yWOVy
	 5eb16TAwg3l8E4xKa5ptorzhbcZ2uD5v5UT+5wpCemurg6g3p8s8C6NJJilXVt+Nbk
	 LcZrjVy/ybizSSF2f1lPG9ZRegFXyj71abUkvkefq8+qJp8AG7aj1iqr7gWGj7MAlF
	 31QrMVW7JlrtA9lPw5ywclZNOxyyOoS86XXLVY9BiyToWNa+wbGsndvgzzVHVhTLcX
	 cLvO+wQ6k9N/g==
Message-ID: <sashiko-outbox-183585@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/7] RDMA/zrdma: Add core data structures and ABI
 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-3-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-3-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:32:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/zrdma: missing WITH Linux-syscall-note in UAPI zrdma_abi.h SPD=
X header
--

commit c85ffe470e05337ffcff385d3797e8a504257235
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add core data structures and ABI definitions

This patch adds core data structures, hardware control structures, and
user-space ABI definitions for the ZTE DingHai RDMA driver.

> diff --git a/include/uapi/rdma/zrdma_abi.h b/include/uapi/rdma/zrdma_abi.h
> new file mode 100644
> index 0000000000000..6686a02f77a32
> --- /dev/null
> +++ b/include/uapi/rdma/zrdma_abi.h
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

[Severity: Low]
Will this license header cause a build failure when installing or validating
exported user-space headers (such as via make headers_install)?

When scripts/headers_install.sh processes headers under include/uapi/, it
rejects gpl license identifiers that omit the syscall note exception:

    # SPDX-License-Identifier with GPL variants must have "WITH Linux-sysca=
ll-note"
    if [ -n "$(sed -n -e "/SPDX-License-Identifier:.*GPL-/{/WITH Linux-sysc=
all-note/!p}" $INFILE)" ]; then
        echo "error: $INFILE: missing \"WITH Linux-syscall-note\" for SPDX-=
License-Identifier" >&2
        exit 1
    fi

Should the first line of include/uapi/rdma/zrdma_abi.h instead be:

    /* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux=
-OpenIB) */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D2

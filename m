Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821743;
	b=nyvEtcTyrv+wA8hPsrkfsNK2Sa5T94DopfR+Bxh/rN8912ka7sdJm3+aDjqXm1IlVkzM
	 jRFk1a2ZsAT/HiMdddnpT8OMY7QVYStVWVjvgfgvPFUvDblL5NVu1j26lb47k1C0kyI4i
	 kTocnuYkJ84+JwnIIN56DxpPWv24XGotoyz3lbFJTOiiNB0xSHXkIGcYXX5DAah4LYyBV
	 kG3FUtSvTV6MbKgV72kMVQPaWWUlGozxAknsfajRADiIbNuZnWx6/MM57j0YK6WKGSqZm
	 A5g91VbCjmHF7UjiaQ2DPHnEJdtjHthrW6aDVjhqIOiUTT/jOg9qOIK9EqQGCIbrj7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821743;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Content-Type:
	 Content-Transfer-Encoding:Mime-Version:Subject:Message-Id:Date:To:
	 X-Mailer;
	bh=paETJkmd7hVUIIU/NOksg+AfrOYTAPYVxcMd61GEsos=;
	b=cq5pTVkQQl+7y5TSqb8S6lI7hF+XL1tBJWfJ6tq3gkdwEd31OlMIOreg89yMohXhR/d4
	 0wnQuH5IZbhIztGldmw+D4HbuSSxcq/RqvqmVbDVvGW2TBHtmHDwpJys7aanuDo7jsQN9
	 QFa4OarPgTlCPe9H2bUkTzRf9A4ifAqDVHBEJYerbZUrOs6SUV4SaEjOVJCqW9wy/zhC8
	 jdaeOV8w1B0xLWKeXbzHsNvXuniT2X6Edz1CCicKiImSSGZjWGwkB2TTC50Mb/HRBmfCY
	 b3/Gba8joBAuKGOZ0b8SsV+fe0+rW1i0d8ZnrONALuUlyKHzgawXjpZ9f5MaPl99CrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k9OsnB7A;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A55607608F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 19:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76A55607608F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k9OsnB7A
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso5378195e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 11:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793821742; x=1794426542; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :content-type:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=paETJkmd7hVUIIU/NOksg+AfrOYTAPYVxcMd61GEsos=;
        b=k9OsnB7A3XndcOfKeUs4S/h/WtiBLvQaLlbGPwLPWMUTfH3K1tjff4gbvDE/9odh6O
         jB8VOsYPmUMa5yjEhU6AOxPl2PE1YzufadwDv+hymh7C2HOz+SXbZxuy7yYoaRLtAP7e
         2iR0tpW6Nuz69LCEzSIx3oATEdmxre8rC4tEpveYX0cbazwxSvwdfD+mc9iVPYqgJaAA
         oVp5ht8KjC+9j68otiLVzFnOKOb5uF+yoS0CsnsGqw/QueB3oJaIRrkdsdKeOT8oj6Km
         hDl90/v1jjIDb0eu/lrXsPngRH0C3S1cabYpfegy+9IzapwH90Ji310XV7W/aESWU0C1
         H/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821742; x=1794426542;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :content-type:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=paETJkmd7hVUIIU/NOksg+AfrOYTAPYVxcMd61GEsos=;
        b=ExR3VxEtdoAU9WDW3PRag16gQLBOCZS4Iyklcma4CjKmuewdSjluSXvGpPseHFAIhj
         EtbbAlU+nVevYHUQD0CkRVmVYXVOEWtE5KjE7BO7yxp9tQzfNo+AIihFBq4ROpiHaaw0
         oif68IVVLoqToLuukmDWqjDxVpq9QcdO3V06mfnnO+jBvrpOUSJe1BK0JayJ7sLNdT7t
         50KCnrFhopLYGt6WXInX/kdD/gRbFI8UNY7kuDO6h6LB8CFPtBuK8ABmV3tPt/2ykOeE
         4rPXeTZnI/Cyv6hD2ZZeGsLztnq9P6xaGsJwDV7knl4jgPu+sK1R/KeYwtY1TKDouN9v
         ohfg==
X-Gm-Message-State: APuU4Z+u05RL9JuvhgDXUaiWmkI1d/RBNE0wuBKWOZ39gaHAidXifMU0
	F/RkvgeToxu++WkTNMyetXy6y05j4MVgo50nonjt6rafh1Q+noU6QDBrwIUc4ZJX
X-Gm-Gg: AYBFou3ja6qsa/R8opSuhnltdgULdtzyQcKEdwONsKJdlFlPoA0m7cV8nSvMS5nITtc
	xgDx2E09DV5yrMBgP9383QvIZMVTV1gWYjRe1XRCKZikCS3WwVeNmxUahO3aHSYefM8NteChxkT
	qMuGeqBZ8KvjsHEwM1clgP7gtlEhHhzFa4eTHeaej0IOTshcuforkl9zPoz+rmgDcNGVdnC0AOM
	xBuge1t2W0sPw+YnTKFQx2ErhX919457dvCjNUO2ygx0Vt/ivabB55feRGTd6zLUcZjXzavYhVR
	2Dq0F1dh1Kl2ftESpHRWKd5th84V2brZ+gZBBcAQO+75B4YxCLJ3L/lqO2R/mqDKz81vOFF+wjF
	z1NzfcE27PL0Tbl8OPu5MCyVx2yQ9NFez+vhGwiDIhhKhLQi8AuuBJsQUvd8vebWADW1fEN6zcw
	6St+fqxGt9oG3zgezalnIw6j74Ahc40zvXlb5wc/9HxTACfILa6/b1gUO0Fw5In5sKfpSRmZKAe
	6xMXmQb1Wmr7WwBJFJpa9Ksk7v0YMD7ivIYkbjRLXJiGMUS05UN7jxCAdHHmu/lQGiOwIL2xw8U
	R032okhJ1dLo8+xiqyQb5FntDXxUJzGbDcNMNibs4dO9wNG/roDnVRNJGtKxy8RUQyE8jrNV5GV
	nnmhsGtcgSTF0JIgeqw9N3itlDRNT4HLQXsvPGBXqLVUJ9Q==
X-Received: by 2002:a05:600c:c4b8:b0:4a0:1b14:e283 with SMTP id 5b1f17b1804b1-4ac150b38dbmr398866575e9.1.1793821741495;
        Wed, 04 Nov 2026 11:49:01 -0800 (PST)
Received: from smtpclient.apple (ipservice-092-209-235-033.092.209.pools.vodafone-ip.de. [92.209.235.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed08514fsm5424639f8f.31.2026.11.04.11.49.01
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 11:49:01 -0800 (PST)
From: Dezhen Lu <dinadegttyarenko6@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: tests: explicit GID index zero is replaced by the configured index
Message-Id: <AD62C4CB-E5ED-41C1-8CBD-110BFEBC87EA@gmail.com>
Date: Wed, 4 Nov 2026 20:48:50 +0100
To: linux-rdma@vger.kernel.org
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hello,

At rdma-core master a70151dfec390eb5f7fc5b266f51d601da2a7778,
RDMATestCase.__init__ uses a truth-value check to choose between the
gid_index argument and the configured GID. GID index 0 is valid, but an
explicit argument of 0 is replaced by the configured value. The same
constructor correctly treats a non-None gid_index as explicit when it
sets gid_type, so the resulting index and selection mode can disagree.

This reproducer needs an in-place pyverbs build but does not access RDMA
hardware. Run it from the repository root:

```sh
PYTHONPATH=3Dbuild/python:tests python3 - <<'PY'
import sys
from unittest.mock import patch

sys.path.append(sys.path.pop(0))  # Prefer the built pyverbs over the =
source directory.
from tests.base import RDMATestCase

config =3D {'dev': None, 'port': 1, 'gid': 7}
with patch('tests.base.parser.get_config', return_value=3Dconfig):
    case =3D RDMATestCase(gid_index=3D0, gid_type=3D2)
print('gid_index:', case.gid_index, 'gid_type:', case.gid_type)
PY
```

Observed: gid_index: 7 gid_type: None
Expected: gid_index: 0 gid_type: None

Checking `gid_index is not None` instead of its truth value preserves an
explicit zero while retaining the existing fallback for None. Regression
tests for zero, None, and a nonzero argument fail on the base only for
zero and pass with that change. I reproduced this on Linux aarch64 with
Python 3.12. No network or GPU traffic was run for this comparison.


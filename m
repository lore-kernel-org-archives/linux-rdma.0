Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2D019D8AC
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 01:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787104108; cv=none; b=UHWX9qRFAn9gXq+HLzGVlzOHZlE6cxAXyj03vvCTwqThGPkjknv5lnOg8+1WASO/TTO8Wftb7BzPqjn1FupFPiUEWtVTxGYpe0q+A5IvjUOhEOlEpQGyFcXCaXRw4nDjR/V0XufAY7gBQ3KNbwPF/8e2bSkOPZvm8LnV1/QRgSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787104108; c=relaxed/simple;
	bh=7zDtK1+SZ1zwQMNGkR53n6SIlbE7b0OVVJ8QZq0aRRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yfv/UraPmX0DNzapvzVm2q19Od45r2wz2Y6cnfhm4Zoy0serEBkcceUZk9PRqFbNhKfZ5S/2p8Vj+Jj7nsVgMOqK4a4BwGqeTq7cqc+62kgww3YBHrSJohuxe2WcrneQ/LOUVmDzS6QXHOoDRUUHBGJD8c1zZj/dfNGw9D3cf3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=wQkjyuPy; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="wQkjyuPy"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8485ef63b68so470220b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 18:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787104106; x=1787708906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=siuYPloOqsDQiXuJrGNEWodYtqI8v97Pc5mC2E0cvrM=;
        b=wQkjyuPy1wsE50PrHHezZqXeY9ZNaX3VyfHLTQNdajIkY7nTn89OVj1tj/fiF3wEv3
         +Dps52Xdl1nOdTCdv+ixU6afPmx/NfXz6uu/KGL1/3l0mG4ORjqbqrAMGqt035J+ziiH
         SVu19m/zwGp79t1AFgvxU8RsW0z2s0jOKuUmMrVaBIrkUNiEpkafVHlHSwGSMSG8hVtc
         U5yKa7gAo/t7HFUQE5zoxY/zE5ZitYHp9jvK0BF5yEL5r27vwlcO6F7sMsCNXzze57f5
         O6MeACgbVoCWI37SN6Jon3f7DYpaPyjRV7Ol4B7meue23q/7XkUD3VgIn0fvku+Q6wim
         HgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787104106; x=1787708906;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siuYPloOqsDQiXuJrGNEWodYtqI8v97Pc5mC2E0cvrM=;
        b=d6yip4VGUZaREx5MgVgF7EpfwpozolRDAsOm+uM8H+ZJtXF+7Ylt09YsczF1YSLSy0
         S8iZmFv+mnxCBQgOLHwTgbSunzccvWeOvHtpKAembMn2Vd+2cUOx/2Fpsom+qOayNSaA
         WgdEu1ZSKW0MTjv6Krlk4edtZUzLLpSaXYlUdPjz68Tvjz0I7LDHgzOVYh8/6qCC9B4C
         iQG27UrRcdiJwEHRJveM8V6NqFx7ZJT/EWbH0hwY87odpk5JLZkXJtAL6wfdWV5s3go1
         bBGocWHwmJ/MlrVSLaVkmKjD597Kw3fSsdzCHkdjMrEgoAb/jxhiBU37bahEj4IwjmoM
         URkw==
X-Gm-Message-State: AOJu0YyksnjnZpAO7fGRbULWgUfwxaKn7NvqBeVLrE5/E8e/JQk/lDrF
	nCJi8+hh4ts2i1fNN4+55PRuBX6/839GFO8tynhU3iVg+81jyjkx9OXKViULEXitj4t3/0UQyQZ
	72deXCGc=
X-Gm-Gg: AR+sD12BpCiit2NOSulNx3jXoT/0t+BcdPN44NifkAIR18nsvDWICPNT/nR9PvVgTil
	Yku7GyZNvgfKMLrNaCL45AWC+I2trx87KQDl6nquKxM1c/Cu4ZFmhudRM71YDED8PliiJ0yJ4a4
	wiXcFl+BVc+RnA//DqSjOsQgWLfdZJ/o9O+Nv/Q8Xy77U20EQYUgfECJP/W3+AmTJd1e5FQ5ai5
	BX3Wgc5/w1QWwdlnoxN5YvR/TI1kqVCX662JV19eggGv0F6smWa7z3X96J5Ar6W5rrDq6ZwA0Kf
	P3bRLgPlt1iK9kVMBxaWGB5qeeKiD5OG0Kb1SnqgaXWPYGJDnf4R+qu5Exeu79dgJ9Y5AIT0N3S
	R2WZEdvH9SX07Ho5I/GpZBXItLpAxDn0Z0iKF0Zttfq7BHD3+vAyUDdNx5+fG6dWpBJvqlnJjAT
	mSIvu/WQCBrZE07gZWedAqBWvZq7XkIgwOksdnTnuzu7y4SWd0Au4slB6Cu6aO3p2lLlBnFfqBu
	oj28Lc=
X-Received: by 2002:a05:6a00:3a07:b0:84e:2382:f4f0 with SMTP id d2e1a72fcca58-851d36d2909mr1516620b3a.4.1787104105938;
        Tue, 18 Aug 2026 18:48:25 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d33a5b72sm79345b3a.23.2026.08.18.18.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:48:25 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: bvanassche@acm.org
Cc: linux-rdma@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Wed, 19 Aug 2026 10:48:15 +0900
Message-ID: <20260819014815.642500-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 8/18/26 9:26 AM, Bart Van Assche wrote:
> This patch introduces a race condition because it associates a single
> CQE data structure with multiple concurrently submitted work requests.

Thanks for looking at this.

struct ib_cqe holds one member.  After this patch ch->reg_cqe.done and
ch->inv_cqe.done are written only in srp_create_ch_ib(), either before
the first QP exists or after srp_destroy_qp() has drained and destroyed
the previous one, and both writes store the same value every time.
srp_handle_qp_err() finds the channel through cq->cq_context, so neither
handler reads the cqe back.

The sharing is not new: one command posts up to mr_per_cmd REG_MR work
requests, all carrying &req->reg_cqe.  ib_srpt shares ch->zw_cqe the
same way this patch shares ch->reg_cqe.  Could you point at the two work
requests you have in mind?

One thing does get worse: "for CQE %p" in srp_handle_qp_err() used to
differ per request and now takes one of two values per channel.

If a completion has to identify its work request here, I accept that and
will drop patch 1.  Should patch 2 then carry Cc: stable?  Patch 1 is
the one tagged now.

Best regards,

Yehyeong Lee

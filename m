Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D163F3B636A
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 12:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476960; cv=pass; b=uRwreKgkBb3uIgl/rOJSvVVqEIEWnEy3uB2XH8h9h6G9fAdJMRaZbk89WZ90k5E2gv06Y/M6byjAzTLcAjAyNOfskmzoyyHnWPhlMB2V/0iQ0r946/7NOvmMsB149I8Spve+JTRclXBelc25ISglaBLbthYiTH9tYSle8Ul8ADM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476960; c=relaxed/simple;
	bh=CdBbkIBqVKxeI71vx/Dz3+9WRVTRjIiopj4MAwT/5GE=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=P/ZUY4PhcW5ZylLBml84IDk7Bp7wzWyk+M7NqWoiZrFgSKzHZIZ7vbbm0Ue3696gtmT6vqQjo6up3+V4fPok1DO3ix+2yDKeQm9kQzobgpIuzPgnY9YgoVuo2X+yLLf9g4YAYOJFGz+5RJcibFCnLr/B01SezhrfQ02h75kuwqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsIHs+Ly; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsIHs+Ly"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e69b9e16aso30423815e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 05:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789476957; cv=none;
        d=google.com; s=arc-20260327;
        b=MQiYAlXyAXwMjp1Y3a8lGSwC36DX9g7OG4bv6oNpHMqxO/UrBQTur1DXKcZb0TrsZg
         PbDUBEYtpCEQVVdzcuGbOgZldN1/2u1e1pVOvrjOzpyf05JPmk8cIsZd83tXo602A+0N
         AajsGeb0lcCkq1/wHUatLn6chFkSrAMgozlLqrdD1WJUspfXL1tT18Dt+i8wjoj1UIpf
         hWDX8jPoWK3OFGKOTZcP8u7RH/c7SXkArVmeTQrrJES3RsXzK/zu5MQLEfq9t/AC6XOx
         gib5Isx2JCJK3Es766kOvG4YNljvZVnly3X5tlJZ4MkwzD/0MhTzDnAJiyMKERvUZNM2
         jeFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:from:dkim-signature;
        bh=Puf1RZTdDJ+Dg7d7Nn8IYz0uQSM2sFuuww6f3wGYaWg=;
        fh=E+s+aqt3CW+GFcMggQ0yXuawKWevpRsOU8mS2w2vsJM=;
        b=IdykeeeK+Q7TlgL8VyyPHdJbJfgVa6WCPEUcb/iZJxAhZU5DbyvsfYpXE4glYiXF/6
         4CwX9CxGiSAwDj325vJb0c/f+XuqpP6/x0UojKnSUj8Cm9Ijc+U95FmShXr4UDlHyM6H
         ZuippNog/z+WOKhlJxPXo0curVJH+BqiDD0igWYqOAdEenquFoTSV7B5uizBoSzVFp4q
         cCSO3wH1MIo+NkEBxigedJo/CF0LE2CEwkrxawezucKOZToPbF6pIgHQ65IE15Ij8s47
         SqNQVgIlyposYdfHfjgBc6fRU2hX/YC0ju+08LmM/hMjWW0ZlDbKIpkLuS8B/ubQRmjA
         5Z2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476957; x=1790081757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Puf1RZTdDJ+Dg7d7Nn8IYz0uQSM2sFuuww6f3wGYaWg=;
        b=OsIHs+Lyk0OCtSvBcnF++EkHPdIdV8fsTGQZhWiULXvVKhIhWLZW2zmH2ToLl49Hfl
         tEubgyuvWPXtSHhaSk3v46SGk7TEyhP5FYExm6pxWKZFGRHPGqOLjICiYb/9C+mBtKCG
         XmK/+dkW7iWj1t+pLyE3YPF2xsIoNNgdZAyx+7Pa5+KiSNkSfMpLlvcxEOYF0bSO3BCJ
         r1KnISxrB6u1366jyviVgK8hOSSsBcayaN84/RjJsgjdIlM3VqjHQyUpcsGtRudaXcMq
         zAhv4ArZLvzm2TwfZ6BCxVz1+1Jpf8XTwNEvu80YtiSiuKvItc99uaRUZmv9O5O12OMk
         i6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476957; x=1790081757;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Puf1RZTdDJ+Dg7d7Nn8IYz0uQSM2sFuuww6f3wGYaWg=;
        b=dqNC8YauZ7+vTBpnyilByGF5gDu1cH+QnVrFdAd+qjssg7ZNZWb6GHd5IbWAPhPPcN
         V51CXBVfBjqTOdp+ie6IrPvDA1lp+DqXdw+mOPhY3aE7XnDHXHepkkZcjpM90uWZq4xx
         y4qbpgxKg9k2+Mm0bB4tcC7xVOvbCNVubCO/rJVhM5H07D3RC2E/FEoLTpOKhH+rd3dN
         MCUEPT2rkCl4bcb5HmvF4z2m8XL60RSFspbqNuxGgqkHWYTgHti8NxMexa4077uBEptD
         OKTEuPacE28zNSu4vXoC3tr9ag1He55Di58RR+FaH0wG0gNV+rFzKBcesOBDOIsYsOL9
         bmvQ==
X-Gm-Message-State: AFuF++mDmupBdBlKr5ZDn6EeWPfDRWu4hm7EfwUGyRgSE7OvBwY2N6Dg
	DB5YSTsGu++0gNhp3KffeQqAyKVxNNPmbjkueiD83eUhTQCDIA6TnbhzrGmA4vsG1q9K4Ik9ph7
	bfpipLH1wb3jOag9779zdX0YFk2injg7Wfyge8RbWKmT3
X-Gm-Gg: AYBFou29M007NeIv8y5sFFy0uGb8webh+0nUlvT8xQS3WkHh+IH72Z6aHf0P0/0Ye51
	mfGTCSbTFYaGaOa+omQXxumZBzPvFjL82MtD35tFSUg+o5JTQ+HS+Swtzfra1SwyaPjWlcur9UN
	nSCVHlQGedgJ0+fe9AwyX7G1sKurPBCVPZt8/28fkFG8XtOfdxRjJJ4oLkfCwBUxi36Ve/GNeov
	NhvkTeuId62iDW4YCidR/NvpqDoOA+OGTWyKmEDlFBWy1xuRIxtpgSqkUrwfKDxv+c6CmJPLp5N
	Oi2Ny9mFm6x48OoQC4eu+/LWgK5dkrOK++NxTLkeQNUvdIV9BhuVpw==
X-Received: by 2002:a05:600c:4ecc:b0:499:7219:122f with SMTP id
 5b1f17b1804b1-49e7a662f2emr77694805e9.4.1789476957128; Tue, 15 Sep 2026
 05:55:57 -0700 (PDT)
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 07:55:56 -0500
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 07:55:56 -0500
From: Ruslan Vagner <rusya92266@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 15 Sep 2026 07:55:56 -0500
X-Gm-Features: AcwNN1XrR4tTECknv7knmCE1lUXsR8CQZ0dE7ck6tLh4yRK9gQ-J8zLqQb_ozpw
Message-ID: <CAF9RqJ66ApKFeMwr59AYXHpDO2FOL=NCuvG=q3NaTxR4yEg1NQ@mail.gmail.com>
Subject: [PATCH] RDMA/qedr: fix comment typo in verbs.c
To: linux-rdma@vger.kernel.org
Cc: jgg@nvidia.com, leonro@nvidia.com, Ruslan Vagner <rusya92266@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fix the spelling in comments. No functional change.

Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c
b/drivers/infiniband/hw/qedr/verbs.c
index 012a0ab98d6b..973d0fa7cdce 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1075,7 +1075,7 @@ int qedr_destroy_cq(struct ib_cq *ibcq, struct
ib_udata *udata)
 	/* We don't want the IRQ handler to handle a non-existing CQ so we
 	 * wait until all CNQ interrupts, if any, are received. This will always
 	 * happen and will always happen very fast. If not, then a serious error
-	 * has occured. That is why we can use a long delay.
+	 * has occurred. That is why we can use a long delay.
 	 * We spin for a short time so we don=E2=80=99t lose time on context swit=
ching
 	 * in case all the completions are handled in that span. Otherwise
 	 * we sleep for a while and check again. Since the CNQ may be
--=20
2.54.0.windows.1

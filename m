Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4190304BB2
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 06:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787034289; cv=none; b=tHFV77bVZtBUAK+HWeNgCRIkZPmYGLngGui/1saJLwQDiW9f2CZWb6naAUqg558kt+31bf053rVR6Xn8sbVYDQAg0LSQsMKLDO+5yzpKasC1O2/8L5p0t3OW0JLuRhFwgQTeVJi/KSXrOkaOED6kGYGk976LRPQGSSWOEwwPucw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787034289; c=relaxed/simple;
	bh=x3ovj+sDMCzZqo9XZnGFKTcxKIf1dNFL9CSWC6MOows=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYXrxg34YyIatpGYg/SoXBEgcGv3Uqqe0SddQ6GSy9+G2eLzo4r2yEDqPpIwpFm1V2KnTjuToxv1tjAHqqgGVFbeo0L7WCW18anJlSc1LD7yMfi2oCXaUeB8MLsHv70/TS6sNeFfyVzMa42vqSxgq5YRh5A8k41IMhtpm2u3UKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=XviQVh+h; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="XviQVh+h"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca80d708489so510842a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 23:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787034285; x=1787639085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ccqE1CLIMERTXZobkPMubAnoPIP549GphIc/Y5+QbnA=;
        b=XviQVh+hvbrNNkNXYs+tFc7P2ILRCCttcawkS8pYEL5vcnXsXpn2mlvrR+auprNkJ5
         hx47b2KlEn2QU6shM0acg+cpvwxVErR4SoumdayNkaR+96399zrjGSLp9KtRVGrsYADK
         C/LCcEowyZm3ymvuQoh8TwdDHcMPcuSnNxLq+bjxJs5qhWJiiUIWd/l84oRM9f8V6XRc
         RRlN+4B+lK/atj2UIkML2XjgKGlQR8SNTgICeuS9/KZc7Cr+183eY85tAZNwkCHJgKDH
         AsuORQitXj2a4I5pOU4iULCMz5X2OYZ6EKlueYttAiebRnrjUg63lTbeBGLgt2E2lAse
         JuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787034285; x=1787639085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ccqE1CLIMERTXZobkPMubAnoPIP549GphIc/Y5+QbnA=;
        b=T8DmT6x/GOQf1eqOL6GHIxuMFT4LLuTx5g7ulwWh38JC/cXfKU3Y4PoqpW8UI7ZtqJ
         6dgtnQF+s7oTMEM14tmh+h42qSxRFiyGGSwiJpEnLZp/c8hDFXAOxwxUMta9i3mIyQNN
         lAQf1/aCzvXjKdzhDriaOhJiy/6BrSmf4WkNIAPBAjJ0lxI4VJtbHHxEGEdSFaJ8PtPX
         dXcG+oBqmcXPu9C6OeJxKhihuJg+eISOtan0KzwIckYT4yOsefQUKSylz5VfMhg0q0nD
         wymwnQH9GckvZB0mUCWO4lItXGBf8sEf6LzeDYozm8x/woGUBfJik3DLbYGUz+iFRUKA
         m1bg==
X-Forwarded-Encrypted: i=1; AHgh+Rpyuj/M9elQtC/y3FEC4qamG8QivDeyib6P3XEmB+OuNmrvRnUWIL3qZnd78KWx/Zcgot1cVvNiYIwQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz50nUx1th5artgnLgAogVii7X8UIywV1h/WbWepYD0a/08mHb0
	cpQMmKp3qcpX35JkEFVWEB9eQSukxzzA8elZYdslZrti9Yl2JwS+OBv6ZVFmvJyQnyvlYeu8S3H
	euVjS5PQ=
X-Gm-Gg: AR+sD118QSUwm/9DJ4hUsfWVfJSYVaSvMpLHrSylcMtIbHbhA3KDJhzykw7515oDO5J
	vLaHFIDgoW2mWMZNZCB/1Ln6dXQWDEAU1pjSnY0BbAkqZbUoegLj2RIuu7CYCqvnFoIAqR7jjqu
	2BhU3SPtybW8nahk2+mO8ZNrjttR32u4fBYISS0VikFJbshT//wt2XHRZraoewOP+5Brc/FcEi/
	d47RcG402rgR+C7Gy2OBQGjSF6bYN/BjSMgdfme1O2nZ8fDwUaRxdCyNGazRvGdmZxe71dCW5rl
	dJNDroIxL1u/DWlWZVD8pX0KhC/RtVY97Q/RJQdXZC6aVOA3a2mPNlK4is5Gm21EyPyuNKzdRP+
	z9ALWa8llGQjUC4+gjFO617pZKSuPPeRNVi/+KpmgUiRy5ADRPYOLdfNsELeTJjJRXJdyD03nsn
	Vay15ovUGaiSUyWjtCUZHF6OkcUx40xR5LZWRmggAGuE1rR7Fde9d8dgTM7i7lZYy0hMzN
X-Received: by 2002:a17:90b:2e42:b0:38f:657:6823 with SMTP id 98e67ed59e1d1-395638b424amr2843053a91.8.1787034284883;
        Mon, 17 Aug 2026 23:24:44 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d3b4383sm4760493a91.15.2026.08.17.23.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:24:44 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	mgurtovoy@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dledford@redhat.com
Subject: Re: [PATCH] IB/iser: skip an unregistered direction on remote invalidation
Date: Tue, 18 Aug 2026 15:24:25 +0900
Message-ID: <20260818062425.568046-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814054712.260495-1-yhlee@isslab.korea.ac.kr>
References: <20260814054712.260495-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AI review on this patch asks two things: whether a bogus remote
invalidation is now silently accepted, and whether that desynchronises
the MR state.  The first is true by design; the second does not happen.

need_inval lives in the ib_mr inside struct iser_fr_desc
(iscsi_iser.h:320 and :333).  With no descriptor there is no flag to
clear, and the cleanup path already returns early on the same condition
this patch adds - iser_unreg_mem_fastreg() at iser_memory.c:156.  A
need_inval left true is cleared by the next registration, which posts
LOCAL_INV ahead of the registration work request (iser_memory.c:316).
The state that would be wrong is need_inval false with a live MR, and
skipping never clears it.

With the default always_register, desc is NULL only for a write sent
entirely as immediate data (iser_memory.c:364, iser_initiator.c:105),
and that path advertises no stag (iser_initiator.c:116), so a conforming
target has nothing to invalidate for such a task.  Returning an error
would fail the whole connection (iser_initiator.c:657).

Two corrections to what I wrote earlier.  The claim that returning an
error would break a bidirectional command, which I made under the ---
and again in a follow-up note, is wrong: ISCSI_FLAG_CMD_READ and
ISCSI_FLAG_CMD_WRITE are set in one if/else in libiscsi.c:368-417, so
they cannot both be set.  And the eight-versus-132 and ten-versus-three
counts in that note were each from a single run; two other runs of the
error-returning build saw three invalidations and no rejections.

Best regards,

Yehyeong Lee

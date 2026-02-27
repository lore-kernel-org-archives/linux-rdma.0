Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39609438FFF
	for <linux-rdma@vger.kernel.org>; Fri, 27 Feb 2026 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772206068; cv=none; b=dm2CF5s82cFBsHmUsjtaex0VZzolCagw8vsSsqcVSWXajqUU5cDaeURxSDBay9J+IbVgnNoktZV/k8qQSeYr/2B6YPl/5nZXpOssHQuSihOMSbME5u09xmSzmxsaPCme74oDxvySf2U4TSXAbL5bxdNQfNUPWeGgj3Y8bE5jzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772206068; c=relaxed/simple;
	bh=Oq5H/m7659mfqHzq0YL+fXocsEMiL/ehoDueRF1Conw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qEjrv0o+t6O21QdshDUAFtGjiDSlB9FmbGqMwCguleQWOHgvNPZTUCLo7rRX/xbpXk1MUeo8uuP0amr/Bu3/RIbPW62DVwNlzS4c5teaKbNQlCIj0E3Zn0l5hkxNXGr5UnX1DDg1ffW3wstcXwuE09nfgjyVAMFLHhcVYGnjKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=spS3oGrw; arc=none smtp.client-ip=74.125.224.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spS3oGrw"
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-64c9d15b682so3165146d50.1
        for <linux-rdma@vger.kernel.org>; Fri, 27 Feb 2026 07:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772206065; x=1772810865; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vl9ptpdI16Bezq9h1W/l2A4FgvWIIIKYAlTzGTIYkX8=;
        b=spS3oGrwwt+1JtFfugRs8fIJ+7hiF1I3INpzHRrKbRttuOicMURB7Il1Qqh4A6nfe7
         vT7NhLG/jYxTKLtfi7ID5sYkyQKbr7WD10Cp0R/hy82MwwaBiotoT5y/WL2MnQugfzez
         upnZuupOPwNwdTO+uZyw73P9Zrf7iTwdB2m4cP8P5KXse2j/TlPIHWJaidYia9zqYfD+
         mnC5QK5R6LMrobcYWCcvsr1z79t1Y85VqUarIcgw00V68d41aJILlWItLrlrhb0wKO1i
         ATirZrL9pdFqC18RxZO52t/iSHBJQ61tI1wami8BItRYQZAKtcW3p9EOcD9dilx0he7v
         tIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772206065; x=1772810865;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vl9ptpdI16Bezq9h1W/l2A4FgvWIIIKYAlTzGTIYkX8=;
        b=auRNSRDaD7lgXVHN+0cnxuNy8WS0RdI/jWI79CIO0VLQgza/MraW4qyT7jwKiz5+jB
         SPkttfsj6am+6Dh+7SHnaT1b6uut2vFU1mRX6kI3Lmhm/m3YKm8EPGPck2NrRvDvQIKe
         r8977coanKgzrHFfu3Y4vYkjWAQit9KyLxGm6fB8HBmPhofRWpy7wKW3rNkNqEKA+J7a
         VevCRD0Uwg08Sv/5kFMNE6uw062wMLuFron/8JEsfMujYVPC4TAY9/sEgPpte0uo0Q7l
         sT4KngMtENguwh6EjnJzdMfNbTBf78KlL6bYUTq/GnSSnqAqGyNuyb2red2qX8HnThLS
         nNuA==
X-Gm-Message-State: AOJu0YxTZjIaqxMuJq015T+vWIydjhwGI179Q6R+m/lvuazXKR8VWlT0
	nHUqdkqOMVliFaSWsiCIXizd/Xm31ts/CCY/OzaeufNBVSCD2m3lThbSamboTFDWeY3xDclW0OK
	PZ1+2UnQRNA==
X-Received: from yxjo1.prod.google.com ([2002:a53:a101:0:b0:64c:257a:c62f])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a53:d009:0:b0:64c:9797:b188
 with SMTP id 956f58d0204a3-64cc20e640cmr3134115d50.37.1772206064992; Fri, 27
 Feb 2026 07:27:44 -0800 (PST)
Date: Fri, 27 Feb 2026 15:27:43 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227152743.1183388-1-jmoroni@google.com>
Subject: [PATCH] RDMA/irdma: Fix double free related to rereg_user_mr
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, krzysztof.czurylo@intel.com, jgg@ziepe.ca, 
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

If IB_MR_REREG_TRANS is set during rereg_user_mr, the
umem will be released and a new one will be allocated
in irdma_rereg_mr_trans. If any step of irdma_rereg_mr_trans
fails after the new umem is allocated, it releases the umem,
but does not set iwmr->region to NULL. The problem is that
this failure is propagated to the user, who will then call
ibv_dereg_mr (as they should). Then, the dereg_mr path will
see a non-NULL umem and attempt to call ib_umem_release again.

Fix this by setting iwmr->region to NULL after ib_umem_release.

Fixed: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 15af53237..b39174b4b 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3723,6 +3723,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr *iwmr, u64 start, u64 len,
 
 err:
 	ib_umem_release(region);
+	iwmr->region = NULL;
 	return err;
 }
 
-- 
2.53.0.473.g4a7958ca14-goog


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795874921;
	b=2xOhIhkPjzgBWl+lIiqmuYxg6Hv7xC4S/4sJD0IEtltBTpVJjCk+hqVMR6XzbsfOH3Rx
	 0uNIQEnlQ410N1Ppb7VtpctcA6AhxG3H4QvlPRAi3hKABXHpzthI+HhlJstZ9dF9eCgEI
	 Xf761Wt6ni23+JkeHMRYB0IYs5f8p0J9T90eWfvQVVZbg3k529URi3eYS1JZzYtWIKooI
	 fji/nIpSN9u89FXAgHloX/OvNdwNaK8WQtIRoVc5JtQ46wxpziXBqRkTZbwyaoNug968f
	 jLgb6P+jO+rh0NLlllo2GBrOhnFF8LEenE7jBrBlz09m53hwmGHaoHrTYmsYZwZfHQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874921;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fT1VNozeccmEI0oNEySMECfiot8WRdphib7347h8ODQ=;
	b=vgSq9wXg8aRaQ1x55lRfa5Lwulj5L8J/A5EpbYyvWsTp0CMt8UtXaIgZbEhLKNeshfeg
	 py6M+NLGqcf/GRsxLVg0S2q5fzD8zsG3V0oONXsY9hsht8942cz1RtdPMmUv7MsWw+8M8
	 v5zgTE2PCkh/J5Xadr9zXf2J+IIalpAby0a42bEFia3Lo1q7lI/+ZpF4k3of8OPBtYi8N
	 Cuxs/kVG6Iv99Zr5H+z9alm4gpuVc3tGTrGvAaXrONhvRVhpkU3iHWpKJOY5Z0U5aneWZ
	 ipLdU1imU0Cp/LEHhu5WXMM8rLWTJEYAC9nBBaK6igatOkpNeyTXGtagYt4GQcZr4eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=none smtp.mailfrom=stellman-greene.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HqoSBjTR;
	arc=none smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92699606A324
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:08:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92699606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HqoSBjTR
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67db23d8892so9469333d50.2
        for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 06:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795874920; x=1796479720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fT1VNozeccmEI0oNEySMECfiot8WRdphib7347h8ODQ=;
        b=HqoSBjTRfs1/o6L78Z4MTHialTqgMvBkR1O0fBtqicxV0bUIfGT1tEs0h1mE1amEhd
         2M3mq43r50Q5K+g/dWqYWEFVcpVhRrT0fR8BwMLqHKhRrILZyDJIE1c2NS5niSS4cygb
         KM8L3eXQ0mdTj/GXV8kVBRMdBdk59aoAvuO+Jr2d/Zt2EanNC2OVy2QyrVfNORGdyP1L
         srejzVGLPzgu/Sz99nMllbXAFvc9CYpQFk//GxOfKqQ9hEhU52QGvSjeOhIy7iUwiGaj
         p0dpQHi42AtZnECi2Pp9MFX22PMqnK3GGwpEOsf5gP7iEMYsKTVrB30jL9jOkOH/fGm8
         FuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795874920; x=1796479720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fT1VNozeccmEI0oNEySMECfiot8WRdphib7347h8ODQ=;
        b=ulHj5FVd1OimBxp9/1swRUDUWP7Ef4IiIh02TAh3CqF1U9SAEZrUAnWpZ/xvY4OEtk
         BqC1KY+oNK1S+i7QyFvBqQbNaRFh0xEtG3oQicDPjqFYVXRMy6smjU+dZyrgzKEQv8Cv
         XBBdjRtVIkZlnNGQmKKiZWlct0NrSi+Oh7POgPOG6bkpTh/n5Z/HqC78b6bV5vJkdZ1I
         ct0TQfAiEZr5n2OM6APz2sdpi8IsM5PrrUCXMzSSd97SOItVACpzDnGYjInmTZcnAP70
         Q8Cd0XOivgWw3M2GwDCiswCDQuBAvk01gvSaQgRLJQ2VjBplPibjYGhXakRf014EiKBT
         wzyg==
X-Forwarded-Encrypted: i=1; AL+hErFeiZBe/D2es1Y032BAEVPE9yt0MYXaBi9MmtdCqwnrfsJXasac5ek9hTC4lawfzc6yPlM5GnxGUVEO@vger.kernel.org
X-Gm-Message-State: APuU4Z/JanNDdwufDmXtJgfekDcp1rfnSCDDII1gRM4cwnrqVTlw4ZIB
	EJJ+xWwOIhi0uLDVhILsi1hXN4Y+/c1vxdCtMM+yX9jAP861hBwtwoX77DvlSUx8KQy6Wqpcpra
	TcIwh3hSuSg==
X-Gm-Gg: AZFdTZe+vSW0R+ae5ZUkJ5APXpnB3usittab/W+1uuKNWfNSxt2WgNKrp4AM4gX6CR6
	SvpWFE7Ssh3xyVYc3OCYPi64OTJz+ET71DvEjMG6oOGpKLnJb2NTK7gsAT4F55GfJ7cDUFbal3E
	PzCV5skWnUjws2jEBZ4NtCOItWEOIb1F/AWBUU8BJK3Qx5Rdaz3Fyc4OaTfZYjXs3YceAqlQFG+
	GtLvptl1+6NSFSb68gFok6r4fKn0T5LrvDA3LVuix8jkp6fO4712lrTpuB1bokoQWUTokrYbdWi
	mWYycFC2eCGar1e6EZ5JpqPzmVthonqM3GA5dDrYknYbDkq2qdX/rdZPNiNaIYnCvpPaRvem+Rr
	lZyOEbmAbhJM5VOHvIeyz4M2LKwmCuAB6KlFtjkjNUpVSPsIfx8ozOR+eKI5JO1Q+OJjEm62hnA
	mU6T/nqkgTg46PDhC5bO1hwnSFftOlB2nJ48B+l3NmKEQXooC1zPxxAfuggwgnSGFPOz33Mj8O6
	z0cwvPL/dmLGSk/zrA5bPRwmJcveJsQ9ChiuGAco8jN2PJ7CWPBqJrJNQ3Bq0EQwhon2FqErSJr
	slkKcGygoJoJ6X0cd5l30vPQDCBeGdEwxR8FUW8FYL72xk+rDLDrNXI72On2/6a7AaZAo/alOOa
	2Xw==
X-Received: by 2002:a05:690e:5d1:b0:679:afc8:9d1b with SMTP id 956f58d0204a3-67df449aa38mr9465934d50.95.1795874919733;
        Sat, 28 Nov 2026 06:08:39 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:a4e3:fb15:aef5:60c7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921787f6847sm103196806d6.30.2026.11.28.06.08.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 06:08:39 -0800 (PST)
From: Andrew Stellman <bugs@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Reject an MPA reply too short for the IRD/ORD block
Date: Sat, 28 Nov 2026 09:08:38 -0500
Message-ID: <20261128140838.58976-1-bugs@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Stellman <astellman@stellman-greene.com>

When a siw initiator uses enhanced connection setup (MPA v2),
siw_proc_mpareply() reads the IRD/ORD block from the reply's private
data without checking that the responder sent one. The responder
chooses the PD_Length of its reply.

With a PD_Length of 0 there is no private data buffer and siw
dereferences NULL:

  Unable to handle kernel paging request at virtual address dfff800000000000
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  Call trace:
   siw_cm_work_handler+0xfa8/0x1b5c (P)
   process_one_work+0x5cc/0xc90
   worker_thread+0x3ac/0xaa0
   kthread+0x36c/0x420
   ret_from_fork+0x10/0x20
  ---[ end trace 0000000000000000 ]---

With a PD_Length of 1 to 3, siw_cm_upcall() subtracts the 4 byte block
from the u8 private data length, and iw_cm copies 253 to 255 bytes from
a much smaller buffer. With PD_Length 2 (a 6-byte buffer):

  BUG: KASAN: slab-out-of-bounds in kmemdup_noprof+0x48/0x60
  Read of size 254 at addr ffff0000da924cc4 by task kworker/u32:3/179

  Call trace:
   kmemdup_noprof+0x48/0x60
   cm_event_handler+0x318/0x50c
   siw_cm_upcall+0x290/0x420
   siw_cm_work_handler+0xb84/0x1b5c
   process_one_work+0x5cc/0xc90
   worker_thread+0x3ac/0xaa0
   kthread+0x36c/0x420
   ret_from_fork+0x10/0x20

Fail the connection when an enhanced reply is shorter than the IRD/ORD
block, and only hide the block from the consumer when it is there. The
initiator now gets RDMA_CM_EVENT_REJECTED with -ECONNRESET for these
replies.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Opus 5.5 and
reviewed by me.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
Tested on arm64 QEMU with KASAN, built from rdma for-next 94e81a1f3ffa
sources applied to an older checkout (hence the version string). The
PD_Length 0 oops came after over-read reports in the same boot (hence
the B taint). Each reply's 20-byte MPA header was sent in five writes
and its private data one byte at a time. With this patch, PD_Length 0
to 3 and a reject with PD_Length 2 all gave RDMA_CM_EVENT_REJECTED with
-ECONNRESET and no KASAN report, and a valid enhanced reply still
established.
A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_cm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index ed49818793dde..0a0d91398e790 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -392,7 +392,8 @@ static int siw_cm_upcall(struct siw_cep *cep, enum iw_cm_event_type reason,
 			event.private_data = cep->mpa.pdata;
 
 			/* Hide MPA V2 IRD/ORD control */
-			if (cep->enhanced_rdma_conn_est) {
+			if (cep->enhanced_rdma_conn_est &&
+			    pd_len >= sizeof(struct mpa_v2_data)) {
 				event.private_data_len -=
 					sizeof(struct mpa_v2_data);
 				event.private_data +=
@@ -849,6 +850,14 @@ static int siw_proc_mpareply(struct siw_cep *cep)
 				      -ECONNRESET);
 			return -EINVAL;
 		}
+		if (be16_to_cpu(rep->params.pd_len) <
+		    sizeof(struct mpa_v2_data)) {
+			siw_dbg_cep(cep, "mpa reply error: pd_len %u\n",
+				    be16_to_cpu(rep->params.pd_len));
+			siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+				      -ECONNRESET);
+			return -EINVAL;
+		}
 		v2 = (struct mpa_v2_data *)cep->mpa.pdata;
 		rep_ird = ntohs(v2->ird) & MPA_IRD_ORD_MASK;
 		rep_ord = ntohs(v2->ord) & MPA_IRD_ORD_MASK;

base-commit: 94e81a1f3ffabb388f7d0a9674bb1d3acc067e00
-- 
2.53.0


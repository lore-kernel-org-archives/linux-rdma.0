Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007996;
	b=Oj1s5Nj2QPBlU5+lqLUJr0CHUsuBWDcE2EMkeEpwCYSsh2dzhFYjcFSrDhH/53eQAlsr
	 vaJbmueEeWVsn8xqc4r2mAUG0wPY9R+ceF0ZWd138eTRTiljxoDUI8G/z/ED3/AJVo0K0
	 45lg03ymCY8zhvRdueEPtODLs+WMdpIuevNcvOFk/GdUwnHSfsEDHLziOzqdSjN19S1Yt
	 fmKKVCt+E/dLD3g9GCMPecYZ4sq2tng/IUIklnfzkAD94N77myRkjxYhP55OCBDVXf0tW
	 aveSzsvnsCmTEkMvGrVjoYrA612dxlWUf44B927q0XGgfYz7MCn2O2L4czaQarHfsXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XvTSmuMfFY3q/sfZxdJtMgP+cT08HPhiF656C8De+nA=;
	b=h3GPme0cVFe4In8Qp8Vom9KOuDsMIHXyMrTjSMLxh7N/yWRoCr3QMQdahUqKtkUnHBND
	 NZeXPTO9SBC6ao0PwIw4NwE8Lw86L8PumE8I3wbhhhM8DzC6ei2wGVnTD0T9eqyzSNlb+
	 dW6DkboS/FPhUS0EM1RVjHByPTq6ch68fdp7/WYxrxoCXskrsRQIaZeOi8SVltz+L+Fde
	 rKKqSqbEotkUXe3IyJRlCb/VRiKOdFPk9Y3iaJy/Q5s/hvg0fJqapdcw767AxEl5iTglQ
	 phTrMbkMaeWsi9NPs1F87rP/LzEh2+ak3RCcdKiCPfWaaeulEGV4cZI242O3hnOYmgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FzwMzYhc;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3229606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3229606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FzwMzYhc
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so9941885e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 05:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795007994; x=1795612794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XvTSmuMfFY3q/sfZxdJtMgP+cT08HPhiF656C8De+nA=;
        b=FzwMzYhcOT68fh1Wfkw/Jzn6y+7K05F9ZpQ/2KPnIs8uL74CgV6RR8vKA87xNjbUeP
         eIILtRAyJVotot4NT+3E4wX/5/i1i2WxkZf8hbBafe5/GGDRr3AmH/LlZm9LpJ2T75KH
         P+aoDvuZxiCmjg2pKO+Tmk6DCU7sviVtr84tDxJd/+TVsaLYGbrOykAE6f4/AonVzpyM
         w37IgqE1CsCOsxt+7Mr2kVDICqRAKCA3ixoFspv7SWOzRqE+gUxbgSo3mIKH7v1jRy+D
         WlQF3Oq/TTxlaMOQEiPhLyW3Pgg9ewrbhkxJo2DRoTsUb/yoZylw3vqgNl14NpeZ0KQp
         RM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007994; x=1795612794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XvTSmuMfFY3q/sfZxdJtMgP+cT08HPhiF656C8De+nA=;
        b=Bkq3iPtcgy36vaq9XPpF8JJ0CEhq2w+zWqZZj303q3aFI6cBz7LHKIWHMOtPyUZNdY
         anI85FrqqNeWhNy+RA/py/ySXO3CLE3Pj9t/i6bTIRx6/VNmuqfgscH0lzrWCcYxzhCE
         fU3tq5xpgoXcZ8g5hFJ0Knefg+nnq1Yx+6Jooc9z2CypJZ5fEBraw8qc+6DxUuTaCUVR
         +QeoorCkH3yYpRFnIfLymz3cBY9Cm4qaRzCJKyXjgjapIuvEgFI4LX2w8BPZnCePvKFb
         0iGkQoBE22DZXaupUDRy7ttxXmHw+8cuSSr5qHUWqQHrKBvGmUQuKuaTzeLLQhRKJY4n
         GMuw==
X-Gm-Message-State: APuU4Z/vQnlDU0sDFeH7FOtABDs5eJ++xZ7kniwNM1/UTHN2VPM941/p
	/AGACNbAJB+BUXGMPaWsqy3lPrb29TsjYQ8prbtkMZnaHvZJQ26GwANu
X-Gm-Gg: AYBFou3uFlRsvjMYKZRSBg3PHnAp3BGshWLPnQxmuNMV4sAKjwiqe7c7awiML4Pqx5g
	ZM/nbcr+0y8IbMOZPgJmRYpnoO3TPJquAKEhCCCrONRd+79qUvedYxZosdzGdDwCqM09mQ/vWNH
	5beMwQdOAHOYF7wZ3ThScITXnRp5+TrAqkcAT2TZeGsjJ1fvrWAzIc9DD7NgbRMRDmKu7YiqorV
	6nh1JvTmucI3ViHVRY12cnkFCjulL1YOC1MbYgOEkZnl9k4cPvRbnse8W6PBFi+gY8Rxyxyl6H3
	14gbC5H0u+AOktKA2q2H7IhFXttu9z2JdGAgRjuTnty+52XHtILD6Z/OKrJyj+vny4l9TbwKhMs
	RSMjL1M1jwoX/ZhcPvqfYIwbJGYoAkSotzvIodQeIJWwuYuzxNEXKvUoVPxb/+0Km+JlhDZ7ke3
	8kB5Yu1ul/3HKIcRWr5Dx5hwTc84F94oo2LmrxsKbeHcBPKrkU75a1tJD+BYq1ALRxNF7SsR3M+
	JBIbsTkUBuL4gwiQjkjMXexfy2WTJb0k4Q5S5P1Zd2hF7Cbapy3UpZD4SlZtv6gN6/LzAf2WkZn
	ZSzEralBAgIsw8dMOAt8ls6AfJD7s7JhT7xkktSjKVCw76ZMJuyRZ3T7tpB5XnXdgOvy5W1pt1t
	gQWhp8WVvz3zpbNKnxi+0P7Zaeg==
X-Received: by 2002:a05:600c:4f56:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb7da12aa6mr53734285e9.10.1795007993903;
        Wed, 18 Nov 2026 05:19:53 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7e513c28sm24342875e9.0.2026.11.18.05.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:19:53 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] IB/hfi1: reject writable SUBCTXT_EGRBUF mmap
Date: Wed, 18 Nov 2026 16:19:47 +0300
Message-ID: <20261118131948.28748-2-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118131948.28748-1-suruurism@gmail.com>
References: <20261118131948.28748-1-suruurism@gmail.com>
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

hfi1_file_mmap() clears VM_MAYWRITE for the SUBCTXT_EGRBUF mapping, but
never checks whether the caller requested VM_WRITE in the first place.
A caller can pass PROT_WRITE to mmap() and get a writable mapping of
the read-only shared eager receive buffers, unlike RCV_EGRBUF which
rejects the request with -EPERM.

Add the missing VM_WRITE check, matching the other read-only mmap cases
in this function.

Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 680364fda856f..6de12a276a605 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -525,6 +525,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
+		if (flags & VM_WRITE) {
+			ret = -EPERM;
+			goto done;
+		}
 		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
 		flags &= ~VM_MAYWRITE;

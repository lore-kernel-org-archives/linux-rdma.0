Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066BF49362D
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460921; cv=none; b=E8fs44WoWTPUY+mtqfWlZv5aLtwBfTpjoFvVCjILSgZBcBUYmtTInAkuxNAfa03fMfb32qVU8SO85kgSX3ZYTuUuepZQQE5QB4FEi+4z1uv3QzM1b3QblKUOUUS3hngwBmwWAX6Hm3gSHGEmuRj5uAp1xROEH1beSgdLYaaC4j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460921; c=relaxed/simple;
	bh=3tqj8Zo7XJ8hZdiFcRSIYKAGzk68q4VHp4XNaAc9QBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SVVi2YeDDX0JPfMPMZqnssHEgrAvLtkcEbee90vMRBC0vi5bKTxtYIjICpIuSb9IeqJzMEHG4/tmn8brCM2VU3AXSLp4GC5sv7d1Lyg8wT6sIdHQUI3doQmNWu55dDRprAbBLeqjDCsg0h5HF/UXU4e6nsW1WVqMUe2ejraZcww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMK+Heat; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMK+Heat"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a02718da81so22720895e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 05:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460918; x=1792065718; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N15FR/lrbJ5GLsPhF2Pbd6l/4dIVTCcLD/U1z5cW6/g=;
        b=fMK+HeatfbUTFIg3+W5uRLOXhRvmKlErqwlYpIrBL5fntHhTD0tenLB49D8uCdb/2m
         nB+4eOyMuWzxE0b1pTbv5a95TxpVeGO1esF65BsUCMSSaqSWaYeKrcl+O8xkLe+BuKPa
         ZUaiWbl19albjq8xkXHPDCcJoQ7zt5n1aGIpM7Pb11Z49dxX4xjSpFafN2xcvXVJ1GDk
         eVLqBu+31qtWbduJW7Npzb0I6NMsQ+2iBlWBIHU+FILU6njo9BRKqAZ6XJ6BpfObvuM/
         7NEzI3fJrDyWHrb2OgmtO78y6o5JhovGeP+h8vNRvGdWtXd5wJxTYvUZvbTsw3c3JU/9
         Uymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460918; x=1792065718;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N15FR/lrbJ5GLsPhF2Pbd6l/4dIVTCcLD/U1z5cW6/g=;
        b=yEWkQXcfqKyHU9rA/kn8NfZedLp4X4Nb25Oif3Fh4wR7p6HDGDruYQNf194qWJzXOv
         S7mYi0IVz5j+ilFumqfmCw8maex1MOhz94YWC6BpBb9IB/yeaPV5VjKwyr/8SRB1LyTK
         o4yzfFN3/zDMPjj0w8z4zWji+e/ptcmoyB26nGMuJXqd+cUV/ISqlSjJlmzEkPbeVpqT
         kIh5zaSN2V936l4WzKR1R+URplj1zNf0MRvMiZWM1I3HxqZDlbfvDqXg/ACfsXLCO9d6
         7wFLoGwMdUwebwq7QkLG8JklqXF0n4FIX07MKrRvpK/WIwMxbLkutQ9pqc3TltIDWOLp
         oaxw==
X-Gm-Message-State: AFuF++kMlow1ZbaCODHmND9isy0WNXknwrsD0hWLxk+qHy9bO2cbQOSa
	4mVKr2VeiAMtgxncGfgCoguW+ZErFA6kNAEt1p9J+uiaeuHhdExJMtI=
X-Gm-Gg: AYBFou0MygZt6UsgGZfsD2MI6vXha/fRNBAoSYkyQGtUcBz7rg/aku0I8m+gQHGnWsX
	+iotRLvLsH9u9O9svBY9hNW74cuDe+AOKSk86F6qLiVR2Hn6qYzASdLnlV3Hx72sCooSM++6zTD
	WUYWqNvaaM/cz50IA/6VPCIoasjvjHK9KfU1fHAXoFO8OgrrN2pJyQ8lenCsK24I5FVx3RNzWWa
	NsrSxkeVL9A2ge8PCPQ+BJXNVASTCI2Ah9J10Z4zzvauUUub6d3k4IwLOhM1CwMLjFTjAGHCtLV
	FpHEcYDtOKfXei8ICjQ6+uO4U2+iC9Xk26p98TkG1DEec0ooGoL4Yam3l+AavVJvw/GlqnkPfrF
	OMWDFkP5+ja6HkGqUERhV6wVgi5wiWU/1sfortt9wYNicgBk537WSBlcaMKCQObxYEN2AdsqPAP
	Q+N+klQj1QEHVkrCiqwaOMEnhpn28c+S21jj4z
X-Received: by 2002:a05:600c:a30c:b0:4a1:80d8:aed0 with SMTP id 5b1f17b1804b1-4a180d8b180mr67907355e9.15.1791460917984;
        Thu, 08 Oct 2026 05:01:57 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d2e2dcsm12223759f8f.42.2026.10.08.05.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 05:01:57 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: yanjun.zhu@linux.dev
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, tristan@talencesecurity.com
Subject: Re: [PATCH v4 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
Date: Thu, 08 Oct 2026 12:01:56 -0000
Message-ID: <179146091623.3840242.8978910812704841884@gmail.com>
In-Reply-To: <714b1a9e-560d-4fbb-9dfa-6f1fee5cb13f@linux.dev>
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <714b1a9e-560d-4fbb-9dfa-6f1fee5cb13f@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Yanjun,

Thanks for flagging the Sashiko review. I went through all 8 findings
across both patches.

One was a genuine issue: the memcpy size used qp->sq.max_sge * sizeof(sge),
which truncates when max_inline_data is not a multiple of sizeof(struct
ib_sge). For example, if a QP is created with max_inline_data=3D20, the
integer division gives max_sge=3D1, and only 16 bytes of the flex array are
copied instead of 20. v5 fixes this by using qp->sq.max_inline directly,
which is the exact data portion size stored at QP creation.

The remaining 7 seem to be false positives:

  - FORTIFY_SOURCE (raised on both patches): struct rxe_send_wqe ends
    with struct rxe_dma_info which contains __DECLARE_FLEX_ARRAY, so
    __builtin_object_size returns (size_t)-1. The merged receive-path
    fix (d6ab440240a04) uses the same pattern without issues.

  - Inline data / sge_offset / resid / cur_sge validation: these fields
    were already unvalidated against max_inline before this series. The
    requester path bounds-checks num_sge and cur_sge (lines 754-760 in
    rxe_req.c); adding resid/sge_offset validation is a valid hardening
    improvement, but it is a pre-existing gap, not introduced here.

  - wr_opcode_mask() OOB via untrusted opcode: the call existed at the
    same location before this series. We did not add it.

  - DMA state writeback for RDMA READ retry: on retry, the requester
    changes the WQE state via smp_store_release(). The completer's
    smp_load_acquire() detects the change, bypasses the reuse path, and
    takes a fresh copy from shared memory with the original DMA offsets.

  - ERR flush path barriers: when send_wqe_valid is false, writes go
    directly to shared memory, which is identical to the pre-patch
    behavior.

  - Shared pointer for wqe_state_posted: posted WQEs cause the
    completer to return COMPST_DONE/COMPST_EXIT without processing.

v5 is already sent with the max_inline fix:
  https://lore.kernel.org/linux-rdma/20261008093740.3034881-1-tristmd@gmail.c=
om/

Best,
Tristan

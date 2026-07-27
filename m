Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B733DE452
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785146217; cv=none; b=C+eN+EPXa8RDvLkjf1cA6fpvJgzHDu4K2ONm0iusn2qzKJY1VZffQAodvO/wAj8f6+cNmRxaBjAPqpvcr3bYT/UFRrWLQ09cAxle3EIkbhegmWFyqZjho3d7li7/VFhRg3DpjHOYcCG2uLUxL7yiPtC1CjODKcUrWZfzIPQnqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785146217; c=relaxed/simple;
	bh=13GOSqAdgrF0dIuUjy81pMTDfGbzXmq8V5DyscCG2H8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBZ1cuer8woheJj9Cp0AyQxx3pwoWr+rn7kDl+Zjl7oO25bZMMa2MfxPt0eWXpr4Z8D7Z5Q/HWXUo9k/Zhb/H5IlDzPLSrjfCNzfIDPKinI3qpjnitepgOPuUPe2st1BC4m45Rn6CXWHLO3miFPFJzOnE2n5kVlVWKarzBuHl9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ZV0eGQN4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ZV0eGQN4"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso2324082a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 02:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785146214; x=1785751014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sYEClUMgtlxTRfHjpZUCI6IfQ0ehz2GfsZPhfUC/e30=;
        b=ZV0eGQN4W4QZ87w72QXoir4QKNpCaoPNJuqfdTxjcgFOiNMIAjIqVYw9oyEewSH7yW
         n+6bTD4gU2hBaHOcUPQT/mheBv8uswF/pC6gMlRG8Q40AFz4uI14vhWQJ5D71ZT/4xu0
         CHAsnGAy0i6ahkFpmvO+ZU/PGa8NpmrEctph6d0xO2gUtWTVe+rK2fiGrfvwsMplfGKV
         99oPKzLLqpNjV2pHNkiEWyDa3eRu6CEHOpX2L7vCYZJrkxZjteSPds0VXQC9dcpJtxgG
         h1AZzmI9TSeuKY/+3XVAEPQstdauEy+ncE2+wsTQQYn3SeEQc0jDZusBhZaLWR9blPaG
         u2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785146214; x=1785751014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sYEClUMgtlxTRfHjpZUCI6IfQ0ehz2GfsZPhfUC/e30=;
        b=T2IIi+SHGyxhg1QqxplIn8tgnSYUVWThQanJiCy6pFNamDED5rdXpMyD9TES6oMkT5
         bpNkUUo4Vx4z+lHLfpV1T3Y2DkTlmF+Z9ROWGKoBwX/Nnqcxps4GtsgH7v4ZYS4IjeX2
         31HWa+3zsi4fCrNw1BGpYcUEhhslojzNGU5qmEPLQkYxF32/uchkES0odie3kUOwdouz
         t8dkMM0a01j7x8d6Mxpv6pdVYzJGi3blTzlTrPmHy6KKc3dRTTwUQ9sruNeKMFhzcRsw
         fQeOAMYAK1RN2kOlmP5y+UF1kY0lQJcR9o6Rh7fmYnrvwlD6VgE96rSkCXyruG0/Bjlg
         ZcIg==
X-Forwarded-Encrypted: i=1; AHgh+Rr9GZQksVdByK5mg98ypXLthWDzY6Gtn6T02c+51PMNBt2xAb/t+fbHiBBZ0Ja6dmL+0TBTlje2hGEY@vger.kernel.org
X-Gm-Message-State: AOJu0YyozA5FOJ3bh7spu8y/m0N0bmh8YE0fPeNV/MKd3VH6Xpwgxk7P
	UFTDoqvtjtInxiKhWtoUE2J701OFyLCkay2CblPhMSDPLkDaUo3NsfIsyyRPnDTxguw=
X-Gm-Gg: AR+sD13HV7nHx6MzkWvm95GR2WsZmu1uqaSwfm826/TwQT2Ri7ytANTy5f3IOoph7xB
	ApxRWn/E9hUh7ueS1JOIG1KamZD41NsEHXYUaVOvRua+fMBPNdYnlPU/vqFA5jCpgxxPNKV9fv0
	ePaJNBPom3djKIYmqPP/QKN9RkrEOF0fqBpJM6+eeUm6PT5zkCr2Qx91rHjupDJzzvtl/XMNyje
	TVk0HKBJuG2kJd9UDcRjLMyh+4Fe177Aianm1qAVjJecmdmmINf36by1hymMlWdxUYVo6gbB6TT
	5Nsy4LdrYocdmDDWS7Zgr1uHkIHZX8kq8yHYNqYAQDTHoJ1Fe+WWLk3/LM2YlfvRyI16Zn3N3aN
	DFTjP2Fqsn7mot3WJdMhzf46k9KvYL3nfjti6YCdl+megaVIeYzAJjwGoMpgyu2pTvJJ8XkpLBe
	A7rStECe4Sh8tTngx6H6lgsHXO
X-Received: by 2002:a17:90b:398d:b0:38f:657:6823 with SMTP id 98e67ed59e1d1-38f2a97aa1emr5126778a91.8.1785146214078;
        Mon, 27 Jul 2026 02:56:54 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:fc36:f2a9:533e:766d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f090619f4sm2806808a91.3.2026.07.27.02.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 02:56:53 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/smc: fix out-of-bounds read of rkey array in SMC-Rv2 LLC processing
Date: Mon, 27 Jul 2026 18:56:34 +0900
Message-ID: <20260727095634.1079605-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727021511.GA95674@j66a10360.sqa.eu95>
References: <20260727021511.GA95674@j66a10360.sqa.eu95>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 27, 2026 at 10:15:11AM +0800, D. Wythe wrote:
> Could we consider attaching a full copy of the message body directly to
> the qentry (e.g. kmalloc(wc->byte_len, GFP_ATOMIC)) for V2 messages that
> exceed the 44-byte inline union smc_llc_msg? The only V2 types that grow
> beyond the header are DELETE_RKEY_V2 (batch-delete, rare),
> ADD_LINK_RESP_V2 with ext (link setup, rare), and REQ_ADD_LINK_V2
> (~hundreds of bytes). Memory pressure should be acceptable, and this
> also unifies the shared/non-shared paths.

Yes, I agree, and I will send a v3 that does this.

It is better than what I posted for a reason I underweighted. In my v2
the body still lives in the per-link-group lgr->wr_rx_buf_v2, which
every LLC message on that link group shares, so a later v2 message can
overwrite it between reception and the llc_event_work item that consumes
it. My v2 protects the header from exactly that by restoring it from the
per-qentry copy, and the commit message says so - but it leaves the body
exposed and I did not state that plainly. Copying the body onto the
qentry removes the exposure rather than bounding it: the buffer then has
the same lifetime as the request that owns it.

One refinement. Since union smc_llc_msg is the last member of struct
smc_llc_qentry, the body does not need a second allocation and a pointer
to free; it can travel in the same allocation as a trailing flexible
array:

        struct smc_llc_qentry {
                struct list_head list;
                struct smc_link *link;
                u16 body_len;
                union smc_llc_msg msg;
                u8 body[] __counted_by(body_len);
        };

I measured the layout rather than assuming it: msg sits at offset 28 and
ends at 72, which is where body[] begins, so header and body stay
contiguous and the existing v2 casts become correct instead of out of
bounds - the non-shared line

        llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;

stands as it is today, and the shared/non-shared branch in
smc_llc_rmt_delete_rkey() and the two ternaries at the
smc_llc_save_add_link_rkeys() call sites are deleted rather than
rewritten. smc_llc.c already asserts the invariant this relies on:

        BUILD_BUG_ON_MSG(sizeof(union smc_llc_msg) != SMC_WR_TX_SIZE,

Every existing kfree(qentry) site also stays correct unchanged, since
there is still exactly one allocation, so the flexible array adds no
paired-free surface. One lifetime question does surface, though it is
not created by this change: smc_llc_srv_add_link() calls
smc_llc_flow_qentry_del() before the v2 rkeys are read, so the
non-shared path already dereferences add_llc after the qentry has been
freed. My v2 hid that by reading wr_rx_buf_v2 instead; reading from the
qentry makes it load-bearing, so v3 keeps the qentry alive until the
rkeys have been consumed.

One consequence is worth stating, because it changes what the patch has
to contain. Once the body lives on the qentry, the backing allocation is
exactly as large as what arrived, so the loop bound has to come from
what arrived as well. Today the count is capped only by
SMC_LLC_RKEYS_PER_MSG_V2:

        max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);

In my v2 that was sufficient for memory safety only by accident of the
destination: the reads always landed in the 8 KiB wr_rx_buf_v2, and
num_rkeys = 255 reaches offset 1028. With a per-qentry body, a 44-byte
DELETE_RKEY_V2 declaring num_rkeys = 255 gives body_len = 0 and the loop
walks off the allocation again. The same applies to ext->num_rkeys on
the ADD_LINK path, where even reading the count needs 28 bytes of body.

So v3 bounds both counts by the received length instead of only by
SMC_LLC_RKEYS_PER_MSG_V2. That is the validation I deferred as separate
hardening in the v2 commit message; under this design it stops being
hardening and becomes part of the fix, which I take as an argument for
the design rather than against it.

To be precise about unifying the two layouts: every consumer unifies,
but smc_llc_enqueue() still needs one branch, because in the shared
layout the body was DMA'd to lgr->wr_rx_buf_v2 + SMC_WR_TX_SIZE by the
spillover SGE and is not contiguous with the header it copies from,
while in the non-shared layout it is. That is one if/else at the single
copy site instead of a branch in each consumer.

Two things I would like your view on:

- smc_llc_enqueue() already returns without queueing when the qentry
  allocation fails, so the LLC request is dropped and the flow times
  out. I plan to keep exactly that behaviour for the larger allocation
  rather than adding a fallback.

- The allocation grows from 72 bytes to at most SMC_WR_BUF_V2_SIZE per
  queued request. Those three message types are rare, as you say, but
  they are peer-driven. Is the llc_event_q depth bounded anywhere, or is
  LLC flow control what limits it?

I will keep the Fixes: tag and target net, since the out-of-bounds read
is still what the patch fixes. Tell me if you would rather see the
restructuring go to net-next with a minimal fix for net.

Best regards,
Yehyeong Lee

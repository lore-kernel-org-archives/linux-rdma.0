Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688741DED8
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 10:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233081; cv=none; b=TyB4l/oFArjrS5jfiHzg99eJx7dqUHWS2ldb/5YtRadAJBdXsLzKqCWcgGZ0cx37EMvm0nAeqLFbWrPUc7hJBu7YCoxe8c7QuZ83X8UqhWA68b46pMKvREH4eY3tDfes61O9111K+RRFekuA1zvHzElYIXlnxju7R+Sn3lBm2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233081; c=relaxed/simple;
	bh=lNsH6KFl6jXz7cYKHk1mtd5Pe+VMGWPOl92WSI/TU+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cU5JIXY7la6y5ZbDycg5v2d3ca+Z0/RxGJtqefzHqUw6fJfJPqgC2JewHBO3dsQoxQzWHv1bnq5ypZ6/2Zti2mu5Kr/AGGEVGpAHnKSrSyth6Hj35fN6V7bTlerzMsVgJee5Lkm1+qBgcqHZp9K+rOKIsApzL4TzdJVKtKaqJGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUWH/WIe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTURWzXa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUWH/WIe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTURWzXa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785233078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jy51T/GGPD8X/iu+8/Zl6g1NCdPj8ghOQ9Vza8iPsx4=;
	b=VUWH/WIeNbwcSsNUeUSNej3Oz9HJ+eDtwBpvWmo8VNe94h2GjtyF6WN7XF+HvuMt+XnD3m
	+qdSnC/pVg+cJJf9mQPj2A706NIAXyVBc++vHi1yvTaytvUGnzSTv1eBDWAHNxsxIbAYr1
	kdYyS2GJyXo+DPUy77cWmtLRy+u0j6A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-OcOT65CbNF6JFPErRpuaKw-1; Tue, 28 Jul 2026 06:04:36 -0400
X-MC-Unique: OcOT65CbNF6JFPErRpuaKw-1
X-Mimecast-MFC-AGG-ID: OcOT65CbNF6JFPErRpuaKw_1785233075
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so33357175e9.0
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 03:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785233075; x=1785837875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jy51T/GGPD8X/iu+8/Zl6g1NCdPj8ghOQ9Vza8iPsx4=;
        b=eTURWzXa1ShZBevWiSPHZurQ+dNl8gXow14lgw2Npnp5ghz58kbmqJIOmfrc/ZtA5d
         +WQD1bABMSkCA0/PgmWiCYh3+NbICNYz6m6WPjYVHAX9ipeo+DQJ5lShPbwItin5hX8m
         5MmOYyFm+fRCC5jtZyYnN+5oxNR7sm1HN0PdULXxS3Nipzk/Q0yUW+9lMfI0mckz6LFB
         UzVbrcH2hZV8dIRJhRX8rh7I0+52j+3rlmlpx3kurIQJ/EQU9YKp9A5Nx1pde/YhjbIG
         +meCFWatQBANl47S/NW3SxrpMnf032rqvMRZ5WblTgkDEwpl4fXvfSbC4xBDb8r6Vz/i
         sskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785233075; x=1785837875;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jy51T/GGPD8X/iu+8/Zl6g1NCdPj8ghOQ9Vza8iPsx4=;
        b=pSivetjVy9FdBmdDY55jONGNEtyiUhE848s+ADe3KcVaxpuIEmNMSa5U9mj9h17qZt
         DkwgX0qH6spyDCSbCNssOvHomY5EqtPfNyu2OmcsRJFjFGzMwF1SFMV+fAQupGe/9L0u
         lMbKxM7EWgmQULiaKgDju71mnMakU+QQGLUp4v3m6qXRT6iOy69Oqt1Sn7IAjJpXEGR9
         N9vf/qDd4QTq5HLp+un0+oU5kvKMbkIvPNIfiy9ABYdtsdC/zFus1NxwVrMlHLPTm2Ls
         QqbnHGGhBnAGzP3v9ODp4YXiXZfey55piSQr/Y1aCx3CLNvyrLyr93Meghn5s57jb7WF
         5ZDw==
X-Forwarded-Encrypted: i=1; AHgh+RoINHMwVysUsNJ81TA38gXMyJkHhBi+0ODmBZO56sYW+//TnVNLLoElWPWIq0mnvzvorD5z5kn6euPS@vger.kernel.org
X-Gm-Message-State: AOJu0YwzymUSiTAY/MB2JYrUUNYp4ZO/UbSuy5u03hXMIVY9fgGXxa29
	SZ8gcMPdNezmd4SGEt+hcGDlgyeP2ata6Yw6kVshOwdCl8lPYvSrgDilXRXKPtQZ+fr68dmlOO7
	M0TaVHUSEITE3W9B6mpMiQzmws/DD2Kt1vF4rbk5wuQDQPd5MwWK5O8xqyzcyuso=
X-Gm-Gg: AR+sD11aKA4ZhDp0inGtx3oMgvfFNCJr0OJo6ojk7X4r2B6pNzwWHazLPlr7Q+HkILw
	TuQ1o9HMgVRKH75SvVuo7AVNWmQSlmGGpyrjEBqzMjj4ISESJXhYdzC+DShf8xoqMw7aXigsAby
	72WdLefrpKtTfYNDDynM0XS8pq3zMo4LfVksAky9N4qfGzS7Svz9/wcOEeFaxLGc+4l8uxir5h3
	bMcbjEiioy5SRq1BsKPCXV9YUlE/lfDYQb+5nKgM/jM8DeZ7B80Db1XTTaKh2rgH514JzkNo2e5
	tVtqhrKNx7bL7hOZc2vsSHClL/KjEKmlM15iQI0AgGjutn8RUSsFCz/hd5oz2CHVv+szKifKPgI
	wVUtDmHnCjMmXT497o1sp9Wwkj4k9vpLwU3izwxH0ehNPdufrethgPuFIk83gYopo+C+0Nl5Rio
	RIew==
X-Received: by 2002:a05:600c:8214:b0:495:6a2a:951f with SMTP id 5b1f17b1804b1-496c6444f77mr17532745e9.17.1785233075550;
        Tue, 28 Jul 2026 03:04:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8214:b0:495:6a2a:951f with SMTP id 5b1f17b1804b1-496c6444f77mr17532375e9.17.1785233075126;
        Tue, 28 Jul 2026 03:04:35 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85a2573csm57119355f8f.0.2026.07.28.03.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 03:04:34 -0700 (PDT)
Message-ID: <a0d58258-4042-41e9-ab32-8f7e5deba5e5@redhat.com>
Date: Tue, 28 Jul 2026 12:04:32 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/smc: validate peer CDC cursor against RMBE
 size before accepting it
To: Ibrahim Hashimov <security@auditcode.ai>, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, wenjia@linux.ibm.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260722101758.37817-1-security@auditcode.ai>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260722101758.37817-1-security@auditcode.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/26 12:17 PM, Ibrahim Hashimov wrote:
> smc_cdc_cursor_to_host() converts the wire-format producer/consumer
> cursor of an incoming CDC message into a host smc_host_cursor. It rejects
> a cursor that goes backwards, but never checks that the cursor stays
> inside the buffer it indexes. Per smc_host_cursor ("an offset in an
> RMBE") and the invariant smc_curs_add() enforces for every local advance
> (0 <= count < size), a valid cursor count must be < size and a single
> advance can be at most one bufferful; the wire cursor is peer-controlled
> and was never checked against either.
> 
> smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
> unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
> computes the advance without clamping against size. A peer can inflate it
> two ways: an out-of-range prod.count (e.g. 0x7fffffff), or -- since on a
> wrap increment smc_curs_diff() returns (size - old.count) + new.count --
> a cursor with a bumped wrap and new.count above old.count. Either drives
> bytes_to_rcv far past rmb_desc->len, the very invariant the comment above
> the atomic_add() claims but does not enforce.
> 
> smc_rx_recvmsg() then trusts bytes_to_rcv as the amount of valid RMB
> data. Its first copy chunk is safely bounded by rmb_desc->len -
> cons.count, but the second chunk copies (copylen - chunk_len) bytes from
> offset 0, and copylen came from the inflated readable -- an out-of-bounds
> read of the RMB's backing (v)malloc allocation, copied straight to the
> receiving process via _copy_to_iter(). This is a remote kernel-memory
> disclosure driven by a malicious SMC-R peer, needing no local privilege
> on the victim. The same unbounded count also reaches
> smc_cdc_handle_urg_data_arrival() (base + urg_curs.count - 1) -- a
> second, narrower OOB read.
> 
> Reject the bad cursor at ingress, mirroring the cursor-sanity idiom two
> lines above: drop any incoming cursor whose count is outside the buffer
> (>= size), and any whose advance from the last accepted cursor exceeds
> one bufferful (smc_curs_diff() > size), which catches the wrap case.
> smc_cdc_cursor_to_host() gains a size parameter; smcr_cdc_msg_to_host()
> passes conn->rmb_desc->len for the producer cursor and
> conn->peer_rmbe_size for the consumer cursor, bounding it at its single
> origin instead of patching every downstream consumer. SMC-D
> (smcd_cdc_msg_to_host()) does not use this helper and is a separate,
> out-of-scope gap.

@SMC crew: please review.

The above looks so correlated and quite simple to address that possibly
it makes sense to address it in the same series.

/P


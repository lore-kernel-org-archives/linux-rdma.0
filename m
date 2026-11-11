Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358498;
	b=06u86CG0iJRFGKaw2fglMI6xX0BHipGozFu1LlY7MNLiFBC5muP8NFxuXwz/+CEVXK7W
	 H9uE76P29nr1gG+KOZjowt3JdNz5zUcttlTNZlTPvp/m/8DTj1QPmf+q7MIRwCmh26E+q
	 rTl0wOiPwg9EQnC0zAaf+Cbri0KmciomzvH8XW5O4Z+IZz057uJK6s9hA///yJ/utlehU
	 g11e4JnKkJ23HZLNtp7uiwWJ8EMP4cabzoctnQhKZu6ugxAnFaZU0RZCNF+rPJU1Rrl3p
	 A8mrb2Csei6+FWfsQDn9QO7PGsoNtqRSTt/j9qw5nBCICCu/UTYMXAlmj6INkzgNFRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358498;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=bQwp89LGZ8zRmajtcyvmVGS2udRo2pxMuP3YlaRU85U=;
	b=gvNwe+YohHfzhgfcW3nwfvIyACKpfUwPtejx/hA8CZfb3ixMMK70x7hyr9EJTYGrDk/c
	 y47YBdragR4HgjI+xd0aPVSReGnRsTCDccvsqANHMrjaUPJY4Vr6KnHP+qK89cQVJs33f
	 PErNkIeG3pH6B2ne3XQM/SJXcyy22Tj6pHKId94HfAsxXcwZBk5P9uI13ccLZXTO7BUL2
	 CvLiro3MgSp/WB+Bb0Hd1V9U8MnbcVjyqUgKPseAy8n9ogW/9DXKA+xuI4xu+rXCw5AJZ
	 l/of1Ss+WfFh5mos8l+WwgzwMAnnIvE0GhLZg/cSl2MpTPuYIwCOkczs3O902beu+xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="h/GBLPsV";
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FAD606A31C;
	Wed, 11 Nov 2026 00:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4FAD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=h/GBLPsV
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jPQ692hBrzlgyGs;
	Wed, 11 Nov 2026 00:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794358494; x=1796950495; bh=bQwp89LGZ8zRmajtcyvmVGS2
	udRo2pxMuP3YlaRU85U=; b=h/GBLPsVfaLw43/+HNjek3kKM5Z6PcqaZCEaN36V
	h2WBzD50AHpX0TpPU37rZXghPQ5mPvcmxTyJaApxlhgEfx8axwWhVVY/XeZPdxQL
	TAbwhzrspNNoAadI+tKHhRPqF5hbXaoeXHwQD604imeu1nbKuW54zcSsrfsyffaO
	+30p1FW3j45e1EzM1sFYDvD5v3AhFvoLku9ZuWIeVms4/6TGSIx4vlCWaQ9ZA9xJ
	spZ63vfuPjJXVXRPqopC5FnmX9G3ETTvBOfenuwfu5Eeu5fYGr6D+e960NqwVMoe
	cQjNtthLzMUU3BwXnlNnR/XtS/Z2KKUNsdmpqJR/g/sQuA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Cu5h4u51i4Gm; Wed, 11 Nov 2026 00:54:54 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:28e8:10eb:f1c8:4883] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jPQ6658CXzlffvf;
	Wed, 11 Nov 2026 00:54:54 +0000 (UTC)
Message-ID: <2e748067-f733-4edc-b71b-540de4bc3d26@acm.org>
Date: Tue, 10 Nov 2026 16:54:52 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/srpt: Limit read data transfers to the command
 length
To: liuyong <pkfxxxing@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, security@kernel.org
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261110052827.963143-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 9:28 PM, liuyong wrote:
 > SRPT builds RDMA contexts from the initiator's buffer descriptors before
 > parsing the CDB. The resulting RDMA WRITE requests can exceed
 > cmd->data_length after target core shortens the command or when an
 > indirect descriptor's buffers exceed its advertised total length.

Agreed that both cases need to be addressed. For the second case,
srpt_get_desc_tbl() should reject SRP_CMD requests for which the sum
of the direct descriptor lengths does not match the total length in
the indirect buffer descriptor instead of building RDMA contexts for
an inconsistent descriptor table. That is a protocol violation by the
initiator and it is better to catch it while parsing the request than
when sending the response.

 > +		/* Do not expose uninitialized data beyond cmd->data_length. */
 > +		for (wr = first_wr; wr != &send_wr; wr = wr->next) {
 > +			int j;
 > +
 > +			if (wr->opcode != IB_WR_RDMA_WRITE)
 > +				continue;
 > +			for (j = 0; j < wr->num_sge && data_len; j++) {
 > +				struct ib_sge *sge = &wr->sg_list[j];
 > +
 > +				sge->length = min(sge->length, data_len);
 > +				data_len -= sge->length;
 > +			}
 > +			wr->num_sge = j;
 > +			if (!j)
 > +				wr->sg_list = NULL;
 > +		}

The work requests and SGEs returned by rdma_rw_ctx_wrs() are owned by
the RDMA R/W API. This loop relies on several implementation details
of that API: that data is transferred with IB_WR_RDMA_WRITE work
requests, that the remote address of each work request has been
computed in advance, that the work requests occur in data order and
that the work requests and SGE arrays may be modified by the caller.
Any future change in drivers/infiniband/core/rw.c that invalidates one
of these assumptions would silently reintroduce the information leak.

The irdma issue mentioned in the patch description shows another
problem with this approach: it causes work requests to be posted that
the RDMA R/W API never generates and hence that RDMA drivers have not
been tested with. If irdma does not handle num_sge == 0 correctly for
RDMA WRITE requests then that should be fixed in the irdma driver
rather than worked around in SRPT. Additionally, there is no guarantee
that other RDMA drivers handle such requests correctly.

Please consider the following approach instead:
- Reject inconsistent indirect descriptor tables in
   srpt_get_desc_tbl().
- In srpt_queue_response(), zero the part of the data buffer beyond
   cmd->data_length, e.g. with sg_zero_buffer(), if the data buffer is
   larger than cmd->data_length.

This is simpler, does not depend on RDMA R/W API internals or RDMA
driver behavior, only adds overhead for commands with a residual and
is easy to backport.

Thanks,

Bart.

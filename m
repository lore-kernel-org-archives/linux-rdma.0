Return-Path: <SRS0=BP9/=VO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1E2C7618F
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jul 2019 14:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F4B2182B
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jul 2019 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563373434;
	bh=jpbnFRZvVJ078ffKt7kmp6lLYZE1rp2GjIutfxcdtxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kNrQc3dcHovQ3LWsca8ggiL1Y0NgCmeX50EVAJpiV7tskbZxTNbiEVD8UqTk16yDX
	 U0pIF0+8qF/dwZirNqbO0/HshCyD9XUVDpc91aiA3LdHSJSAnKYrj6Iovx15+4TG1t
	 +aq/DdZmECAu5o7W1kovWj8j9kqHET+lmcQ5kUDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfGQOXx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jul 2019 10:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfGQOXx (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 17 Jul 2019 10:23:53 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C8921743;
        Wed, 17 Jul 2019 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373432;
        bh=jpbnFRZvVJ078ffKt7kmp6lLYZE1rp2GjIutfxcdtxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0l4apvVGFpebjNz2EEC+dH/+7jMks2ByykvtGM0cIp11JjQN8UEVgBcChThGbEEi
         hKE9VI7lc+t2ntOGQuSb861PpQOfwzVxNK6myLQav4GAhyoTl1rF8P3OVZV2XndAkC
         Ennto2zcR7yRQOZzCxILM2jBGZBmbE2ihlJVPiL8=
Date:   Wed, 17 Jul 2019 17:23:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc 2/8] rdma: Add "stat qp show" support
Message-ID: <20190717142346.GO10130@mtr-leonro.mtl.com>
References: <20190710072455.9125-1-leon@kernel.org>
 <20190710072455.9125-3-leon@kernel.org>
 <20190716120128.6beab22e@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716120128.6beab22e@hermes.lan>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 16, 2019 at 12:01:28PM -0700, Stephen Hemminger wrote:
> On Wed, 10 Jul 2019 10:24:49 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > From: Mark Zhang <markz@mellanox.com>
> >
> > This patch presents link, id, task name, lqpn, as well as all sub
> > counters of a QP counter.
> > A QP counter is a dynamically allocated statistic counter that is
> > bound with one or more QPs. It has several sub-counters, each is
> > used for a different purpose.
> >
> > Examples:
> > $ rdma stat qp show
> > link mlx5_2/1 cntn 5 pid 31609 comm client.1 rx_write_requests 0
> > rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 out_of_sequence 0
> > duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0
> > implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0
> > resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
> > req_remote_access_errors 0 resp_remote_access_errors 0
> > resp_cqe_flush_error 0 req_cqe_flush_error 0
> >     LQPN: <178>
> > $ rdma stat show link rocep1s0f5/1
> > link rocep1s0f5/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 duplicate_request 0
> > rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0
> > req_cqe_error 0 req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0 resp_cqe_flush_error 0
> > req_cqe_flush_error 0 rp_cnp_ignored 0 rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0
> > $ rdma stat show link rocep1s0f5/1 -p
> > link rocep1s0f5/1
> >     rx_write_requests 0
> >     rx_read_requests 0
> >     rx_atomic_requests 0
> >     out_of_buffer 0
> >     duplicate_request 0
> >     rnr_nak_retry_err 0
> >     packet_seq_err 0
> >     implied_nak_seq_err 0
> >     local_ack_timeout_err 0
> >     resp_local_length_error 0
> >     resp_cqe_error 0
> >     req_cqe_error 0
> >     req_remote_invalid_request 0
> >     req_remote_access_errors 0
> >     resp_remote_access_errors 0
> >     resp_cqe_flush_error 0
> >     req_cqe_flush_error 0
> >     rp_cnp_ignored 0
> >     rp_cnp_handled 0
> >     np_ecn_marked_roce_packets 0
> >     np_cnp_sent 0
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  rdma/Makefile |   2 +-
> >  rdma/rdma.c   |   3 +-
> >  rdma/rdma.h   |   1 +
> >  rdma/stat.c   | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  rdma/utils.c  |   7 ++
> >  5 files changed, 279 insertions(+), 2 deletions(-)
> >  create mode 100644 rdma/stat.c
> >
>
> Headers have been merged, but this patch does not apply cleanly to current iproute2

Strange, it applied for me cleanly and latest commit in my iproute2
local repo is d035cc1b "ip tunnel: warn when changing IPv6 tunnel without tunnel name"

I will resend the series with fixed typo.

Thanks

>

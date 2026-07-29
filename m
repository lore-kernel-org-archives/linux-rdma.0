Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB1E488773;
	Wed, 29 Jul 2026 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330112; cv=none; b=d4JGD+hTtT1uTs14GjdOuHF2ha6GbDQIrcsr2HGaDBquhVOTv7y9TjxJ7YHVQgLmxsn/jgQzA+KANwR0YNoNF3nWWYacDShbiy6K3lWw5lL7NFN47DeIvjVhPpD+AlkvvbQC4ynWrELD3iwbppl/tM1QUuv2dI/iQuvGtrRn990=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330112; c=relaxed/simple;
	bh=OmWFXyTutZpGmJhegJaW5l/v27yzjx9jhmLD2UqO39A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9ZzyDuKVn51MzHDVnHP78EV1BfKYh5y51Y70vZ1PvYEHyD66QgbX9OLrfAORtm5WF60vom/r4ozgDKi5sfjW5qFj+uY8XIApiQX0ggrHmixI5UxCgEwjAkUMd2tjSu1eQUgPb8Wt6hHGFkXwGt31ERwnfHIP3/JjfMD/qrQcTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzsB5hgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzsB5hgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004D61F00A3A;
	Wed, 29 Jul 2026 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785330105;
	bh=d2iDQ/XFzSylptxqaGEPXyly087MYqpda+JKaK7wyQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lzsB5hgnmQMb7LvAz3l89TqTPTSJsCT7f/PpIv3ktX4Tvz156GYjtajDlIlhPMpEe
	 I7naZSygp8kYCtJsVrmtQgpbEbMxRshAxVhqc+Eix+sq2j6pdsX1X6pjRcKAtpNEMG
	 siHev2FOq+VkeHSWb3m6/z/2xHJ5NlVjTSCDc+2Fvs/OZx2ecHJEGHuqPHlH3SPn9t
	 2G/6FMiUL4GJYeRaWENPDjppgY2ATqrrT6SVscV3twlSrzYd3DQOxumHEx4CNKOmY2
	 9B0ZzjaQaUqROWGHsjdVIqkHr4+5l1pXkGra8M5EoQ0oMZMdOBuEd3mmy0P/LCv8fL
	 BOwf+9r8cXEoQ==
Date: Wed, 29 Jul 2026 16:01:41 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: sagi@grimberg.me, jgg@ziepe.ca, nab@linux-iscsi.org,
	michael.christie@oracle.com, martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] IB/isert: post full-feature receive buffers after
 session registration
Message-ID: <20260729130141.GN12003@unreal>
References: <20260726144213.933544-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726144213.933544-1-yhlee@isslab.korea.ac.kr>

On Sun, Jul 26, 2026 at 11:42:13PM +0900, Yehyeong Lee wrote:
> isert_put_login_tx() posts the full-feature receive buffers and then
> sends the final Login Response on the same call:
> 
> 	isert_alloc_rx_descriptors()
> 	isert_post_recvm(isert_conn, ISERT_QP_MAX_RECV_DTOS)
> 	isert_conn->state = ISER_CONN_FULL_FEATURE
> 	isert_login_post_send()
> 
> iscsi_post_login_handler() only runs after that, and it is what calls
> __transport_register_session(), which sets se_sess->se_tpg.  An
> initiator that sends a SCSI command as soon as it sees the Login
> Response can therefore have that command received, executed and
> completed before the session is registered, and target_complete()
> dereferences a NULL se_sess->se_tpg:
> 
>   Oops: general protection fault, probably for non-canonical address ...
>   KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
>   Workqueue: ib-comp-wq ib_cq_poll_work
>   RIP: 0010:target_complete_cmd_with_sense.part.0+0x17d/0xc90
>   Call Trace:
>    fd_execute_rw
>    __target_execute_cmd
>    iscsit_execute_cmd
>    iscsit_sequence_cmd
>    isert_recv_done
>    __ib_process_cq
>    ib_cq_poll_work
> 
> The command reaches the backend because transport_lookup_cmd_lun() does
> not need se_tpg on the mapped-LUN path; it uses se_sess->se_node_acl,
> which iscsit sets much earlier in iscsi_target_locate_portal().
> 
> iscsit's own RX thread does not have this problem: it is started at the
> same point but waits on conn->rx_login_comp, which is completed at the
> end of iscsi_post_login_handler(), after __transport_register_session().
> isert takes its PDUs from the completion queue instead, and
> isert_recv_done() has no connection-state check.
> 
> Post the receive buffers from isert_get_rx_pdu() instead.  That callback
> is invoked by iscsi_target_rx_thread() only after the same rx_login_comp
> wait, so the buffers become available to the HCA only once the session
> is registered.  isert_recv_done() runs on ib-comp-wq and cannot wait
> there itself.  The allocation stays in isert_put_login_tx() so that a
> memory allocation failure still cannot happen after the final Login
> Response has been sent.
> 
> rx_descs can legitimately be NULL in isert_get_rx_pdu(): the login
> timeout timer sets login->login_failed from timer context, so
> isert_put_login_tx() can skip the allocation branch while
> iscsi_target_do_login() still returns 1 and the connection reaches
> TARG_CONN_STATE_LOGGED_IN.  Return early in that case, which matches the
> existing behaviour of not posting at all on that path.
> 
> Reproduced with soft-RoCE (rdma_rxe) under KASAN using an initiator that
> issues a WRITE immediately after login, 400 login cycles per run.
> Unpatched: 9 of 10 runs oopsed.  Patched: 0 of 10.  A build carrying a
> diagnostic that reports the NULL without faulting recorded 16 hits
> across 9 of 15 runs unpatched and 0 across 15 runs patched; the two sets
> were run alternately in a single session.
> 
> Not covered by that testing: discovery sessions over iSER, MC/S
> (non-zero TSIH) logins, ERL=2 connection recovery, and real HCAs, where
> RNR behaviour differs from soft-RoCE.
> 
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> This replaces "scsi: target: Fix NULL se_tpg dereference in
> target_complete()" (target-devel, Message-ID
> 20260725165818.769963-1-yhlee@isslab.korea.ac.kr), which guarded the
> symptom in target core.  That patch is being withdrawn.
> 
>  drivers/infiniband/ulp/isert/ib_isert.c | 36 +++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 5 deletions(-)

1. Please keep commit messages concise and easy to read.
2. Include the full kernel Oops in the commit message.
3. Keep code comments to a minimum.
4. Please address Sashiko's concerns about this patch.

Thanks

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A4B13777E;
	Sun, 26 Jul 2026 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785048396; cv=none; b=G/E7fOJO/I8PeMnmC5r58366t4MW9/54G+sRjuJXiX07VO0nlUD9ENx1jM1nH6yC8uliF6LcTP5zCfW4tjqOcsOaiYuHjaGIGJ/Y/notgfeJ52w0AI62QeeAMij9vMTQw+aDtkCn4clK3XhVok2taoM1tlL6L/JEiYPKh5ugzvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785048396; c=relaxed/simple;
	bh=puxLkZoXTTJ0sgLsrsrbDATm5AU4tM0BBQlqQ0eJJro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etzLTO4gf4tFppxB+xk7aSP3cIfsn6vROJ6duRARnHTcuBPhdKA6omyoSxRHBn+u85fVjCd4Rj79WW2Y4vKZ/guCWTeBiTXb6K4/4BleReqUMCR0Z3NDwJgM055TUmHf2zwOnTwAELrGCDUDi8tWZtqM9AZZWFhEy0tkINv+Uso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCy2ONw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCy2ONw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15D51F000E9;
	Sun, 26 Jul 2026 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785048394;
	bh=uCfLJyTtGwJLCN1z+c86/wI7/uMHdIFVIdP2iElexGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XCy2ONw2j1/C+dfMjYZOMFgo3vTS+bT1uEEHXXeEEwuJvFsDyFV8qBlrrGuEBf/+C
	 cjKvX0DYBjA3ruUK2p3EJOMAaYCVoMXkl6RgH9UTn1FAeT5Sk5kemipXBujth1iFYA
	 IOW17JpkIkdpGBWVEXoBd5dBzE1exleWqlyHi44z79CpuS47KEQd8mjxcCOpB97Q7q
	 HSMWHG4Bc95thDjueCwcRM3P7bF4yq4VepDclnAk+c1MJq2UDXP/6f2q6NLNE5KAuK
	 mrSqjuqD1ZBFhtqnSYYzbS0ysoOiH8OZlBXBAHkHKMKNhAcTgPD5M9gJVU+pbGhJ72
	 3qARJMcFATONQ==
Date: Sun, 26 Jul 2026 09:46:28 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: sagi@grimberg.me, jgg@ziepe.ca, nab@linux-iscsi.org,
	linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] IB/isert: reject PDUs declaring more data than was
 received
Message-ID: <20260726064628.GA12003@unreal>
References: <20260725011846.538191-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725011846.538191-1-yhlee@isslab.korea.ac.kr>

On Sat, Jul 25, 2026 at 10:18:46AM +0900, Yehyeong Lee wrote:
> isert_recv_done() hands each received PDU to the opcode handlers without
> ever looking at wc->byte_len, the number of bytes the HCA actually placed
> in the receive descriptor. The handlers then copy that many bytes - the
> data-segment length the initiator declared in the BHS
> (ntoh24(hdr->dlength), via the derived unsol_data_len / imm_data_len) -
> out of the fixed-size descriptor:
> 
>   isert_handle_iscsi_dataout():
>         sg_copy_from_buffer(sg_start, sg_nents, isert_get_data(rx_desc),
>                             unsol_data_len);
>   isert_handle_scsi_cmd():
>         sg_copy_from_buffer(cmd->se_cmd.t_data_sg, sg_nents,
>                             isert_get_data(rx_desc), imm_data_len);
> 
> Because the declared length is never checked against wc->byte_len, an
> initiator can declare a data segment larger than the bytes it actually
> sent (and larger than the descriptor) and cause an out-of-bounds read of
> the receive buffer.
> 
> Nothing upstream of isert closes this door:
> 
>   - __iscsit_check_dataout_hdr() bounds the inbound payload against
>     conn_ops->MaxXmitDataSegmentLength (MXDSL) - a transmit parameter,
>     used here for the inbound check.
>   - iscsi_set_connection_parameters() sets
>     ops->MaxXmitDataSegmentLength = ops->TargetRecvDataSegmentLength;
>     and TARGETRECVDATASEGMENTLENGTH is absent from the min()-clamp list in
>     iscsi_check_acceptor_state(), so the value the initiator declares is
>     adopted verbatim (type range 512..16777215). The initiator effectively
>     raises its own ceiling.
>   - isert never clamps the negotiated value to its own fixed receive
>     descriptor (ISER_RX_SIZE, 9216 bytes), so the target core's bound and
>     the descriptor size are unrelated.
> 
> The imm_data_len == data_len path is more than an over-read: it aliases
> the receive descriptor via sg_set_buf() and passes it to the backend as
> the data source for the SCSI WRITE, so an over-declared length causes heap
> contents past the descriptor to be written through the backend to the
> backing store. The backend is the victim of the oversized scatterlist
> isert hands it, not the cause; no read-back of the written bytes was
> demonstrated.
> 
> Trigger: after login completes (full feature phase), an initiator that has
> declared a large TargetRecvDataSegmentLength and a FirstBurstLength that
> permits unsolicited/immediate data sends a PDU whose declared data-segment
> length exceeds what was received. With KASAN:
> 
>   BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0
>   Read of size 4096 at addr ffff888109720800 by task kworker/1:0H/25
>   Workqueue: ib-comp-wq ib_cq_poll_work
>   Call Trace:
>    sg_copy_buffer+0x150/0x1c0
>    isert_recv_done+0xba6/0x2390
>    __ib_process_cq+0xe1/0x390
>    ib_cq_poll_work+0x46/0x150
> 
> isert_recv_done+0xba6 resolves to isert_handle_iscsi_dataout()
> (ib_isert.c:1160), inlined through isert_rx_opcode().
> 
> Validate wc->byte_len against the framing in isert_recv_done() before the
> PDU reaches any handler, and reinstate the connection if it is short.
> Because the test compares without subtracting the header length, it also
> rejects PDUs shorter than the iSER and iSCSI headers, which would otherwise
> be parsed out of stale descriptor contents. The sibling login handler,
> isert_login_recv_done(), already rejects PDUs shorter than ISER_HEADERS_LEN
> (commit 29e7b925ae6d ("IB/isert: Reject login PDUs shorter than
> ISER_HEADERS_LEN")); the data handlers had no length check at all.
> 
> isert reads the data segment from a fixed offset: isert_get_data()
> returns the iSER header plus ISER_HEADERS_LEN and makes no adjustment for
> an AHS.  The bytes the handlers touch are therefore exactly
> [ISER_HEADERS_LEN, ISER_HEADERS_LEN + dlength), and comparing that sum
> against wc->byte_len bounds precisely the region that is read.  An AHS
> term would only make the test stricter without bounding anything further,
> and cannot cause a false reject: a PDU carrying an AHS is longer, not
> shorter.
> 
> This is a memory-safety fix that verifies the bytes that were actually
> received; it does not touch RFC 7145 length negotiation and is not the
> MaxXmitDataSegmentLength negotiation redesign raised in the 2017 "[Query]
> iSER-Target: QP errors observed on increasing MaxXmitDataSegmentLength"
> discussion. That redesign is explicitly out of scope here.
> 
> The patched kernel rejects the malformed DataOut PDU and both
> immediate-data variants with "PDU declares ... bytes were received" and
> continues to pass normal traffic with no regression.
> 
> Reproduced with soft-RoCE (rdma_rxe) and a raw rdma_cm/ibv initiator; no
> kernel-side test hooks were needed.
> 
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 1015a51f750a..66435a0a5c7a 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -1333,6 +1333,21 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
>  			ISER_RX_SIZE, DMA_FROM_DEVICE);
>  
> +	/*
> +	 * The data segment length declared in the BHS is attacker controlled
> +	 * and is used further down to read that many bytes out of the fixed
> +	 * size receive descriptor, so it has to be checked against the number
> +	 * of bytes that were actually received. Comparing without subtracting
> +	 * also rejects PDUs shorter than the iSER and iSCSI headers, which
> +	 * would otherwise be parsed out of stale descriptor contents.
> +	 */
> +	if (unlikely(wc->byte_len < ISER_HEADERS_LEN + ntoh24(hdr->dlength))) {
> +		isert_err("PDU declares %u data bytes but only %u bytes were received\n",
> +			  ntoh24(hdr->dlength), wc->byte_len);
> +		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
> +		return;
> +	}

1. You should review patches generated by AI.
2. There is a need to add similar check to isert_get_login_rx() too.

Something like this:

Thanks
commit ffe5e4081fa535412fdd5a685369441076a4d1e1 (HEAD -> b4/the-iser-login-handler-fails-to-vali, origin/the-iser-login-handler-fails-to-vali-v1)
Author: Leon Romanovsky <leonro@nvidia.com>
Date:   Sat Jul 25 05:40:22 2026 +0300

    IB/isert: Reject login PDUs declaring more data than received

    isert never compares the iSCSI header's 24-bit data length against the
    bytes actually received for a login PDU. A remote initiator can declare far
    more data than it sends, and before target lookup or authentication:

        isert_rx_login_req()
        iscsi_target_locate_portal()
        kmemdup_nul()

    reads ntoh24(dlength) bytes out of the fixed 8192-byte login buffer,
    overrunning it.

    Validate the declared length against the received login_req_len in both the
    initial (isert_get_login_rx()) and subsequent (isert_login_recv_done())
    login paths before any copy. Allow dlength <= login_req_len, since the
    received count may include up to three iSCSI padding bytes.

    Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
    Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 4691845bf815..02ce4cbe69a1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -970,6 +970,19 @@ isert_put_login_tx(struct iscsit_conn *conn, struct iscsi_login *login,
        return 0;
 }

+static int
+isert_check_login_req(struct isert_conn *isert_conn)
+{
+       struct iscsi_hdr *hdr =
+               (struct iscsi_hdr *)isert_get_iscsi_hdr(isert_conn->login_desc);
+       u32 dlength = ntoh24(hdr->dlength);
+
+       if (dlength > isert_conn->login_req_len)
+               return -EPROTO;
+
+       return 0;
+}
+
 static void
 isert_rx_login_req(struct isert_conn *isert_conn)
 {
@@ -1393,8 +1406,11 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
        if (isert_conn->conn) {
                struct iscsi_login *login = isert_conn->conn->conn_login;

-               if (login && !login->first_request)
+               if (login && !login->first_request) {
+                       if (isert_check_login_req(isert_conn))
+                               return;
                        isert_rx_login_req(isert_conn);
+               }
        }

        mutex_lock(&isert_conn->mutex);
@@ -2359,6 +2375,10 @@ isert_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
        if (!login->first_request)
                return 0;

+       ret = isert_check_login_req(isert_conn);
+       if (ret)
+               return ret;
+
        isert_rx_login_req(isert_conn);

        isert_info("before login_comp conn: %p\n", conn);

Thanks


> +
>  	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
>  		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
>  		 (int)(wc->byte_len - ISER_HEADERS_LEN));
> 
> base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
> -- 
> 2.43.0
> 
> 

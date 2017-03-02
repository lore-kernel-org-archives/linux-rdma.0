From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [Query] iSER-Target: QP errors observed on increasing
 MaxXmitDataSegmentLength to 16384 (default = 8192)
Date: Thu, 02 Mar 2017 02:05:50 -0800
Message-ID: <1488449150.21712.129.camel@haakon3.risingtidesystems.com>
References: <20170224091455.GA11766@chelsio.com>
         <1488443433.21712.111.camel@haakon3.risingtidesystems.com>
         <20170302090101.GA31347@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170302090101.GA31347-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-02 at 14:31 +0530, Potnuri Bharat Teja wrote:
> On Thursday, March 03/02/17, 2017 at 14:00:33 +0530, Nicholas A. Bellinger wrote:
> >    Hi Bharat & Co,
> > 
> >    Adding Jenny + Or CC', as I believe they are still the main point people
> >    for iser-target related items at Mellanox.
> > 
> >    On Fri, 2017-02-24 at 14:44 +0530, Potnuri Bharat Teja wrote:
> >    > Hi Sagi/Nicholas,
> >    >
> >    > When tried changing the MaxXmitDataSegmentLength to 16384 (default =
> >    > 8192), by changing it from targetcli on target and iscsd.conf on
> >    > initiator, I observe the following errors.
> >    >
> >    > cxgb4 0000:06:00.4: AE qpid 1024 opcode 3 status 0x6 type 0 len 0x5c
> >    wrid.hi 0x0 wrid.lo 0x136
> >    > isert: isert_qp_event_callback: QP access error (3): conn
> >    ffff8807da7b6000
> >    > Aligning ISER MaxRecvDataSegmentLength: 4096 down to PAGE_SIZE
> > 
> >    IIRC, this message in iscsi_target_login.c:iscsi_login_zero_tsih_s2()
> >    indicates the initiator presented MRDSL was either not PAGE_SIZED
> >    aligned, or less than PAGE_SIZE..
> > 
> >    Not sure why this is happening with a MRDSL=16384..? Can you confirm
> >    what MRDSL came across the wire..?
> Hi Nicholas,
> 	Thanks for the reply!
> 	I saw the same MRDSL=16384 over the wire. 
> > 
> >    This would explain the iw_cxgb4 errors about the receive buffers posted
> >    by target are insufficient for incoming data.
> > 
> >    > cxgb4 0000:06:00.4: AE qpid 1026 opcode 3 status 0x6 type 0 len 0x5c
> >    wrid.hi 0x0 wrid.lo 0x2
> >    > isert: isert_qp_event_callback: QP access error (3): conn
> >    ffff88053a2ee000
> >    >
> >    > From the error status of iw_cxgb4 the receive buffers posted by target
> >    > are unsufficient for the
> >    > incoming data to be placed/DMAed by the HW/adapter.
> >    > Apparently, from the iSER-target code the rx buffers are acclocated
> >    > for a fixed size of 8192. from isert_alloc_rx_descriptors() in
> >    > drivers/infiniband/ulp/isert/ib_isert.c
> >    >                rx_sg->length = ISER_RX_PAYLOAD_SIZE;
> >    >
> >    > I confirmed the same by increasing the ISER_RX_PAYLOAD_SIZE to 16384
> >    > and the errors arent seen.
> >    >
> > 
> >    Mmmm.
> > 
> >    > As far as i could see, from the iSER target code,
> >    > MaxXmitDataSegmentLength should not be changed according to the
> >    > targetcli/openiscsi parameters and should countinue based on iSER
> >    > specific Initiator/targetrecvdatasegmentlength and so does the
> >    > MaxrecvDatasegmentLength.
> >    >
> >    > Please let me know if my observations are right and what could be done
> >    > to fix this.
> >    >
> > 
> >    OK, it sounds like a reasonable approach to always enforce the default
> >    MXDSL=8192 from the target side.
> > 
> >    The issue of ignoring what the initiator sent for MRDSL, and always
> >    enforcing MRDSL=8192 would be OK if the initiator is presenting a MRDSL
> >    larger than 8192, but could be problematic if it is presenting a MRDSL
> >    smaller than 8192.
> > 
> >    So I think the right approach would be:
> > 
> >    - Always use MXDSL = 8192 in iser-target, regardless of what's
> >      configured by targetcli via configfs, et al.
> >    - Always honor MRDSL = 8192 in iser-target, when the initiator presents
> >      a MRDSL >= 8192 during login.
> >    - If the initiator is attempting to present a MRDSL < 8192, fail
> >      the login with ISCSI_LOGIN_STATUS_INIT_ERR
> Agreed!

After reading your email again, I may have mistaken one important bit..

If the initiator is proposing MRDSL != 8192, are there still problems
with iser-initiator hard-coded limits vs. what iser-target is actually
posting for outgoing non RDMA_WRITE transfers of != 8192..?

Or rather, does initiator proposed MRDSL != 8192 work as expected with
existing iser-initiator + iser-target code..?

If this is true and it's only a iser-target + MXDSL specific bug vs.
hard-coded ISER_RX_PAYLOAD_SIZE definitions mentioned above, then we can
avoid messing with the initiator proposed MRDSL.

If this is the case, then following (untested) patch should do the
trick.

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 303cb65..db811a6 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -427,49 +427,31 @@ static int iscsi_login_zero_tsih_s2(
 	 * Set RDMAExtensions=Yes by default for iSER enabled network portals
 	 */
 	if (iser) {
-		struct iscsi_param *param;
-		unsigned long mrdsl, off;
+		unsigned long mxdsl;
 		int rc;
 
 		if (iscsi_change_param_sprintf(conn, "RDMAExtensions=Yes"))
 			return -1;
-
 		/*
-		 * Make MaxRecvDataSegmentLength PAGE_SIZE aligned for
-		 * Immediate Data + Unsolicited Data-OUT if necessary..
+		 * Due to the hardcoded assumptions about MXDSL for iser-target
+		 * in ISER_RX_PAYLOAD_SIZE, we must always enforce the default
+		 * INITIAL_TARGETRECVDATASEGMENTLENGTH = 8192, regardless of
+		 * what this value may have been set to by user via configfs
+		 * for traditional iscsi-target operation.
 		 */
-		param = iscsi_find_param_from_key("MaxRecvDataSegmentLength",
-						  conn->param_list);
-		if (!param) {
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-			return -1;
-		}
-		rc = kstrtoul(param->value, 0, &mrdsl);
+		rc = kstrtoul(INITIAL_TARGETRECVDATASEGMENTLENGTH, 0, &mxdsl);
 		if (rc < 0) {
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 			return -1;
 		}
-		off = mrdsl % PAGE_SIZE;
-		if (!off)
-			goto check_prot;
-
-		if (mrdsl < PAGE_SIZE)
-			mrdsl = PAGE_SIZE;
-		else
-			mrdsl -= off;
-
-		pr_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
-			" to PAGE_SIZE\n", mrdsl);
-
-		if (iscsi_change_param_sprintf(conn, "MaxRecvDataSegmentLength=%lu\n", mrdsl))
+		if (iscsi_change_param_sprintf(conn, "MaxXmitDataSegmentLength=%lu\n", mxdsl))
 			return -1;
+
 		/*
 		 * ISER currently requires that ImmediateData + Unsolicited
 		 * Data be disabled when protection / signature MRs are enabled.
 		 */
-check_prot:
 		if (sess->se_sess->sup_prot_ops &
 		   (TARGET_PROT_DOUT_STRIP | TARGET_PROT_DOUT_PASS |
 		    TARGET_PROT_DOUT_INSERT)) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

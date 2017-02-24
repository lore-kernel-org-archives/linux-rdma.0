From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [Query] iSER-Target: QP errors observed on increasing
 MaxXmitDataSegmentLength to 16384 (default = 8192)
Date: Fri, 24 Feb 2017 14:44:56 +0530
Message-ID: <20170224091455.GA11766@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sagi/Nicholas,

When tried changing the MaxXmitDataSegmentLength to 16384 (default = 8192), by changing it from targetcli on target and iscsd.conf on initiator, I observe the following errors.

cxgb4 0000:06:00.4: AE qpid 1024 opcode 3 status 0x6 type 0 len 0x5c wrid.hi 0x0 wrid.lo 0x136
isert: isert_qp_event_callback: QP access error (3): conn ffff8807da7b6000
Aligning ISER MaxRecvDataSegmentLength: 4096 down to PAGE_SIZE
cxgb4 0000:06:00.4: AE qpid 1026 opcode 3 status 0x6 type 0 len 0x5c wrid.hi 0x0 wrid.lo 0x2
isert: isert_qp_event_callback: QP access error (3): conn ffff88053a2ee000

>From the error status of iw_cxgb4 the receive buffers posted by target are unsufficient for the
incoming data to be placed/DMAed by the HW/adapter.
Apparently, from the iSER-target code the rx buffers are acclocated for a fixed size of 8192. from isert_alloc_rx_descriptors() in drivers/infiniband/ulp/isert/ib_isert.c 
		rx_sg->length = ISER_RX_PAYLOAD_SIZE;

I confirmed the same by increasing the ISER_RX_PAYLOAD_SIZE to 16384 and the errors arent seen.

As far as i could see, from the iSER target code, MaxXmitDataSegmentLength should not be changed according to the targetcli/openiscsi parameters and should countinue based on iSER specific Initiator/targetrecvdatasegmentlength and so does the MaxrecvDatasegmentLength.

Please let me know if my observations are right and what could be done to fix this.

Thanks for your time.

Bharat.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

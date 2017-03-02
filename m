From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: [Query] iSER-Target: QP errors observed on increasing
 MaxXmitDataSegmentLength to 16384 (default = 8192)
Date: Thu, 2 Mar 2017 14:31:02 +0530
Message-ID: <20170302090101.GA31347@chelsio.com>
References: <20170224091455.GA11766@chelsio.com>
 <1488443433.21712.111.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488443433.21712.111.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "sagi@grimberg.me" <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, SWise OGC <swise@opengridcomputing.com>, Raju Rangoju <rajur@chelsio.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thursday, March 03/02/17, 2017 at 14:00:33 +0530, Nicholas A. Bellinger wrote:
>    Hi Bharat & Co,
> 
>    Adding Jenny + Or CC', as I believe they are still the main point people
>    for iser-target related items at Mellanox.
> 
>    On Fri, 2017-02-24 at 14:44 +0530, Potnuri Bharat Teja wrote:
>    > Hi Sagi/Nicholas,
>    >
>    > When tried changing the MaxXmitDataSegmentLength to 16384 (default =
>    > 8192), by changing it from targetcli on target and iscsd.conf on
>    > initiator, I observe the following errors.
>    >
>    > cxgb4 0000:06:00.4: AE qpid 1024 opcode 3 status 0x6 type 0 len 0x5c
>    wrid.hi 0x0 wrid.lo 0x136
>    > isert: isert_qp_event_callback: QP access error (3): conn
>    ffff8807da7b6000
>    > Aligning ISER MaxRecvDataSegmentLength: 4096 down to PAGE_SIZE
> 
>    IIRC, this message in iscsi_target_login.c:iscsi_login_zero_tsih_s2()
>    indicates the initiator presented MRDSL was either not PAGE_SIZED
>    aligned, or less than PAGE_SIZE..
> 
>    Not sure why this is happening with a MRDSL=16384..? Can you confirm
>    what MRDSL came across the wire..?
Hi Nicholas,
	Thanks for the reply!
	I saw the same MRDSL=16384 over the wire. 
> 
>    This would explain the iw_cxgb4 errors about the receive buffers posted
>    by target are insufficient for incoming data.
> 
>    > cxgb4 0000:06:00.4: AE qpid 1026 opcode 3 status 0x6 type 0 len 0x5c
>    wrid.hi 0x0 wrid.lo 0x2
>    > isert: isert_qp_event_callback: QP access error (3): conn
>    ffff88053a2ee000
>    >
>    > From the error status of iw_cxgb4 the receive buffers posted by target
>    > are unsufficient for the
>    > incoming data to be placed/DMAed by the HW/adapter.
>    > Apparently, from the iSER-target code the rx buffers are acclocated
>    > for a fixed size of 8192. from isert_alloc_rx_descriptors() in
>    > drivers/infiniband/ulp/isert/ib_isert.c
>    >                rx_sg->length = ISER_RX_PAYLOAD_SIZE;
>    >
>    > I confirmed the same by increasing the ISER_RX_PAYLOAD_SIZE to 16384
>    > and the errors arent seen.
>    >
> 
>    Mmmm.
> 
>    > As far as i could see, from the iSER target code,
>    > MaxXmitDataSegmentLength should not be changed according to the
>    > targetcli/openiscsi parameters and should countinue based on iSER
>    > specific Initiator/targetrecvdatasegmentlength and so does the
>    > MaxrecvDatasegmentLength.
>    >
>    > Please let me know if my observations are right and what could be done
>    > to fix this.
>    >
> 
>    OK, it sounds like a reasonable approach to always enforce the default
>    MXDSL=8192 from the target side.
> 
>    The issue of ignoring what the initiator sent for MRDSL, and always
>    enforcing MRDSL=8192 would be OK if the initiator is presenting a MRDSL
>    larger than 8192, but could be problematic if it is presenting a MRDSL
>    smaller than 8192.
> 
>    So I think the right approach would be:
> 
>    - Always use MXDSL = 8192 in iser-target, regardless of what's
>      configured by targetcli via configfs, et al.
>    - Always honor MRDSL = 8192 in iser-target, when the initiator presents
>      a MRDSL >= 8192 during login.
>    - If the initiator is attempting to present a MRDSL < 8192, fail
>      the login with ISCSI_LOGIN_STATUS_INIT_ERR
Agreed!
> 
>    Jenny + Or, WDYT..?

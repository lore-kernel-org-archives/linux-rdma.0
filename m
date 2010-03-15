From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: broken support for UC in rdma_cm
Date: Mon, 15 Mar 2010 20:48:02 +0200
Message-ID: <20100315184802.GA355@mtldesk030.lab.mtl.com>
References: <20100315111228.GC23358@mtldesk030.lab.mtl.com>
	<20100315134527.GA31210@mtldesk030.lab.mtl.com>
	<7E151C5823FF4048B15DCA15845BB0EB@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E151C5823FF4048B15DCA15845BB0EB-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 15, 2010 at 08:38:00AM -0700, Sean Hefty wrote:
> 
> This is really a new feature request, which I may not have time to address.  It
> depends on the scope of the changes that are needed.
> 
> If both sides try using UC QPs, do you know what specific setting causes the
> connection to fail?

The actual failure is to modify the QP from init to rtr since the
attribute mask sets IB_QP_MAX_DEST_RD_ATOMIC and IB_QP_MIN_RNR_TIMER
which are invalid attributes in UC. The flags are set in
cm_init_qp_rtr_attr() since the transport is IB_QPT_RC. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

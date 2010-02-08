From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH] [for-2.6.33] rdma/cm: disallow loopback address for	iwarp devices
Date: Mon, 08 Feb 2010 08:52:10 -0800
Message-ID: <adawrynwtz9.fsf@roland-alpha.cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
	<4B6C498F.3060708@opengridcomputing.com>
	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>
	<4B6D9948.6040007@opengridcomputing.com>
	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>
	<4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B701FE6.60302-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 08 Feb 2010 08:29:58 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > This patch doesn't solve the openmpi/IB regression.   So for OFED,
 > IMO, we need a different patch...

If this doesn't solve the regression the we should have a different
patch for upstream too.  The goal for 2.6.33 should be to keep open mpi
working, even if that requires us to go back to old breakage.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

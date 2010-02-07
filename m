From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] bug 1918 - openmpi broken due to rdma-cm changes
Date: Sun, 07 Feb 2010 08:48:44 -0800
Message-ID: <ada4oltxa8j.fsf@roland-alpha.cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
	<4B6C498F.3060708@opengridcomputing.com>
	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>
	<4B6D9948.6040007@opengridcomputing.com>
	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
	<4B6E15C4.9020703@opengridcomputing.com>
	<4B6EAA5F.1000208@mellanox.co.il>
	<4B6EECBE.6020509@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6EECBE.6020509-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Sun, 07 Feb 2010 10:39:26 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > My point, though, is that even with this patch in ofed-1.5.1, we still
 > have an openmpi/IB/rdmacm regression.  The only way to avoid this
 > regression without changing openmpi is to disallow _all_ rdma binds to
 > 127.0.0.1.

Can you identify the source of the regression?  ie what was the change
that broke things?

I'm most concerned that there is another regression in 2.6.33, and if so
I would like to try and avoid letting that get into the final release.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH] mlx4_core: request MSIX vectors as much as there CPU	cores
Date: Wed, 05 May 2010 12:51:19 -0700
Message-ID: <adaaasejfew.fsf@roland-alpha.cisco.com>
References: <20100505113047.GA12242@mtldesk030.lab.mtl.com>
	<adahbmmpfep.fsf@roland-alpha.cisco.com>
	<20100505163252.GG15969@obsidianresearch.com>
	<4BE1C82F.4000009@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE1C82F.4000009-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> (Tziporet Koren's message of
	"Wed, 05 May 2010 22:34:07 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > We found it in performance work of our EN (10G) driver

What does this have to do with performance?

Do you have a system where num_possible_cpus() differs significantly
from num_online_cpus()?  What kernel is that with?  As far as I can
tell, for x86 they should only be different if there genuinely are CPUs
that are available for hotplug.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

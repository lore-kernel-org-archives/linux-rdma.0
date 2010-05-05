From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 01/11] ib core: Add link layer property to ports
Date: Wed, 05 May 2010 15:19:50 -0700
Message-ID: <adavdb2at4p.fsf@roland-alpha.cisco.com>
References: <20100218172335.GB12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172335.GB12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:23:35 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

I'm hoping to get this IBoE stuff in for 2.6.35.  I started an "iboe"
branch in my tree (similar to the xrc branch I've been carrying for a
while), and I added this patch in, except I renamed
rdma_port_link_layer() to rdma_port_get_link_layer().  This seems to
match rdma_node_get_transport() better.

In any case as I add patches to my branch, you can stop worrying about
them, which should make keeping this series updated easier.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

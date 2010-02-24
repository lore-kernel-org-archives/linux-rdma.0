From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add new device IDs for ConnectX VPI HCAs
Date: Wed, 24 Feb 2010 14:07:20 -0800
Message-ID: <adazl2yxp7r.fsf@roland-alpha.cisco.com>
References: <20100208140455.GA24593@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100208140455.GA24593@vlad-laptop> (Vladimir Sokolovsky's
	message of "Mon, 8 Feb 2010 16:04:55 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +	HCA(MELLANOX, 0x6746),	/* MT26438 ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE Virt+ */

The kernel calls this device ID "MT26438 ConnectX EN 40GigE PCIe gen2
5GT/s".  Maybe we should just delete these comments, since we can't seem
to get them right?

 > +	HCA(MELLANOX, 0x6778),	/* MT26488 ConnectX VPI PCIe 2.0 5GT/s - IB DDR / 10GigE Virt+ */

Are we missing a kernel patch?  I don't see this device ID in the kernel
driver.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

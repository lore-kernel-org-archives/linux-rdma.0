From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add new device IDs for ConnectX VPI HCAs
Date: Thu, 25 Feb 2010 15:28:16 -0800
Message-ID: <adapr3sx5db.fsf@roland-alpha.cisco.com>
References: <20100208140455.GA24593@vlad-laptop>
	<adazl2yxp7r.fsf@roland-alpha.cisco.com>
	<20100225210850.GA26139@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100225210850.GA26139-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Thu, 25 Feb 2010 23:08:50 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > The kernel calls this device ID "MT26438 ConnectX EN 40GigE PCIe gen2
 > > 5GT/s".  Maybe we should just delete these comments, since we can't seem
 > > to get them right?
 > 
 > I guess it would be best if we take the description from
 > http://pciids.sourceforge.net/v2.2/pci.ids

I wonder whether it's really worth having the text at all.  Maybe it's a
bit useful, I'm not sure.  But the pciids text could probably use some
cleaning up, eg:

	634a  MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE]
	6368  MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s]

it would be nice to decide on a standard order of whether the PCIe or
the network info comes first.

And then to make things even better we have:

		103c 3313  HP NC542m Dual Port Flex-10 10GbE BLc Adapter

so we can't even decide on 10GigE vs. 10GbE.

But yeah, patches to get the ID list into shape with at least the right
list of device IDs for kernel and userspace would be welcome.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

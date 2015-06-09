From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Mon, 8 Jun 2015 23:20:54 -0700
Message-ID: <20150609062054.GA13011@infradead.org>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <20150608132254.GA14773@infradead.org>
 <55759B0B.8050805@mellanox.com>
 <20150608135151.GA14021@infradead.org>
 <5575A9C7.7000409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5575A9C7.7000409-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 05:42:15PM +0300, Sagi Grimberg wrote:
> I wouldn't say this is about offloading bounce buffering to silicon.
> The RDMA stack always imposed the alignment limitation as we can only
> give a page lists to the devices. Other drivers (qlogic/emulex FC
> drivers for example), use an _arbitrary_ SG lists where each element can
> point to any {addr, len}.

Those are drivers for protocols that support real SG lists.   It seems
only Infiniband and NVMe expose this silly limit.

> >So please fix it in the proper layers
> >first,
> 
> I agree that we can take care of bounce buffering in the block layer
> (or scsi for SG_IO) if the driver doesn't want to see any type of
> unaligned SG lists.
> 
> But do you think that it should come before the stack can support this?

Yes, absolutely.  The other thing that needs to come first is a proper
abstraction for MRs instead of hacking another type into all drivers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

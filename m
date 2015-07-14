From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: kernel memory registration
Date: Tue, 14 Jul 2015 11:24:29 -0600
Message-ID: <20150714172429.GA24403@obsidianresearch.com>
References: <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <559F8881.7070308@dev.mellanox.co.il>
 <20150711103153.GC14741@infradead.org>
 <20150713164652.GC23832@obsidianresearch.com>
 <55A4C73A.7080001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A4C73A.7080001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 11:24:26AM +0300, Sagi Grimberg wrote:
> 
> >
> >>Having a few schemes availabe in the core code that the driver can chose
> >>from seems like a much more sensible option.
> >
> >I think that makes sense, but several of the schemes we are working
> >with are effectively single-vendor schemes. Indirect MR and DIX are
> >good examples of things that only one vendor implements, and are not
> >standardized.
> >
> >In those cases it is hard to argue the core should provide support for
> >them.
> 
> I'm sorry but I disagree with the statement above. T10-DIF/DIX is a
> standard and *not* a vendor specific feature. Other storage protocols
> (FC, SAS, NVME) fully support it. So yes, the core *needs* to support it.

Sorry, I ment the exact details of how DIX is exposed through verbs is
only implemented by one vendor (eg IB_WR_REG_SIG_MR).

The core absolutely should provide an API for this, I'm not convinced
it should be at the MR level though....

> Moreover, the core stack poses memory alignment limitations for
> registration. The RDMA stack should allow an interface that can resolve
> these limitations if the device is capable of handling them. I'd say
> this is something all vendors should look at.

Sure would be nice..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib/cm: Change reject message type when destroying cm_id
Date: Tue, 19 May 2015 12:14:57 -0600
Message-ID: <20150519181457.GD18675@obsidianresearch.com>
References: <1431632941-3430-1-git-send-email-sean.hefty@intel.com>
 <1431708034.29187.14.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDBF8D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDBF8D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 15, 2015 at 05:06:52PM +0000, Hefty, Sean wrote:
> > Are you proposing for 4.1-rc?
> 
> The code has been this way forever, so IMO 4.2 should be fine.

Yes, but surely we want this backported to -stable and distros? It
isn't tagged for that..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

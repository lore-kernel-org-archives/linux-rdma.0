From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/cm: Change reject message type when destroying cm_id
Date: Tue, 19 May 2015 18:25:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDD131@ORSMSX109.amr.corp.intel.com>
References: <1431632941-3430-1-git-send-email-sean.hefty@intel.com>
 <1431708034.29187.14.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDBF8D@ORSMSX109.amr.corp.intel.com>
 <20150519181457.GD18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519181457.GD18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, but surely we want this backported to -stable and distros? It
> isn't tagged for that..

I don't think that the problem justifies backporting the patch.  The passive side drops the reject, which could have happened anyway, and gets a reject message when sending a REP.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

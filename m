From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Mon, 1 Jun 2015 11:29:29 -0600
Message-ID: <20150601172929.GA17715@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433178057.114391.208.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433178057.114391.208.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 01, 2015 at 01:00:57PM -0400, Doug Ledford wrote:
> > case for this feature, generalizing too much may destroy the
> > performance that is valuable here.
 
> I'm not convinced of that.  Steve has already spoke up about the
> timestamps available in cxgb4.  Those are very different and yet still
> highly valuable to someone investigating performance of their RDMA
> application.

? cxgb4 looks nearly identical to me. There is only one HW time stamp
'cqe_sge_ts', which occurs at some point in the flow, and is written
the CQE. The current cycle counter can be read from SGE_TIMESTAMP_LO
registers. Same as mlx4, really.

The rest is just bookkeeping and logging that doesn't require special
verbs support for an app to implement.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

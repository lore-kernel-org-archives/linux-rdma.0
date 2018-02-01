From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] IB/hfi1: Minor and misc bug fixes
Date: Thu, 1 Feb 2018 15:51:18 -0700
Message-ID: <20180201225118.GF8590@ziepe.ca>
References: <20180201184921.7300.11118.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201184921.7300.11118.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bartlomiej Dudek <bartlomiej.dudek-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 10:52:11AM -0800, Dennis Dalessandro wrote:
> Hi Jason and Doug,
> 
> Here are some fixes for minor issues. Minor in terms of severity, not
> necessarily in terms of complexity. The diffstat for mad.c in particular looks
> pretty bad but it's basically changing the units being used from cycle time to
> flit time.
> 
> This is a resubmit of my previous patch set [1] broken up into smaller logically
> grouped patch sets.
> 
> As always my GitHub had these in-tree for context:
> https://github.com/ddalessa/kernel/tree/for-4.16
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg60011.html
> 
> 
> Bartlomiej Dudek (1):
>       IB/hfi1: Do not override given pcie_pset value
> 
> Kamenee Arumugam (1):
>       IB/hfi1: Convert PortXmitWait/PortVLXmitWait counters to flit times
> 
> Mike Marciniszyn (1):
>       IB/hfi1: Remove blind constants from 16B update
> 
> Mitko Haralanov (1):
>       IB/hfi1: Show fault stats in both TX and RX directions

Applied to for-next, thanks,

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

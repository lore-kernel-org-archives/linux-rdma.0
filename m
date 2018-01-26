From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Fri, 26 Jan 2018 09:05:53 -0700
Message-ID: <20180126160553.GC23869@ziepe.ca>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
 <20180125201023.GA9162@ziepe.ca>
 <20180125202710.GS1393@mtr-leonro.local>
 <20180125210026.GA10719@ziepe.ca>
 <20180125211831.GT1393@mtr-leonro.local>
 <20180125215716.GA11537@ziepe.ca>
 <20180126062423.GV1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126062423.GV1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 26, 2018 at 08:24:23AM +0200, Leon Romanovsky wrote:

> > I've often thought I'd like a helper type that had the kref+complete
> > semantics, because that does seem to crop up in a few places and it
> > would really help clarity.
> 
> Actually, it is used a lot, one of closest examples to us - qib sdma
> kref counting.

Looks like it has the same race bug between the put and
wait_for_completion compared to the async sdma_sw_clean_up_task. Needs
the 'get if not zero' approach too.

Kinda proves my point right? People using krefs for this get it wrong
because it DOESN'T follow well understood kref semantics, because it
ISN'T a kref - it a usecount.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Thu, 12 Nov 2009 13:51:40 PST
Message-ID: <47893.1258062700@asomi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org







>On Thu Nov 12 12:43 , David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org> wrote:See section 4 in the paper called "High Performance RDMA Based MPI Implementation over InfiniBand" on the MVAPICH web page for description of one implementation that polls on data buffers.  Specifically, look at text around the statement "Although the approach uses the in-order implementation of hardware for RDMA write which is not specified in the InfiniBand standard, this feature is very likely to be kept by different hardware designers."  Although this paper is describing a PCI-X implementation, the feature is also exists on PCIe.
>
>It's assumed that the host memory interconnect complies with statements described in the "Update Ordering and Granularity Provided by a Write Transaction" of the PCI spec.  This particular application depends on PCI WRITE behavior, not READ.
>
>Does this help?
>

A simplified way of looking at this requirement is that the last N bytes of the RDMA Write payload require the same ordering guarantees as a CQE would have had.

This is of course ironic since the technique was developed to avoid the overhead of the CQ.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

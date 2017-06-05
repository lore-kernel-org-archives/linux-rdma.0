From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Mon, 5 Jun 2017 17:11:18 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1706051705350.886@east.gentwo.org>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com> <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org> <20170605170825.GP6868@mtr-leonro.local> <20170605171749.GA20477@obsidianresearch.com>
 <20170605174151.GR6868@mtr-leonro.local>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605174151.GR6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 5 Jun 2017, Leon Romanovsky wrote:

> It is rough calculation for 1MB, when I asked Ahmad about this
> limitation (4K) he explained to me that exposed device memory is less
> than 1MB.

Still doesnt that mean more than 256 MPI instances or so per node?

The use case for a semaphore indicates that a 4k page would be
shared between multiple processes? Therefore there is even less of a need
of multiple pages.

You may not be able to avoid the 4k page since page
protection works only on a 4k level. The kernel futexes rely on 4k page
protection tricks.

Please come up with a reasonable use case here.... We do not run MPI but
our use cases work fine with mmapped 4k pages. There are some who actually
would like 2M pages for that use case since some of the adapters have
quite a bit of memory available.

A small object allocator with the need to go through an intermediate
layer seems to be not very productive.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

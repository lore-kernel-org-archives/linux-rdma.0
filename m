From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 00:10:41 -0700
Message-ID: <20170606071040.GA8693@infradead.org>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1706051141230.26831-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 05, 2017 at 11:44:00AM -0500, Christoph Lameter wrote:
> On Wed, 10 May 2017, ahmad omary wrote:
> 
> > We have considered using mmap(), but As the size of device memory may be limited
> > ,the way to access it from host cpu may differ from vendor to vendor, due to
> > the 4K (page) aligment limitation of mmap() and the need not to directly
> > allow user to access the device memory, there is a need for a wrapper access
> > methods API that allows allocating and managing chunks that are smaller than
> > 4KB and not necessarily aligned to 4KB (page size).
> 
> Why are 4k sized chunks a problem given that there are megabytes of memory
> in these devices? We are using various adapters already with an mmapped
> solution here.
> 
> And I would prefer direct user space access to the memory. Fast access to
> the data stored in the NIC is important and it would be best not to have
> an intermediate layer that requires memcpy.

Agreed.  The current design looks incredibly stupid.  Also makes sure
it works with the cxgb4 version of this feature that has been posted
as part of the NVMe P2P patches.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

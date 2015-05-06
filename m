From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Wed, 6 May 2015 10:38:03 -0600
Message-ID: <20150506163803.GB11331@obsidianresearch.com>
References: <20150505154411.GA16729@infradead.org>
 <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
 <20150505172540.GA19442@infradead.org>
 <55490886.4070502@talpey.com>
 <20150505191012.GA21164@infradead.org>
 <55492ED3.7000507@talpey.com>
 <20150505210627.GA5941@infradead.org>
 <554936E5.80607@talpey.com>
 <20150505223855.GA7696@obsidianresearch.com>
 <5549BC33.30905@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5549BC33.30905-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 06, 2015 at 09:01:07AM +0200, Bart Van Assche wrote:
> On 05/06/15 00:38, Jason Gunthorpe wrote:
> >Heck, on modern systems 100% of these requirements can be solved just
> >by using the IOMMU. No need for the HCA at all. (HCA may be more
> >performant, of course)
> 
> Hello Jason,
> 
> Any performance tests I have run so far with the IOMMU enabled show
> much worse results than the same test with the IOMMU disabled. The
> perf tool learned me that this performance difference is due to lock
> contention caused by the IOMMU kernel code. I have not yet tried to
> verify whether this is an implementation issue or something
> fundamental.

I'm not surprised, I think that is well known.

Just to be clear I'm not saying we should rely on the IOMMU, or even
implement anything that uses it - but as a thought exercise, the fact
we could implement a page list API entirely with the dumbest HCA and
the IOMMU suggests strongly to me it is a sane API direction to look
at.

If you did have a dumb HCA, using the IOMMU is probably alot faster
that doing a heavy MR registration or doing operations 'page at a
time'. Which would be slower than using a smart HCA with the
IOMMU turned off, for that work load.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

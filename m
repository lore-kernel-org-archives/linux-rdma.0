From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Tue, 5 May 2015 16:38:55 -0600
Message-ID: <20150505223855.GA7696@obsidianresearch.com>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net>
 <20150505154411.GA16729@infradead.org>
 <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
 <20150505172540.GA19442@infradead.org>
 <55490886.4070502@talpey.com>
 <20150505191012.GA21164@infradead.org>
 <55492ED3.7000507@talpey.com>
 <20150505210627.GA5941@infradead.org>
 <554936E5.80607@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <554936E5.80607-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 05, 2015 at 05:32:21PM -0400, Tom Talpey wrote:

> >Do you have any information on these attempts and why the failed?  Note
> >that the only interesting ones would be for in-kernel consumers.
> >Userspace verbs are another order of magnitude more problems, so they're
> >not too interesting.
> 
> Hmm, most of these are userspace API experiences, and I would not be
> so quick as to dismiss their applicability, or their lessons.

The specific use-case of a RDMA to/from a logical linear region broken
up into HW pages is incredibly kernel specific, and very friendly to
hardware support.

Heck, on modern systems 100% of these requirements can be solved just
by using the IOMMU. No need for the HCA at all. (HCA may be more
performant, of course)

This is a huge pain for everyone. ie The Lustre devs were talking
about how Lustre is not performant on newer HCAs because their code
doesn't support the new MR scheme.

It makes sense to me to have a dedicated API for this work load:

'post outbound rdma send/write of page region'
'prepare inbound rdma write of page region'
'post rdma read, result into page region'
'complete X'

I'd love to see someone propose some patches :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

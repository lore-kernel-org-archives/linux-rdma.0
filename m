From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Tue, 5 May 2015 12:10:12 -0700
Message-ID: <20150505191012.GA21164@infradead.org>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net>
 <20150505154411.GA16729@infradead.org>
 <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
 <20150505172540.GA19442@infradead.org>
 <55490886.4070502@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55490886.4070502-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 05, 2015 at 02:14:30PM -0400, Tom Talpey wrote:
> As you might guess, I can go on at length about this. :-) But, if
> you have a kernel service, the ability to pin memory, and you
> want it to go fast, you want FRWR.

Basically most in-kernel consumers seem to have the same requirements:

 - register a struct page, which can be kernel or user memory (it's
   probably pinned in your Terms, but we don't really use that much in
   kernelspace).
 - In many but not all cases we might need an offset/length for each
   page (think struct bvec, paged sk_buffs, or scatterlists of some
   sort), in other an offset/len for the whole set of pages is fine,
   but that's a superset of the one above.
 - we usually want it to be as fast as possible

While my grep skills aren't the best I can't really find an in-kernel
user that doesn't fit the above, although I might have missed some
long-term registrations where we don't really care about the fast
part.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

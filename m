From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Mon, 17 Aug 2015 00:20:14 -0700
Message-ID: <20150817072014.GA13328@infradead.org>
References: <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
 <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com>
 <20150807063637.GE31458@infradead.org>
 <72E34077-7332-4F7D-8498-E67E7192CD2A@oracle.com>
 <20150807141929.GA12442@infradead.org>
 <55CBF6C1.8010803@redhat.com>
 <79BCB01F-AD69-4BEB-8F03-F5A52701211E@oracle.com>
 <20150813055450.GA19344@infradead.org>
 <55CC9682.1020203@redhat.com>
 <20150813160439.GA32690@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150813160439.GA32690-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 13, 2015 at 09:04:39AM -0700, Christoph Hellwig wrote:
> > > I'm happy to do that if you're fine with the patch in general.  amso1100
> > > should be trivial anyway, while ipath is a mess, just like the new intel
> > > driver with the third copy of the soft ib stack.
> > 
> > Correct.
> 
> http://git.infradead.org/users/hch/rdma.git/commitdiff/efb2b0f21645b9caabcce955481ab6966e52ad90
> 
> contains the updates for ipath and amso1100, as well as the reviewed-by
> and tested-by tags.
> 
> Note that for now I've skipped the new intel hfi1 driver as updating
> two of the soft ib codebases already was tiresome enough.

Doug, is this good enough for merging?

http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/wr-cleanup

is my always uptodate branch, it has collected all the reviews and
tested-by tag I got on the list.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

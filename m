From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Wed, 12 Aug 2015 22:54:50 -0700
Message-ID: <20150813055450.GA19344@infradead.org>
References: <20150806162438.GA27608@infradead.org>
 <55C393A0.6000002@opengridcomputing.com>
 <20150806173143.GA25497@infradead.org>
 <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
 <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com>
 <20150807063637.GE31458@infradead.org>
 <72E34077-7332-4F7D-8498-E67E7192CD2A@oracle.com>
 <20150807141929.GA12442@infradead.org>
 <55CBF6C1.8010803@redhat.com>
 <79BCB01F-AD69-4BEB-8F03-F5A52701211E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <79BCB01F-AD69-4BEB-8F03-F5A52701211E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 12, 2015 at 07:24:44PM -0700, Chuck Lever wrote:
> That makes sense, but you already Acked the change that breaks Lustre,
> and it's going in through the NFS tree. Are you changing that to a NAK?

It seems like Doug was mostly concened about to be removed drivers.
I defintively refuse to fix Lustre for anything I tough because it's
such a giant mess with uses just about every major subsystem in
an incorrect way.

Doug:  was your mail a request to fix up the two de-staged drivers?
I'm happy to do that if you're fine with the patch in general.  amso1100
should be trivial anyway, while ipath is a mess, just like the new intel
driver with the third copy of the soft ib stack.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

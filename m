From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 13 Aug 2015 10:53:54 -0700
Message-ID: <20150813175354.GA4566@infradead.org>
References: <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com>
 <20150807063637.GE31458@infradead.org>
 <72E34077-7332-4F7D-8498-E67E7192CD2A@oracle.com>
 <20150807141929.GA12442@infradead.org>
 <55CBF6C1.8010803@redhat.com>
 <79BCB01F-AD69-4BEB-8F03-F5A52701211E@oracle.com>
 <20150813055450.GA19344@infradead.org>
 <55CC9682.1020203@redhat.com>
 <20150813160439.GA32690@infradead.org>
 <20150813172234.GB13535@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150813172234.GB13535-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 13, 2015 at 11:22:34AM -0600, Jason Gunthorpe wrote:
> The uverbs change needs to drop/move the original kmalloc:
> 
> 		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
> 			       user_wr->num_sge * sizeof (struct ib_sge),
> 			       GFP_KERNEL);
> 
> It looks like it is leaking that allocation right now. Every path
> replaces next with the result of alloc_mr..

Thanks.  It should be come and indeed was in my first version.  Not
sure how it sneaked in during a rebase.

> Noticed a couple of trailing whitespaces too..

checkpatch found two of them, which I've fixed now.

New version at:

http://git.infradead.org/users/hch/rdma.git/commitdiff/5d7e6fa563dae32d4b6f63e29e3795717a545f11

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Fri, 15 Jun 2012 11:19:19 -0600
Message-ID: <20120615171919.GA17224@obsidianresearch.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com>
 <20120614172245.GC6552@obsidianresearch.com>
 <alpine.LRH.2.00.1206142336220.13728@oc4747053027.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1206142336220.13728-Nzfcc2Us4m+Xfo/+vza+31aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2012 at 11:48:09PM -0700, Vivek Kashyap wrote:
> >I don't think anyone ever made patches for this, but considering the
> >performance delta you see it really seems worthwhile.
> 
> How about something like below? Basically the the 'checksum-less'
> operation is only between hosts that both support it by extending
> the existing IB connection setup mechanism. The following also keeps
> the changes confined to ipoib-cm module.

It is much better to do things properly (as I described) so you don't
have a gotcha when a packet gets routed.

We don't want to fake that we are doing csum, we want to forward the
csum offload data to the other side, which might discard it or might
use it to forward the packet out another interface. This is not hard,
just fiddly work.

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

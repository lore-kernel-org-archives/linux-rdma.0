From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Tue, 7 Jun 2016 15:28:31 -0600
Message-ID: <20160607212831.GA9192@obsidianresearch.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194732.18401.71941.stgit@manet.1015granger.net>
 <20160607204941.GA7991@obsidianresearch.com>
 <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F1820E16-A2BF-4529-A5C9-59C9AD57369A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 07, 2016 at 05:09:47PM -0400, Chuck Lever wrote:

> > Either the number in queue is limited by the invalidation
> > synchronization point to 2, or in the case of iwarp read, it doesn't
> > matter since everything executes serially in order and the value can
> > safely wrap.
> 
> I don't understand this. How does invalidation prevent
> the ULP from registering more R_keys?

The ULP doesn't 'register' rkeys, it only changes the active RKey assigned
to a MR. The number of active rkeys is strictly limited to the number
of available MRs.

Further changing the rkey can only be done as part of an invalidate
cycle.

Invaliding a MR/RKey can only happen after synchronization with the
remote.

So the work queue looks broadly like this:

WR setup rkey 1
WR send rkey 1 to remote
<synchronize>
WR invalidate rkey 1
WR setup rkey 2
WR send rkey 2 to remote
<synchronize>

Thus the WR queue can never have more than 2 rkey's per MR in it at
any time, and there is no need to care about the 24/8 bit split.

> And, I'd like to limit the number of pre-allocated MRs
> to no more than each transport endpoint can use. For
> xprtrdma, a transport is one QP and PD. What is that
> number?

I'm not sure I understand this question. AFAIK there is no limit on
MRs that can be used with a QP. As long as the MR is allocated you can
use it.

Typically you'd allocate enough MRs to handle your typical case
concurrancy level (pipeline depth).

The concurrancy level is limited by lots of things, for instance the
max number of posted recv's typically places a hard upper limit.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

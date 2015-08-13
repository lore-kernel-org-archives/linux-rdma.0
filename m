From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Wed, 12 Aug 2015 19:24:44 -0700
Message-ID: <79BCB01F-AD69-4BEB-8F03-F5A52701211E@oracle.com>
References: <20150804143447.GA22172@infradead.org> <20150806162438.GA27608@infradead.org> <55C393A0.6000002@opengridcomputing.com> <20150806173143.GA25497@infradead.org> <003601d0d06f$93107160$b9315420$@opengridcomputing.com> <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com> <20150807063637.GE31458@infradead.org> <72E34077-7332-4F7D-8498-E67E7192CD2A@oracle.com> <20150807141929.GA12442@infradead.org> <55CBF6C1.8010803@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CBF6C1.8010803-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Aug 12, 2015, at 6:45 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> On 08/07/2015 10:19 AM, Christoph Hellwig wrote:
>>> On Fri, Aug 07, 2015 at 10:17:18AM -0400, Chuck Lever wrote:
>>> If bot barking doesn't bother anyone, then I'll keep the removal patch.
>>> For some such a complaint might be grounds for rejecting the patch.
>> 
>> If it's (a) in tree proper and (b) not one of the rare false positives I
>> would consider it a reason for rejection as well.  But this is the
>> staging tree we're talking about.
> 
> I want to put my $.02 in on this.  The staging tree has meant different
> things over time.  In particular, it didn't used to be a place where "to
> be removed" drivers went to hang out for a few releases before finally
> being removed entirely.  I suspect this policy of not touching staging
> drivers with tree wide API changes pre-dates the policy of using staging
> as an intermediate step in removal.  It would seem to me that saying we
> are going to remove a driver in 4.6 and moving it to staging for that
> purpose, and then immediately breaking it so it doesn't compile, is not
> compatible with the goals of orderly device driver removal (namely:
> alerting people to the upcoming change, waiting a reasonable period of
> time for objections/feedback, and then removing the driver if no one
> brings forth a case for it to stay in the kernel).  It effectively
> becomes an immediate removal.  For that reason, I can't say that I agree
> with this policy of skipping staging drivers for API updates, at least
> as it applies to drivers that were in the tree proper and are in staging
> now as part of their orderly removal process.
> 
> I can't say as I really agree with the policy for drivers coming in
> through staging either unless the authors of the driver are allowing it
> to languish and not pursuing their TODO list.
> 
> In any case, I don't expect to have stuff from the RDMA core in staging
> for an extended amount of time.  But right now there is, and for the way
> I'm using the staging area, *I* care if your patch breaks the drivers
> that are there.

That makes sense, but you already Acked the change that breaks Lustre, and it's going in through the NFS tree. Are you changing that to a NAK?--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

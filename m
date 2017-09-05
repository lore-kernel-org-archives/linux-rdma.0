From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Tue, 5 Sep 2017 17:22:04 -0400
Message-ID: <0D960F54-0BC7-4A5A-8001-0391673892DF@oracle.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net> <20170905200608.GA4055@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905200608.GA4055-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Sep 5, 2017, at 4:06 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Tue, Sep 05, 2017 at 01:00:10PM -0400, Chuck Lever wrote:
> 
>> - Send completions are batched to reduce interrupts, but still
>>  provide a periodic heartbeat signal for SQ housekeeping
> 
> I would scrub this commentary, it is very misleading.
> 
> The idea of a periodic completion does not match how verbs works at
> all, it was an incomplete root cause analysis from a HCA that uses
> different rules for freeing space in the SQ.

I think it does bear mentioning that, given this diagnosis, it is
still safe to remove the ib_post_send counting mechanism in 5/5,
which has been in xprtrdma for as long as I can recall, and has
been effective (with a few minor adjustments) at preventing SQ
overflow.

I'm not able to test this change with every HCA the Linux kernel
currently supports, unfortunately. The best I can do is offer a
"proof of correctness" and hope that vendors will jump on this
and try it out.


> Instead, I would say this series creates strong SQ accounting and
> properly guarentees the SQ can never overflow by only releasing SQ's
> back into the pool when the HCA has confirmed they are completed via a
> CQ.

I will adjust the cover letter (and patch descriptions as necessary)
next time I post this series. Thanks for your suggestions and review.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

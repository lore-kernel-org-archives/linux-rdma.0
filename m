From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Tue, 5 Sep 2017 14:06:08 -0600
Message-ID: <20170905200608.GA4055@obsidianresearch.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170905164347.11106.27140.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 05, 2017 at 01:00:10PM -0400, Chuck Lever wrote:

> - Send completions are batched to reduce interrupts, but still
>   provide a periodic heartbeat signal for SQ housekeeping

I would scrub this commentary, it is very misleading.

The idea of a periodic completion does not match how verbs works at
all, it was an incomplete root cause analysis from a HCA that uses
different rules for freeing space in the SQ.

Instead, I would say this series creates strong SQ accounting and
properly guarentees the SQ can never overflow by only releasing SQ's
back into the pool when the HCA has confirmed they are completed via a
CQ.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

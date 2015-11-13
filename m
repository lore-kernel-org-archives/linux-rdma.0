From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Thu, 12 Nov 2015 22:48:55 -0800
Message-ID: <20151113064855.GA31779@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <5643AE20.7040003@sandisk.com>
 <20151112175924.GA26612@infradead.org>
 <564538EE.3050805@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564538EE.3050805-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 05:12:14PM -0800, Bart Van Assche wrote:
> On 11/12/2015 09:59 AM, Christoph Hellwig wrote:
> >[  108.998574] WARNING: CPU: 0 PID: 1258 at kernel/sched/core.c:7389 __might_sleep+0xa7/0xb0()
> >[  108.998580] do not call blocking ops when !TASK_RUNNING; state=1 set
> 
> Although this is most likely unrelated to the issue reported at the start of
> this thread, I have started working on a patch for this warning.

It's unrelated and fixed in the SCST version.  But don't bother, I have
a series that gets rid of the srpt completion thread entirely.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 13:58:45 -0400
Message-ID: <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com>
References: <20150804143447.GA22172@infradead.org> <20150806162438.GA27608@infradead.org> <55C393A0.6000002@opengridcomputing.com> <20150806173143.GA25497@infradead.org> <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Aug 6, 2015, at 1:44 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:

> 
> 
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Christoph Hellwig
>> Sent: Thursday, August 06, 2015 12:32 PM
>> To: Steve Wise
>> Cc: Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sagi Grimberg
>> Subject: Re: [RFC] split struct ib_send_wr
>> 
>> On Thu, Aug 06, 2015 at 12:04:32PM -0500, Steve Wise wrote:
>>> You missed amso1100 (and probably ipath) that have been moved to
>>> drivers/staging...
>> 
>> Driver/staging isn't considered in tree for global API change
>> perspective, so I didn't bother with all these staging drivers.
> 
> The kbuild test bot will probably catch this.

Wondering if this means we'll have to drop ib_reg_phys_mr()
removal until Lustre gets around to removing their call sites
from the staging tree.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: RFC: Immediate data support for SRP
Date: Thu, 16 Jul 2015 08:25:37 -0700
Message-ID: <55A7CCF1.3080201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

As you probably know for write requests "immediate data" means sending 
the data in the same packet as the write command instead of sending it 
as a separate packet. This approach improves performance and reduces 
latency. Although support for immediate data has not been standardized, 
it is easy to add to the SRP initiator and target drivers. 
Implementations exist in the ib_srp-backport initiator driver and the 
SCST SRP target driver (see also 
https://github.com/bvanassche/ib_srp-backport and 
http://sourceforge.net/p/scst/svn/HEAD/tree/trunk/srpt/). These 
implementations are available since considerable time, work reliably, 
are backwards compatible and support zero-copy. Since using immediate 
data provides a measurable performance improvement I'm wondering whether 
it would be acceptable to add support for immediate data to the SRP 
drivers in the Linux kernel tree (ib_srp and ib_srpt) ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: dumping queue state
Date: Wed, 20 Dec 2017 09:53:33 -0600
Message-ID: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey,

I have a need to provide tools for customers to gather runtime state for an
rdma device.   Say, when an application is stuck waiting for some completion
or other rdma event.   This includes hw/fw state of course, and equally as
important, rdma object sw state.  Is debugfs the correct way to export this
sw state?  The data is quite large potentially; each QP, its structures, the
dma queue memory, etc.  Ditto for CQs.  Also MR state, etc etc.  It seems
that would be overloading debugfs to me.  Currently the hw/fw state is being
gathered via ethtool dump commands (--get-dump, --register-dump,
--eeprom-dump).  I am considering using the ethtool --get-dump method for
the low level driver to also include dumping the rdma queue state for the
device.   Is that a reasonable approach?

Any thoughts/suggestions? 

Thanks in advance,

Steve.


---
This email has been checked for viruses by AVG.
http://www.avg.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

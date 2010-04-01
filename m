From: Kit Westneat <kwestneat-LfVdkaOWEx8@public.gmane.org>
Subject: IB devices reorder
Date: Thu, 1 Apr 2010 15:22:05 -0400
Message-ID: <4BB4F25D.60107@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Sorry if this has been covered before, but I couldn't find anything in 
the archives. I have machine running Centos5.3 with an mlx4 and an mthca 
adaptor, and I'm unable to get a stable ordering of the ib_ipoib devices 
on boot. Sometimes ib0 = the mlx4 device and sometimes it = the mthca 
device.

Has anyone else run into this? Is there a way to get them consistently 
ordered?

Thanks,
Kit

-- 
---
Kit Westneat
kwestneat-eJXmXnHXqs5nV8he+ouRCwC/G2K4zDHf@public.gmane.org
812-484-8485

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

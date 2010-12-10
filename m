From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb3-1.3.0 Release
Date: Fri, 10 Dec 2010 13:11:07 -0600
Message-ID: <4D027B4B.4070200@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The libcxgb3 package is a userspace driver for Chelsio T3 iWARP RNICs.   It is a plug-in module for libibverbs that 
allows programs to use Chelsio RDMA hardware directly from userspace.

A new release, libcxgb3-1.3.0, is available from

http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.3.0.tar.gz

with md5sum

40a8c9013de84c4a662cf451a4b5a534 libcxgb3-1.3.0.tar.gz


This version makes use of the iw_cxgb3 changes added to ABI version 1 of that driver, which is releasing with 
linux-2.6.37.  However, libcxgb3 does not _require_ ABI 1, so it can be pulled into any distros with the current iw_cxg3 
driver ABI version 0.


Vlad, please plan to pull this in for OFED-1.6.


Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

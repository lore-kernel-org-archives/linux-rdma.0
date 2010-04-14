From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4 1.0.0 Release
Date: Wed, 14 Apr 2010 11:19:46 -0500
Message-ID: <4BC5EB22.3030106@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The libcxgb4 package is a userspace driver for the new Chelsio T4 iWARP 
RNICs.   It is a plug-in module for libibverbs that allows programs to 
use Chelsio RDMA T4 hardware directly from userspace.

The initial release of this library is now available at:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.0.0.tar.gz

with md5sum:

21c3505414e861837d4d54d501d918e9 libcxgb4-1.0.0.tar.gz

Also, I welcome code review comments if anyone cares to review the code.

My development git tree is at:

git://www.openfabrics.org/~swise/libcxgb4 
<http://www.openfabrics.org/git/?p=%7Eswise/libcxgb4.git;a=summary>


Thanks,


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

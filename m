From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4-1.3.3 released
Date: Tue, 11 Mar 2014 12:37:13 -0500
Message-ID: <007d01cf3d50$8a070e70$9e152b50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The libcxgb4 package contains a userspace driver for Chelsio T4 and T5 
iWARP RNICs.  It is a plug-in module for libibverbs that allows programs

to use Chelsio hardware directly from userspace.

A new release is available from:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.3.tar.gz

with an md5sum of:

a78cace976958f562ec7861b4105909f

The git tree is available at:

git://www.openfabrics.org/~swise/libcxgb4

The tag is v1.3.3

This release contains one (important) bug fix from 1.3.2:

commit 98cea522707232b99ff5c07dd9f57937aa8a7d91
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Mar 11 11:44:16 2014 -0500

    Zero the status_page_size before calling get_context.

    Signed-off-by: Steve Wise <swise-7bPotxP6k4+WOkSXwOZclFaTQe2KTcn/@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

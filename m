From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb3 1.2.4 released
Date: Mon, 28 Sep 2009 14:43:27 -0500
Message-ID: <4AC111DF.2000008@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The libcxgb3 package is a userspace driver for Chelsio T3 iWARP RNICs.  
It is a plug-in module for libibverbs that allows programs to use 
Chelsio RDMA hardware directly from userspace.

A new release, libcxgb3-1.2.4, is available from

http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.4.tar.gz

with md5sum

d445ec6ee3004b78b43d069dcb99d836 libcxgb3-1.2.4.tar.gz

This minor release fixes a bug where the qp attribute sq_sig_all was 
being ignored by libcxgb3.


Vlad: Please pull this into ofed-1.5.



Thanks,

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4-1.3.1 released.
Date: Tue, 24 Sep 2013 14:02:29 -0500
Message-ID: <5241E1C5.6070600@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The libcxgb4 package contains a userspace driver for Chelsio T4 and T5 
iWARP RNICs.  It is a plug-in module for libibverbs that allows programs 
to use Chelsio hardware directly from userspace.

A new stable release is available from:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.1.tar.gz

with MD5Sum:

8753c03c879c0b0fd3096e449e19f3a9


The git tree is available at:

git://www.openfabrics.org/~swise/libcxgb4 
<http://git.openfabrics.org/git?p=%7Eswise/libcxgb4.git;a=summary>

The tag is 'v1.3.1'.

This release contains important bug fixes, some build fixes, plus 
copyright updates.


Shortlog from 1.3.0:

Steve Wise (12):
       fixed false uninitialized var warning.
       Handle qp flushes with pending sw cqes.
       accounting for unsignled sq wrs fails to deal with wrap.
       clean up queue dump logic.
       flush problem with unsignaled wrs.
       fixed bug where sq.udb was getting overwritten.
       always do GTS write if cidx_inc == M_CIDXINC.
       Mind the sq_sig_all/sq_sig_type QP attributes.
       update configure.in
       get rid of hard coded queue iqs.
       Update copyright.
       Spin release 1.3.1.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb4-1.3.2 released.
Date: Fri, 21 Feb 2014 10:25:10 -0600
Message-ID: <53077DE6.7020301@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The libcxgb4 package contains a userspace driver for Chelsio T4 and T5 
iWARP RNICs.  It is a plug-in module for libibverbs that allows programs 
to use Chelsio hardware directly from userspace.

A new release is available from:

http://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.2.tar.gz

with an md5sum of:

d6e9b98f0d58dff639662eae9866541b

The git tree is available at:

git://www.openfabrics.org/~swise/libcxgb4

The tag is v1.3.2

Shortlog from v1.3.1:

Steve Wise (16):
       T4 onchip workaround: do the 16 4B MA writes just before DB ring.
       Fix DEBUG code in c4iw_flush_hw_cq().
       DB Drop Avoidance, Version 2.
       unmap status page when freeing the context.
       never consume a pending wr in sq flush.
       iw_cxgb4/libcxgb4: swsq "signaled" state needs to mind sq_sig_all.
       Remove dead raw qp code.
       Remove dead SIM code.
       Add common device id table and chip types.
       Refresh t4 fw/hw reg files.
       Update copyrights.
       Call rmb() after reading valid gen bit.
       Call wc_wmb() needed after DB writes.
       Use V_PIDX_T5() for T5 devices in ring_db funcs.
       Fixed compilation error with debug enabled.
       Spin release 1.3.2.

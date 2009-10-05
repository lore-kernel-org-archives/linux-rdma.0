From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE] libcxgb3 1.2.5 released
Date: Mon, 05 Oct 2009 16:44:32 -0500
Message-ID: <4ACA68C0.8030301@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry for yet another libcxgb3 so soon, but:

The libcxgb3 package is a userspace driver for Chelsio T3 iWARP RNICs.   
It is a plug-in module for libibverbs that allows programs to use 
Chelsio RDMA hardware directly from userspace.

A new release, libcxgb3-1.2.5, is available from

http://www.openfabrics.org/downloads/cxgb3/libcxgb3-1.2.5.tar.gz

with md5sum

ed2eaf99bc7cce401dd0549505febdd1 libcxgb3-1.2.5.tar.gz

This minor release fixes a bug where the qp wasn't being correctly RESET 
causing dapltest failures.


Vlad: Please pull this into ofed-1.5 before RC1.


Thanks,


Steve.

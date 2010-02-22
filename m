From: "Vu Pham" <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: nfsrdma fails to write big file,
Date: Mon, 22 Feb 2010 10:41:42 -0800
Message-ID: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-class: urn:content-classes:message
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Setup: 
1. linux nfsrdma client/server with OFED-1.5.1-20100217-0600, ConnectX2
QDR HCAs fw 2.7.8-6, RHEL 5.2.
2. Solaris nfsrdma server svn 130, ConnectX QDR HCA.


Running vdbench on 10g file or *dd if=/dev/zero of=10g_file bs=1M
count=10000*, operation fail, connection get drop, client cannot
re-establish connection to server.
After rebooting only the client, I can mount again.

It happens with both solaris and linux nfsrdma servers.

For linux client/server, I run memreg=5 (FRMR), I don't see problem with
memreg=6 (global dma key)

On Solaris server snv 130, we see problem decoding write request of 32K.
The client send two read chunks (32K & 16-byte), the server fail to do
rdma read on the 16-byte chunk (cqe.status = 10 ie.
IB_WC_REM_ACCCESS_ERROR); therefore, server terminate the connection. We
don't see this problem on nfs version 3 on Solaris. Solaris server run
normal memory registration mode.

On linux client, I see cqe.status = 12 ie. IB_WC_RETRY_EXC_ERR

I added these notes in bug #1919 (bugs.openfabrics.org) to track the
issue.

thanks,
-vu

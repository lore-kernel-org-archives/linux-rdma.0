From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-1-rc2 release is available
Date: Mon, 26 Oct 2015 16:27:02 +0200
Message-ID: <562E3836.6030200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'OpenFabrics EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.18-1-rc2 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18-1/OFED-3.18-1-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18-1

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_3.18-1-rc2_release_notes

OFED-3.18-1-rc2 Main Changes from OFED 3.18-1-rc1
-------------------------------------------------------------------------------
1. Updated packages:
   - dapl-2.1.7
   - infiniband-diags-1.6.6
   - infinipath-psm-3.3-7_g05f6f14_open
   - libiwpm-1.0.3
   - libfabric-1.1.1
   - fabtests-1.1.1

2. compat-rdma changes
   - xeon-phi: ibscif bug 2575: Allow xeon-phi support for Knights Landing
   - xeon-phi: ibscif bug 2570: correction to communitate between host and card


Regards,
Vladimir

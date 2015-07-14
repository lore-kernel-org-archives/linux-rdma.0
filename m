From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18 release is available
Date: Tue, 14 Jul 2015 18:59:42 +0300
Message-ID: <55A531EE.3060003@dev.mellanox.co.il>
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
OFED-3.18 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18/OFED-3.18.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_3.18_release_notes

OFED-3.18 Main Changes from OFED 3.18-rc3
-------------------------------------------------------------------------------
1. Updated packages:
   - libiwpm-1.0.2
   - mstflint-4.0.1-1.43.g97d7275
   - perftest-3.0-0.9.g214990b

2. compat-rdma changes
   - Adding backport to neigh resolve fix for RHEL 6.5 and RHEL 6.6
   - ibscif: Fixed bring up of scif device on kernels >= 3.11
   - openibd: Unload in-box drivers upon boot
   - RDMA/nes: Fix for incorrect recording of the MAC address
   - RDMA/nes: Fix for resolving the neigh
   - RDMA/iwpm: Updated fixes for the client registration functionality


Regards,
Vladimir

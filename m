From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.40
Date: Mon, 10 Feb 2014 22:23:21 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972DEC8F5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A new release of dapl is available at http://www.openfabrics.org/downloads/dapl

Latest Package (see ChangeLog for recent changes):

	md5sum: 7c6ef6e0573672ffb19f75db305b609c dapl-2.0.40.tar.gz 

Install following RPM packages: 

   dapl-2.0.40-1 
   dapl-utils-2.0.40-1 
   dapl-devel-2.0.40-1 
   dapl-debuginfo-2.0.40-1 

Release 2.0.40 fixes (OFED 3.12) 
 
  - build/dist: ib collective extension include files missing 
  - dapltest: the quit command is missing changes for -n option 
  - dat.conf: remove v1, add Mellanox Connect-IB and Intel Xeon Phi MIC 
  - NULL undefined on Fedora, incorrectly using kernel stddef.h 
 
Arlin

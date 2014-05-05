From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.0.42 release
Date: Mon, 5 May 2014 16:47:46 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E23927@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL v2 (2.0.42) available at  http://www.openfabrics.org/downloads/dapl

Vlad, please pull into OFED 3.12 RC2. 

md5sum: 08a9ccf071935c9149d4bd1d6a0f9d65 dapl-2.0.42.tar.gz

For v2.0 package install RPM packages as follow:
    dapl-2.0.42-1
    dapl-utils-2.0.42-1
    dapl-devel-2.0.42-1
    dapl-debuginfo-2.0.42-1

Summary of v2.0 changes:

    Release 2.0.42 fixes (OFED 3.12 GA)
    dapltest: increase DTO evd size to prevent CQ overflow on limit_rpost test
    dapltest: RSP limit test fails. Creation of reserved SP moves EP state to DAT_EP_STATE_RESERVED in error cases.
    dapl: fix string bug in dapls_dto_op_str

-arlin

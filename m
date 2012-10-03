From: Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED-3.5-rc2 is available
Date: Wed, 3 Oct 2012 09:13:46 -0700
Message-ID: <506C643A.70105@nasa.gov>
References: <506C5FBE.1080004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <506C5FBE.1080004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Vlad. Happy New Year (belated) ! One additional note below...

On 10/03/2012 08:54 AM, Vladimir Sokolovsky wrote:
> Hi,
> OFED 3.5-rc2 is available.
>
> The tarball is available on:
> http://www.openfabrics.org/downloads/OFED/ofed-3.5/OFED-3.5-rc2.tgz
>
> To get BUILD_ID run ofed_info
>
> Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 3.5
>
> Regards,
> Vladimir
>
>
> OFED-3.5-rc2 Main Changes from OFED 3.5-rc1
> -------------------------------------------------------------------------------
> compat-rdma: Add SRP backport
> compat-rdma: /etc/init.d/openibd: Fix LSB header
> compat-rdma: IB/qib: linux-3.6 patches backported
> compat-rdma: iw_cxgb4: Fix bug 2369 in OFED bugzilla
> compat-rdma: IB/qib: fix compliance regression in 3.5
> compat-rdma: RDMA/nes: Added linux-next-pending patches
> compat-rdma: RDMA/nes: Updated backports
> compat-rdma: NFSRDMA RHEL6.3 backport
> compat-rdma: NFSRDMA SLES11SP2 backport
> compat-rdma: linux-next-cherry-picks: RDMA/ucma.c: Different fix for ucma context uid=0, causing iWarp RDMA applications to fail in connection establishment

Although it didn't require additional patches, I have verified that 
NFSRDMA is also supported on RHEL6.2. Thanks.

-jeff
>
> Updated packages:
>       infinipath-psm-3.0.1-115.1015_open
>       perftest-1.4.0-0.80.gd1763bd
>       qperf-0.4.7-0.2.gf3f7001
>
> Supported Platforms and Operating Systems
> ---------------------------------------------
>     o   CPU architectures:
>           - x86_64
>           - x86
>           - ppc64
>           - ia64
>
>     o   Linux Operating Systems:
>           - RedHat EL6.2          2.6.32-220.el6
>           - RedHat EL6.3          2.6.32-279.el6
>           - SLES11 SP2            3.0.13-0.27-default
>           - kernel.org            3.5    *
>
>         * Minimal QA for these versions.
>
>
> OFED_release_notes.txt
>
> Note: See the release notes of each component for additional issues.
>

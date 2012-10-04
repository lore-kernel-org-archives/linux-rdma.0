From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED-3.5-rc2 is available
Date: Thu, 04 Oct 2012 12:05:17 +0200
Message-ID: <506D5F5D.9050308@profitbricks.com>
References: <506C5FBE.1080004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506C5FBE.1080004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Vladimir,

why do you put OFED together for a kernel nobody uses? Perhaps SLES and
Red Hat do it like this but nobody else.

Have a look at http://en.wikipedia.org/wiki/Linux_kernel - 3.0, 3.2 and
3.4 are the long-term stable releases.

This approach is worse than the approach before IMHO. Since 1.5.4.1
there is no real stable release. No wonder that everyone puts his own
OFED together.

I'm so glad that we don't need too much OFED user space and we just use
the IB stuff from the mainline kernel. We need to surf close to mainline
kernel development anyway.

The only thing that we would need is a list which packet with which
version matches our mainline kernel. Updating it from Git directly from
a tag or branch with no external patches or SRPM/tar.gz stuff would make
it much easier - also for other distributions. Things are getting better
for us with the switch-over to Gentoo. There, we can leave out the
packages that we don't actually need.

Cheers,
Sebastian


On 03.10.2012 17:54, Vladimir Sokolovsky wrote:
> Hi,
> OFED 3.5-rc2 is available.
>
> The tarball is available on:
> http://www.openfabrics.org/downloads/OFED/ofed-3.5/OFED-3.5-rc2.tgz
>
> To get BUILD_ID run ofed_info
>
> Please report any issues in bugzilla https://bugs.openfabrics.org/ for
> OFED 3.5
>
> Regards,
> Vladimir
>
>
> OFED-3.5-rc2 Main Changes from OFED 3.5-rc1
> -------------------------------------------------------------------------------
>
> compat-rdma: Add SRP backport
> compat-rdma: /etc/init.d/openibd: Fix LSB header
> compat-rdma: IB/qib: linux-3.6 patches backported
> compat-rdma: iw_cxgb4: Fix bug 2369 in OFED bugzilla
> compat-rdma: IB/qib: fix compliance regression in 3.5
> compat-rdma: RDMA/nes: Added linux-next-pending patches
> compat-rdma: RDMA/nes: Updated backports
> compat-rdma: NFSRDMA RHEL6.3 backport
> compat-rdma: NFSRDMA SLES11SP2 backport
> compat-rdma: linux-next-cherry-picks: RDMA/ucma.c: Different fix for
> ucma context uid=0, causing iWarp RDMA applications to fail in
> connection establishment
>
> Updated packages:
>     infinipath-psm-3.0.1-115.1015_open
>     perftest-1.4.0-0.80.gd1763bd
>     qperf-0.4.7-0.2.gf3f7001
>
> Supported Platforms and Operating Systems
> ---------------------------------------------
>   o   CPU architectures:
>         - x86_64
>         - x86
>         - ppc64
>         - ia64
>
>   o   Linux Operating Systems:
>         - RedHat EL6.2          2.6.32-220.el6
>         - RedHat EL6.3          2.6.32-279.el6
>         - SLES11 SP2            3.0.13-0.27-default
>         - kernel.org            3.5    *
>
>       * Minimal QA for these versions.
>
>
> OFED_release_notes.txt
>
> Note: See the release notes of each component for additional issues.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

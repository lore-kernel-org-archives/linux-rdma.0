From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [ANNOUNCE] OFED 1.5.2 rc3 is available
Date: Wed, 04 Aug 2010 11:40:02 +0300
Message-ID: <4C592762.8000301@dev.mellanox.co.il>
References: <4C591A49.4000807@dev.mellanox.co.il> <7E95F01E94AB484F83061FCFA35B39F88E15EA@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F88E15EA-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Shiri Franchi wrote:
> Hi,
> 
> I think there is a mistake in sles11 sp1 default kernel.
> It should be 2.6.32.12-0.7-default
> 
> Thanks,
> Shiri

It is SLES11 SP1 RC1:
              - SLES11 SP1 RC1        2.6.32.9-0.5-default *

But SLES11 SP1 is supported as well.

Regards,
Vladimir

> 
> -----Original Message-----
> From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> [mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Vladimir
> Sokolovsky
> Sent: Wednesday, August 04, 2010 10:44 AM
> To: OpenFabrics EWG
> Cc: linux-rdma
> Subject: [ewg] [ANNOUNCE] OFED 1.5.2 rc3 is available
> 
> Hi,
> OFED 1.5.2-rc3 is available
> 
> Notes:
> 
> The tarball is available on:
> http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc3.tgz
> 
> To get BUILD_ID run ofed_info
> 
> Please report any issues in bugzilla https://bugs.openfabrics.org/  for
> OFED 1.5.2
> 
> Vladimir & Tziporet
> 
> ========================================================================
> Supported Platforms and Operating Systems
> ---------------------------------------------
>       o   CPU architectures:
>             - x86_64
>             - x86
>             - ppc64
>             - ia64
> 
>       o   Linux Operating Systems:
>             - RedHat EL4 up7        2.6.9-78.ELsmp
>             - RedHat EL4 up8        2.6.9-89.ELsmp
>             - RedHat EL5 up3        2.6.18-128.el5
>             - RedHat EL5 up4        2.6.18-164.el5
>             - RedHat EL5 up5        2.6.18-194.el5
>             - RedHat EL6 beta       2.6.32-19.el6.x86_64 *
>             - SLES10 SP2            2.6.16.60-0.21-smp
>             - SLES10 SP3            2.6.16.60-0.54-smp
>             - SLES11                2.6.27.19-5-default
>             - SLES11 SP1 RC1        2.6.32.9-0.5-default *
>             - OEL 4 up7             2.6.9-78.ELsmp
>             - OEL 4 up8             2.6.9-89.ELsmp
>             - CentOS5.3             2.6.18-128.el5
>             - CentOS5.4             2.6.18-164.el5
>             - Fedora Core12         2.6.31.5-127.fc12    *
>             - OpenSuSE 11.2         2.6.31.5-0.1-default *
>             - kernel.org            2.6.29, 2.6.30,
>                                     2.6.31 and 2.6.32    *
> 
>           * Minimal QA for these versions
> 
> Main changes from 1.5.2-rc2:
> ===========================
> 1. Updated packages:
> 	libibverbs-1.1.4-0.11.g1541e64.tar.gz
> 	libmlx4-1.0-0.11.gd213393.tar.gz
> 	libnes-1.0.1-0.5.g9371546.tar.gz
> 	compat-dapl-1.2.18.tar.gz
> 	perftest-1.2.4-0.19.g9e79456.tar.gz
> 	rds-tools-2.0.3
> 
>      - MPI
> 	mvapich2-1.5-1.src.rpm
> 
> 2. New features
> 	ibacm-1.0.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED 1.5 rc6 release is available
Date: Wed, 23 Dec 2009 11:52:10 +0100
Message-ID: <20091223115210.07f37954@alex-laptop>
References: <4B30F0E2.6010501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B30F0E2.6010501-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Dec 2009 18:16:34 +0200
Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Hi,
> OFED 1.5-rc6 is available
> 
> Notes:
> 
> The tarball is available on:
> http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc6.tgz

I've tried to download RC6, but openfabrics.org seems to be down. Will try
again later today...

Regards,
Alex

> 
> To get BUILD_ID run ofed_info
> 
> Please report any issues in bugzilla https://bugs.openfabrics.org/  for
> OFED 1.5
> 
> Vladimir & Tziporet
> 
> ========================================================================
> 
> 
> Release information:
> --------------------
> Linux Operating Systems:
>          - RedHat EL4 up7:       2.6.9-78.ELsmp
>          - RedHat EL4 up8:       2.6.9-89.ELsmp
>          - RedHat EL5 up3:       2.6.18-128.el5
>          - RedHat EL5 up4:       2.6.18-164.el5
>          - SLES10 SP2:           2.6.16.60-0.21-smp
>          - SLES10 SP3:           2.6.16.60-0.54-smp
>          - SLES11:               2.6.27.19-5-default
>          - OEL 4 up7             2.6.9-78.ELsmp
>          - OEL 4 up8             2.6.9-89.ELsmp
>          - CentOS5.3             2.6.18-128.el5
>          - CentOS5.4             2.6.18-164.el5
>          - Fedora Core12         2.6.31.5-127.fc12   *
>          - OpenSuSE 11           2.6.25.5-1.1        *
>          - kernel.org:           2.6.29, 2.6.30,
>                                  2.6.31 and 2.6.32   *
> 
>         * Minimal QA for these versions
> 
> Systems:
>         * x86_64
>         * x86
>         * ia64
>         * ppc64
> 
> 
> Main changes from 1.5 rc5:
> ============================
> 1. Updated packages:
> 
>        - Management packages:
>        libibumad-1.3.4_20091214.tar.gz
>        libibmad-1.3.4_20091214.tar.gz
>        opensm-3.3.4_20091221_033cf4c.tar.gz
>        infiniband-diags-1.5.4_20091221_033cf4c.tar.gz
>        ibutils-1.5.tar.gz
> 
>        - MPI packages
>        mvapich-1.2.0-3567.src.rpm
> 
> 2. Bug fixes
>       See attached.
> 
> 
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

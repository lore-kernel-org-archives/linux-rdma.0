From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ANNOUNCE] libibmad 1.3.8 tarball release
Date: Fri, 2 Sep 2011 15:16:24 -0700
Message-ID: <20110902151624.8551f21c.weiny2@llnl.gov>
References: <20110902150155.a5c1edd7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110902150155.a5c1edd7.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

My apologies to Al Chu.

The patch:
>         libibmad: Make new feild names consistent

Was done by him.  I must have screwed the am command or applied by hand.

:-(

Ira

On Fri, 2 Sep 2011 15:01:55 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> Hi,
> 
> There is a new release of libibmad.
> Tarball available in:
> 
> http://www.openfabrics.org/downloads/management/
> 
> (listed in http://www.openfabrics.org/downloads/management/latest.txt)
> 
> md5sum:
> fe88bdfa48626d01ffad8b2fde87466e  libibmad-1.3.8.tar.gz
> 
> This version requires:
> 	OpenSM >= 3.3.10
> 
> 
> All component versions are from recent master branch. Full list of
> changes is below.
> 
> Albert L.Chu:
>         Fix offset in various < 32 bit field entries
>         Support optional performance counters, including congestion control performance counters.
> 
> Hal Rosenstock:
>         libibmad: Added smp_query/set _status_via functions
>         libibmad: Add initial extended speed support
>         libibmad: Add PortExtendedSpeedsCounters support
>         libibmad: Add remaining SM GUIDInfo attribute fields
>         libibmad: Add support for PortInfo CapabilityMask2
>         libibmad: Add support for SA GUIDInfoRecord fields
>         libibmad: Distinguish timed out from other errors
>         libibmad/dump.c: Add IsOptionalIPDSupported into mad_dump_portcapmask
>         libibmad/dump.c: Allow 0 (extended speed active) in mad_dump_linkspeed
>         libibmad: Fix backward compatibility
>         libibmad/gs.c: In pma_query_via/performance_reset_via, set errno
>         libibmad/[register rpc].c: Fix some bounds checks
>         libibmad/smp.c: Fix to smp_query_via for attribute data
>         libibmad: Support for Mellanox vendor specific ExtendedPortInfo SM class MAD
>         libibmad/vendor.c: In ib_vendor_call_via, set errno
> 
> Ira Weiny:
>         libibmad: make IB_GUID_GUID0_F consistent with new GUIDInfo fields
>         libibmad: Make new feild names consistent
>         libibmad: Remove libibnetdisc specific define
>         libibmad: Remove reference to OpenSM in COPYING file
>         Update AUTHORS and add README with release notes
> 
> shefty:
>         libibmad: Fix build on win8


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

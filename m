From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] OFED 1.5.2 beta1 is available
Date: Mon, 3 May 2010 16:51:54 -0700
Message-ID: <F19F5F7668A84FCA82A2E0E3CDEF7001@amr.corp.intel.com>
References: <4BDE7CB9.8020801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BDE7CB9.8020801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Main changes from 1.5.1:
>===========================
>1. Updated packages:
>    - Management
>      Using latest daily builds from
>http://www.openfabrics.org/downloads/management/daily
>    - Updated libnes
>      libnes-1.0.1-0.1.g89ea0ee.tar.gz
>    - Updated libsdp
>      libsdp-1.1.101-0.3.gc767eee.tar.gz
>    - Updated perftest
>      perftest-1.2.4-0.15.g82b7e29.tar.gz
>    - Updated mpitests
>      mpitests-3.2-923.src.rpm
>2. Added RHEL5.5 support
>3. Use files under /etc/modprobe.d/ instead of /etc/modprobe.conf
>4. Bug fixes

I would like to add support for IB ACM path resolution (i.e. user space path
record caching) into the 1.5.2 release.  Vlad pulled in the necessary kernel
patch from 2.6.33 a few days ago.  All other changes are in user space -- an
updated librdmacm release and a release of ibacm -- and must be enabled to be
used.

I hope to complete testing this week.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

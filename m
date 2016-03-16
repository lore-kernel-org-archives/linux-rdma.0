From: "Estela, Henry R" <henry.r.estela-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] infinipath-psm_3.3-19_g67c0807_open is available
Date: Wed, 16 Mar 2016 18:09:05 +0000
Message-ID: <152F98E1C68AAF499EABB07558C80F3B0277C6F0@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for infinipath-psm (3.3-19_g67c0807_open) is available at http://downloads.openfabrics.org/downloads/infinipath-psm/

Vlad, it is ready for the next build.

Summary of changes:
Reduce virtual memory usage for the host on non-SCIF builds
libpsm_infinipath version bumped to 1.16 
Allow for signal handler to be properly disabled to allow for Open MPI Java bindings to work
Fix hang with specific PSM_MULTIRAIL configurations
Fix hang with Intel MPI on larger jobs

--
Henry

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

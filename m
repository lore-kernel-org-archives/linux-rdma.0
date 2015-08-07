From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ewg] [ANNOUNCE] Updated PSM library is available
Date: Fri, 7 Aug 2015 19:48:54 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2577B37D@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tang, CQ" <cq.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Estela, Henry R" <henry.r.estela-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

An updated PSM library is available at:

https://www.openfabrics.org/downloads/infinipath-psm/infinipath-psm-3.3-6_gca75825_open.tar.gz

The update addresses the following issues:
- Adds support for 2^20 MPI ranks, up from 2^16
- Fixes issue with exhaustion of send tid dma descriptors
- Fixes performance issue with PIO

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

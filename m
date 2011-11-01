From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osmtest/osmt_multicast.c: Fix multicast flow
 failures on pkey validation
Date: Tue, 1 Nov 2011 18:29:20 +0200
Message-ID: <20111101162920.GE2286@calypso.mtl.com>
References: <4E84695C.8080003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E84695C.8080003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 08:49 Thu 29 Sep     , Hal Rosenstock wrote:
> 
> Found and fixed by Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> commit f7f1ead1b4e9bba741a0d1312513839504cab1e3 introduced an additional
> pkey check into osm_sa_mcmember_record.c:mcmr_rcv_join_mgrp
> 
> subsequent commit ffdcdec8a6557088b23e273c5d605465501d2d24 fixed only
> some of the pkeys in the multicast flow of osmt_multicast.c
> 
> This fixes the remainder of the multicast flow for this issue:
> osmtest -f m -M1 now passes 
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

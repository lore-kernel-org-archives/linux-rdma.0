From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Fri, 18 Dec 2015 11:26:42 -0500
Message-ID: <567433C2.70404@dev.mellanox.co.il>
References: <20151217195255.334854705@linux.com>
 <20151217195312.334770847@linux.com> <567316F7.9030707@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171527060.22782@east.gentwo.org>
 <56732D97.2080303@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171649070.22782@east.gentwo.org>
 <567342F5.5090000@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512180737150.32514@east.gentwo.org>
 <56740F8C.4060703@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512180944540.1506@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1512180944540.1506-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 10:46 AM, Christoph Lameter wrote:
> Subject: IB core counters: Support noietf extended counters V2
> 
> V1-V2: Fix logic to detect when 64 bit counter are available
> 	based on Hal's suggestions.
> 
> Detect if we have extended counters but not IETF counters.
> For that we need a special table and create a function that
> returns the table address.
> 
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

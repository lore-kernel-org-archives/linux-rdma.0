From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_perfmgr.c: Output remote port on perfmgr error
 counter log messages
Date: Tue, 09 Dec 2014 07:50:01 -0500
Message-ID: <5486EFF9.3060608@dev.mellanox.co.il>
References: <1418063952.20566.44.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418063952.20566.44.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/8/2014 1:39 PM, Albert Chu wrote:
> Outputting the remote node and port aids in servicing the fabric more
> quickly for system administrators.  In addition, it aids in fabric
> monitoring efforts that scan the log.
> 
> Example output before this patch:
> 
> perfmgr_log_errors: ERR 543C: VL15Dropped : 17 : node "ibcore1 L101" (NodeGUID: 0x66a02e8001313) : port 11
> 
> Example output wth this patch:
> 
> perfmgr_log_errors: ERR 543C: VL15Dropped : 17 : node "ibcore1 L101" (NodeGUID: 0x66a02e8001313) : port 11 connected to "hype355 qib0" (NodeGUID: 0x40ed770000751100) : port 1
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_console.c: Support portstatus output for
 unenabled width/speed
Date: Thu, 28 Feb 2013 10:34:49 -0500
Message-ID: <512F7919.7090009@dev.mellanox.co.il>
References: <1361915680.28997.11.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361915680.28997.11.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/26/2013 4:54 PM, Albert Chu wrote:
> On occasion, it has been observed that active link width and/or speed
> is set at a level not enabled.  For example, a link may be active at
> QDR but SDR & DDR speeds are the only ones enabled.
> 
> Under these scenarios, the portstatus option in the console may
> incorrectly output port status, which can confuse users.
> 
> A new port output status of "unenabled width" or "unenabled speed" is
> output when this situation is discovered, helping users find problems
> in the fabric.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

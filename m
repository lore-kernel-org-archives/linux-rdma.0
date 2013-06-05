From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] ibsim: Fix PerformanceSet parsing corner case
Date: Wed, 05 Jun 2013 15:39:10 -0400
Message-ID: <51AF93DE.3080205@dev.mellanox.co.il>
References: <1360284301.17736.154.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360284301.17736.154.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/7/2013 7:45 PM, Albert Chu wrote:
> Parse of attribute did not properly remove whitespace before it.  So
> 
> PerformanceSet "H-0002c90300325280" PortCounters.SymbolErrorCounter=3
> 
> would work but
> 
> PerformanceSet "H-0002c90300325280"  PortCounters.SymbolErrorCounter=3\
> 
> would not.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

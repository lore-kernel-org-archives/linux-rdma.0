From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 02/07] opensm/perfmgr: clean up: break out redirect
 processing from pc_recv_process
Date: Fri, 01 Mar 2013 09:37:09 -0500
Message-ID: <5130BD15.2040306@dev.mellanox.co.il>
References: <20130228170526.97fbdd98d3dd8dd747dd5673@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130228170526.97fbdd98d3dd8dd747dd5673-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/28/2013 8:05 PM, Ira Weiny wrote:
> 
> Changes from V1:
> 	Cleaned up processing when CPI redirect is invalid
> 
> Changes from V2:
> 	cpi_valid should not be set to false when redirect is invalid
> 	If CPI is a redirection only set cpi_valid if the redirection was valid
> 		(Also set cpi_valid on all ports for a switch)
> 
> Changes from V3:
> 	Reissue original query on redirect if query_cpi is not enabled
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

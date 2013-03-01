From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 03/07] opensm/perfmgr: Issue PortCountersExtended query
 when supported
Date: Fri, 01 Mar 2013 16:52:53 -0500
Message-ID: <51312335.4080402@dev.mellanox.co.il>
References: <20130228170618.ab723d29705f948219b364b8@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130228170618.ab723d29705f948219b364b8-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/28/2013 8:06 PM, Ira Weiny wrote:
> 
> Changes since V1:
> 	Track sent attribute id and use it to resend proper redirected query.
> 		(This should technically "never" happen.  But it is more
> 		complete to check this in the redirect handling code.)
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

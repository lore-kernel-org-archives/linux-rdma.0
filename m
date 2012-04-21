From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: force fdr link to 10gb
Date: Sat, 21 Apr 2012 07:02:50 -0400
Message-ID: <4F9293DA.9080507@dev.mellanox.co.il>
References: <4F92399C.6070408@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F92399C.6070408-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/21/2012 12:37 AM, Bob Ciotti wrote:
> I'm trying to change the capability on an FDR port to run at most at QDR
> speeds (force a 14 port to 10).
> I've tried various ibportstate (speed/espeed) commands and can't locate
> any documentation
> on the specifics.  Looks like LinkSpeedExtEnabled wants to be set to 0?

0 is no state change. 30 means Disable extended link speeds.

-- Hal

> Thanks for any pointers/help. Bob
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

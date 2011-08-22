From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/6] infiniband-diags/man/ibportstate.8: Update for fdr
Date: Sun, 21 Aug 2011 22:15:55 -0700
Message-ID: <20110821221555.b90281d9.weiny2@llnl.gov>
References: <4E4E9516.8040704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4E9516.8040704-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 19 Aug 2011 09:53:42 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  man/ibportstate.8 |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/man/ibportstate.8 b/man/ibportstate.8
> index 2989247..2a60db9 100644
> --- a/man/ibportstate.8
> +++ b/man/ibportstate.8
> @@ -1,4 +1,4 @@
> -.TH IBPORTSTATE 8 "Jan 13, 2010" "OpenIB" "OpenIB Diagnostics"
> +.TH IBPORTSTATE 8 "Mar 9, 2011" "OpenIB" "OpenIB Diagnostics"
>  
>  .SH NAME
>  ibportstate \- handle port (physical) state and link speed of an InfiniBand port
> @@ -23,7 +23,7 @@ also allows the link speed/width enabled on any IB port to be adjusted.
>  .TP
>  op
>  Port operations allowed
> - supported ops: enable, disable, reset, speed, width, query,
> + supported ops: enable, disable, reset, speed, espeed, width, query,
>  		down, arm, active, vls, mtu, lid, smlid, lmc
>   Default is query
>  .PP
> @@ -33,12 +33,16 @@ Port operations allowed
>   speed values are legal values for PortInfo:LinkSpeedEnabled
>   (An error is indicated if PortInfo:LinkSpeedSupported does not support
>    this setting)
> + espeed ops are allowed on any port supporting extended link speeds
> +(An error is indicated if port's capability mask indicates extended
> + link speeds are not supported or if PortInfo:LinkSpeedExtSupported
> + does not support this setting)
>   width values are legal values for PortInfo:LinkWidthEnabled
>   (An error is indicated if PortInfo:LinkWidthSupported does not support
>    this setting)
>   (NOTE: Speed and width changes are not effected until the port goes through
>    link renegotiation)
> - query also validates port characteristics (link width and speed)
> + query also validates port characteristics (link width, speed, and espeed)
>    based on the peer port. This checking is done when the port
>    queried is a switch port as it relies on combined routing
>    (an initial LID route with directed routing to the peer) which
> -- 
> 1.5.3
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] opensm: fixing unused-but-set warnings in compilation
Date: Fri, 29 Jul 2011 12:15:03 +0300
Message-ID: <20110729091503.GD2055@calypso.mtl.com>
References: <20110711174518.GB2084@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110711174518.GB2084-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 20:45 Mon 11 Jul     , Alex Netes wrote:
> Latest GCC 4.6 include -Wunused-* flags as part of the -Wall flag, causing
> many warnings during OpenSM compilation.
> 
> This patch series tries to clean these warnings.
> Where possible, unused variables were just deleted.
> In other cases where some variables are used only when specific compilation
> flags are used (DEBUG, VENDOR_RMPP_SUPPORT, etc') this variables marked as
> __attribute__((unused)) meaning that the variable is meant to be possibly
> unused.
> 
> More info:
> http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
> http://gcc.gnu.org/onlinedocs/gcc-4.6.1/gcc/Variable-Attributes.html#Variable-Attributes
> 
> 
> -- Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Applied.
-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

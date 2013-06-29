From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osmtest: Make the "-guid" option's argument mandatory
Date: Sat, 29 Jun 2013 09:19:26 -0400
Message-ID: <51CEDEDE.60008@dev.mellanox.co.il>
References: <1372406820-11505-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372406820-11505-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/28/2013 4:07 AM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> Currently, the getopt table in osmtest labels the "-guid" option as
> taking an optional argument; however, running osmtest with the -guid
> option but no argument just leads to:
> 
>     $ /usr/sbin/osmtest -guid
> 
>     Command Line Arguments
>     Segmentation fault
> 
> because the handling for the -guid option just passes optarg directly to
> strtoull(), and without and argument, optarg is NULL.  Really, the
> argument should be mandatory.
> 
> This bug was found by the Mayhem tool:
> http://www.forallsecure.com/bug-reports/edea01ceefbb188dcc62b3fc4f59dc743d7429c9/
> 
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

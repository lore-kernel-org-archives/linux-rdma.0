From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2 TRIVIAL] IB/core: ib_mad.h ib_mad_snoop_handler documentation fix
Date: Mon, 4 Jan 2016 19:05:41 -0500
Message-ID: <20160105000541.GC12703@phlsvsds.ph.intel.com>
References: <568AD99F.7040009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568AD99F.7040009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 04, 2016 at 03:44:15PM -0500, Hal Rosenstock wrote:
> ib_mad_snoop_handler uses send_buf rather than send_wr
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> Change since v1:
> Fixed typo in patch description
> 
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index ec9b44d..2b3573d 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -424,11 +424,11 @@ typedef void (*ib_mad_send_handler)(struct ib_mad_agent *mad_agent,
>  /**
>   * ib_mad_snoop_handler - Callback handler for snooping sent MADs.
>   * @mad_agent: MAD agent that snooped the MAD.
> - * @send_wr: Work request information on the sent MAD.
> + * @send_buf: send MAD data buffer.
>   * @mad_send_wc: Work completion information on the sent MAD.  Valid
>   *   only for snooping that occurs on a send completion.
>   *
> - * Clients snooping MADs should not modify data referenced by the @send_wr
> + * Clients snooping MADs should not modify data referenced by the @send_buf
>   * or @mad_send_wc.
>   */
>  typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

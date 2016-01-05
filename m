From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv4 TRIVIAL] IB/core: Documentation fix to the snoop handler in the MAD header file
Date: Tue, 5 Jan 2016 17:03:42 -0500
Message-ID: <20160105220342.GD12703@phlsvsds.ph.intel.com>
References: <568C1107.2060203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <568C1107.2060203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 01:52:55PM -0500, Hal Rosenstock wrote:
> In ib_mad.h, ib_mad_snoop_handler uses send_buf rather than send_wr
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

First off I have to say; this comment is wrong and should be fixed.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

That said.

I agree with Sean that the snoop interface should be removed.

I don't know the specific reason madeye was not accepted upstream back in the
day.  However, I _think_ it was because it implements a non-standard tracing
mechanism.

For this reason I have explored the use of the standard tracing infrastructure
within the mad stack.  The series I sent for general comment [1] implemented
tracing at a number of levels (umad and mad) as well as tracing of registered
agents.  This IMO give more insight into what is going on within the MAD stack
than the madeye module.

I'll see what I can do to update the tracing code.  In the mean time if others
want to look at the tracing code I have so far I pushed a branch to my github.

https://github.com/weiny2/linux-kernel  doug-fn-mad-trace

Ira

[1] https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg28188.html

> ---
> Change since v3:
> Fixed title to not include function name
> 
> Change since v2:
> Changed title to use "higher" language
> 
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

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2 TRIVIAL] IB/core: ib_mad.h ib_mad_snoop_handler
 documentation fix
Date: Tue, 5 Jan 2016 09:42:30 +0200
Message-ID: <568B73E6.4010106@mellanox.com>
References: <568AD99F.7040009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568AD99F.7040009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/4/2016 10:44 PM, Hal Rosenstock wrote:
> ib_mad_snoop_handler uses send_buf rather than send_wr
>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Please use higher language in commit titles e.g

  IB/core: Documentation fix in the MAD header file

> ---
> Change since v1:
> Fixed typo in patch description
>
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index ec9b44d..2b3573d 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -424,11 +424,11 @@ typedef void (*ib_mad_send_handler)(struct ib_mad_agent *mad_agent,
>   /**
>    * ib_mad_snoop_handler - Callback handler for snooping sent MADs.
>    * @mad_agent: MAD agent that snooped the MAD.
> - * @send_wr: Work request information on the sent MAD.
> + * @send_buf: send MAD data buffer.
>    * @mad_send_wc: Work completion information on the sent MAD.  Valid
>    *   only for snooping that occurs on a send completion.
>    *
> - * Clients snooping MADs should not modify data referenced by the @send_wr
> + * Clients snooping MADs should not modify data referenced by the @send_buf
>    * or @mad_send_wc.
>    */
>   typedef void (*ib_mad_snoop_handler)(struct ib_mad_agent *mad_agent,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> ______________________________________________________________________
> This email has been scanned by the Symantec Email Security.cloud service.
> For more information please visit http://www.symanteccloud.com
> ______________________________________________________________________

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

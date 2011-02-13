From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: FW: [PATCH] umad_send.3 (man page)
Date: Sun, 13 Feb 2011 08:56:24 +0200
Message-ID: <20110213065624.GA5697@calypso.voltaire.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B284CC@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B284CC-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:19 Fri 11 Feb     , Mike Heinz wrote:
> Alex,
> 
> Given the change over in libibumad, you may not have seen this, so I'm resending it.
> 
> -----Original Message-----
> From: Mike Heinz
> Sent: Monday, February 07, 2011 11:10 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ewg
> Cc: 'Sasha Khapyorsky'
> Subject: [PATCH] umad_send.3 (man page)
> 
> The man page for umad_send() does not match the source code.
> 
> Signed-off-by: Michael Heinz Michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
> ---
> diff --git a/libibumad/man/umad_send.3 b/libibumad/man/umad_send.3
> index 2d84f57..c4a617a 100644
> --- a/libibumad/man/umad_send.3
> +++ b/libibumad/man/umad_send.3
> @@ -7,11 +7,13 @@ umad_send \- send umad
>  .nf
>  .B #include <infiniband/umad.h>
>  .sp
> -.BI "int umad_send(int " "portid" ", int " "agentid" ", void " "*umad" ", int " "timeout_ms" ", int " "retries");
> +.BI "int umad_send(int " "portid" ", int " "agentid" ", void " "*umad" ", int " "length" ", int " "timeout_ms" ", int " "retries");
>  .fi
>  .SH "DESCRIPTION"
>  .B umad_send()
> -sends the specified
> +sends
> +.I length\fR
> +bytes from the specified
>  .I umad\fR
>  buffer from the port specified by
>  .I portid\fR,
> 
> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
> 

Thanks, applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

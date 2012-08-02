From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: FDR HCA only doing QDR?
Date: Thu, 2 Aug 2012 02:42:26 -0700
Message-ID: <CAL1RGDWe_utjyW-MHomdp-e8WTL2BNe2d0dgCsLS_6Gak23Efw@mail.gmail.com>
References: <CALfB72AFcWfrvRHfh0fRu_0iLt0wdapgwPef6RFe3KockzxeEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72AFcWfrvRHfh0fRu_0iLt0wdapgwPef6RFe3KockzxeEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 2, 2012 at 1:18 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>                         active_speed:           10.0 Gbps (8)

You actually seem to be getting FDR-10 (raw speed undecoded of 8
instead of QDR==4).

There may be some software/firmware issue but I would double check
that your physical layer is clean -- it may just be that the card is
legitimately deciding it can't do full FDR on the link you have.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

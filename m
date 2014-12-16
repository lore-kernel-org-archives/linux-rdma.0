From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Query regarding MAD_DEMUX and Secure Host
Date: Tue, 16 Dec 2014 17:33:22 +0200
Message-ID: <20141216173322.01dfc2c9@jpm-OptiPlex-GX620>
References: <CANwwZzXucfdxVYJWD3F=gJ2PLOnXEt-9aDSm4pskwO_pXFjaZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANwwZzXucfdxVYJWD3F=gJ2PLOnXEt-9aDSm4pskwO_pXFjaZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 15 Dec 2014 15:07:58 +0530
Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> am I correct in my understanding
> when i say that MAD_DEMUX feature is not required to be
> supported/implemented in Mellanox RoCE Drivers?
> 
> It is required only for Infiniband drivers?

Actually, you will need to support MAD_DEMUX anyway. If not, the
CONF_SPECIAL_QP command will fail if Secure Host mode is operating.

CONF_SPECIAL_QP is required for RoCE as well, since if it is not called
we will not have QP1.  However, since this command maps QP0 as well to
a QP, the MAD_DEMUX command is still required.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

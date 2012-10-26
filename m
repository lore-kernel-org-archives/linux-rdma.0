From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Questions about IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV opcodes
Date: Fri, 26 Oct 2012 01:18:45 -0700
Message-ID: <CAL1RGDUNX+hWScz5FGryp7bSV2-QBFGedAH5QtU3kJ-xJF=MJQ@mail.gmail.com>
References: <CAKgG1fzodm5qPmokjOG_OTsXOFmU+nd4H1z3Kqq-A-ixpYDO_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgG1fzodm5qPmokjOG_OTsXOFmU+nd4H1z3Kqq-A-ixpYDO_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kenneth vitagliano <kenvitagliano-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 25, 2012 at 2:09 AM, kenneth vitagliano
<kenvitagliano-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If there is any documentation with the answers to the questions below,
> please link it to me, thanks.
>
> Can someone please confirm the usage of the post_send opcodes
> IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV:

The best place to look for an explanation of this is the InfiniBand spec,
specifically the base memory management extensions.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state
 for multicast
Date: Tue, 26 Apr 2016 15:16:25 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com> <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461070287-13469-4-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Apr 2016, Erez Shitrit wrote:

> +/*
> +* There are 4 types of join states:
> +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
> +*/
> +enum {
> +	FULLMEMBER_JOIN,
> +	NONMEMBER_JOIN,
> +	SENDONLY_NONMEBER_JOIN,
> +	SENDONLY_FULLMEMBER_JOIN,
> +	NUM_JOIN_MEMBERSHIP_TYPES = 4

It will be 4 because there are 4 definitions before this. No need to
assign a value. The value will be wrong if more definitions are added
later.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

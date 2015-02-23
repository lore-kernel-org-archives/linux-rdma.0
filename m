From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/ipoib: drop mcast_mutex usage
Date: Mon, 23 Feb 2015 18:56:29 +0200
Message-ID: <CAJ3xEMgLPF9pCwQDy9QyL9fAERJXJRXN2gBj3nhuXUCcbfCMPg@mail.gmail.com>
References: <cover.1424562072.git.dledford@redhat.com>
	<767f4c41779db63ce8c6dbba04b21959aba70ef9.1424562072.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <767f4c41779db63ce8c6dbba04b21959aba70ef9.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 22, 2015 at 2:27 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We needed the mcast_mutex when we had to prevent the join completion
> callback from having the value it stored in mcast->mc overwritten

downstream patches of this series (7/9 and 8/9) make pretty much heavy
usage of the mcast_mutex (e.g add/delete lines that use it), and patch
9/9 removes it altogether.. which would be very confusing for
maintaining purposes. Is there a sane way to avoid that?!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

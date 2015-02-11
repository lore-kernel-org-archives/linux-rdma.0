From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Wed, 11 Feb 2015 02:52:34 +0200
Message-ID: <CAJ3xEMhrU4Lk_zpB+5XBoBdSNQf92XR7pjiROQOZXsdzwkK2Ag@mail.gmail.com>
References: <1422999775-32111-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422999775-32111-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 3, 2015 at 11:42 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Last minute InfiniBand/RDMA changes for 3.19:
>  - Revert IPoIB driver back to 3.18 state.  We had a number of fixes go
>    into 3.19, but they introduced regressions.  We tried to get everything
>    fixed up but ran out of time, so we'll try again for 3.20.

Doug, it smells as of we might be going to lose 3.20 too... 10 days
left and you haven't posted a revised version of the patches so people
can review/test/respond on them... once you have it please also
provide a public git spot where they can be pulled, Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

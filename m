From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH fixes-3.12 00/15] Mellanox mlx5 driver fixes
Date: Tue, 17 Sep 2013 23:54:13 +0300
Message-ID: <CAJZOPZKreJ+koN56-4AgzkK10N-uGajZ_1nqhj=htw=pgVf81w@mail.gmail.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 11, 2013 at 4:35 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Roland,
>
> This series from Eli and Co contains batch of bug fixes to mlx5 issues we've stumbled
> on during various regression tests. Few other fixes which are more of cleanups and
> enhancements will be sent for-next/3.13 once this series gets into 3.12
>
> One or two patches need to go into -stable to for 3.11.y, lets do that after
> they spend some time in the 3.12 cycle.



Hi Roland, is this series safe/ok for 3.12? I know not just 5-6 fixes,
but this is new driver, so 15 fixes for RC > 1 don't seem like a
killer to me.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

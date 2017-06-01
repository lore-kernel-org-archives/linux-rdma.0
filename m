From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Replace netdev_priv with ipoib_priv for
 ipoib_get_link_ksettings
Date: Thu, 01 Jun 2017 18:26:09 -0400
Message-ID: <1496355969.7171.65.camel@redhat.com>
References: <1494504868-17204-1-git-send-email-honli@redhat.com>
         <20170511123109.GC18962@yuval-lap> <20170511124020.GH3616@mtr-leonro.local>
         <92da39f0-2c7a-5039-234e-94da89d5eacb@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <92da39f0-2c7a-5039-234e-94da89d5eacb-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-05-19 at 11:15 +0800, Yanjun Zhu wrote:
> >> Suggesting to remove kernel oops from commit log message, fix is
> trivial.
> > Please don't, they are useful.
> Can we explain this in commit log message?
> 
> The patch "IB/IPoIB: Support acceleration options callbacks" makes 
> ipoib_pirv different from netdev_priv.

I reworked the commit message considerably to resolve this issue, and
then applied the patch.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

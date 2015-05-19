From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/netlink: Add defines for MAD requests through netlink
Date: Tue, 19 May 2015 08:36:59 +0300
Message-ID: <CAJ3xEMj7cWuUYDvEtpLP93spQk52K=DN8Nw7bTD9RBt=LStaFA@mail.gmail.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
	<1431975616-23529-2-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431975616-23529-2-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 18, 2015 at 10:00 PM,  <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> This patch adds netlink defines for MAD client, MAD group, and MAD
> operation.

But you added code that deals specifically with SA things, not general
mads, right? better to reflect that
is the name and use RDMA_NL_SA prefix
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

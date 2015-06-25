From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 00/10] Move RoCE GID management to IB/Core
Date: Thu, 25 Jun 2015 12:13:57 -0600
Message-ID: <20150625181357.GG21033@obsidianresearch.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
 <CAJ3xEMjZgMPWA0jm3ReM4Cb1Q-Gz-vXh=XguSYUMAVD+qPA6Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjZgMPWA0jm3ReM4Cb1Q-Gz-vXh=XguSYUMAVD+qPA6Zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 11:34:43AM +0300, Or Gerlitz wrote:

> So... are we finally OK wrt the feedback  you provided?

I've been looking at Yishai's series, I though it was almost good to
go, but the error flows are still wrong :(

For Matan's patch, I only looked briefly, merging it with the other
file made the diffs super hard to read for some reason. But I think it
is the right series now, and covers the right ground..

Very superficially the locking looks improved I am happy to see the
wonky smb_rmb stuff gone as well. But I stopped reading the first
series after I saw the bad use of rcu, so who knows what else in
there..

Haven't even looked at Haggai's patch considering the other two are
ahead of it. It seemed like it was covering the right ground too.

I'll try and read one of them next week, hopefully others will comment
in the mean time.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

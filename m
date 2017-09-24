From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Question on mlx5-ib auto load
Date: Sun, 24 Sep 2017 12:52:15 -0600
Message-ID: <20170924185215.GA18007@obsidianresearch.com>
References: <daab19a4-98c8-3115-065d-2c40c5843121@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <daab19a4-98c8-3115-065d-2c40c5843121-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 24, 2017 at 04:43:58PM +0300, Sagi Grimberg wrote:
> Did anyone notice that mlx5_ib does not auto load at boot time?
>
> While mlx5_core requests mlx5_ib, mlx5_ib still does not load
> at boot time (only when reloading mlx5_core).

I tested this recently, and it does work.

Be aware, that if you have mlx5_core in your initrd then you must also
have mlx5_ib in the initrd as well, otherwise it will not work.

Not all distros are doing this yet. eg there are patches for Debian
derived.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

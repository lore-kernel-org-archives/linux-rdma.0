From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat: Remove non-existed infiniband modules
Date: Mon, 9 Jan 2017 08:43:02 -0700
Message-ID: <20170109154302.GC29687@obsidianresearch.com>
References: <20170109085429.32598-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170109085429.32598-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 09, 2017 at 10:54:29AM +0200, Leon Romanovsky wrote:
> The modules ib_addr.ko, ib_mad.ko and ib_sa.ko were integrated
> into ib_core.ko in following kernel commits:
>  * c2e49c92326f ("IB/SA: Integrate ib_sa module into ib_core module")
>  * 4c2cb4220431 ("IB/MAD: Integrate ib_mad module into ib_core module")
>  * e3f20f02864f ("IB/core: Integrate IB address resolution module into core")
> 
> Fixes: 39fa824dd80e ("redhat: add udev/systemd/etc infrastructure bits")
> Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  redhat/rdma.kernel-init | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Make sense to me, but if we are saying the redhat scripts only work
with a certain newish kernel then it would be great to also purge all
that crufty compat stuff (mttrs, pci tuning, etc) so we can better
understand what is still actually needed..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

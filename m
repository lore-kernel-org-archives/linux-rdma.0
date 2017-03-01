From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Adding uploaders field
Date: Wed, 1 Mar 2017 10:28:11 -0700
Message-ID: <20170301172811.GA14791@obsidianresearch.com>
References: <20170301122349.22634-1-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301122349.22634-1-talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 02:23:49PM +0200, Talat Batheesh wrote:
> Issue: None
> Change-Id: I4d5c5ab493974d7be537d83f3a8efa5cdb160679
> Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Please don't send patches with these internal header..

>  debian/control | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/debian/control b/debian/control
> index 4033dd8..55f7f50 100644
> +++ b/debian/control
> @@ -1,5 +1,9 @@
>  Source: rdma-core
>  Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> +Uploaders:
> + Benjamin Drung <bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
> + Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
> + Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I don't need to be on this list ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

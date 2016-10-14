From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [bug] build the user-space stack code in github is fail on ubuntu
Date: Fri, 14 Oct 2016 10:48:42 -0600
Message-ID: <20161014164842.GD6258@obsidianresearch.com>
References: <5800A467.2020602@huawei.com>
 <5800A835.5020207@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5800A835.5020207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 05:41:09PM +0800, oulijun wrote:

> >   Run Build Command:/usr/sbin/ninja cmTryCompileExec2838577708

I should also point out that ubuntu has two things called ninja, you
want the 'ninja-build' package, not the 'ninja' (eg the /usr/sbin
version).

You probably have to deinstall the ninja package.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

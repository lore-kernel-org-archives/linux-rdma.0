From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V1 7/9] IB/cma: Add configfs for rdma_cm
Date: Mon, 23 Nov 2015 14:23:59 -0700
Message-ID: <20151123212359.GC6062@obsidianresearch.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
 <1444925232-13598-8-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444925232-13598-8-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 07:07:10PM +0300, Matan Barak wrote:
> Users would like to control the behaviour of rdma_cm.
> For example, old applications which don't set the
> required RoCE gid type could be executed on RoCE V2
> network types. In order to support this configuration,
> we implement a configfs for rdma_cm.
> 
> In order to use the configfs, one needs to mount it and
> mkdir <IB device name> inside rdma_cm directory.
> 
> The patch adds support for a single configuration file,
> default_roce_mode. The mode can either be "IB/RoCE v1" or
> "RoCE v2".

Also no Documentation/ABI stuff for this

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

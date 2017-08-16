From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Wed, 16 Aug 2017 09:36:20 -0600
Message-ID: <20170816153620.GA22584@obsidianresearch.com>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170815095651.GQ24282@mtr-leonro.local>
 <20170815153523.GA14623@obsidianresearch.com>
 <20170815155843.GT24282@mtr-leonro.local>
 <20170815165737.GB15171@obsidianresearch.com>
 <20170815174058.GW24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170815174058.GW24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 15, 2017 at 08:40:58PM +0300, Leon Romanovsky wrote:

> Can this be a solution?
> http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/in.h#L27

No, that is going the other way - continuing to provide compat
#defines while using an enum underlying, the preprocessor still cannot
see the value to build the string.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

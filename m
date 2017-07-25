From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] Autoloading for RDMA netlink modules
Date: Tue, 25 Jul 2017 15:22:48 -0600
Message-ID: <20170725212248.GD10905@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170725063236.GQ3259@mtr-leonro.local>
 <20170725143420.GA434@obsidianresearch.com>
 <20170725181951.GT3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725181951.GT3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 09:19:51PM +0300, Leon Romanovsky wrote:

> Let's wait till Doug creates for-next with RDMA netlink patches, because
> I assume that 2 out of 3 patches will be completely different.

Send me a note when Doug has a tree and I will respin things.

> My concern that "regular" user will trigger "admin" operation without
> any checks.

It seems strange, but this is how the kernel works in this area, and
RDMA is not special in this regard.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

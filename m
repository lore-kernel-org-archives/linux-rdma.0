From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V7 libibverbs 0/7] Add extension and XRC QP support
Date: Thu, 11 Jul 2013 11:07:10 -0600
Message-ID: <20130711170710.GB27357@obsidianresearch.com>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1373555063-31790-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 11, 2013 at 06:04:16PM +0300, Yishai Hadas wrote:

> ABI support with OFED release, added place holder for 6 function pointers
>  in verbs_context to enable ABI compatibility with OFED release that already 
>  used 6 extended verbs before XRC. 

WTF !?!

The extension mechanism is NOT A TOY.

IT IS NOT FOR VENDORS TO USE.

Extension ids must be allocated at upstream, by Roland.

If you deviate from upstream you *MUST* change the ibverbs SONAME.

PERIOD.

What version of OFA OFED did this? This is a violation of the new
upstream first policy at OFA!

So, I'm going to NAK this. It sets an exceedingly bad precedent going
forward.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

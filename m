From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: vendor extension moratorium?
Date: Wed, 17 Feb 2016 12:02:07 +0200
Message-ID: <20160217100207.GB30450@leon.nu>
References: <20160217085508.GA3578@infradead.org>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160217085508.GA3578-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 17, 2016 at 12:55:08AM -0800, Christoph Hellwig wrote:
> While doing heavy lifting in the RDMA stack I keep running into
> badly designed vendor extensions over and over.
> 
> Is there any support for requiring that we'll only add features that
> actually are peer reviewed and standardized before keeping on piling
> up crap?  It seems like at least vendors seems to be fighting for death
> by features unfortunately.

Your description of current state is pretty accurate, except one thing -
there are a lot of actively used code in user space with real consumers
which eager to get new features.

Do you have any suggestions on how to handle the adding and exporting
of new IB features?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5 7/7] Use configuration symbol for always in-line
Date: Wed, 1 Jun 2016 10:10:55 -0600
Message-ID: <20160601161055.GA15186@obsidianresearch.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
 <1464788882-1876-8-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464788882-1876-8-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 04:48:02PM +0300, Yishai Hadas wrote:

>  #define HIDDEN		__attribute__((visibility("hidden")))

If you are going to do one you might as well do them all...

BTW, it is strange to use visibility("hidden"), usually you'd use
-fvisibility=hidden during the compile and then use
visibility("default") only on the one or two functions that need to be
public.

Much safer.

> +#ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
> +#define ALWAYS_INLINE __attribute__((always_inline))
> +#else
> +#define ALWAYS_INLINE
> +#endif


Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5 7/7] Use configuration symbol for always in-line
Date: Wed, 1 Jun 2016 10:28:18 -0600
Message-ID: <20160601162818.GC15186@obsidianresearch.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
 <1464788882-1876-8-git-send-email-yishaih@mellanox.com>
 <20160601161055.GA15186@obsidianresearch.com>
 <07a22f6a-eea9-201c-2c64-f51eb557a1d3@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <07a22f6a-eea9-201c-2c64-f51eb557a1d3-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 01, 2016 at 07:15:35PM +0300, Matan Barak (External) wrote:

> It wasn't added by this series :)

No, but the autodetection of attributes was added. It doesn't make
sense to autodetect only one attribute. Don't do it at all or do it
properly, adding non-functional theoretical 'portability' crap is a
bad idea.

> Actually, it isn't used in libmlx5 so it should be dropped.

Make sure that nm --dynamic on libmlx5.so shows the provider is only
definining the one or two entry point symbols.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

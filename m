From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Tue, 19 May 2015 13:15:53 -0600
Message-ID: <20150519191553.GP18675@obsidianresearch.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
 <1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
 <20150519185801.GM18675@obsidianresearch.com>
 <20150519190031.GN18675@obsidianresearch.com>
 <CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 10:11:43PM +0300, Or Gerlitz wrote:
> > Sorry, direct this toward the page offset in the next patch.
> 
> We see this as a piece of detail related to the specific vendor
> driver. I don't see the point of overloading the user space verbs
> library or app with an API to get the offset of the clock within the
> mmap page and such, do you?

Can't you find a better place for this than overloading the
query_device call? I'd rather see you add some kind of driver-specific
command than this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

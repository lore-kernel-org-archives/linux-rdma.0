From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 3/7] IB/core: Add idr based standard types
Date: Wed, 15 Feb 2017 11:09:06 -0700
Message-ID: <20170215180906.GC19162@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-4-git-send-email-matanb@mellanox.com>
 <20170210200849.GC4335@obsidianresearch.com>
 <CAAKD3BDyg04Y0c9Pn1YbxZyxR8PpRFYbpF8UokFcgi7CdUcj3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDyg04Y0c9Pn1YbxZyxR8PpRFYbpF8UokFcgi7CdUcj3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 03:44:22PM +0200, Matan Barak wrote:

> > static int uverbs_destroy_qp(struct ib_uobject *uobject, enum rdma_remove_reason why)
> >
> 
> Since we don't care about the reason here and it's called from the
> destroy callback,
> we could leave the deceleration as is.

The point is to ultimately push the reason down to the driver so the
driver can do the proper action. Eg force-destroy a HCA object.

> I can add a WARN_ON, but this is essentially the same as ib_destroy_qp
> fails when a context is destroyed (either because of hot unplug or process
> termination). You won't get here because of regular destroy handler.
> This is the current behavior as well.

I don't think the current behavior is very good. We've had driver
submissions that include random failures inside their destroy routines
- the current situation is a mess.
 
> Why should we calculate this on runtime if we could know this in compile time?

Because then you need the ugly macro :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

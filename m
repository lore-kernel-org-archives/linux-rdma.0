From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 7 Mar 2017 11:17:38 -0700
Message-ID: <20170307181738.GC2228@obsidianresearch.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d3cc85f3-d5ef-5114-68a3-6989b5b26478-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 07, 2017 at 07:18:40PM +0200, Yishai Hadas wrote:

> >I'm not sure I like this, why not create a mlx5dv_create_cq?
> >
> 
> Below notes justify the suggested scheme comparing adding mlx5dv_create_cq()
> API for that purpose:
> 
> 1) From developer point of view it's fully preferred to use single API (e.g.
> ibv_create_cq_ex) otherwise developer should choose, do I use

Why? That isn't right, from a developer point of view it is better to
have strong type safety so the API is obvious how to use correctly.

How is the developer to know to pass some random mlxdv struct in the
void *? How do they know when that is even safe to do?

> ibv_create_cq_ex() or mlx5dv_create_cq(). If I use the latter, do I need
> mlx5dv_destroy_cq() or can I use ibv_destroy_cq()...

Since ibv_create_cq_ex would return a ibv_cq, it obviously would be
destroyed via ibv_destroy_cq

> 2) We would like to support this scheme for other calls as well and enjoy
> libibverbs generic services on top, that's can be achieved by the suggested
> scheme.

Other calls can be evaluated when we get to them, but I can't see why
they would be any better..

> 3) Other vendors can use the suggested scheme without the need to expose any
> xxx_create_cq() API, all that is needed is just to expose direct H file,
> this can be done also by mlx5 customers who don't want to use the mlx5_dv
> direct calls but to enjoy from the option to supply vendor data as part of
> CQ creation.

I don't think this is a positive.

Using the dv interface should be obvious and *always* create a
link-time dependency on the driver. If someone doesn't want to do that
then they shouldn't use the interface.

This makes it very clear to the user that they are touching a
non-portable API and they need to plan accordingly.

We have caused ourselves alot of pain by trying to be too clever with
function pointers in the past. That totally defeats the usual symver
mechanism for compatability and should *NOT* be done by this dv stuff.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

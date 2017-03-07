From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 7 Mar 2017 15:22:28 -0700
Message-ID: <20170307222228.GB15314@obsidianresearch.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
 <20170307181738.GC2228@obsidianresearch.com>
 <6da2bd37-62c3-af73-fe81-5be57a327c2d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6da2bd37-62c3-af73-fe81-5be57a327c2d-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 12:10:18AM +0200, Yishai Hadas wrote:

> >>1) From developer point of view it's fully preferred to use single API (e.g.
> >>ibv_create_cq_ex) otherwise developer should choose, do I use
> >
> >Why? That isn't right, from a developer point of view it is better to
> >have strong type safety so the API is obvious how to use correctly.
> 
> Having 2 APIs for similar purpose usually doesn't make sense and might bring
> confusion and code duplication. The mlx5dv_create_cq() from application
> point of view can be used to create a regular CQ when no vendor data will be
> supplied, the idea is to have a single API for clarity.

It is very common to have 'basic' and 'complex' API entry points. I
don't see a problem here.

> Once the correct structure is used there should be *no* safety issue, please
> note that the vendor data defined to be as some extended structure which can
> only be grown based on comp_mask so that compatibility will be saved in any
> case.

No, you still have to make sure that your ib_device is somehow a mlx5.

mlx5dv_create_cq can directly verify this on entry, but ibv_create_cq
will assume the vendor data is for the device that is bound - this is
why it is inherently unsafe and unfriendly to discard the type
information via the void *.

> >This makes it very clear to the user that they are touching a
> >non-portable API and they need to plan accordingly.
> 
> This is correct for using DV APIs which are fully driver specific but its
> not a must to add an API which is quite similar to the ibv_xxx one.

When I suggested this approach at Plumbers, I explained that all
create methods should be the vendor specific call, and that they should
return a generic object that could be used with the other standard API
entry points.

The idea you want to pollute many of the existing common APIs with a
vendor_data argument is ugly as sin, the entire *point* of this
approach is to keep all that uglyness in *your* dv driver and make it
*very clear* to users that they are outside the standard and cannot
export portability when they touch this stuff.

I don't find your arguments against this idea very compelling..

> >We have caused ourselves alot of pain by trying to be too clever with
> >function pointers in the past. That totally defeats the usual symver
> >mechanism for compatability and should *NOT* be done by this dv stuff.
> 
> That's why we want to prevent from new APIs when really not required.

Symbol versions are well understood, we should use them sanely when
possible.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

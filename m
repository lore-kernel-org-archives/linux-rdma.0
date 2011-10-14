From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 09:34:39 -0700
Message-ID: <CAL1RGDXWV1f9SxJ4gXQbqDBazk7Xm6RHHNGdZv46SzZXsUu39Q@mail.gmail.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
 <1828884A29C6694DAF28B7E6B8A8237316E6AF8E@ORSMSX101.amr.corp.intel.com> <alpine.DEB.2.00.1110141131150.6411@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1110141131150.6411-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 9:31 AM, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org> wrote:
> Our 3.1-rc9 included Rolands for-next branch.

There are a few RDMA-related changes there :)

A bisect from 3.1-rc9 to my for-next branch shouldn't take too long if
you get chance,
otherwise I'll try to take a look soon.

This is with mlx4 drivers?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

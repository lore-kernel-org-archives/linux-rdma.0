From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Wed, 21 Oct 2015 00:00:54 +0300
Message-ID: <CAJ3xEMgjyTDJYEfEs+SYZVVZ_h1hTYOL0Oq=ih7cdhxBo+C--Q@mail.gmail.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
	<CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
	<561E510C.8060501@redhat.com>
	<CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
	<56266C4B.1060000@redhat.com>
	<CAJ3xEMiM1VRCOZwVtMR2=3dmBi_DmOA3yhPas5TqBtaFCdzH-A@mail.gmail.com>
	<20151020165237.GC24608@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151020165237.GC24608-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 7:52 PM, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2015 at 07:42:25PM +0300, Or Gerlitz wrote:

>> As for the RoCE patches, you mentioned reviewing them, this is going to
>> take time, which makes sense. However, the self-multicast loopback prevention
>> patches are
>
> My issue with the latest round of UAPI changes is I don't see any
> Reviewed-By tag from someone at Mellanox whom I think understands our
> UAPI.
>
> UAPI changes are *NOT* something first-time list contributors should
> be doing unassisted.

Jason, your point makes sense, when we did the internal review, I have
asked that someone with the relevant knowledge will review this part.

As I wrote below, we should encourage people to take part in upstream
development, and making such comment only after the patch sits on the
list whole two months (V1 was very minor change, V2 was re-spin) isn't
going in the encouragement direction.

There's one patch in the series that adds UAPI -- it's 1/7 "IB/core:
Extend ib_uverbs_create_qp"
https://patchwork.kernel.org/patch/7405241/

I will try to get Reviewed-by: from Haggai or Matan tomorrow, can you
also take a look today, so we don't miss 4.4 just for that?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

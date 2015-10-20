From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Tue, 20 Oct 2015 10:52:37 -0600
Message-ID: <20151020165237.GC24608@obsidianresearch.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
 <CAJ3xEMiZCrj83XK6R0za61SenfzDh5H3wF-DTanvsk1Hha7MKA@mail.gmail.com>
 <56266C4B.1060000@redhat.com>
 <CAJ3xEMiM1VRCOZwVtMR2=3dmBi_DmOA3yhPas5TqBtaFCdzH-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiM1VRCOZwVtMR2=3dmBi_DmOA3yhPas5TqBtaFCdzH-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2015 at 07:42:25PM +0300, Or Gerlitz wrote:

> As for the RoCE patches, you mentioned reviewing them, this is going to
> take time, which makes sense. However, the self-multicast loopback prevention
> patches are

My issue with the latest round of UAPI changes is I don't see any
Reviewed-By tag from someone at Mellanox whom I think understands our
UAPI.

UAPI changes are *NOT* something first-time list contributors should
be doing unassisted.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

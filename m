From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 02/16] IB/pvrdma: Add user-level shared functions
Date: Wed, 5 Oct 2016 10:43:32 -0700
Message-ID: <39c3d051-5be8-dfef-075e-b76b2b56dd61@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
 <515c704574423b16feb4c3d97847156623a8d042.1475458407.git.aditr@vmware.com>
 <20161005134254.GH9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161005134254.GH9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 4:42:54PM +0300, Leon Romanovsky wrote:
> On Sun, Oct 02, 2016 at 07:10:22PM -0700, Adit Ranadive wrote: > > We s=
hare some common structures with the user-level driver. This patch adds >=
 > those structures and shared functions to traverse the QP/CQ rings. > >=
 > > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> > > Reviewed-by: J=
orgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> > > Reviewed-by: George Zhang <georgezh=
ang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> > >=
 Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> > > Signed-off-by: Adit Ran=
adive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> > > --- > > Changes v5->v6: > >  - Removed the p=
vrdma-uapi.h file and moved common structures into > >  pvrdma-abi.h. > >=
  - Moved enums and structs common to user-level and kernel driver into >=
 >  pvrdma-abi.h. > >  - Changed _exp_ to _ex_ for extended structures. >=
 > > > Changes v4->v5: > >  - Moved pvrdma_uapi.h and pvrdma_user.h into =
common UAPI folder. > >  - Renamed to pvrdma-uapi.h and pvrdma-abi.h resp=
ectively. > >  - Prefixed unsigned vars with __. > > > > Changes v3->v4: =
> >  - Moved pvrdma_sge into
pvrdma_uapi.h > > --- > >  include/uapi/rdma/Kbuild       |   2 + > >  in=
clude/uapi/rdma/pvrdma-abi.h | 289 ++++++++++++++++++++++++++++++++++++++=
+++ > >  2 files changed, 291 insertions(+) > >  create mode 100644 inclu=
de/uapi/rdma/pvrdma-abi.h > > > > diff --git a/include/uapi/rdma/Kbuild b=
/include/uapi/rdma/Kbuild > > index ac62908..04357ba 100644 > > --- a/inc=
lude/uapi/rdma/Kbuild > > +++ b/include/uapi/rdma/Kbuild > > @@ -8,3 +8,5=
 @@ header-y +=3D rdma_netlink.h > >  header-y +=3D rdma_user_cm.h > >  h=
eader-y +=3D hfi/ > >  header-y +=3D rdma_user_rxe.h > > +header-y +=3D p=
vrdma-abi.h > > +header-y +=3D pvrdma-uapi.h > > You forgot to drop this =
line.

Yes, sorry about that. I mentioned this to Doug already. He didnt want me=

to do a respin just for this though.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

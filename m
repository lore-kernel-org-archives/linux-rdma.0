From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned IB objects
Date: Thu, 7 May 2015 13:23:13 +0530
Message-ID: <a943c57dfa28c91f418a07a2904ef852@mail.gmail.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
 <20150504175700.3483.57728.stgit@manet.1015granger.net> <CANjDDBicLDb7K=RZB5Gqv+oACaAG8DANJX3ML971jnXd_5KEuQ@mail.gmail.com>
 <963F9850-38D0-4434-88E8-14BC42F74499@oracle.com> <CANjDDBg3Ey0DEM3n9PY9VLW+chF0=AJPghYOopo1a9vL3CKzKg@mail.gmail.com>
 <20150506164817.GC11331@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150506164817.GC11331-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, May 06, 2015 10:18 PM
> To: Devesh Sharma
> Cc: Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux NFS Mailing List
> Subject: Re: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned =
IB
> objects
>
> On Wed, May 06, 2015 at 07:52:03PM +0530, Devesh Sharma wrote:
> > >> Should we check for EBUSY explicitly? other then this is an erro=
r
> > >> in vendor specific ib_dealloc_pd()
> > >
> > > Any error return means ib_dealloc_pd() has failed, right? Doesn=E2=
=80=99t
> > > that mean the PD is still allocated, and could cause problems lat=
er?
> >
> > Yes, you are correct, I was thinking ib_dealloc_pd() has a refcount
> > implemented in the core layer, thus if the PD is used by any resour=
ce,
> > it will always fail with -EBUSY.
>
> .. and it will not be freed, which indicates a serious bug in the cal=
ler,
> so the
> caller should respond to the failure with a BUG_ON or WARN_ON.

Yes, that=E2=80=99s what this patch is doing.

>
> > .With emulex adapter it is possible to fail dealloc_pd with ENOMEM =
or
> > EIO in cases where device f/w is not responding etc. this situation=
 do
> > not represent PD is actually in use.
>
> This is a really bad idea. If the pd was freed and from the consumer'=
s
> perspective everything is sane then it should return success.
>
> If the driver detects an internal failure, then it should move the dr=
iver
> to a
> failed state (whatever that means, but at a minimum it means the firm=
ware
> state and driver state must be resync'd), and still succeed the deall=
oc.

Makes sense.

>
> There is absolutely nothing the caller can do about a driver level fa=
ilure
> here,
> and it doesn't indicate a caller bug.
>
> Returning ENOMEM for dealloc is what we'd call an insane API. You can=
't
> have
> failable memory allocations in a dealloc path.

I will supply a fix in ocrdma.

Reviewed-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

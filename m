From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 16:11:50 -0700
Message-ID: <20150818231150.GB32269@kroah.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
 <20150818161102.GA4040@kroah.com>
 <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com>
 <20150818165026.GA25138@kroah.com>
 <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 10:00:39AM -0700, Doug Ledford wrote:
>=20
> > On Aug 18, 2015, at 9:50 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> >=20
> > On Tue, Aug 18, 2015 at 04:29:50PM +0000, Marciniszyn, Mike wrote:
> >>> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
> >>>=20
> >>> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
> >>>> The move from infiniband to staging requires a temporary PCI
> >>>> dependency to fix 0-day build issues.  The
> >>>> drivers/infiniband/hw/Kconfig gratuitously added it for all driv=
ers.
> >>>>=20
> >>>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>> ---
> >>>> drivers/staging/hfi1/Kconfig |    2 +-
> >>>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>=20
> >>> Why are these drivers not in drivers/staging/infiniband/ ?  Why d=
o they all
> >>> need their own drivers/staging/ directory?
> >>>=20
> >>=20
> >> Greg, what is the path name convention for adding a driver to stag=
ing
> >> when its eventual destination is part of a subsystem?  Perhaps it
> >> should be drivers/staging/hw/hfi1?
> >=20
> > As I have no idea what this driver is, or what it is for,
>=20
> It=E2=80=99s a driver for Intel=E2=80=99s newest RDMA capable fabric =
interface.  It=E2=80=99s
> not InfiniBand, but Intel=E2=80=99s answer to InfiniBand and will eve=
ntually
> live in the drivers/infiniband/hw tree with the other RDMA capable
> device drivers.
>=20
> > or why it is
> > in staging, I can't answer this=E2=80=A6
>=20
> I put it in staging in my tree because it=E2=80=99s >50,000 lines of =
code, so
> repeated patch submissions to the mailing list were absolutely
> painful, but it has work that needs done as a result of review
> comments, and one item of work in particular (converting it to use an
> RDMA transfer engine library) will take a lot of work, so putting it
> in staging and requiring that to be complete before putting it in the
> regular tree is a decent carrot for getting that large bit of work
> done.

Does it have a TODO file that lists what needs to be done with it?  Are
you going to be responsible for all of the patches sent to it and you
just want me to ignore them, or will you send patches to me for me to
apply?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

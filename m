From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 19:49:04 -0700
Message-ID: <20150819024904.GA4151@kroah.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
 <20150818161102.GA4040@kroah.com>
 <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com>
 <20150818165026.GA25138@kroah.com>
 <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com>
 <20150818231150.GB32269@kroah.com>
 <08B07723-39A2-416E-92F9-E939B21EBBCA@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <08B07723-39A2-416E-92F9-E939B21EBBCA-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 06:24:40PM -0700, Doug Ledford wrote:
>=20
> > On Aug 18, 2015, at 4:11 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> >=20
> > On Tue, Aug 18, 2015 at 10:00:39AM -0700, Doug Ledford wrote:
> >>=20
> >>> On Aug 18, 2015, at 9:50 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> >>>=20
> >>> On Tue, Aug 18, 2015 at 04:29:50PM +0000, Marciniszyn, Mike wrote=
:
> >>>>> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
> >>>>>=20
> >>>>> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrot=
e:
> >>>>>> The move from infiniband to staging requires a temporary PCI
> >>>>>> dependency to fix 0-day build issues.  The
> >>>>>> drivers/infiniband/hw/Kconfig gratuitously added it for all dr=
ivers.
> >>>>>>=20
> >>>>>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>> ---
> >>>>>> drivers/staging/hfi1/Kconfig |    2 +-
> >>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>=20
> >>>>> Why are these drivers not in drivers/staging/infiniband/ ?  Why=
 do they all
> >>>>> need their own drivers/staging/ directory?
> >>>>>=20
> >>>>=20
> >>>> Greg, what is the path name convention for adding a driver to st=
aging
> >>>> when its eventual destination is part of a subsystem?  Perhaps i=
t
> >>>> should be drivers/staging/hw/hfi1?
> >>>=20
> >>> As I have no idea what this driver is, or what it is for,
> >>=20
> >> It=E2=80=99s a driver for Intel=E2=80=99s newest RDMA capable fabr=
ic interface.  It=E2=80=99s
> >> not InfiniBand, but Intel=E2=80=99s answer to InfiniBand and will =
eventually
> >> live in the drivers/infiniband/hw tree with the other RDMA capable
> >> device drivers.
> >>=20
> >>> or why it is
> >>> in staging, I can't answer this=E2=80=A6
> >>=20
> >> I put it in staging in my tree because it=E2=80=99s >50,000 lines =
of code, so
> >> repeated patch submissions to the mailing list were absolutely
> >> painful, but it has work that needs done as a result of review
> >> comments, and one item of work in particular (converting it to use=
 an
> >> RDMA transfer engine library) will take a lot of work, so putting =
it
> >> in staging and requiring that to be complete before putting it in =
the
> >> regular tree is a decent carrot for getting that large bit of work
> >> done.
> >=20
> > Does it have a TODO file that lists what needs to be done with it?
>=20
> Yes.
>=20
> >  Are
> > you going to be responsible for all of the patches sent to it and y=
ou
> > just want me to ignore them, or will you send patches to me for me =
to
> > apply?
>=20
> I expect the patch load to be significant due to the required TODO
> item of making it use a transfer engine library.  I wouldn=E2=80=99t =
want to
> sign you up for that load.  If you are OK with me processing the
> patches, then I=E2=80=99m happy to do so.  If you would prefer the ot=
her way
> around, then I=E2=80=99ll defer to your wishes.

What is "significant"?  I'm kind of used to handling a lot of patches :=
)

How are you going to handle all of the coding style fixups that will en=
d
up coming in from people?  Want me to just let you handle all of them a=
s
well?  If so, please remove me from the MAINTAINERS entry for this
subdirectory so that I, and the driverdevel mailing list do not get the
emails.

Otherwise, feel free to just send me patches, I can easily handle them.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

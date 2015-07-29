From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: deprecating amso1100
Date: Wed, 29 Jul 2015 09:31:29 -0500
Message-ID: <017301d0ca0b$423decf0$c6b9c6d0$@opengridcomputing.com>
References: <55AE93E0.9060002@opengridcomputing.com> <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com> <D2F193D21ECD8C45917AD3D5B26513300C49590A@CRSMSX101.amr.corp.intel.com> <0F66BC31-60A1-4513-B858-17A75BFD42DA@redhat.com> <55B8E30D.5090205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B8E30D.5090205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, July 29, 2015 9:28 AM
> To: Dennis Dalessandro
> Cc: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: deprecating amso1100
>=20
> On 07/21/2015 04:45 PM, Doug Ledford wrote:
> >
> >> On Jul 21, 2015, at 4:42 PM, Dalessandro, Dennis <dennis.dalessand=
ro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> -----Original Message-----
> >>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> >>> Sent: Tuesday, July 21, 2015 2:49 PM
> >>> To: Steve Wise
> >>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Subject: Re: deprecating amso1100
> >>>
> >>>
> >>>> On Jul 21, 2015, at 2:48 PM, Steve Wise <swise@opengridcomputing=
=2Ecom>
> >>> wrote:
> >>>>
> >>>> Hey Doug,
> >>>>
> >>>> How should I submit changes to deprecate amso1100?  The HW hasn'=
t been
> >>> sold since 2005, and the SW has definite bit rot.  Its time to re=
move it...
> >>>>
> >>>> Thanks,
> >>>>
> >>>> Steve.
> >>>
> >>> Send me a git patch that uses git mv to move it to staging and we=
=C3=A2=E2=82=AC=E2=84=A2ll leave it
> >>> there for a release or two and then remove it after that.
> >>
> >> Steve, "git format-patch -M" does a nice job creating a patch that=
 can actually be looked at via email.
> >>
> >> http://marc.info/?l=3Dlinux-kernel&m=3D143593782206479&w=3D2
> >>
> >> For the Ipath driver I was going to send directly to the staging m=
aintainer/list. Doug, should that come to you through linux-rdma
> instead?
> >
> > I sent an email to Greg K-H to ask that question.  It doesn=E2=80=99=
t matter to me.  If you want, send the email to this list and if I get =
a response
> from GKH that he wants to take it, I=E2=80=99ll just point him to it =
once he lands.
>=20
> I'll be sending these through to Linus (as agreed with Greg).  Howeve=
r,
> the patches need a TODO file added to the driver directory when it is
> placed in the staging tree (that's a mandatory requirement of being i=
n
> that tree).  In this case, the TODO would just be to remove the drive=
r
> as some point in time.  That point it pretty arbitrary, but I would
> suggest removing the driver in the 4.6 merge window.

Sure.  Will you create this file or do you want a patch from me?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

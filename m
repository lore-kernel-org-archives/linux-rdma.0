From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] pull request: linux-firmware: Add Intel OPA hfi1 firmware
Date: Thu, 13 Aug 2015 17:47:40 -0400
Message-ID: <20150813214739.GA3975@phlsvsds.ph.intel.com>
References: <20150811213205.GA28613@phlsvsds.ph.intel.com> <20150811222557.GA6293@obsidianresearch.com> <9010F06FA27E5745AF23866A8C9A2B3D2E9B136C@FMSMSX106.amr.corp.intel.com> <20150811233553.GA3553@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150811233553.GA3553-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vogel, Steve" <steve.vogel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sowa, David" <david.sowa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 11, 2015 at 05:35:53PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2015 at 10:47:03PM +0000, Vogel, Steve wrote:
> > The license terms allow anyone to distribute (but not sell) the fir=
mware but
> > only for use on Intel products.=20
>=20
> Redistribution alone may be enough to be included in linux-firmware
>=20
> However, most of the additional terms (and there are lots of them)
> this imposes beyond the usual likely make it impossible to include in=
 a
> distro, so pragmatically, there is no reason to push for inclusion in
> linux-firmware.
>=20
> This is going to be a hard road for you guys. Falling in line with
> every other Intel firmware blob's (i915, ibt, iwlwifi, SST2) license
> would be much easier on you and the distros.
>=20
> Frankly, I think the onus is on you to get statements from the
> licensing teams at Fedora, Debian, RH and SuSE on if they can include
> work under this license or not.
>=20
> I suspect Fedora and Debian will both say they can't, just based on
> their public policies and the additional restrictions in this
> license.. But hey, I'm not a licensing lawyer..
>=20

I just noticed that the email from Steve that Jason Replied to did not =
make it
to the lists.

Here is the text from Steve for reference.

<quote>
Here is an interpretation of the grant language:

2.11Grant.  Subject to Your compliance with the terms of this Agreement=
, and
  the limitations set forth in Section 2.2, Intel hereby grants You, du=
ring the
term of this Agreement, a non-transferable, non-exclusive, non-sublicen=
seable
(except as expressly set forth below), limited right and license:
(A)Onunder Intel=E2=80=99s copyrights, to:
(1)Onreproduce and execute the Software only for internal use with Inte=
l
Products, including designing products for Intel Products,; this licens=
e does
not include the right to sublicense, and may be exercised only within Y=
our
facilities by Your employees;

[This allows anyone obtaining the software to
make copies and use the software, but not to re-license it.]


(2)Ondistribute the unmodified Software only in Object Code, only for u=
se with
Intel Products; this license includes the right to sublicense, but only=
 the
rights to execute the Software and only under Intel=E2=80=99s End User =
Software License
Agreement attached as Attachment B, without the right to further sublic=
ense;


[This allows anyone to re-distribute the software for use on Intel prod=
ucts and
requires the them to re-distribute with the license in Attachment B]


</quote>

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

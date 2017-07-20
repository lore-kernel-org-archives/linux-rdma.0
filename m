From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: CFP: RDMA Microconference - Call for presentations
Date: Thu, 20 Jul 2017 17:15:40 +0000
Message-ID: <VI1PR0502MB3008B5B0E8C0D48FD77C0FEFD1A70@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170615050305.GF17846@mtr-leonro.local>
 <20170720040739.GU3259@mtr-leonro.local>
 <aa1dc549-ce54-d5b7-00e6-0fe07a5f3736@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aa1dc549-ce54-d5b7-00e6-0fe07a5f3736-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dennis Dalessandro
> Sent: Thursday, July 20, 2017 11:03 AM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>;
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Liran Liss
> <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Matan Barak
> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: CFP: RDMA Microconference - Call for presentations
>=20
> On 7/20/2017 12:07 AM, Leon Romanovsky wrote:
> > REMINDER !!!!!!!
> >
> > On Thu, Jun 15, 2017 at 08:03:05AM +0300, Leon Romanovsky wrote:
> >> Hi All,
> >>
> >> We want to point your attention to the following [1] announcement
> >> that RDMA microconference is accepted into LPC 2017.
> >>
> >> This is a call for presentations for the 2nd RDMA microconference
> >> which will be held on September 13-15 in Los Angeles, CA. The event
> >> is intended to gather developers of the RDMA stack and the main
> >> intent is to provide room for discussion between developers with focus=
 on
> resolving things.
> >>
> >> If you are interested to present, please submit a proposal to
> >> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org and/or to Linux RDMA mailing list
> >> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org before August 14th, 2017, at 23:59 EST.
>=20
> >
> >
>=20
> Have exchanged a separate email thread with Leon. I am planning to attend=
 and
> present for a discussion on how we can add statistics to RDMA Tool. This =
will
> focus on device related counters and how an architecture could look that =
is easy
> to add more counters and have different counters across devices without
> requiring a lot of updates to the user space tool.
>=20

I haven't synced with Leon yet, nor I have followed any past rdmatool discu=
ssion actively for statistics.
So feel free to ignore my comment.

Having ethtool style mechanism that allows device related counters is good =
starting point instead of reinventing a new mechanism.
Probably a good starting point to follow existing mechanism via 3 similar c=
allbacks get_strings(), get_sset_count(), get_ethtool_stats().
May be such 3 callbacks for rdamtool from ibdev.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

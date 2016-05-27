From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 17:44:27 +0300
Message-ID: <20160527144427.GZ25500@leon.nu>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
 <20160527045157.GW25500@leon.nu>
 <20160527114414.GA27420@phlsvsds.ph.intel.com>
 <20160527131357.GX25500@leon.nu>
 <57484C71.309@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ohyzAr2DuZRs7WU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57484C71.309-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7ohyzAr2DuZRs7WU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2016 at 09:32:33AM -0400, Doug Ledford wrote:
> On 5/27/2016 9:13 AM, Leon Romanovsky wrote:
> > On Fri, May 27, 2016 at 07:44:15AM -0400, Dennis Dalessandro wrote:
> >> On Fri, May 27, 2016 at 07:51:57AM +0300, Leon Romanovsky wrote:
> >>> On Thu, May 26, 2016 at 06:34:28PM -0400, Doug Ledford wrote:
> >>>> Hi Linus,
> >>>>
> >>>> This is the second group of code for the 4.7 merge window.  It looks
> >>>> large, but only in one sense.  I'll get to that in a minute.  The li=
st
> >>>> of changes here breaks down as follows:
> >>>>
> >>>> Round two of 4.7 merge window patches
> >>>>
> >>>
> >>> <...>
> >>>
> >>>> - The big item on the list: hfi1 driver updates, plus moving the hfi1
> >>>>  driver out of staging                             <- everything else
> >>>
> >>> Hi Doug and Linus,
> >>>
> >>> The move hfi1 from the staging is a right thing, it was there a long
> >>> time and it is almost ready.
> >>
> >> No, not almost, it is totally ready. We have bent over backwards to go=
 well
> >> beyond what was in the TODO list. This is a clean, stable, and well
> >> performing driver.
> >=20
> > It is your's TODO, not mine.
>=20
> No, but Mellanox has been adding to the TODO list, changing the goal
> posts so to speak.  They really *have* bent over backwards to meet the
> TODO requirements and then some.
>=20
> >>
> >>> However the timing of this move puzzle me, we are in the process of A=
BI
> >>> change [1, 2] as a response to security alert [3]. Moves like this wi=
th
> >>> proprietary char device and ABI scheme different from whole RDMA stack
> >>> will limit the ABI work without real need.
> >>
> >> The driver sitting in staging or not has no impact on the ABI re-desig=
n.
> >> They are two completely separate issues.
> >=20
> > Separate char device? IOCTLs per-device vs. global IOCTLs per subsystem?
> > Role of the IB CORE code in the driver management?
>=20
> Really Leon?  The qib driver has the *exact* same issue, and it sits out
> of staging.  If moving this driver out of staging somehow stops us from
> making the new ABI while the qib driver not being in staging doesn't
> prevent it, then we are a bunch of idiots.  This would appear to me to
> be a very disingenuous complaint on your part.

Doug,
Did you read my question?

I feel that I need to repeat my main point again: "It is OK to move hfi1 dr=
iver
out-of-staging" and repeat the question too: "Will the hfi1 interface
decisions limit our ABI work?".

There is no politics here, just my PERSONAL opinion and believe that ABI wo=
rk can be
done in months time frame. And again, "It is OK to move hfi1 driver out-of-=
staging".

--7ohyzAr2DuZRs7WU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXSF1LAAoJEORje4g2clinrXsP/jCVRx3l/7R56eAzooP5kIoq
IvYfKy6hVAWsU8EzZE/6+6naNcAa68RFeWMVsPz0wVB3vg/1ZLDxytqaPkWuXHzt
yqW3SDaVBIl0ozXD/drCfz+LUhRM9OgyU3O30MnE670jmtPg6schfbspMHE4A3Ik
APfJhRIZbUK8lpVXusvb4gstx8tGrobLU8Vq+Gm0nApYW5YWwzLF+csIgTG5VJ/+
LT0Ue1HosStuouAc8BPCYMEpGbTCJSSlXirvvrkGJEXLF8KYvwEGpU6JUiGbKitD
AeDWEWK2YBqnsfMuRCiWDKFj5x1OqGteIpRZdeE14nhf3bFvi6nKa+ZAOO8ltSzZ
d7gs1W9ePHdnT2AZmn1jMQ89CudSIlPGfUU7WkjkOTGZePMGn07YMcFU2Lgp/tVz
RRggtgybsAGImt2pdg/T04wbvIy8ucalOCD1f6qVBNrfWILdaMwl8J2WYJFJ8EZe
Sfej1uO9srWkJZAzuMJR43eRsZaA9jRUAApDognk7JhTF8jemrNwAu8/9W8W7TZ+
Yh4b1SBzCngXmfwHBnu8nRWVQROQYpl6K/r44p3uYR93DLrPjv7/uVowfcqVpl+L
gOcJ3PjkYbXsDaorQwoYw/Kc+HN4iszlNBHd7VwGUVYCYaVwIW3xQ93CrQodSO9e
TOnqaI+RCUVkZyLvNf1y
=vPZ/
-----END PGP SIGNATURE-----

--7ohyzAr2DuZRs7WU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

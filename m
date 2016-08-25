From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Thu, 25 Aug 2016 10:20:15 -0400
Message-ID: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eGKsV0kWgpsXiVEKew2nj110v2B76SeXp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823185441.GA1233-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eGKsV0kWgpsXiVEKew2nj110v2B76SeXp
Content-Type: multipart/mixed; boundary="002gJ4ho0uAnABWE0EjePQxVjF0tDrQAu"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>,
 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>,
 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
References: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160823185441.GA1233-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160823185441.GA1233-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--002gJ4ho0uAnABWE0EjePQxVjF0tDrQAu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 2:54 PM, Jason Gunthorpe wrote:
> On Mon, Aug 22, 2016 at 03:43:52PM -0600, Jason Gunthorpe wrote:
>=20
>> The full install to / is still a small TODO, it is part and parcel
>> with doing the packaging, in my mind.
>=20
> I just pushed a basic starting point rpm spec file, it still needs to
> be split into multiple subpackages, but it is installable with all the
> usual paths.

You can do that, but I routinely tell upstream maintainers that we don't
touch their spec files.  Every distro modifies the spec file so heavily
for their own custom installation that it just doesn't make much sense
to worry about it at the upstream level.  Build one that can be used
when running rpmbuild -ta and that's all you need.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--002gJ4ho0uAnABWE0EjePQxVjF0tDrQAu--

--eGKsV0kWgpsXiVEKew2nj110v2B76SeXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvv6fAAoJELgmozMOVy/dnEUQALJJ51r2FzzwGqlfM28tIH1Y
QphXCGLcAgdS4tREdzUKNYJ+LJUGrZkrYP/C6kTLlVdtFs6bnrk9DA1XHj64Mi4c
aNQUXLnzW8RPW+NKdaCoGEohXWGvcQ4uFCawQygMSZHdFr7DaH9e8xRZTLJzoyTi
CeWWkmHK+0qc2aLFSLLf+1dDQNUxRwVltUR/f80v6/jsrrt1xPlMXIeZwz+EtYxZ
oTpEae6sJQzlVOL+OJa8Y46uTmmzW0tZEOdTVN6BKjATT/uthSVG69GITokCyf04
rd8FRzKXB+Lhie7B0W8VI0MLioBsiWVnLGOfKkswHbmBcziYUjPrdVJISUksTX+V
XIW7KBhs5OMORY8ZMQoo1qeuOZhTjQCk+mlHXJPdUos31O/4ccQvbEsMtICQcd2Q
e+wrTLr4rNfsIekpF2FzAGZbwnpZNj37FwTATCcS83+oBhvVYXpwoSxqqSmnJzbA
T/BCUFgRcLGXeduC5ySZXP6mtjbE0gsA899ucZSXVGHmwYc9k+WWuWbqiR5joPCI
1fGR4GNkmZqHRYnRJ/7ZkExA/xUqK1L+OSxN80TsbywhoTdJhOWsEwRX6nXTfPn1
iJGTf11242HFLr1UwfIh1xla0a95doJywF8ccCiWrfI2dWm/p5esKFpnG+ONH/En
WUWCz31MyyhswY2tWSEs
=v7uj
-----END PGP SIGNATURE-----

--eGKsV0kWgpsXiVEKew2nj110v2B76SeXp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

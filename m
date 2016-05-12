From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/5] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 12 May 2016 15:48:16 -0400
Message-ID: <f96bfe93-6bcc-7d55-8f7a-1792d12d41d9@redhat.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512171846.6198.31415.stgit@scvm10.sc.intel.com>
 <20160512174332.GB13553@obsidianresearch.com>
 <20160512192726.GB15146@phlsvsds.ph.intel.com>
 <20160512194006.GA6364@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tin3h2IX4Ol26MUVN6Um5QmKd33ncMiDm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512194006.GA6364-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tin3h2IX4Ol26MUVN6Um5QmKd33ncMiDm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 03:40 PM, Jason Gunthorpe wrote:
> On Thu, May 12, 2016 at 03:27:27PM -0400, Dennis Dalessandro wrote:
>>> I thought we agreed to get rid of this as well? It certainly does not=

>>> belong here, and as a general rule, I don't think ioctls should be
>>> doing capable tests..
>>
>> Yeah. I left it in this patch set because this just "ports" our existi=
ng
>> code to ioctl(). The eprom stuff is completely removed in another patc=
h set
>> that I posted shortly after this. It's at:
>=20
> Adding code and then removing it in a later patch is not a best
> practice.. Just don't add it or define ioctl numbers at all..

Yeah, but then that changes the nature of the patchset.  It goes from
being "We ported the existing write API to ioctl API" to "We ported
existing write API to ioctl API and also changed the scope of the API in
the process", which is considered bad coding practice (one stand alone
change per commit).  It's pretty 6 of one, half dozen of the other if
you ask me.  A better solution would have been to remove the EEPROM
stuff from the write ioctl, then only port the remaining stuff.  That
would have avoided both coding issues, but I also understand how they
got here, which is they did the ioctl conversion before they knew they
were going to rip out the EEPROM code.  In any case, the best fix would
be to rebase the two series that are remaining and move any "rip out
things like eeprom support" patches to prior to the ioctl patches and
make it so that they rip out the write interface version of it instead,
and then squash a second copy of the ioctl removal into this patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tin3h2IX4Ol26MUVN6Um5QmKd33ncMiDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNN4AAAoJELgmozMOVy/d5IsP/jUkefaiH+a1HIbgcng/ZnC4
lS2rx2fNfhaOsDf649QC4St1Dz4K6DBPytgQp88+Yb79CrRvGgufOemy0riKVM77
KuCLMECBR0qN6nH8LlJCR6PqyTU9t+qh3FFOOYHOTmq0jpM+/NzDP5xmG9FV673w
TvPAnpd78BcHt2Agj0Aq5busYPUhH4wDtD3Xk5DTpGNxR2LPloEteq0H/MhTzQom
DEx1oFXMhxp2T1xWomtHNy9f9QCxj+MGY4DDhW/PnNvby57TB6HKcqjnhcYMwVAK
5efIz6SqZ/YEEbUxZ/dmVRC8TeLuHTBm4/yLrR1jQW5G+wzPXCBP4kJVUS1mesaA
crRMOn7isxw9oHelF753rvyosnvVOdIJVUbh2wqmEBaubzlMS0OxancRvlWOdaWM
M/eAyT5SMav6SRr+Ui2rP/zpuP00wP4UxOzkvV8zvra4q8o1hWtLmDcftXAmBxxx
X2LFBVxeTmm639loHf5g/7cu/DEKzuaTxhHQS0PUdUuH1y4ZxB4UParscyxKF0Z0
2h51aM+UwilHkFVjlEI3pBys00H6d3GUNf1MVAId4dAGtKMqPF+zk3xXgPNFBgUC
IbPNBWU1wSShcwZ8tMoKX26VfiHxJdgDH0PHZzAyocaK0kgyi0O8c8Wj07ZXtys9
854QdFc8pdyEVXkrB1Be
=MYT0
-----END PGP SIGNATURE-----

--tin3h2IX4Ol26MUVN6Um5QmKd33ncMiDm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

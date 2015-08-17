From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] please pull rdma.git
Date: Mon, 17 Aug 2015 15:00:49 -0700
Message-ID: <0C315E78-9CB7-41C9-AD1F-26C191C36C8C@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F12BB28C-CBC3-4E54-B99A-2AE9365FEC35"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_F12BB28C-CBC3-4E54-B99A-2AE9365FEC35
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Linus,

I have a single bug fix for you to pull:

The following changes since commit =
b8f5595eb96c9fce1c907d13e89581e5061edf2e:

  RDMA/ocrdma: update ocrdma module license string (2015-07-24 11:34:41 =
-0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git =
tags/for-linus

for you to fetch changes up to 3661df179bfbd1bb21cf2c782d3c5c084ebe3cf4:

  iw_cxgb4: gracefully handle unknown CQE status errors (2015-07-28 =
11:24:51 -0400)

----------------------------------------------------------------
Changes for 4.2-rc

- Bugfix in iw_cxgb4

----------------------------------------------------------------
Hariprasad S (1):
      iw_cxgb4: gracefully handle unknown CQE status errors

 drivers/infiniband/hw/cxgb4/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_F12BB28C-CBC3-4E54-B99A-2AE9365FEC35
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV0lmSAAoJELgmozMOVy/dOB8P/AooC1BiXrxllKcYKa5KRsbo
ii5qKLUlXDZpD8DxeER51k+fP3vJWlgBe8m807bWdG2aZPgJHj+1aHg+5mASuJyZ
axu87/JRQ4yGAu1CcYeISERFYpAA3YCrl59D05DiXAgHREezRiNetvJhzI+D+kMe
gSGJZ3u+ncblhqg9mbSPyNG/gHledb0J8a+sGIOGSDIqpDQx8aCEt7ADer0S4EpU
pBi6HDRdZvdZwmTHbpkplcervWV4q8IWWHfnIijurUEiO/0bVOVrFD07RbjfamD6
R++3fue22RtN4j/3hh9AHczvCElLRy1c83kBSEDyJAb5oFvyfgbQMx1ELRv/y19m
htTyikqW0lTrGNufJz9eGtETLJPTlnAc+t6u5lj8k62T0h6IZB/31Rm5+WgD9QwG
TIgBAEtofjLt/19WH2VQVfTqOWFvBALARg32ulvkDDA/Y/H6osvpNnjgCBq2WD7R
ptwJcVvmyV2KaDflbMWZiq03MFef/nMQjNu1bgj+TmiHcxSEYW+cLi1zYHWyDIbF
du/1aGpbkpdVq6dnnGNtRoTZw+8qEVhaU2BlXKYXTJcA2Azaz6apapl6Td3ahE6Z
C/MM4ZBo2q5WteX2IwlVnRQdSkyuTSXMt11sV7G23n65gElZUYtDVjHYpzMcRf9S
d7ItJlklBcs8ecRnFSUR
=EwLS
-----END PGP SIGNATURE-----

--Apple-Mail=_F12BB28C-CBC3-4E54-B99A-2AE9365FEC35--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

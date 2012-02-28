From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ibacm fixes/updates
Date: Tue, 28 Feb 2012 16:17:11 -0500
Message-ID: <4F4D4457.5060806@redhat.com>
References: <4F4D424F.3040004@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig19200F147B12A2EF6E935362"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4D424F.3040004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig19200F147B12A2EF6E935362
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/28/2012 04:08 PM, Doug Ledford wrote:
> By default ibacm expects to find its configuration files in /etc/ibacm.=

>  This adds to the proliferation of directories in /etc/ needlessly.  We=

> already have a number of RDMA related directories to choose from
> depending on your install (OFED =3D=3D /etc/ofed or /etc/openib in the =
old
> days, RHEL5 =3D=3D /etc/openib from the old days, RHEL6 and Fedora are
> /etc/rdma, don't know what SuSE uses).  Would be best if these files
> were in the same place as the other RDMA related files.  And to make
> that happen easily, it would be best if they picked up on %{sysconfdir}=

> from the ./configure invocation in order to set the directory.  I used =
a
> static patch for now because I'm behind on my work, so updating the
> configure script was more than I had time to do.  I'm not bothering to
> include my patch as it needs done the other way so my patch is purely a=

> stopgap that should not see the time of day ;-)

Oh, and another issue, the pid and lock files are not in the LSB
standard locations:

Pid file: /var/run/
Lock file: /var/lock/subsys/  (this is created by the init script, and
it is doing the right thing here)

Right now the program creates the pid file in /var/lock (or
/var/run/lock, don't know which and they are linked so it shows up both
places), but not in /var/run which is the standard location for pid
files.  The port file can stay where it is.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig19200F147B12A2EF6E935362
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPTURXAAoJELgmozMOVy/dNQcP/1YSQCiyc+f1yIME3PjyjsHv
y4oOkaT1jfGh+9tQ1pZ6fKDCD9KrAh6WCc8Rh09Ydb4mgjVOqFlTpvtO5rA3kSdR
IyWBRxvypMH/ZxipyCTApMmchWJoY2Cq8nwODgW71FjnUmNBEmqJMjaPMRurxPug
c8Qz9PIVDkRWHsVTgyJE0XPqGLWLQvqPVKqrHFI40bYBbKJ1jrOp/pnLPxaxT95E
E1xvFPW4hSuQh/oGRmyuhpEX31ki4diHcjL7zAkt0zwvPWQdUpMhSLb7XWP1SzeI
OyxwHdp7mdlw8KSf2RL4GUCC1PAtznZbr/r0+slHwLC/FB+7joPLW3Y5LgyWkgmD
iF/BqlCd2u26MaHKaGT4W8zfAk5uqC733GoI5XNuEbIq9I4ynMCWJJWIFQuuouAI
+is/7F6XhgkU95RE1ufl2Y9RfwQknH6iOumBWZ/Zq+8Fw0Hgc08l0plrKYBevaWP
wuV1r9Xh1euwWND5rqp3sjhAfYK9iZATJveQ1pMkEqBoj4fICwkVCk8zPG6MMTzL
CM6YU2Zhbi1+tIkuhrhaKQEuMSrCrYntBUDjdHpXvAAv2H+tScDxTAhYooMkaVVn
wyd25gIe7eDfYSVkTxhZ65KmwaozF5tI9H2ydieI3pmvrraXNDiiNUcy9IvlhM1w
65MNa1heF8w2yM9WrUpx
=gfkF
-----END PGP SIGNATURE-----

--------------enig19200F147B12A2EF6E935362--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

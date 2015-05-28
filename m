From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Thu, 28 May 2015 11:02:03 +1000
Message-ID: <20150528110203.5cc1e9ce@canb.auug.org.au>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	<1431485563.43876.93.camel@redhat.com>
	<CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	<1431530845.2377.30.camel@redhat.com>
	<5554B7E8.4020902@mellanox.com>
	<1431615776.3276.14.camel@redhat.com>
	<CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	<555ABD9D.3080303@mellanox.com>
	<1432038160.3114.16.camel@redhat.com>
	<CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
	<1432064993.3114.80.camel@redhat.com>
	<1432069455.3476.12.camel@dworkin>
	<CAJ3xEMjk5JyY14ySXQsLRAMewxtqfJBDint6K=wGwnp6SOf9Pw@mail.gmail.com>
	<1432732409.28905.181.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rJYoH5=bPAW=GgBLez1VwBL"; protocol="application/pgp-signature"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432732409.28905.181.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Sig_/rJYoH5=bPAW=GgBLez1VwBL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Doug,

On Wed, 27 May 2015 09:13:29 -0400 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Stephen, can you set it up so that the linux-next tag from
> git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git is added
> to the linux-next testing please?

I haven't fetched tags in the past, only branches (it is a little
tricky, but I can work on it) and there is no linux-next tag in that
tree anyway (I assume that you mean for-next).

Also, how does this relate to Roland's infiniband tree
(git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git#for-ne=
xt)
that is already in linux-next?

Added from today.
Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/rJYoH5=bPAW=GgBLez1VwBL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVZmkQAAoJEMDTa8Ir7ZwVDFUP/iqiLvcVff6nEb7vQqSqzhQt
JX4GZixxtI7R9Gt2k3x6SzPTDPzWLCx4iq9qJH1xfKFClqtHIOgKTJBJz9wmINiH
se1N80FkE7+MjKJKO0x2LD1LSuU6D1TX+oeLc1fcyQgqbTuTTxPhgjbyfpjSzJB8
ypKn1WzmHITxCIwnyKp85Dq00wRu5EQFjybpzr7BCYEtXSV1mnL/jDyPPu33cFVt
CXDcYowTyf9OZ5rdgqpYJeGb+O1KL0WFx0DLOSCmKrO0b8dhXdVpu4pXW8rPn1NO
SCh52/07DdBnI7wp+KQiR4eD+C+d/F2aVDmY3x7isq/JnTjoAOxm6r9ZfQT1N1uW
KyOuOXtdcKjupKM4c2rTyITXkenTuGIgy/70KnzOoZL51To6iiEM5ebfYXGzynOj
3osffmvLeHyidnAvgVft0UjkaNgyYZD+CYZl2Gyog+xjrXoyPL+nErP3uO6xWS8C
RLL2cwdIOg680E7iJyZf5D5J54dtQn1rqa5hMrXz+BnPZkNrTrRcK4nJGuzcELrb
25TxQrejvgvHC2CzDLtKp38gdIrIHit4fX8cgi27q10tXZFxQt3wxi3JHEAOTvo7
nxziNeTUEFe2/NT/u7ZtB/BBXw+jP3HDJ37q7wGGYtRgfytvMnDkcLK9ZPN4T9PT
TuzguKYwyvhHsb7HDKsT
=FbkF
-----END PGP SIGNATURE-----

--Sig_/rJYoH5=bPAW=GgBLez1VwBL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

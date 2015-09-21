From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/hfi1: checking for NULL instead of IS_ERR
Date: Mon, 21 Sep 2015 13:03:52 -0400
Message-ID: <56003878.7080409@redhat.com>
References: <20150916062220.GC21542@mwanda> <55FC32ED.1000404@redhat.com>
 <20150919030153.GA30373@kroah.com> <56002564.6000100@redhat.com>
 <20150921164846.GB27380@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4ml48uUAVjeCHMhLQSf8oj9NvbIFiq3pS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150921164846.GB27380-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4ml48uUAVjeCHMhLQSf8oj9NvbIFiq3pS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/21/2015 12:48 PM, Greg Kroah-Hartman wrote:

> But, that's already not happening, as is obvious by my inbox.

Yeah, I see that.

> So, how about you forward on what you have so far to me, and I'll keep
> these.  Otherwise you will end up with nasty merge issues very quickly
> as people will continue to send stuff to me.

As you wish.  I pulled in a number of patches related to hfi1, but I've
already sent the pull request to Linus and they made it as of 4.1-rc2.
So, just start from there and you will have all the patches I've taken.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4ml48uUAVjeCHMhLQSf8oj9NvbIFiq3pS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWADh4AAoJELgmozMOVy/dwaEP/3EHz/g8An1nH+TNqrT7CGzz
vxWVWrtKrfYoEF7ZOVXE6xHI+NnT/gvXylP3A9AL+/V6xN2gD1rssFgckL6XGPpC
3ItpfJebDFTEjrx7ElElQuCJGj+vW0yoK+T4wwYKsDw0W75j7eWnVNvM49d86MUs
TqRSmy3dUecQ/glzp9q1D2UucjS9PzB9nRgJcEQB1luKJO9qSY/zWLp5IfuULk7t
7BFMNCwixmv8RsUJV55ovGOmLqo0PFzI1Xttzj+3+W7nCbb7Vw6p8Qz7ZYjLkFfF
h3B0E3xY7EXSVsxmNu2+oClkPBG/GVIYKrpzgM/udonIWbgQyP/b4XZadKNe/2mx
3tzNMDlbvvvold3nnItzYP9vlNMJjX1C5ksrMnVxFyLkkBaVWWkFLWWyhjgA9mhr
+ESBphC4v4k326Pjuh5ZVIsHrxpTGXfdxpT3yg1HPo4zrL/ZeVL89Ib8MJ/9P3hU
actKM+MGCPkzl/Sk/5j9mvhl/FCtjCCyFQ21v4u30DlBIEdG26Bl0nBd08cKhOwm
FjahZLcxLHBtOfRt8ju91Dpv81TWID/toznLRbSZp/6IXu0Pa0w5HpzoCdF+SMG+
D/3cc/huBlxGConVNIMafmt8pB8lohN9w0GSGihcmsJ66mvhmHQjTBNQsxz+sAUH
dHKT8xZl+UhajkuMiPj9
=IliK
-----END PGP SIGNATURE-----

--4ml48uUAVjeCHMhLQSf8oj9NvbIFiq3pS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

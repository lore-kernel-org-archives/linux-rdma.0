From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Mon, 13 Nov 2017 09:15:07 +0200
Message-ID: <20171113071507.GA18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171111075704.GS18825@mtr-leonro.local>
 <CANjDDBiaw1VsJXbhNS2VJtpWE7XAx2diP7zXKr-CVViDZyMPGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1ysCV03AuJYXZqZy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBiaw1VsJXbhNS2VJtpWE7XAx2diP7zXKr-CVViDZyMPGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1ysCV03AuJYXZqZy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 13, 2017 at 08:47:38AM +0530, Devesh Sharma wrote:
> Hello Everyone,
>
> Can someone guide me how to initiate a pull of my recent submission to
> the stable branch. This is quite urgent.

Most probably, we will follow kernel rules for stable@.
It means patches should be in master branch, no pull requests and we
will use some tag to inform Nicolas to pick that fix for stable too.

At least, there is a need to write (copy/paste from kernel) initial document
with description of process.

Also, I didn't hear commitment from OFED developers that they use this
stable branch.

Thanks

--1ysCV03AuJYXZqZy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJRnsACgkQ5GN7iDZy
WKfMHA/+JyzG3jePKE9gSJTztsFs3FR/xhlXtTGhC2XvugT1/pW8NcdQYE37xXDL
lrwzXZZjSAeFBAAc1gxIGcYBd6KhWfrwm8IeWALWRADmnz/e8+kSc6aJNdd7KcQ3
N+HyC87F5BBxwftBU6TFdmcy0cwvZQTtzEoUe9NdeSReg7pr7D0nUniui3NFU07L
X7ssyfVK5kYq47GugxYvnC/zTlevkHjigt6dFguFpMQH+rdIbcqnQeRaQuxKKK88
Lc+7Jz46C3ZbqWq/byexogos9CuRkeYXnKbe0j8K14I0LFlZ2+izttrEAILWxTDh
6tmBR9sSN/0eAL2hVUsltWbXBgs4jZYLHMEGwl3fEawIS1CBXIC2Iz/utLKSa7mK
MnUryxq2wBZvkW695qfR7dFQwa+U+ZcA1r5Y6L2geMkvTnbPnAKB50i0ZgC0HIo/
0wK3WhgMm0R79sJmJQic05kWhQOv9+cSiGoV0ZOqmDzkjhewxuQsA9+a0sH+2plL
5dsFt6kBiFL/0xznESDMWbQYP8mcJZ7FOvA1txCwVaDu2Sp5W474/2BPnzkIda7m
JnxYc9u2Bc2M9a+f6z1uf2qi/95aClCxCU1tA4CJTQoAXkQKHR2uw7WH5BGfN8Fz
DY59vD9/USv5j//3di1KBvP19ikK8FktOBtqDqoOmp3DpEAMPdw=
=eZaW
-----END PGP SIGNATURE-----

--1ysCV03AuJYXZqZy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

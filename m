From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 19:27:08 +0300
Message-ID: <20170503162708.GO22833@mtr-leonro.local>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
 <823aa3f0-685f-4569-11d6-238cc4f0b126@grimberg.me>
 <780938034.8003164.1493824767084.JavaMail.zimbra@kalray.eu>
 <20170503155316.GA14334@obsidianresearch.com>
 <1493827096.3901.4.camel@sandisk.com>
 <77ada146-67eb-9dce-d252-6ac630c9a1e8@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MZf7D3rAEoQgPanC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <77ada146-67eb-9dce-d252-6ac630c9a1e8-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--MZf7D3rAEoQgPanC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 03, 2017 at 07:01:14PM +0300, Sagi Grimberg wrote:
>
> > Hello Jason,
> >
> > As far as I know the compiler only does that for compile-time constants. In
> > this case the divisor (max(queue_size / 2, 1)) is not a compile-time constant.
>
> We could theoretically do a (sig_count & max(queue_size / 2, 1)) but
> that would only do well with power of 2 sized queues...

IMHO, It is not-so-big-deal limitation.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--MZf7D3rAEoQgPanC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkKBNsACgkQ5GN7iDZy
WKdEyw//RItAIGZzws8EtdWYCAL4Azslkizn/P9nBiFyAJ7L7Pah9FRNLteLvf0N
vyvD6sDYHvBO0rdU0+QyaMuqBy5QVk1diyJ7I7cAcYT7kn4PARCOpX48mzszZWgj
+OHNJoCGcnfxzAy0fglJX3ujRUSaMxG/mDOGndyfhWekcZv0JJAfE4NYnfWBWGmr
tknog47I8dez78zkxtFOiByuMHpqgp9UD7W5HxcztglgRe2jAoO7CLqsPUwPiNDB
9qNnyS+Rpv0pY9yKqHff6zXNPW37ksow3lBPfRXDb2VyIU8jUJ9od2sCC6mrDbQV
lTiHxJdFnmNgGSlsoSRZPfDbrZpPmQGThBtxRNaTJY6Vwd7W8wJ4aKhTp0aAOVZf
FgqSo9CthlcYOpWLBjFPMjRyboLkIrIrf7ER8kvQ9p9PpJ/aaYrboX24KaLksUd9
D3A+cyB3Ei6dSSao7sZTiME+NIyn30KbKcZLGF6HLXV8ZzJArCAvooRu0lm+/JrG
JxF/28i4twdJnzTrdci9qBejM7ubUkIzm/gas3T2HqnyfXyOKXvOqxAuYlnB3ENL
0i68OX097v9J6KXJqTxn6Q9izvatES5c0DTz5HvdJvfUpKan/yRYOmXS3oNUYA7o
s+45brZ2pfpp/3TtVExpT8UGrauAn+SMNqsvD+6rmMIHNIMlQQI=
=ctGi
-----END PGP SIGNATURE-----

--MZf7D3rAEoQgPanC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

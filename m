From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Sun, 23 Apr 2017 13:34:39 +0300
Message-ID: <20170423103439.GC14088@mtr-leonro.local>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492101079.5176.9.camel@sandisk.com>
 <c52b5ce7-5346-419d-26f2-0d4d45d20471@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RGnAp+RkZMffi58C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c52b5ce7-5346-419d-26f2-0d4d45d20471-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RGnAp+RkZMffi58C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 20, 2017 at 02:30:46PM +0300, Sagi Grimberg wrote:
>
> > > This patch adds an arbitrary sg list support to NVMEoF host for
> > > capable devices (such as RDMA CX4/CX5 HCAs).
> > > During the review we decided to add an helper function to ib_core
> > > that will be used by ULPs in order to avoid code duplication.
> >
> > Hello Max,
> >
> > A question that is not related to the ULP drivers touched by this patch series:
> > some time ago registration of sg-lists with gaps was disabled in the SRP
> > initiator because arbitrary sg-lists triggered CQE dumps in combination with the
> > mlx5 driver. Does this mean that this issue has been resolved? If so, what mlx5
> > driver and/or firmware version are needed to reenable arbitrary sg-list support
> > in the SRP initiator?
>
> I'm concerned about the fact that the SRP issue wasn't resolved. There
> might be a bug hiding there.
>
> Max, Leon, my recollection was that the error syndrome you saw with SRP
> described "too much sgls for a single mr". If this is true, then I still
> think we need a different device capability for it.

I don't remember that Max succeeded to reproduce it.

>
> I'm even thinking we need to remove gaps support from iSER until this
> is addressed.

Better to find the root cause.

Thanks

--RGnAp+RkZMffi58C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj8gz4ACgkQ5GN7iDZy
WKc2ww/+NC9oNwziI7Vzbq9jR3HIGjTtA/TPItildKLz8vR3faU9Ac0g1XJ3NXUW
Kjju/CYBcB6xSbGMfYlX39B94UWRWbfadS+BEIuKVPTf6sdONFekZg0JdixZKiC+
BXJMtigC6re7mKfyZTnGIKscK+TnVgVbRjqsWhcuOgOCxNllsTcTB3nRBTA47Mpo
HfPO8/pmKflTba6OCRcX992/mVJRYpJZOtwTl7tGJfC0sugSvMQVBwXMM+M7wopP
4E136i2/xBKW/qZHsrYugmmgwUSuWHm4nPRAsrwXpN2o+BAkBq270xy091l6pOhW
z1A7qgmCLVl1Il6vFoYIaXhxTxkWhphLsQp5dpcnVSyi0npFrsUsms+31aADdmzU
zuGBece4TrCDXRHU2ll8qsuZHmndJbr6YR4P26p4ZpgGEj7unuujSQKM2Ge2Ja6O
NgbEuWcfkzEzn0vzq8gcpzuojOsrPvuX07VRQ7PjpYMuwUjwCRpiwK7Mz1Z0TA7Y
sT7x6TaaGWQdulIWHwQKg/dYoYBrCL9InuTfy+i6pA/GRx/RYhlfoiZLh0GpOqCo
4xXBdS1yqymwAf2rk/aU13eFLzyCPQniAqz/B/D+Z0cCaW10nc8tqQ4P2i8zyUgu
aIvaPkPbH2D6b0B04tZt8bVwyRGv4KAV64nIysoGhy8c4y82YXE=
=nKTF
-----END PGP SIGNATURE-----

--RGnAp+RkZMffi58C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

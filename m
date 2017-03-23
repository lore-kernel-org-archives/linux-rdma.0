From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Setting RoCE to v2 automatically
Date: Thu, 23 Mar 2017 21:14:26 +0200
Message-ID: <20170323191426.GD20443@mtr-leonro.local>
References: <CAANLjFqEeB6JM8pFDFcTRJCL9FPc4hUai45rNPf72rNb8g3NEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFqEeB6JM8pFDFcTRJCL9FPc4hUai45rNPf72rNb8g3NEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 22, 2017 at 05:30:11PM -0600, Robert LeBlanc wrote:
> How are people setting their adapters to use RoCEv2 automatically?
> I've created a udev rule that creates the directory in configfs and
> echos into default_roce_mode and it works fine if I run it with
> 'udevadm test', but on boot or module load it is not working (I do
> have the udev rule in initrd and it is creating the VFs, and renaming
> the adapters from my other rules). I was trying to get it all done
> through udev so that it happens when the module is loaded or at boot.
> We are not using OFED and the 4.9.14 kernel on CentOS 7.2.
>
> My current rule is:
> ACTION=="add", SUBSYSTEM=="net", ATTR{type}=="1",
> ATTRS{subsystem_vendor}=="0x15b3", \
> ATTRS{device}=="0x101?", WAIT_FOR="/sys/kernel/config/rdma_cm", \
>    PROGRAM=="/bin/sh -ec 'D=$(ls /sys$DEVPATH/device/infiniband); \
>        C=/sys/kernel/config/rdma_cm; if [ ! -d $C/$D ]; \
>        then mkdir $C/$D; fi; \
>        echo RoCE v2 > $C/$D/ports/1/default_roce_mode'"
>
> I've tried a variation using the infiniband subsystem, but it had the
> same result.
>
> Any ideas?

Maybe, the best way for the ecosystem in 2017 will be to set
RoCE v2 as a default in future kernels.

>
> Thanks,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljUHpIACgkQ5GN7iDZy
WKemDQ//aD7RqCQxx3U/BXWrqmegv0b1WHXOPXoNAcqgWqOU0sPtylezI3wMVKDh
GNsFmiKKgZPhEE11fIS9EcNlOZcBOr0Fcp79/fq1kgoe1pmNVuV3E2z+ZjUGiXnt
rgHfj3R5KgM+rLyqRDubXRQId4edLIMWGgBAIlhB5VW3By9cAQkKVjWW8b6a3Hkn
hFioMbn/evQHHliYBL0wOGA10ZyfKH99ySlj+qLxHmLgwwUAeYwjlHaPrqBRT0FX
uHZanPTfePW+5e3hY1NEI4l11GvOsVwKpCsfeJyNkW1b4sJLpiwM/1ZIEfM/OrYn
CPO6bX5mec3Z1JWdiNwxJbxm3xCWGEWfsL/CGQzNDpJg1poIL0ZBBTsABrSPR/ry
QR1lLeQNFUmb7sbyPBnplg5fX0lJ2suQ8QsEgwVUzLsbs3aroK+KFyCmNX94a1x9
3XRFrQlk3bJFOogxWZZ3qeNI2ic0F6v1rKRcfLx4xux4mM6k8emr8v9gVygKHVMd
T5mupguE+5DzRqU6fcB46Ycpn9iJBqM0XXYNd0s7UZ3D4Yr0NmC0ZsQg5bcIv5jp
nLaRhoi+pQUyxaX+EDTeIMSGweg+jVfluIrclTf1gA21MSGZbsb21/nNWIYvW+8S
3NzjPfWUgZxo4zGirZVJlVhKA7T+y+/9Hgd0JAEhH377gMkoEco=
=+7EW
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

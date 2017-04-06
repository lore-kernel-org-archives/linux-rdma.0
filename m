From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/6] mlx5: convert to generic pci_alloc_irq_vectors
Date: Thu, 6 Apr 2017 17:24:38 +0300
Message-ID: <20170406142438.GK2269@mtr-leonro.local>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
 <1491474998-16423-2-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJFRpmOek+ZRSQoz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491474998-16423-2-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--IJFRpmOek+ZRSQoz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 06, 2017 at 01:36:33PM +0300, Sagi Grimberg wrote:
> Now that we have a generic code to allocate an array
> of irq vectors and even correctly spread their affinity,
> correctly handle cpu hotplug events and more, were much
> better off using it.
>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--IJFRpmOek+ZRSQoz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljmT6YACgkQ5GN7iDZy
WKeziw//cVN3RKp/Wq6iHcAZmW4a1R9qiXVnMwcIMMFuHjQmOm/QklsgWWAW4GN9
ROJIC0H7ngo+wQU8DwipLmPzFZ8JPNoUitmRNnOP5/U7PSalJKg2KmuAVl2Zp7bk
dtTVkw4nYa0hfobzCvzoN8eH71qLq8e9O8+w9krHOGnwNVSQIdFV8YFzo/1nnVb6
P+z8WvG6pdGFnHkCc/Na2hXQEf/qDZa4Mxn1ch9K6oUvcrrG/tSqBuLsf9ks2El9
l51Ml3MUBMykMfJoHlk2UKqbTelPLmL/Gotp5gcp42AkBJP41FK7Zog7qZBMOPqS
ah/Ph/8NVBBF4eFAWiDYugl8hvVynDdWmE82mr8FOV6sq3OCige6JXn2XqF7n+VV
QEUdSlI6vCURbXNMdBySz5s31GgHCeRISGHnbEwitltjoqlys9AS8eg8L1NOjj1K
6f816ZEEtpGLDv86n07E6onCTzotbAKgVimKBokO9IoHYTeGUy1q0aEzoJ8a0jN7
u4FPUPcnUZI+foAtDQYbJgyYN2xoVINCiW2Mi+O+crUZsXsLfS4c3rmqCc0j+Hcr
5//qRFpD8bie0fda7zkX8KgFdXs/6WDbYD2g1/8A9IMEzaN8QYEOHUA4neJgY+MX
yKhtPdN0TSwD+iy1ocflQbAPdGFiKj2TsAXtfRm26zL96p3NfbU=
=/PLZ
-----END PGP SIGNATURE-----

--IJFRpmOek+ZRSQoz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

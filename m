From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Protect against self-requeue of a cq work item
Date: Sun, 12 Mar 2017 21:29:55 +0200
Message-ID: <20170312192955.GG2079@mtr-leonro.local>
References: <1489003252-1893-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489003252-1893-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 08, 2017 at 10:00:52PM +0200, Sagi Grimberg wrote:
> We need to make sure that the cq work item does not
> run when we are destroying the cq. Unlike flush_work,
> cancel_work_sync protects against self-requeue of the
> work item (which we can do in ib_cq_poll_work).
>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljFobMACgkQ5GN7iDZy
WKdQyxAAl8ec441yiZtLHLt5fcwidrJlUMI99ULRVYvY7e2xvOYTM5mEyKPJxajj
BBFpYnZOqQBvsKLHXw9Ic4KlHnLwEzSHTtVW7W2FEJXwbCSsaxCejleBmT4KuOXp
aH7CqVzj/VW1wRYiMF7OYGIplRpKcsGJ16abVheOZkDGMGplc0KvApHHXOSEf93X
esKJGHc1Az4tMxmTiDNjGWHX2M5uRPpvqBcXu+LobliBgkxoLA346ZWUmVldKVnV
ZWCV4NEdGvVe6NI4XFWNeT9x2Rn/gKtW8B02Jj6LrBe1Wu1BmZ3CxLaZ4sYqrCVJ
3Ph4yogdstqZXTP+nWBqGvl6nSGAs3wxPZLHYb9tw8sb+/oP0SvQESy1gkdXCNgV
fIQ1UEMr02kLwHOaxo5PKCxRUU3KD1vB9qMymM37Io309SCOsJSwfsjfMX/OeIw/
Gub+gDvCR+iHWtmbWno5eF4JjDTfDeiYSR1sCByQGT8IEpB55JU5nn+DtYR5LRGs
f1clB8KQU356G6+ucL9mBQmKYO25YKkza8yJ2zbDVou/kHFhfK10x0FfX/LgyizB
y25QGAgah6Zf2pahUBNt1bQEJiwfFzFlqLNCX+NbU/MpYYE3EGs+MlF2l7jH57pq
RNRC3mFnJ9eA0SShu3p49gLd7tUNrVDcvcUkpkqugBZDDrVzXW4=
=fscN
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

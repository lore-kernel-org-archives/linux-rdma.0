From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Mon, 29 May 2017 13:05:04 +0300
Message-ID: <20170529100504.GZ17751@mtr-leonro.local>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
 <20170528090705.GM13083@lst.de>
 <19a1d347-91da-7e5f-8877-86772204a80a@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XSEVMyPRvc8xgDhM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <19a1d347-91da-7e5f-8877-86772204a80a-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XSEVMyPRvc8xgDhM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 28, 2017 at 12:53:00PM +0300, Max Gurtovoy wrote:
>
>
> On 5/28/2017 12:07 PM, Christoph Hellwig wrote:
> > On Sun, May 28, 2017 at 10:53:11AM +0300, Max Gurtovoy wrote:
> > > Cache the needed umr_fence and set the wqe ctrl segmennt
> > > accordingly.
> >
> > Looks good,
> >
> > Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
> Thanks.
>
> >
> > But that whole fence logic looks awkward to me.  Does the following
> > patch to reorder it make sense to you?
> >
>
>
> Yes it make sense to me.
> Sagi/Leon, any comments ?

Max,

Do you see any performance impact for IB_WR_RDMA_READ, IB_WR_RDMA_WRITE
and IB_WR_RDMA_WRITE_WITH_IMM flows? They don't need fences and such
change can cause to performance losses.

Thanks


>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XSEVMyPRvc8xgDhM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkr8lAACgkQ5GN7iDZy
WKfRnA/6An8EL7+KNJcvVayjOxd3yYLaMQ66+hxmFAOKjPa6Ibi8WoDfjAbQqd2v
3evUPOkgkYJ6nzWmKPg6jAqAmkRy30LwefkiLrwHjJLyx50kRSAqQ6fw6r9oqOD+
f0FSaYpfFq3E7R871b3nbw5RwoR9Daf3sG/7PaZvy4ybrvwKR5ltYJDTvnORc4Ri
B/UEPCNVwOeA46NInk8wfgFKctF3+3F8tKUapu1nMn9UaTJLpqXsYZu45sjYwqoH
R3Y/Q/JzZun7ETaoVaLKeIV7Akcxro5noJfrT8o8/3sk5lO0k4/zhQ/xuldrHze0
rf9Uavizhfjdlqxgoc0iNK/rw30Ffk1cxgiIpqOS8g+dIP1V0u4LlPjxw9pE7Yv7
3FSHU2kpYsYEfImZL+oJZDoMy5x738Tqnc71tz/oMQtlXBBlDL+dy2nDnfoA1G8R
He1h/+7yyhdX7U6dWQURbjxu+4tGZU2fzJgd3mFo7lTmHN0JsbGwbl2K73qdM/wa
k1PdlZK6sxKH22m7wxZVdpdnWDF3ouv+ChenELKDvHQovGfThR0trJtwLFE4Rffg
NKXz0s/89u8Hs88xnivhd3qfNSfRAdQRjR/EwL0/ULlIbR4UtzEp4wKeYYZO8uf0
toOn3aDfC4kVNp0Pr09E/wfR7qABrXpzfegYINzrGg0+kBZLZvo=
=wGlN
-----END PGP SIGNATURE-----

--XSEVMyPRvc8xgDhM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

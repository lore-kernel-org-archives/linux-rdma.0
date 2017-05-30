From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Tue, 30 May 2017 20:15:02 +0300
Message-ID: <20170530171502.GC5406@mtr-leonro.local>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com>
 <1495957991-19223-2-git-send-email-maxg@mellanox.com>
 <20170528090705.GM13083@lst.de>
 <19a1d347-91da-7e5f-8877-86772204a80a@mellanox.com>
 <20170529100504.GZ17751@mtr-leonro.local>
 <89409b6d-466d-070a-7082-1f7bbb9ad7c7@mellanox.com>
 <20170529160609.GA17751@mtr-leonro.local>
 <d23a5a6f-bd9f-3b1a-34d5-25e8eb2a041c@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d23a5a6f-bd9f-3b1a-34d5-25e8eb2a041c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2017 at 01:51:33PM +0300, Sagi Grimberg wrote:
> Leon,
>
> > > We don't fence those WR's.
> > > Christoph just re-write it to be more intuitive code. I don't see logic
> > > difference, am I wrong here ?
> >
> > A little bit, before Christoph's suggestion, we calculated fence for
> > the paths which need such fence, after we will calculate for all paths.
>
> Every WQE posted to a send queue must include a fence bit. All work
> request posted on the send queue calculate the required fence, this
> used to happen in finish_wqe call-sites with get_fence(), Christoph
> just inlin'ed it.

Sagi,

Thanks, I found my mistake, I saw that IB_SEND_INLINE WR doesn't call to
get_fence and we have an if() which can skip finish_wqe, so I thought
that finish_wqe isn't called always, however it was for error path.

Thanks again.

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlktqJYACgkQ5GN7iDZy
WKdO9Q//aRlJSaRGg9dI7yYPACcVnwSuJ2OHBrkvDORNxjQ0wmq+XdTnnZBSaaPn
HnGhyv2HDRgzg38Q2rx8yuovWgq1g5BJYRyl7qBC/VXSwSjTbmSXugBkRtzDfSb6
N3mJy3SSm7oM3e296+A3Z7MqjfkIe01ELwaetekJz+x5EUv8hjPVhOfs/1oNNc9W
lNqQ5m5MR8yLyCsGPBoK3EO5VzP97KCDqo36KPMOmEzWc2g5J89DB77X0wN0gciA
4DBmMqIr5XSpKpOrroxIaXPY5FoUWtiDZVEhQpiTr2Aearx02cML9DOVkwUK1GOo
n+1ic+e3tb0msY5OehUBYqQrKuvPjHAEkdyAxRpN7LDAYl4R7E1AsXB13VPH0KSH
wGgLrgfqhkqhB6E1zdKmuxLcYxSiiSZRzOX0ZF3isHpiNreTYIR6K6Q0rrMSzVU/
GNsLBOEtWK6+NLN5MnEoKFUE7PwxQHIG/1NYkx391/f5nKUoyvhfBrbXmqUV4cL6
Q9vZkUdCets9YutTRv3XBXE5FuGFX1AxFd3MVXopyFrKVrGwFQRP5TmDaFsKPqkN
xnWPPP5FP4VrT/G1WaRCiLyhtFxqBQdCUI6qf0fWaomsOJhPFNYRQ5aV5cDhlG1e
3vKDGO2fyi40QuJzP0yZxh4A2zJV7Enm7KLwG56uil1q8TKHLDA=
=fnFJ
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

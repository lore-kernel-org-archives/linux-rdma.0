From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 07/10] IB/core: Support getting IOCTL header/SGEs
 from kernel space
Date: Fri, 28 Oct 2016 18:46:28 +0300
Message-ID: <20161028154628.GP3617@leon.nu>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-8-git-send-email-matanb@mellanox.com>
 <20161028065943.GA10418@infradead.org>
 <20161028151606.GN3617@leon.nu>
 <20161028152138.GA16421@infradead.org>
 <20161028153306.GO3617@leon.nu>
 <20161028153725.GA14166@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xXygN3QAmJYWdGtb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028153725.GA14166-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xXygN3QAmJYWdGtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 08:37:25AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 28, 2016 at 06:33:06PM +0300, Leon Romanovsky wrote:
> > Just to summarize, to be sure that I understood you correctly.
> >
> > ---------    --------------------
> > | write | -> | conversion logic | ---
> > ---------    --------------------   |      ----------------------
> >                                     -----> | internal interface |
> > ---------                           |      ----------------------
> > | ioctl | ---------------------------
> > ---------
> >
> > Am I right?
>
> Yes, as long as the write and ioctl boxes do the copy_{from,to}_user.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xXygN3QAmJYWdGtb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYE3LUAAoJEORje4g2clinJb0P/3KQo9EuoDwEN14ZwxnhOTIq
PF/yDy3x6iuPqae6ZXsKi/jnbD1mMdRvEW6PjGWr5miF0D23K3z2JsIo0CJQ2PYf
oyG5AKkRRk1MIJ/3PLW6mr/dAfxHVQhcc0eqP3vy8LQLKbynUzkM8kEEHbHUFIh1
35EkeDfu5dP6h/YIGXPXcwqVmrSWzC3VtfBi0z6QpPof9psCA9LrHAF9ZRPCZxPD
BfCEO31lK6sb1nkVPrmtZF9Svv9rqAfO2mWUfToDIuDpo+bV+YR9imXvvyiShvCh
pe0ssHUMFgiXPGq9LbBGGspduq0LUmTybrQSNJydSD0lIC9F1vizaXBzm09RZrPe
/IT7z+SdvrppEbaNvIQz3w1V1LRbL0uZVVnQNwfrUw1BrFutHphXKQ0/3VJKdvF0
VW6WcWBqZdiwhGBT0/5CnurND71blamZEbK9XhcYfWXRQNcLdmh5EQvEY/RTL8qe
loP0DNiW97lWRb0LnMzezM3txkQxbimlPAbDKCZQ/1O7wNxwhUmcHTkUFoA5nBa6
jrMRmRPiOYmLOrwMAmntClpboZf2EgkStQr7Ln//H8wAwr/u1RGx5BLU7qHNazQp
e4qc1OeWOTbCfvY3VTP4g4zFvGiPCUx+ZqD+IITQ3NfMYgFSv4vaTXM93AnKhXi6
m9Qly3+OeNd93Q/Lp/y0
=953s
-----END PGP SIGNATURE-----

--xXygN3QAmJYWdGtb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

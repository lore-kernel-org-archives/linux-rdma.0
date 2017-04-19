From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 02/18] IB/IPoIB: Remove 'else' when the 'if'
 has a return.
Date: Wed, 19 Apr 2017 19:43:18 +0300
Message-ID: <20170419164318.GN14088@mtr-leonro.local>
References: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492212538-32459-3-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j3zO+32zXj6UcJCE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492212538-32459-3-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--j3zO+32zXj6UcJCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2017 at 07:28:42PM -0400, Dasaratharaman Chandramouli wrote:
> This patch fixes a checkpatch issue related to not having
> to use an 'else' if the 'if' path returns from the function.
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--j3zO+32zXj6UcJCE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj3k6YACgkQ5GN7iDZy
WKc28xAAwZDjezJNmJcITvEu/ggNL7msIFhPa/HrHMVzn55VrQxwnXjjC/5eRZzR
iKTkZrCzlBptJRAx7lOIxTVxJ91l0hc87TQDfDN5isWjMH17C5BK3SfucA8BYB6J
mwBh+7nZVR4zDADN54SGEa/YB3tzWS2kbm8VlSlbi5RDVPlnPPYCAX4NbZn49+rn
83LIOxP/IMo71zFsTl0cubJtaQeZ3vLX68FuITjEP7625ZnjDdzkUk/N3mGV9uNU
N7BPZwFniUARGP8l4LzsrBlZBui1O17efuKz9NCnTAJK2JQWjciNdFJ5rHBiUbOA
8ZEHwygrzCMmytHnFiXXRzh5v/3VcaQA92n9jccUJRsQb8iB7JhM/SsdIxVGuo48
RRaf13JKyQPnJk/XBWrBuaxbkLtMU7RjnCfgdVGtVxmjRgBCDIqfTdKwe/niEvLL
wnhl6FHdX/qAIVeVpUgxUjhR10QywraiTUgeXvQQ7FK+w1aGH7YTZsljO0pLw9e3
rscBjJBq3sG5izmKXXLxpUg2NtLFpfHnWVGU0nuVUUQXXV9NjIXkkgCtggdXo2Xw
Me0JVl33ZSw2rPFf2WxOSJaeU5ku8++uvawpua0fI318kaJm9XCc3evqWq45CAsV
nrfdPq9hf8opovM4+n7/TNlk6AwvBcBYebg+ZnXj2OBNZljBF8k=
=TN+n
-----END PGP SIGNATURE-----

--j3zO+32zXj6UcJCE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

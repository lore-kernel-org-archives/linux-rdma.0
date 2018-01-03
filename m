From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iproute2-next 6/9] rdma: Update kernel header file
Date: Wed, 3 Jan 2018 07:28:41 +0200
Message-ID: <20180103052841.GJ10145@mtr-leonro.local>
References: <20180102093725.6172-1-leon@kernel.org>
 <20180102093725.6172-7-leon@kernel.org>
 <8dc793ba-abf7-900b-02b9-0f9f468fd49f@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+ZmrHH5cGjskQnY1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8dc793ba-abf7-900b-02b9-0f9f468fd49f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+ZmrHH5cGjskQnY1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 07:50:43PM -0700, David Ahern wrote:
> On 1/2/18 2:37 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Synchronize iporute2 package with latest kernel
> > RDMA netlink header file.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  include/uapi/rdma/rdma_netlink.h | 58 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 56 insertions(+), 2 deletions(-)
>
> FYI: uapi headers are updated separately. Once the patches hit net-next,
> I will update the headers and drop this patch.

No problem, just wanted to raise your attention that this header will be
updated in rdma-next and it will appear in net-next in delay of one cycle,
after merge cycle will complete.

Thanks

--+ZmrHH5cGjskQnY1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpMagkACgkQ5GN7iDZy
WKfC8xAAuxW3RNbu1mAuz4UZnPwIF9LX52xVxge8NPh5Hc9IxltCzIbS8WwcqF7G
7/lXMvTr0hzwvLdKDH/lf68uUsUyXVg7Y9DANHLWWjKMMda17lbACvjgkAcEikkA
UWL7tBpV78ga3GC4dNoScvRegytCn3kEU55Zh37ATZTFb0V+ErjGbw4CqfRaZx2S
DApcQq9Il88IMfapcVlOE+kJb656Hk5nvvdBEXL0lXiOVOW6ypopQITWgmWjkQ3R
8dh6VK23H1loNzcm+EtRO7CF8+YzP+eNBG3bs58aaugcDgcKB2RcpeS9f1N6HZJq
UIiojCkFohlsFpzUIXBXv7heSbbty1XLECQJ9XTi1zExl0X9jW8SKf6CLzxbaQn7
IifbUGoCdp5xLmXlu/OQTJvFwp5WeYf3xqPrcLyRPQpVvbu0MZhw97TiwkzQq5sW
3TsjAXzKCK9EOuY+LSWvJ867v2VURlvPw8H5uNbs2vU3Qi6Lc/gNg5K00diexIns
n63YOeYVz3bsFHKDggNJJm4n5HBai/Daq9WkraweQMN7eN6j5WQEEj3MgQZAvqJ1
jhq2wIrzmCa1MTuxkHjjB8pi7RWbvz+MXFsmdxMpd4FhSnh+LFz06NSfOTIDNDJb
WBAHO+ceytEgnzPcCKez+aQZvNFhHnuB7cvK4Xbg5mJz3ERzjuc=
=hyjk
-----END PGP SIGNATURE-----

--+ZmrHH5cGjskQnY1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

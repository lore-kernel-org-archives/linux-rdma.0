From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: libmlx5 list.h
Date: Fri, 23 Sep 2016 20:04:48 +0300
Message-ID: <20160923170448.GQ4088@leon.nu>
References: <20160923155901.GA17362@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qd/SZIFVu+MYwfCR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923155901.GA17362-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qd/SZIFVu+MYwfCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 23, 2016 at 08:59:01AM -0700, Christoph Hellwig wrote:
> Hi all,
>
> libmlx5 comes with a partial copy of the kernel list.h despite claiming
> to be available under a BSD license.  As far as I know the kernel
> list.h implementation never has been available under anything but the
> GPLv2.

1. BSD list.h implementation [1] is very similar to the linux kernel version.
2. I'm working to create separate directory to put common code (min,
max, lists) into one place with proper license.

Thanks

[1]
https://github.com/lattera/freebsd/blob/master/sys/ofed/include/linux/list.h

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qd/SZIFVu+MYwfCR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5WCwAAoJEORje4g2clin8/EQAMlt/6/VbYLTD47y2kBYqiDC
iD47Uae6YzyKsZdT1eIqDqi28O9JMPFk160JfVE9Li0IxVgOxjMvjF6v5HRzX9y3
kueSOnG/T4d9bRizJU7w5R+uZvqzyeHau3tEo7v9ymlpMjdbZOeoVlGkNG4votPz
Omt4RM06dzgAfNDe6qHgjTWj+ObUy4coGtL5PWmFFvpaF5Lelh/dqURLPGXjbzAE
+eCVl9vOh37MwMcQ/WFa5aQMv/vr1m7yU6goVZPDj1bToU8H3oV+D5isTGti8J0W
hLktaoHYAwSA9gI+LZOTUwtFCUwUXv77V4k5Pk08rZ8RjUyH4bwnhlklJqpQc6hF
S3BOiSzcu33aSYxfOrq782sSp15mwLXpJTL1v2ebsyea2zvAn+Zn8/bNwNNBkCDW
RSYuKcnAE2xissLsNEjILz+N8QEFvm+1VbQirqemQ6VSod9lcObPgm65pQsClur/
pkorcB7cCPhD2XmKRzSTdkRcYwMvDPKfv0JD4qFDQmJpOzyUV1stzZIgfKAlOmjL
r+LXd6vx32+vw0wALDxDUvcAHPUZcYRuLmQaVd+38VdOKauptkvDFK5ORnRxRrGm
L8XLTYL6M39R+1xFYXJYx2tuR+bZpcUB6fYgv1xOCpB7mdZZaOSbk+/HqXXYlakN
1eXXGXFaTPH8MMGYlUaS
=TSm4
-----END PGP SIGNATURE-----

--qd/SZIFVu+MYwfCR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

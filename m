From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 13:42:59 +0300
Message-ID: <20170424104259.GH14088@mtr-leonro.local>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nM4qzG6nHdnn/sXd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--nM4qzG6nHdnn/sXd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2017 at 12:58:53PM +0300, Vasiliy Tolstov wrote:
> Hi! Does this mailing list suitable for questions about rdma userspace
> programming or i need to find another list?

This is the right list.

>
> My question is - how userspace libraries communicate with kernel
> devices which provided by kernel infiniband drivers? This is character
> devices and userspace libraries read/write to it or userspace library
> do some ioctls?

There are number of char devices exported by infiniband subsystem
(/dev/infiniband/*) and the communication is performed with read/write
interfaces to uverbs file [1].

Right now, we are in process of migration from these interfaces to ioctl
based, see Matan's latest RFC [2].

[1] https://github.com/linux-rdma/rdma-core/blob/master/Documentation/libibverbs.md
[2] http://marc.info/?l=linux-rdma&m=149261526916544&w=2

>
> Where i can find info about it?
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nM4qzG6nHdnn/sXd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj91rMACgkQ5GN7iDZy
WKfdEw/8DJh1AgPexCZPVxvcnzPUd7GZ8nFzJ9i/UBaC51KbxXlyQFaJoqSWWbz5
637fmdtAGe6In3GDLOkNJRjR5hCQZl4+8V1b0QcqI5jci1ZLwAW3jdOMC3IFVH95
9oSlbUSslOIJskiolA6O8S6MxIQXzy3iuPBLk7S9+NRqFygyf9MqczTOnYx7EiEQ
1f1t8GQqq48Zljb+1i6FyjISkLMEprYqYfMNDCg2f28dmqOvQ6/mHX39VKBGO5OB
zlQ1rkZiw21Hxa0GsmQJY4xOzxdLFb/Zp4FBevdh1cN3HLWTi8qwyVQMM5bjXjW+
mdFVSjtmWxf/zsGX+uu5OLjGGRJeSY1KiENcPC2EcvjXWeh8Ya6UwuGAqXeKjvfb
+7budFNUXUEELMHsSpCir4CBdL0a1OYgLvkDOQ14HWBxSjlzGGJ4yeZOzDsKC0Gk
fLW56p+R28eYUxweXDwKSuQqyCf6pE3KqyFpZ/9G0HGScBKyv8MSv2MDByHQolVn
ugJmhbjb4W1YnwbnBwwzXyRSYI2NdhJdBzChR0vJ5pvACzJF4bAV2WK5iZMohLb4
ZS7As7Zy79rIWuOJhaX9BSmZFo5IEqfz5Z2IFMZTJlj4C/NpbrkYw/xKwTXKX4Ex
hafZYneBZHpo/N1F4fiwKxvfj3GAtcYtU5GTGkThttLUbx4y8kE=
=q6hk
-----END PGP SIGNATURE-----

--nM4qzG6nHdnn/sXd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

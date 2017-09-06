From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] libmlx5: add support for the s390x platform
Date: Wed, 6 Sep 2017 17:15:00 +0300
Message-ID: <20170906141500.GJ18084@mtr-leonro.local>
References: <20170906133620.58716-1-kmeesomp@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2nTeH+t2PBomgucg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170906133620.58716-1-kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2nTeH+t2PBomgucg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 06, 2017 at 03:36:20PM +0200, Kittipon Meesompop wrote:
> Since s390x platform requires execution of privileged CPU instructions
> to work with PCI I/O memory, the PCI I/O memory cannot be directly
> accessed from the userspace programs via the mapped memory areas.
>
> This patch is created against libmlx5-1.2.1 and contains the changes to
> the libmlx5 userspace Mellanox device driver library required to provide
> support for the DAPL API on the s390x platform. The original code that
> directly used mapped memory areas to access the PCI I/O memory of the
> Mellanox networking device is replaced with the new system call
> invocation for writing the data to mapped memory areas. The functions
> for reading and writing are added analogously to libmlx4.
>
> libmlx4 comparison to:
>         commit f5c26f8762135f629c8cbe73d808e3029f07b176
>         Author: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>         Date:   Wed Nov 19 11:17:19 2014 +0100
>
> Signed-off-by: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>

Thank you for doing it. I afraid that you sent this patch to a wrong
mailing list. I don't know exactly where you should sent it, but all
new development for last ~12 months of RDMA user space stack is done
against rdma-core [1].

Thanks

[1] http://github.com/linux-rdma/rdma-core

--2nTeH+t2PBomgucg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmwAt4ACgkQ5GN7iDZy
WKfuKA//dmf8/gb1I9uhIU8KFKK16nxVS0CpCwprjF8uk1sFwrgbRBu90PK83+5R
+u3bRwOAn2cyG2h22a1AIwil2VFHK8HihAXQg+fdjPui3elXkI9XHutaBMWNqISJ
VjiG4coL5biaCrt3/XSdvpNW++zJemxCWM2XLNom6emEvlmeu5SzOnFZTzyl5Air
Od9H7dhsPAdnH9bTdg5oT6pYnl76LyJPry/dyDOsBa6CE60E0cysCfMRmrEWaQMV
rHbX0gqG/b3hvV+44vq3K5L3oEpMyfVmC5jagLuyzMY7SUlfCUBQMrz8qKf6AiSw
UIHqUgr6UBth+vcPKBNaDuFL0XHSafR/wPuf55okJVPI1p9uar8oIp2wVv/05jub
OhK7OhCALpvf1kOaQeeh4pqXefpso7DT0J5HnKHA/MtLz3zRDstIYhPJSwp/k+3H
NlUJz+ehUBYvtFCdOymfb/0vW9yibwb9/4u3b/sW2EP2lU76hr6u/aWzofltYUn7
m57lXmvpxN7ow3krVI3aM9qjV8URJbRxH3FI1QTyVvWfWV9gtZ7KUzDPu3oZCZyk
sQ+yRKO37Soat95wC+mpftoqQs3AQHZzdbSOpJtTuu3dfJLBvKyylA51SuKCpdIw
b2yCdQs/5wpPyJ2Q5f/16YvsiEPK+YD2gKJ1h9yDfpz5jwirUQ4=
=xx9S
-----END PGP SIGNATURE-----

--2nTeH+t2PBomgucg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 18 Jan 2018 07:42:52 +0200
Message-ID: <20180118054252.GU13639@mtr-leonro.local>
References: <20180115151255.30167-1-leon@kernel.org>
 <20180115151255.30167-2-leon@kernel.org>
 <1516138397.2844.34.camel@wdc.com>
 <20180117054721.GE13639@mtr-leonro.local>
 <1516246321.3665.7.camel@wdc.com>
 <20180118052020.GS13639@mtr-leonro.local>
 <1516253594.3665.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="80Ds8Z/hZmemMosa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516253594.3665.10.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--80Ds8Z/hZmemMosa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 18, 2018 at 05:33:15AM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-18 at 07:20 +0200, Leon Romanovsky wrote:
> > Please read Documentation/doc-guide/kernel-doc.rst - "In-line member
> > documentation comments" section.
>
> A quote from that document:
>
> <quote>
> Structure, union, and enumeration documentation
> -----------------------------------------------
>
> The general format of a struct, union, and enum kernel-doc comment is::
>
>   /**
>    * struct struct_name - Brief description.
>    * @member_name: Description of member member_name.
>    *
>    * Description of the structure.
>    */
> </quote>
>
> Since the above syntax is shown first I think it's the preferred syntax.

I like to have documentation in-place near their actual usage/declaration,
so as long as one of the options won't be marked as mandatory, I'll leave
my implementation.

Thanks

>
> Bart.

--80Ds8Z/hZmemMosa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpgM9wACgkQ5GN7iDZy
WKexSRAAklB0jHsvNacWxm79LkmS3yMNhgpwJpxZoGqdXBD2jS5Zc5Rwb8EQledc
IMsaL+6LUBlbGRo/D7jog7tgyhkuWj/4f/2pZPT/0xdcphFYtMhHkfxpCJPhPVDy
4oxTw/BcIqWl5Zt8rEz7FssebeVwszBkWw901q2TLKfInhXeIbiiws7v22ryT87I
Xin6wYUhYj9RZBqDiEL9ZH0rrAWfd42PWqDnOL6ISS4O4tfJES6SS8s7VqwAcWlh
zVV9f7vBwUuEDJNaJqsC2VyA3J6OplfxhY5ZYVJs0mXJ1QVBJ7dx9vd48Ki0s1XP
Q8KJEQPdra+omy3f1TJJ/hRlygLfULLI580oVLLHqxCwrTYO5IP6ksnVq2E4jfFQ
Ym57GhmQNXeA00fmqpxzwqcNx64KZYYLytRBsOcuMhQctQRc0XqVQVztN/xmLxdn
/F7sMrqfM9wtSuVpzVKGJGCHSqbiFUk5+Yvuwtj3xAOsrDTLNxUnW7YIWl2k1B/w
QV+LREYAe0aj/UZvALS/OrRvf4mp/a4GB3DpotkOA7dxJxGI4sfolb1IudrRy5qH
B2axv/Tx7W770JpTietbU/OrVmcJfXSWHZhQGdDy/Grr3W8/Ap0Cs0iBG7ttOnER
p6JA7cfxtzjHigLG8gH8EhC823zKq3JY+IOXXJ2Fi/59z7f/wfA=
=Z9v/
-----END PGP SIGNATURE-----

--80Ds8Z/hZmemMosa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

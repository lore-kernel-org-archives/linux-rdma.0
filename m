From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Wed, 10 May 2017 20:15:50 +0300
Message-ID: <20170510171550.GH1839@mtr-leonro.local>
References: <1494349653.3752.4.camel@profitbricks.com>
 <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
 <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
 <20170509180159.GK10073@mtr-leonro.local>
 <1494423046.3739.8.camel@profitbricks.com>
 <22803.7541.113159.214164@gargle.gargle.HOWL>
 <1494432414.2578.9.camel@sandisk.com>
 <22803.16933.196383.482890@gargle.gargle.HOWL>
 <1494434801.2578.13.camel@sandisk.com>
 <22803.19010.749349.461444@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7SAgGoIHugoKhRwh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <22803.19010.749349.461444-4mDQ13Tdud8Jw5R7aSpS0dP8p4LwMBBS@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Fehrenbacher <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7SAgGoIHugoKhRwh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 07:13:38PM +0200, Roland Fehrenbacher wrote:
> >>>>> "B" == Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> writes:
>
>     B> On Wed, 2017-05-10 at 18:39 +0200, Roland Fehrenbacher wrote:
>     >> The new package is very new, sits in debian unstable and most
>     >> likely hasn't made it to Ubuntu 17.04.
>
>     B> Hello Roland,
>
>     B> Does that mean that most Debian users do not yet have that change
>     B> in their /etc/srp_daemon.conf and when they upgrade and the
>     B> packaged version of /etc/srp_daemon.conf gets installed that SRP
>     B> login to remote systems will not occur anymore after a reboot?
>
> The pre/postinst files of the new package version are written, such that
> the new config file/behavior has to be explicitly enabled by the admin
> when the package is updated. Only new installations get the new config
> file automatically.
>
>     B> Since you wrote in a previous message that such changes are
>     B> mentioned in the NEWS file: how many people do you think read
>     B> that file before or after installing an upgrade?
>
> The NEWS file is displayed automatically if the apt-listchanges
> package is installed.

Ohh, this explains why I never saw them :)

>
> Roland

--7SAgGoIHugoKhRwh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkTSsYACgkQ5GN7iDZy
WKd89Q/7B8NQKZEAxcA82H+PkiTNBrByFIe4bmTsgM/Dwbz1BmXhCVaC9rtxsobo
mRNmFoPpIMZ289p+Q2CSyUhG2gv6Hut5+f6EIhpCqytzAExxzRzkeIGAPHFpqlM5
2SeaImZ7Cp+vR1H9F1JpY4eXdJASPFiaKQVQnWGaU9saKkGic7X8qlk6jk+Uqvan
1yorvEUkvAtxNdPOjVcScjDp8GEwKTnz3GH0KvTruIgvesc2MM5cUuzx+cxEVOeP
DTvIMgW3FMVarol+qB0btZWlldBzcjxXDt+sjJTioeEYBvyPwbliQKkvh/vAZfhb
SBGM5rJrJ/T4DcK4mxQGQx1EXYxllfOz3vZmXydtRKjEf1+/ggjfaX9KYUcj+86D
lZoMc6MOyksh2atjzaR6lJg/8KLMs7nrguh7h0jjcVmWYWiJF1nJK26Ao2WshuGS
Wh2repM0jghWCIEZdh6cR8RiA0xPmGZ3qYe/T/nTYeo3v0ScYXksXeRPPC3FlGU/
KVE/2cAK2ur0eDkrMKS7/yugVCNQq1QJ+EjrPThfi+GWDtfo4nd8KSDPsaPi1wlK
49z4V1iRWXJQL4kzJVikyRq6MGWzedJDayR6f9o5I4OfSdotsDvqjmNmah1XD+Qv
/wHC97HAVBg3onFjcVABpS8QQhlrN3jwNK9S+21y8wENe8W5KGI=
=njqC
-----END PGP SIGNATURE-----

--7SAgGoIHugoKhRwh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

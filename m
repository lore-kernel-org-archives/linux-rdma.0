From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Tue, 20 Sep 2016 15:30:07 +0300
Message-ID: <20160920123007.GM26673@leon.nu>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
 <20160919061558.GG3273@leon.nu>
 <1474288178.6520.12.camel@intel.com>
 <20160919132518.GH3273@leon.nu>
 <1474292075.6520.28.camel@intel.com>
 <20160920105642.GI26673@leon.nu>
 <1474373496.12415.28.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uwB7x3tnyrZQfZJI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474373496.12415.28.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uwB7x3tnyrZQfZJI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2016 at 12:11:40PM +0000, Dalessandro, Dennis wrote:
> On Tue, 2016-09-20 at 13:56 +0300, Leon Romanovsky wrote:
> > > Yes we do have that, which illustrates that trace points can not do
> > > everything. I had hoped to deprecate that at some point.
> > > Regardless,
> > > sometimes you want additional code to be added or to do something
> > > slightly different. You can't do that with a tracepoint.
> >
> > Can you elaborate more on this topic? Which limitations did you see
> > in tracepoints?
>
> Just making up an example. Say you have a hash table. You want to dump
> the items. If you iterate over it and do a trace point, yeah the actual
> trace point has little to no perf impact, but you still walk the
> table.=A0
>
> There are situations where you need to do more for debugging than just
> printing a message.=A0

Thanks

>
> > In regards of other discussion in KS 2016, "tracepoints and ABI
> > stability warranties" [1]. Are you strict with this tracepoints ABI?
>
> Honestly we are not super strict about it, but do take care not to
> break/remove something that could be useful. It will be interesting to
> see what comes out of the discussion. Perhaps we do need to be more
> strict about them going forward.

I followed the discussion and it looks like that majority are against to
declare tracepoints as ABI. Otherwise, you will find yourself unable to
change the kernel code.

>
> -Denny

--uwB7x3tnyrZQfZJI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4SvPAAoJEORje4g2clinwJcQALjo7+62yiF8El5o39bnD+Gy
IGKN+GEU0aIkLioUvHrjzSAPZc7jxxfsmzrkX9+eIAfDP/i69w2yi1s3u5NJKPeD
TmjwVfCmPVjDbFZJFge1YZ3e/F30b0PRY7xkUpTPSglUUWlvehrvQJamKsScjXff
LEOzuHjrkLv7oZ8aVnhnh8KXAGxKZfumomUxhrPFZU0M/RleDEYs83YC3gHJ9ME4
yi9ZO2iIkfGERATjmv7OOzrKSyXFfvm0dVBEC9lhEY2e5owmkr8RVOpI+z4NKofU
8jm0NQK5cxtoc/mT5UyVTZFY8vj1q/UCpQ+7rcrhNLHS5vjLGFldhZozJbOPlAJi
EDYTW1bU09TkIpwBwH6/Zc+4/QfYy5HrFLFgKJSsjfN6V7oBvSHmMrFR9yZ539k4
0baT2IAERIk/exg/ovFe+MFxuwEQCrTtreILXP4Hdp0mjK8LnPoi9Bn8n1YAxE4j
yoF2/6dAOK0IpAxwo5aD7q2LD2Cs+4iyNqJFSERbgxN2HREjD0H6w63z0XAbkQMD
5LT5dzc1Rtophj17fcZuQjO6Xr2lzLZKj4HWleT6z00T8fWeyhwYe214ueQlhM2p
3fFXuuNUOLioSOaS1Xyvl4HoOiKhBtfyp7ygeXYCk2NNHWfuAX+jmj+65xDDvtH8
LjFYI3rMKgSxA+qoUhGD
=bkRh
-----END PGP SIGNATURE-----

--uwB7x3tnyrZQfZJI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

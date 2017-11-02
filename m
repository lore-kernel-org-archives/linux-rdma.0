From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] rdma/ib: Add trace point macros to display
 human-readable values
Date: Thu, 2 Nov 2017 08:19:34 +0200
Message-ID: <20171102061934.GX16127@mtr-leonro.local>
References: <20171030215809.31286.46685.stgit@manet.1015granger.net>
 <20171101062743.GO16127@mtr-leonro.local>
 <1509551986.2530.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fMu+u8YVVpMOH5Qg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509551986.2530.20.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fMu+u8YVVpMOH5Qg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 01, 2017 at 03:59:47PM +0000, Bart Van Assche wrote:
> On Wed, 2017-11-01 at 08:27 +0200, Leon Romanovsky wrote:
> > Bart, Steve
> >
> > You attended the MS track, and for the rest of us, the quote below
> > sounds a little bit cryptic. Does the quote below mean that Chuck's
> > proposal is no-go?
> >
> > From LWN.net "Another attempt to address the tracepoint ABI problem" [1]
> >
> > "The solution that was arrived at for now, as related by Torvalds,
> >  is to hold off on adding explicit tracepoints to the kernel. Instead,
> >  support will be added to make it easy for an application to attach a
> >  BPF script to any function in the kernel, with access to that function's
> >  arguments."
> >
> > [1] https://lwn.net/Articles/737530/
>
> What I remember is that Linus does not require us to avoid breaking user
> space applications that use tracepoints. Powertop however is an exception
> to this rule. Although it uses tracepoints, we must not break it. I also
> remember that Linus noticed that the purpose of many tracepoints is to
> allow users to trace a function and its arguments. Linus wants a better
> approach for tracing kernel functions than adding an explicit tracepoint
> to each kernel function. Maybe I wasn't listening carefully enough but I
> haven't heard Linus saying that we would not be allowed to add new
> tracepoints.

Like Steven, I wasn't in MS either and the sentence "is to hold off on adding explicit
tracepoints to the kernel" made me worry.

Thanks.

>
> Bart.

--fMu+u8YVVpMOH5Qg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln6uPYACgkQ5GN7iDZy
WKfwXxAArEE3qIYeUnib+m/XTQyl1E1gB0LX5KHwVX0PnKMM9ehHS1n5/GEJ2ubs
qCF6ITiRE7h/V2kj484h6fZqaaJYF5N8wIDikTeTP0l5dIBn0hQdmZxFTnBDsGAI
aFJBqN3dfC3/wSLa6RSsyVNmHaJMXMyCpjXAgqycFhW5PVzdw1Q0RrrOzG0DQtTx
h0Qot3NLyJ4bJgvQedJadtybiG5NdvZuHhwc4t3Wyn5MZRIUgG4q2p7Alx78Rzzp
UvmZ+mkLOxR381Spt3CQYmkiU50SlehxV3nHwPWjJ4RO4jcumjnvzTcXhZQFLftq
1YHWV9bJE6hcvM9KD6peUnUaq85n5fTjvBw43TKomF75ZspA0X4aiYmY9nxMoXjr
ItM7Y0k13N7PLnKE81FKC1akcVYYdCdYvXXCl2kJd/6Ha1zRIWMAGEiu0qkWFy3F
jLnf5ilP/RGcgfkcB+sPAHQhY7s1BS6B5d71+cjw5QyWmJlbc3VFX4kq6pzazpUI
J4iUlQtdQdJBWyUTaauU58d8i30vgE5zKZh77g7u9fp1kDFLduS20qzKjVmyZ1ke
ebTw3G4A+FCeD+wMyYhkAYMaM82EPKosSxm/aHK9PTkeggr7IFnFSA5Abj2zdz5b
/1DnYh041VHC0v8O9fp4LenLibb8+9u5+ejD+82DNSgwUz+09ZY=
=gwF/
-----END PGP SIGNATURE-----

--fMu+u8YVVpMOH5Qg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

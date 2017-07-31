From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Kernel oops
Date: Mon, 31 Jul 2017 10:12:28 +0300
Message-ID: <20170731071228.GS13672@mtr-leonro.local>
References: <20170724211606.GA1705@obsidianresearch.com>
 <CAAKD3BAdB2aRk3WGdbeDYof6dUfkEwhQf27cG0FWe5DRuQ15NQ@mail.gmail.com>
 <CAAKD3BDFrTMMgX0nErD50rp2je=HC9zeaYWHDKf0mqQwc5fM9g@mail.gmail.com>
 <20170727204437.GA16986@obsidianresearch.com>
 <20170730102514.GQ13672@mtr-leonro.local>
 <20170731035208.GA30615@obsidianresearch.com>
 <20170731053901.GR13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="A7FgPGrDEcSmmdo/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731053901.GR13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--A7FgPGrDEcSmmdo/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 08:39:01AM +0300, Leon Romanovsky wrote:
> On Sun, Jul 30, 2017 at 09:52:08PM -0600, Jason Gunthorpe wrote:
> > On Sun, Jul 30, 2017 at 01:25:14PM +0300, Leon Romanovsky wrote:
> > > > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > > Tested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > >
> > > > Please add a fixes line
> > >
> > > Hi Jason,
> > >
> > > I queued it [1] for submission, once the IPoIB fixes [2] will be
> > > accepted, I'll submit it.
> >
> > Isn't fixing random kernel memory corruption triggerable by userspace
> > exactly the sort of thing we should be rushing into Linus's tree?
>
> I'm still looking on the easiest way to submit patches and want to see
> that everything is working before "rushing".

OK, I followed the advice [1] - "I would prefer to see is one submission,
then two or three days (so the first submission has had some bake time),
then the next one and it should assume the first is applied."

And submitted the fix [2].

[1] http://marc.info/?l=linux-rdma&m=150020922014003&w=2
[2] https://patchwork.kernel.org/patch/9871109/

>
> Thanks
>
> >
> > Jason



--A7FgPGrDEcSmmdo/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll+2FsACgkQ5GN7iDZy
WKeCtRAAozZsulaeNc67lW2md3xfFJt4oBswd7ddgV0NRZBLFqX1ZFB+Kz/4oXeP
Afy6IUIpPCCaCPWcWO0U6tjrIAVoPWOlV/8RYHS0of5v+m3t9IQXfRT+ufcmjiiY
LSh1ql9W2E/4ICgCnPslgRR0VRioCu5ibHUy7f79ADpej5SPs6pDnK6sJ9d8DVgO
ebxZwLtKFVGrqkig9WJmMTTmGeLmEfditdTJwpgwIbzNNqu+Il1OtUi4/b9bBAgU
7Bg0qylBK/9dUYXHag5Tk2nDNziuTyxgBC5MB5HXGcNzvC3WoScnvhZVZWCWgHY/
K4t4yEowRPb3tC8dlXIJI/F+r4p47TW/FXQfx4xQ2GGipHIJLQdouN8mK5aAHcwr
Ns2hKYqb/pO5tJoe3Af9EW3VEewQpEm3vE5GFe7WITrkio0dOJWnKHE6+IflpnrA
GXeDBPrxDzymCq9GJ9b34B6rRyLaVrkvWnb8oPPw7f0N5s9b0aiUcanvRfSi+yx/
zod2OyYENp2nBbGlGvsXWxm/osdGug69rUgZNIQYXS0qPF0Ua5cuc/Ey8pyEILq3
dpnCnat5WBSo5gonRa39ilR69boetttHevjtWzuuMR22ooex4MgcpBORoi02Dmg/
DV8nj+TC1XksX9D10RF0SU7u8xeRpE/3vIwu9jjlrr6a/c8Gs7k=
=kxND
-----END PGP SIGNATURE-----

--A7FgPGrDEcSmmdo/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.14-rc] RDMA/netlink: Restore nlmsg_len calculation
 in ibnl_put_attr
Date: Thu, 28 Sep 2017 22:47:20 +0300
Message-ID: <20170928194720.GI2297@mtr-leonro.local>
References: <20170928114953.9600-1-shiraz.saleem@intel.com>
 <20170928132457.GW2297@mtr-leonro.local>
 <20170928190033.GA12760@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J+xDcZ1j08+V/OfU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928190033.GA12760-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--J+xDcZ1j08+V/OfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 02:00:33PM -0500, Shiraz Saleem wrote:
> On Thu, Sep 28, 2017 at 04:24:57PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 06:49:53AM -0500, Shiraz Saleem wrote:
> > > Commit 1a1c116f3dcf removes nlmsg_len calculation in
> > > ibnl_put_attr causing netlink messages to be rejected due
> > > to incorrect length.
> > >
> > > Restore the netlink message header length calculation
> > > to include the added attribute.
> > >
> > > Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/netlink.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> >
> > The length supposed to be updated in ibnl_put_msg, where you should
> > supply correct length from the beginning. The suggested way to supply
> > length for unknown data is to provide NLMSG_DEFAULT_SIZE while allocating
> > new netlink message.
> >
> > NLMSG_DEFAULT_SIZE ensures that netlink fits into one page.
> >
> > It is better to avoid messing with message length after allocations,
> > especially for the attributes.
> >
>
> Hi Leon -
>
> It is not neccessary that the length is passed in ibnl_put_msg.
>
> See drivers/infiniband/core/addr.c/ib_nl_ip_send_msg().
>
> In ib_nl_ip_send_msg() nlmsg_len is corrected using nlmsg_end,
> which is typically called after attributes are added to calculate
> the correct length.
>
> The _original_ ibnl_put_attr wrapper in netlink.c achieves the same
> by calculating the nlmsg_len.
>
> One can argue that it is undesirable to calculate nlmsg_len on
> every ibnl_put_attr call. An alternate fix we could do is instead of
> recalculating the length with every ibnl_put_attr call is to
> add a nlmsg_end after the last ibnl_put_attr call.
>
> Do you agree this is a reasonable solution to fix your commit?

As long as you don't add it into ibnl_put_attr and add nlmsg_end into the caller sites,
I'm more than fine with that.

The rationale behind my "simplify ..." commit was to get rid of ibnl_put_attr
and replace all calls to appropriate nla_* calls which performs type
checking.

Thanks

>
> Shiraz
>
>
>

--J+xDcZ1j08+V/OfU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNUcgACgkQ5GN7iDZy
WKfn6g/+Nu6rVHKMkIaDf00ACyFSynZayeQejVy/QBoyfWCk4BCV3JmaeqZcomqI
cMkF6flTvm996pcQq5S1fJcoqfKhTsAei3VijMQQMFdA9NHhbrW2QGtIgT0Z2fA+
Izz7WZhwdaOuXuGcN5P7FLffG3Bbj9dC36knqHGwn7Ru7Ax5ygnfb8lVZt73SEhJ
mLkddA6+XdbOIXNwzSvZoKti8wi7CtJX97bhCJnCU1zlG+YOsyScpHK3THueTjSJ
RYmzIWMn00297tfVx1g0tokPlndIgHBUA74hDdCa20vJgRQVI4X5Up8gtOVSmq/g
OTHFYelVzhMLM3rbTlWZcNzVwHtHOIqC0HCHsVTOHMWkwjVPe3fg4dOEPCbzGPDt
Qb6BL03eNLxBOgxMOLoFDmlMX71pkOrhTe6IUU6A0BSDCO5m3ma2WIof8UGHRmvz
mmBv0Hr/W97Af9zhEIp2HcT5rhB3hdnc2aOrQ8vX4upE0LFNpeiFHcJsab1F582d
0I5BN2n9G1+SgNjTnFAAvFmz1GRHrZyemy4zd1LMOiNA/cKFXCg+8mP8viZNuzZ5
pfW/tJz7VL1wU0X14P0iuLVAaRtCjl7QzceRdUqyOiLIpE5OfudcAfliElRcyj05
lZ7+lzjrGNHVfxm6HYkhLF/l7DEaDJMheLQJCdxNlZo/79Trc14=
=/Inr
-----END PGP SIGNATURE-----

--J+xDcZ1j08+V/OfU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

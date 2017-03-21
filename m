From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB
 driver
Date: Tue, 21 Mar 2017 18:49:52 +0200
Message-ID: <20170321164952.GE2079@mtr-leonro.local>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com>
 <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K05eYGEa9LVdiTAA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170321161530.GB22216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--K05eYGEa9LVdiTAA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 21, 2017 at 10:15:30AM -0600, Jason Gunthorpe wrote:
> On Tue, Mar 21, 2017 at 01:49:55PM +0200, Leon Romanovsky wrote:
> > On Mon, Mar 20, 2017 at 02:59:27PM -0600, Jason Gunthorpe wrote:
> > > On Mon, Mar 20, 2017 at 09:08:22PM +0200, Erez Shitrit wrote:
> > >
> > > >    TODO:
> > > >         1.change the send api in order to move it to the ndo start_xmit (unless it hurts the performance of the default driver)
> > > >         2.Take out the ipoib_ah from the send signature and use ib_ah instead, no need with including ipoib.h
> > > >         3.Check if/how to add rdma_netdev layer to the default ipoib
> > > >         4. splitting out the bulk rename of ipoib_priv into a single patch
> > > >         5. change the name of the header to be ipoib_rn.h
> > > >         6. no need to pass qkey, it is in the ah struct.
> > >
> > > So.. why are you resending the series? Are these going to get fixed?
> >
> > Sure, he will. This is why he added them to TODO so nothing will be lost.
>
> Well.. if I assume everything done wrong in this series is fixed, then
> it seems fine :)

At least, it is written as TODO :)

>
> It looks like the only difference from what Intel started with was the
> attach/detach_mcast which is basically how I expected this to look.

Glad to hear,

Erez,
It seems that the next step is to fix TODO and to send actual patches.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--K05eYGEa9LVdiTAA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljRWa8ACgkQ5GN7iDZy
WKe/RA/8Dc/v6OxsJ5ESSrHDWHp1vyPDv2JDxdIHLQ7QYDR8RyG4KJC09QpNh9bk
DcHiPikfp95JIpvuJq22Vq5Qn0RElyztB32j8Gsl1I6//kW6eoYWtHRq3onbvYg2
UINqMdWpf8++fJz+B1aH0mUCHDIgtT7S29WGXxBGC8UzRWn8D7TVBwoSnYzmCPMa
ilpBFd2sBk3f2ZP1NVKqkM0oHel94SUReLpGbEemq8+CR6g0kxHtQTCikKABD3YI
QbvnEAIASNEYQv2ynAV8dpH22bzB+XCDdps5JZdX16tN1aZO1SyylYrV4Kj6thzm
Lc22bHS1v0J1QfU3YO2DqjR1r0mCc9g32uxlEzoT5h3yp3X4gcCNNB6B9ajAVSZ2
f+kPCauzrTU2fcqGXgbBW6vl9hftgxk4XG1mAEYdY8wFclBScDRsiUx5zWE1TIY6
f3PdlQNdElqVQjiPWNBYSKfbIaxz/FV8DkJhUcMb3jYVDXjp0XROGwK29Iq0tQrx
kqtc0Y00jgZZU2oCVaGniTxoigpRxvQuZ9YlD6CQ95K3U9dDQFNIEOOV+CY+qv+9
GMhlwv2niPr306DvF8nkjnbO7KAzYob+LosbcJkyZEb2EuFIMuC8jR9h7YtjHw9O
/YsN/mRIxpyGjWvWFnih3hTLdaXFdXR6UzWmglpVih5iBkAOVkk=
=sTS3
-----END PGP SIGNATURE-----

--K05eYGEa9LVdiTAA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

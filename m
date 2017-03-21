From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB
 driver
Date: Tue, 21 Mar 2017 13:49:55 +0200
Message-ID: <20170321114955.GB2079@mtr-leonro.local>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="guYUoZW38XEuSLXo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170320205927.GA17225-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--guYUoZW38XEuSLXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 20, 2017 at 02:59:27PM -0600, Jason Gunthorpe wrote:
> On Mon, Mar 20, 2017 at 09:08:22PM +0200, Erez Shitrit wrote:
>
> >    TODO:
> >         1.change the send api in order to move it to the ndo start_xmit (unless it hurts the performance of the default driver)
> >         2.Take out the ipoib_ah from the send signature and use ib_ah instead, no need with including ipoib.h
> >         3.Check if/how to add rdma_netdev layer to the default ipoib
> >         4. splitting out the bulk rename of ipoib_priv into a single patch
> >         5. change the name of the header to be ipoib_rn.h
> >         6. no need to pass qkey, it is in the ah struct.
>
> So.. why are you resending the series? Are these going to get fixed?

Sure, he will. This is why he added them to TODO so nothing will be lost.

The purpose of this RFC is to get clear view on the rdma_netdev design, understand
the API limitations and provide solid ground for actual IPoIB/HFI-VNIC patches.

It is important to mention, that this RFC is working and curious readers
can start playing with it and/or legacy IPoIB too.

So, the question is really simple. Are the interfaces properly designed
and Erez needs to start working on conversion this RFCs to actual patches?

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--guYUoZW38XEuSLXo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljRE2MACgkQ5GN7iDZy
WKfW+A//X4vMR6LMrDTzelScnyhAbYGddNIkaatWPmJWvqpvuLrYX1hOvXMlGjrT
NURlycYYTjUBRciGroWbPls4lyptXBhOn3hrgdr9PS1VmPZh22JdHKmPMD2oUWUb
43rtdDe7aNEnzuX5jRUA3xox7/h7nyN7qX9+GAlUkFMq0FqQ0xqTTazX+fQA8ay2
uJD3VOaFYfOZVgHZTrvAoLWH6RlqwIv9cIfICZdHnGLnIXZwvK/GqijjNCYtZK9l
cwb65XIsyGkz9Gr5IMQv3kYYmY8Fvktp6q6hgkioFCephfXWb+ejz1IBDFEx3FDB
ijy/nPmSuevKiLYb5oTcMWkWnURmHZHfUqFh3N+1G9qeQd898eAGYIi8zNAodbOk
7K/HgoIa1+Rviw84nOb29Fyj2jhVJwQ41oK6QowY3yEKDa+KaXmDdkFllGe+pwVu
dk0m/pcnaSINn2AGsuJx+qEL7Z8sXRVbWZpSQRarqGqu+4S+et9jIr3ypk3ImygA
15aWlZucMmJDF1bWl98EfXACVcDKES5hrTUqPuoco/7zluvoBgVb68Gb1Vlw0qyT
jccneHJKnDJLEES1i0o8V+rO/LYWfNSWX+HyghQjPNl216FWC2EpbtkrnW5oRe4Z
IyddPRczWoNvZR0nUSjIzeUtnuvVoS6vEMTiajgpBl6Se+wNQ0o=
=FfMb
-----END PGP SIGNATURE-----

--guYUoZW38XEuSLXo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

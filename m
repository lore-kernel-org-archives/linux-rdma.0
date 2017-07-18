From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: This merge window...
Date: Tue, 18 Jul 2017 11:05:20 +0300
Message-ID: <20170718080520.GL3259@mtr-leonro.local>
References: <20170712160432.GA24552@infradead.org>
 <20170712171044.GE1528@mtr-leonro.local>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136@grimberg.me>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
 <11752e09-6ac3-6362-0aac-8e735b80033b@redhat.com>
 <20170716035749.GB14674@mtr-leonro.local>
 <d285c27b-bcd2-9585-f513-d7e96fb28e34@redhat.com>
 <20170716143816.GD25686@mtr-leonro.local>
 <1aab4918-74a0-5891-a157-0a9be290d462@redhat.com>
 <BN3PR07MB2578BEDA5D3FA4ACD5A3B17DF8A10@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578BEDA5D3FA4ACD5A3B17DF8A10-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 18, 2017 at 07:47:21AM +0000, Amrani, Ram wrote:
> Hi Doug,
>
> > > Can we move to pull-request model?
> >
> > Yes, I'm fine with that.
> >
>
> I'm in favor too.
> I think this will lower overhead (on you) and speed things up.
>
> I guess we'll need a clear process for this to work well.
> E.g, refresh the branches (periodically? Once notified?), match expectations on their contents, make sure they are stable around pull time and etc.

I think that we agreed that branches are going to be updated on constant basis.
This operation process is the same as DaveM's methodology.

I'm going to post pull-requests together with patches based on for-next Doug's tag.
https://www.mail-archive.com/netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg168151.html

The readers of this mailing list will see slightly different cover
letter, but no other changes will be (they still see and discuss over
patches posted on to the mailing list), while Doug will do something like:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2017-05-12-V2
into his tree and will get the whole series.

So nothing to change, just update for-next, for-rc constantly and pull for-rc to for-next from time to time.

Thanks

>
> Thanks,
> Ram
>

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlltwT8ACgkQ5GN7iDZy
WKf5Hg/+L29uQ3RrMNxKm3lJ1f+8X7RVFfucDlgJqZCRpfxQ3e5Eg7o6fhdwJX5Z
h9x5qh9SWhSX8aZkIeO1e24qzOSCZ+4+SdULxUb4aUelPBHdwkBshB3ZyQvCw/K7
e+WYcM+9kx9ne0GW8GjNE4NAUCf/W0qchVBXeryBjpYTSllqkf701ZpwZiZoqjhR
bJih2iKoHOmvSw70G+5iB7d/RhWPQFXXTaninC5vbTGEVLkpac3a0BxXClHnhJlR
eJHbIobt5pYRXuzFSa69LKKo/B6R7JRx3i9LthsYvrfp8VHIJgpMsO+XcVafli+I
7rB8VrloTNdwC3OrGpTz9l821ocsJ6hNEfpVcrZbnCnBVEIGmkuXncXD0t0dtUqh
dRrsfZviJAzKOUxGPqZPuRJKxapMDwFpiZhQS09Bq60ePtcQD6YIO7KZey5Zb7hu
1eGKFvT7qVP0C7/uoO67yPxnN/OZCt/7a/e63OOduwypGeq9rbAXq28NfEVGMonI
2IAV/v4qupYJwPLL28DnRSXBTmN1JQQ4/LQpkUIB6VRjNFBsodfPY1AgsQvLCQkj
DuWsypirizy3iSUvgmEBo9wEU7XHfXDGt4afl1aunmuFvJqVQdcrptChJuPURGNc
U8gRxibd9wQ1Fw0+SsYmAnY4g63b0IKcb8fOfkniEQ8hG9/0snM=
=vHLA
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/5] Hardware tag matching
Date: Mon, 12 Jun 2017 14:13:48 +0300
Message-ID: <20170612111348.GB2576@mtr-leonro.local>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <20170612074055.GA24879@infradead.org>
 <628acd1f-7502-be87-df2e-48475f34fdd8@mellanox.com>
 <20170612104600.GA2576@mtr-leonro.local>
 <20170612110507.GA14990@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612110507.GA14990-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 04:05:07AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 12, 2017 at 01:46:00PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 12, 2017 at 12:41:12PM +0300, Artemy Kovalyov wrote:
> > > On 12/06/2017 10:40, Christoph Hellwig wrote:
> > > > Artem, what firmware version / what specific hardware do I need for
> > > > this?  I've been working on prototyping a simpler subset of this
> > > > (1:1 tag matching) for use in NVMe or NFS over RDMA, so I'd like to
> > > > play around with your code to see if it matches my use case as well.
> > >
> > > Christoph, here is Contect-X5 firmware with Tag matching support:
> > >  http://www.mellanox.com/page/firmware_table_ConnectX5IB
> >
> > Latest available FW for ConnectX-5 supports Tag Matching.
>
> Is there support for ConnectX-4 as well?

Right now - no.
AFAIK, there is need HW support and CX-4 lacks it.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk+d2wACgkQ5GN7iDZy
WKcIfBAAlKj4mEuEBh6pxIldosgNSPJ5CtW4jirP+9zvEAwWfNJ8ZJavwgDF87Jh
/bvsw6Gwt4F1bdtEJbqhQWSCon18+SH5gF/iJJa8gMtiAAu/JVkHA8tARpEmNrWU
qAX0HWJjFuxWBsr8hRKYwh+Tq6nCwP/RTG17ouDYvX9RSZoMbg1ooKd3txpPxzWj
Ectw281c4xUv/PWfT6GCEco+qeT0mem7xTEctxN2oNZ0N9aFXjIRVWL9NdKYHWIN
KtSfeAMRaX0ABzrcoMxVWqaoDo+X6qanoLCpywjN0e7kDeIIWA66gFWIrGtxtQOE
omP9FZ3NA91Ilsky6vdaCNN1Elyy/Wd5rQuBRaMMHP7mvS2oD0rdni01nTRnN1OA
Hj0j6UaenQj4rGgH68NN1w5au6CKaSJcxdhzsSnQhhvPMiQ5kDsC6jXsoXODAvOt
wqTCrB4w2gWvhcGgmdS+ybAT4gmlqNOymJfKnwbH2jRETrnvCAalMSwurL2Xb94L
HdvkU+noyuE1Lc2OEP25V5ziMNg4Q515Md7GABzBQMpYOPl5j2n96x54RKtg3gnc
F74hhQP6YWenmNhaonhHWkpHwaYudPzFu2ym0VUgIVGvrVwoJ/cEy4/3eZ/iOoi3
n6l8Q//hvDcjipucRdar2HXdtPmXEdJtWRcf1OCSZGxj0a8TL8A=
=K3ev
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

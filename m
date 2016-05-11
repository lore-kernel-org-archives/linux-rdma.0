From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 07:31:34 +0300
Message-ID: <20160511043134.GE900@leon.nu>
References: <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160511020429.GA32766-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 10, 2016 at 08:04:29PM -0600, Jason Gunthorpe wrote:
> Look at the patches. The LSO patch is so bad Sean and Steve couldn't
> even figure out what the heck the HW feature does. I know what it
> does, but I can't tell you the fine details of the actual required
> hardware behavior.

These people are very busy and you can't expect from them to know
everything, If someone doesn't know/understand, he will ask, exactly
as they, you and me are doing all the time.

Just to remind you, that YOUR's patch [1] didn't meet YOUR own quality
criteria and can be called bad one, just because very respectful people
asked their questions which very expected to be answered in the patch
itself, but they don't [2].

[1] e6bd18f57aad ("IB/security: Restrict use of the write() interface")
[2] http://marc.info/?l=linux-rdma&m=146264707224127&w=2

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMrWmAAoJEORje4g2clin5KkP/0NXeJVwEKB8cDBZhJB1uWWD
+E7y7fPXI3CZlGyvBVt3xm+UFbLRSRftvpJS3P71JBWzCBI9NSfymkpKZJmZrgRd
/m55KBCy7ftEQ6PXhnov8mdIBX8HAJBbP7JeTy2A/mMrrHBTz8H6rlE1dFt8xzm0
NQUn/3LjFdvDvNDbSyQ6K7LYtPpxQaHglkl8X5DiOZr3iMilMNTR0Byps34VQ8nX
ljHOY3RNBnzMeVR/UIRfi7dt7ndgxwHV5P6i3l25V5VTHVcAMQqrLhL4mBQVQoFg
/jlUn+ZNGQpRNT8ti/JA7HKKiwD74esXXMZZFQm7Fk/5wIf6qBOYjh3yk5ZlyIiA
2FG6R/Mb8yFyDg+vm8GBPHZHieJLhtgvtze558XwjOzOMBrvat+p/GTqcKmQDF/+
MJt0B3sWB19y3zIjRVEgZL7Z6YUDAQ7fkA5ItilLmFw8KYlN2tcGW3fH3J1bVqCp
0fPtPvxpeAFnAwLUynkxP1Tx7A0suBxigIbHPRBDi87Cwyiwb3ZXh15BRrxDxmIZ
LrQlfavGYd9ICCF2g+uFqgN8dBx1KleOeCDqAW3fWi9HkqlxUpQyDb+kOAf7/vAY
04GQvHDT3/v9UVD9BZBjY3688EQEpiayeBoIf8WpTxcc5JEZ8RDwYSSta6C0ADTG
Wi+p5SahYOCDe8JbZOb0
=O4hN
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

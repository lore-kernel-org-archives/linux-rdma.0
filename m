From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3] RDMA/umem: minor bug fix in error handling path
Date: Tue, 5 Mar 2019 18:45:30 +0200
Message-ID: <20190305164530.GO15253@mtr-leonro.mtl.com>
References: <20190304194645.10422-1-jhubbard@nvidia.com>
 <20190304194645.10422-2-jhubbard@nvidia.com>
 <20190304115814.GE30058@iweiny-DESK2.sc.intel.com>
 <20190305150406.GA12098@lap1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="o5hfEDzsoqw8wJwC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190305150406.GA12098@lap1>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: Ira Weiny <ira.weiny@intel.com>, john.hubbard@gmail.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--o5hfEDzsoqw8wJwC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2019 at 05:04:06PM +0200, Yuval Shaia wrote:
> On Mon, Mar 04, 2019 at 03:58:15AM -0800, Ira Weiny wrote:
> > On Mon, Mar 04, 2019 at 11:46:45AM -0800, john.hubbard@gmail.com wrote:
> > > From: John Hubbard <jhubbard@nvidia.com>
> > >
> > > 1. Bug fix: fix an off by one error in the code that
> > > cleans up if it fails to dma-map a page, after having
> > > done a get_user_pages_remote() on a range of pages.
> > >
> > > 2. Refinement: for that same cleanup code, release_pages()
> > > is better than put_page() in a loop.
> > >
> > > Cc: Leon Romanovsky <leon@kernel.org>
> > > Cc: Ira Weiny <ira.weiny@intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Doug Ledford <dledford@redhat.com>
> > > Cc: linux-rdma@vger.kernel.org
> > > Cc: linux-mm@kvack.org
> > > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >
> > I meant...
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> >
> > <sigh>  just a bit too quick on the keyboard before lunch...  ;-)
> >
> > Ira
>
> I have this mapping in vimrc so i just have to do shift+!
>
> map ! o=0DReviewed-by: Yuval Shaia <yuval.shaia@oracle.com>=0D=1B

I have something similar, but limited to responses through mail client only
and mapped to "rt" key combination.

in my .vimrc:

augroup filetypedetect
	" Mail
	autocmd BufRead,BufNewFile *mutt-* setfiletype mail
	 " Add Reviewed-by tag and delete rest of the email
	function! RBtag()
		r~/.vim/mutt/rb-tag.txt
	endfunction
	nmap rt :call RBtag()<CR>2j<CR>dG<CR>
augroup END

Thanks

--o5hfEDzsoqw8wJwC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcfqeqAAoJEORje4g2clinMKQP/1gRoq+qz5xGqSzz+mJjU+4C
PJBCXt4vZF7+Gu/HfveIlS7wAB0jNAAd71Sg7rrO8U2iCBAzBopL98o2UK45vBvX
d5FNoMi1WpbiiY3of2d2NbnWu+IhgjUNrixW257UjjBBCllXaxnnpgTsXtBspnFP
wztRSNdIIksIlJBZJEBI/PqvbIs81vdGyQrN3Iiz64uRRinb6GAx75Rspk5M/YFq
WDLMv1+ImDeG2GHOaaQHPK0n5Uaf6gU65vLOqGZp5haZK3lrG1RtcFIFhplqGNUh
xRy+Q5Alsy9RO1E4gfg43bQs8yFgESuhYUHeQwUgENIMLYMwel5sMca6DQEbq1qo
yupHSId4i4oLjujXjJoAsYJilxsjrMxTSAgc44EVhFzf5gYOYgVAccjBj6m7IZMQ
i0E6KROm+XxOPXWXYYXGzO1r9h6RFDA70dH06xCl3011WnC28T4QoMeFRPiRdIX+
sdQtVUEo1HG+x9hF3pmjj2eDCYQNh7olKJC+kIxA9bn9Luo8/Ipoxrohjuvhpmie
52Ekt8ks6TteBjM9E0+msNLpYLL0nF45nvKpUxGW2q6tXTgLnf4epuDGbxTNmZmo
ktbselHH74/nux7OYVG3pUd8w+4guXzmLky1w5aNfnbLsPNSv0shvQ1eJregy2JU
bMNmng/g87i+g5NnWge+
=lxM4
-----END PGP SIGNATURE-----

--o5hfEDzsoqw8wJwC--

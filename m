From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Tue, 10 Jul 2018 19:20:20 +0300
Message-ID: <20180710162020.GJ3014@mtr-leonro.mtl.com>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <20180709122908.GJ22049@dhcp22.suse.cz>
 <20180710134040.GG3014@mtr-leonro.mtl.com>
 <20180710141410.GP14284@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1802529003=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180710141410.GP14284@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashutosh.dixi>
List-Id: linux-rdma@vger.kernel.org


--===============1802529003==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0EphSjNCSB1asamE"
Content-Disposition: inline


--0EphSjNCSB1asamE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2018 at 04:14:10PM +0200, Michal Hocko wrote:
> On Tue 10-07-18 16:40:40, Leon Romanovsky wrote:
> > On Mon, Jul 09, 2018 at 02:29:08PM +0200, Michal Hocko wrote:
> > > On Wed 27-06-18 09:44:21, Michal Hocko wrote:
> > > > This is the v2 of RFC based on the feedback I've received so far. The
> > > > code even compiles as a bonus ;) I haven't runtime tested it yet, mostly
> > > > because I have no idea how.
> > > >
> > > > Any further feedback is highly appreciated of course.
> > >
> > > Any other feedback before I post this as non-RFC?
> >
> > From mlx5 perspective, who is primary user of umem_odp.c your change looks ok.
>
> Can I assume your Acked-by?

I didn't have a chance to test it because it applies on our rdma-next, but
fails to compile.

Thanks

>
> Thanks for your review!
> --
> Michal Hocko
> SUSE Labs
>

--0EphSjNCSB1asamE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbRNzEAAoJEORje4g2clinTRAP/3xbJ66iDSwdQCcVd+3SPmwJ
NYt2S+UqK7m5inKXFtDVKC9BNIb6WKX5gVPyLMKfr6d+Ru6XVd/TmavJyDTHbBzC
B5a13HTOqAMPLoRdcU/HqN0yHWXsRtekZ5jnnxLt+mXVq+34Vk6MNFO2OL8opaeP
1Dznd0rY8jrA9Y3Z6gXBkog9xIFE5h7NouLdApinAqoP8D4/M1quGSGsmSqlkY0z
NHviSlRW8/cRSgSeS5SQEyj3jz6gsZCYRWwskONf+VWy848aAoessVXzNVgtuLbR
4eIkAHhb1DTPdIPIZyzxrQ4e7QCaFOb/AFAt6K0E2YmTgmnntKLrpXf76p8GIXFW
xmxji8Z6R+/124cH67/+GpgSvAFSoqyHsjv8IJkB8XPsLnfN4vqxH6U0U7lO4Z5l
Pex8wMFs55GgrDsI99dEczCglFesam5u9RRnHLGY1nYYofDoNKTbWiKEAAIQJK7R
P0fCVmW921et6rtnsPOIM40O/94vJPLP0Wam76GXSCtQFw22xK90XCIvrYLuZIcs
q7nDB6HzfKUL0Ai1KAhhcqzn785E9xtAxLy6CilgmB4nTqXhaP5cM5RZZiD86jEr
N8GMXABgUjwgwxV4AFHGY2qeawlN+l2yLNl6r05KNyKTWWyhM2rt0HNnRkLRP51G
xxL8y7wxClLAZl6dTXFz
=ETz1
-----END PGP SIGNATURE-----

--0EphSjNCSB1asamE--

--===============1802529003==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1802529003==--

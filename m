From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Tue, 26 Sep 2017 09:56:00 +0300
Message-ID: <20170926065600.GA6816@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
 <20170926051349.GA1230@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926051349.GA1230-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 08:13:49AM +0300, Leon Romanovsky wrote:
> On Mon, Sep 25, 2017 at 10:31:47PM -0400, Doug Ledford wrote:
> > On 9/25/2017 11:57 AM, Leon Romanovsky wrote:
> > > On Mon, Sep 25, 2017 at 10:53:01AM -0400, Doug Ledford wrote:
> > >> On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
> > >>> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
> > >>>
> > >>> <...>
> > >>>
> > >>>>
> > >>>> I want any shared pull requests to be based on nothing newer than an
> > >>>> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
> > >>>> request is on something later it will pollute my main for-next branch
> > >>>> to merge it.  I plan to merge my own -rc pull requests after rc2 into
> > >>>> my for-next branch, so you won't be missing code that goes into later
> > >>>> rcs if you base your work on my for-next branch, so that's a second
> > >>>> alternative starting point for your shared pull requests should you
> > >>>> need it.
> > >>>
> > >>> From our experience, it is not feasible to demand shared pull
> > >>> requests on "newer than an rc2 kernel".
> > >>
> > >> I said "nothing newer than an rc2 kernel".  Did you mean to leave out
> > >> the nothing?
> > >
> > > Most probably I translated it incorrectly. I wanted to say that all
> > > shared pull requests will be -rc2, -rc3, e.t.c. and probably will never
> > > be -rc1. Did you mean the same?
> > >
> > >>
> > >>> The magic of shared pull request
> > >>> is in the fact that it is based on the same origin for both trees.
> > >>
> > >> Correct.  So, for instance, I'm opening up my for-next area today and it
> > >> will be based on a clean v4.14-rc2.  What I'm then asking for is that
> > >> subsequent driver shared pull requests be based on a v4.14-rc2 tree.
> > >> Your last shared pull request was mostly OK, but it was based on a
> > >> v4.13-rc4 kernel and so it would have simultaneously brought in your
> > >> patches and also all the changes between 4.13-rc2 and 4.13-rc4.
> > >
> > > Why is it "undesired behavior"? Anyhow git request-pull to Linus will
> > > filter all patches which already exist in Linus's tree and you will get
> > > merge of -rc fixes for free in your for-next.
> >
> > You obviously have not been paying attention when Linus yells at me.
>
> I do, but probably we are understanding Linus's responses differently.
>
> You probably mean the conversation after that pull request.
>  * First round of RC fixes for 4.13
>    https://marc.info/?l=linux-rdma&m=150039306716272&w=2
>
> He started to complain about empty merge commit with v4.13-rc1, and continued with explanations
> about difference between back and forward merges. From my point of view, my intention to base
> shared pull request on latest -rcX is exactly forward (good) merge, because it ensures that
> all our future submissions for net/net-next/rdma-rc/rdma-next are completely in sync and
> ready to go.

And if we are talking about back-forward merges, the following merge is
a back one and it was mentioned by Linus as a bad type of merge which
should be avoided:
 * Merge tag 'v4.14-rc2' into k.o/for-next
   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/commit/?h=k.o/for-next&id=0d9c2ff1c9f7f8b339fc42ac9763b28c71f1c115

Because your previous for-next was fully merged and new one was opened after
-rc2 and your initial pull request with fixes was accepted during in -rc1 too,
you was supposed simply reset your for-next to v4.14-rc2 tag
git reset --hard v4.14-rc2) as a starting point of for-next.

Thanks

>
> > This is something he specifically does *not* want, and if you send me a
> > shared pull request that is based on, say, -rc4, then I can't merge it
> > into my for-next branch and instead of I have to carry a separate branch
> > and send a separate pull request just for that branch.
>
> I don't think so, but we can probably catch Linus at KS next month and
> ask him directly.
>
> >
> > The reason is that Linus wants to be able to pull up gitk on my pull
> > request and see the changes I am submitting for easy review.  If I merge
> > a shared pull request that also includes an update to the -rc level of
> > my tree, then all those -rc patches get mixed into the gitk ordering and
> > it makes it hard for Linus to find just the patches he wants.  So, this
> > is a Linus issue, not so much my issue.  If he didn't care, I wouldn't
> > either, but this is the way it is.
> >
>
> I don't know how gitk presents git history, but the following command
> "git log --graph --no-merges -- drivers/infiniband include/rdma/ include/uapi/rdma" works like
> a charm and presents only RDMA related commits.
>
> Other replies from Linus about late submission, compiler warnings, tree-wide changes,
> request to separate pull requests, fix with strange name ("Add ...") are completely unrelated.
>
> I read upto 19 Mar 2016, in that pull request Linus explained to us how we should create shared pull request.
> Everything before is not relevant for shared pull requests.
>
> Thanks
>
> >
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG Key ID: B826A3330E572FDD
> >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >
>
>
>



--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJ+f0ACgkQ5GN7iDZy
WKdDpw//epjsZvSLF/xls8PPu/L/ijwq5B1u4txf+qwYamHqIPOCKtzbEW/RHy4Q
eH/KW3NQTulbB1EiTTNg7VjYx+Eyv5CEBPcz5iWZLdIoypRSIkvM7I2AU5fKYDzk
Uw2gz0uVFCAPJMxEAjUZEQH7gHYFBb5SLeahw8tEZ78k8ErIg34IbOqWr8QGXib0
4GlhctpvnVvHVdRsPasTa0mUZQBSIBJqcyg+0hM46vrgTtjg1yTZ6ak49GhAQqPH
OP0dTdpMCh/JNLzTUK9q0+CXH/bitGtDMyvHBuyzzdiQf8PZvFTTqHDhKqz+2DKh
QaJTkCj00sVgiHnkYfNDwg325BjXYro618IfDAG81crqZnTJJxBqJ176TY2b8aCs
3nWV/iXiDEea9rJ6QvlMKXcgvAxDuNnaUIxeepNtiSi49fzHeUFCIhO3OGiurzIV
T/9oAgNWWzYIBDsDKawEI4fxQrb9OpP6fq7e6t0wfOU1FSL3x5bcRRmRo2kDc4jI
5J6x2ZoLKofajT6h99xsAlGybuaqPiZUb8xZx5OX2WCDVqf8mDNd4wlqHewCCe+c
nre1TOV50IFtTQqBCi17xMLuGJxX0THJBjyfW2seFk7+NAyIN9Cb48nYcivtxxYi
mPgfBFzRX1VomIerZRN+ThWNRs7p4ew1Yr+YqhTBdxngVo8HIMo=
=Y0tn
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

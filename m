From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared pull requests (was Re: Workflow for i40iw
 patch submissions)
Date: Tue, 26 Sep 2017 08:13:49 +0300
Message-ID: <20170926051349.GA1230@mtr-leonro.local>
References: <9DD61F30A802C4429A01CA4200E302A75B9FB085@fmsmsx116.amr.corp.intel.com>
 <1506179005.120853.67.camel@redhat.com>
 <20170925035910.GL25094@mtr-leonro.local>
 <5abacb7d-3e86-4e12-ce95-a8fe472a6a09@redhat.com>
 <20170925155749.GO25094@mtr-leonro.local>
 <7c01cef3-0471-8339-3498-1d9ec4f8a9d3@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7c01cef3-0471-8339-3498-1d9ec4f8a9d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 10:31:47PM -0400, Doug Ledford wrote:
> On 9/25/2017 11:57 AM, Leon Romanovsky wrote:
> > On Mon, Sep 25, 2017 at 10:53:01AM -0400, Doug Ledford wrote:
> >> On 9/24/2017 11:59 PM, Leon Romanovsky wrote:
> >>> On Sat, Sep 23, 2017 at 11:03:25AM -0400, Doug Ledford wrote:
> >>>
> >>> <...>
> >>>
> >>>>
> >>>> I want any shared pull requests to be based on nothing newer than an
> >>>> rc2 kernel.  I branch my for-next branch at rc2, so if your pull
> >>>> request is on something later it will pollute my main for-next branch
> >>>> to merge it.  I plan to merge my own -rc pull requests after rc2 into
> >>>> my for-next branch, so you won't be missing code that goes into later
> >>>> rcs if you base your work on my for-next branch, so that's a second
> >>>> alternative starting point for your shared pull requests should you
> >>>> need it.
> >>>
> >>> From our experience, it is not feasible to demand shared pull
> >>> requests on "newer than an rc2 kernel".
> >>
> >> I said "nothing newer than an rc2 kernel".  Did you mean to leave out
> >> the nothing?
> >
> > Most probably I translated it incorrectly. I wanted to say that all
> > shared pull requests will be -rc2, -rc3, e.t.c. and probably will never
> > be -rc1. Did you mean the same?
> >
> >>
> >>> The magic of shared pull request
> >>> is in the fact that it is based on the same origin for both trees.
> >>
> >> Correct.  So, for instance, I'm opening up my for-next area today and it
> >> will be based on a clean v4.14-rc2.  What I'm then asking for is that
> >> subsequent driver shared pull requests be based on a v4.14-rc2 tree.
> >> Your last shared pull request was mostly OK, but it was based on a
> >> v4.13-rc4 kernel and so it would have simultaneously brought in your
> >> patches and also all the changes between 4.13-rc2 and 4.13-rc4.
> >
> > Why is it "undesired behavior"? Anyhow git request-pull to Linus will
> > filter all patches which already exist in Linus's tree and you will get
> > merge of -rc fixes for free in your for-next.
>
> You obviously have not been paying attention when Linus yells at me.

I do, but probably we are understanding Linus's responses differently.

You probably mean the conversation after that pull request.
 * First round of RC fixes for 4.13
   https://marc.info/?l=linux-rdma&m=150039306716272&w=2

He started to complain about empty merge commit with v4.13-rc1, and continued with explanations
about difference between back and forward merges. From my point of view, my intention to base
shared pull request on latest -rcX is exactly forward (good) merge, because it ensures that
all our future submissions for net/net-next/rdma-rc/rdma-next are completely in sync and
ready to go.

> This is something he specifically does *not* want, and if you send me a
> shared pull request that is based on, say, -rc4, then I can't merge it
> into my for-next branch and instead of I have to carry a separate branch
> and send a separate pull request just for that branch.

I don't think so, but we can probably catch Linus at KS next month and
ask him directly.

>
> The reason is that Linus wants to be able to pull up gitk on my pull
> request and see the changes I am submitting for easy review.  If I merge
> a shared pull request that also includes an update to the -rc level of
> my tree, then all those -rc patches get mixed into the gitk ordering and
> it makes it hard for Linus to find just the patches he wants.  So, this
> is a Linus issue, not so much my issue.  If he didn't care, I wouldn't
> either, but this is the way it is.
>

I don't know how gitk presents git history, but the following command
"git log --graph --no-merges -- drivers/infiniband include/rdma/ include/uapi/rdma" works like
a charm and presents only RDMA related commits.

Other replies from Linus about late submission, compiler warnings, tree-wide changes,
request to separate pull requests, fix with strange name ("Add ...") are completely unrelated.

I read upto 19 Mar 2016, in that pull request Linus explained to us how we should create shared pull request.
Everything before is not relevant for shared pull requests.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJ4eoACgkQ5GN7iDZy
WKewFg/+OsO1tQ3aMUvpJCYC0y3ssuBl9J35OHG+MpR4fmZENpXfSD7zgsz97zrw
aDr33wHV8cYt+CI+IWKFll500FlKxAIWKTsfVve9gni1WaJbQNmOdsSNDrIsOnhJ
FUbF7W4LLHh3npe+KichsfSD9Co+j4q1DyhX7OsvbjoCzYZaXlC57WlA1xT76Mwe
+6TeikQEp+3vcOO4Ef7H1cqlAoOB8mf/pWL/27a7IPG5rPV1TJI0bOw2UIpm9+nL
KDwBk8x2KlsYNt0BDPnA7kE2Fq5BpvJUUbER5mdtqY2hvINbUQoMCNixFmaP46yx
nqR2ooJf/ahIVSYm7XA/kYOstuiQx/ovgvnKS0S5LGjgZSHQLFf9sBOq6DD4LVF9
6iQDxNCf0aqu31ar/1vuCcfpSmLrgESc2+oyh79q7JakXoYHWU+b3SiwE2O3WmDF
N9ZcjRvU+r6xmQRE5sXONrSAUMafYaTb0peYPGWRZOqdezyX8MdrYDrAd5qOKuxW
VsqQ83eKEQu/hAW7auPlb9pbkG8jXSgeGE2rvIhkHBK3X3G9jcsqnPaXBQ4MC4Yd
UntgdECsjBFf9tnicZC57q+RwWxaoY2Ddp3I55H1RN/wltL1g/rG9vqXlCm5E1v5
GX/gUU0kkJiChiSfmPqWvPDx2hFmXI97BDPWe4/VQmM73yObqok=
=OmQT
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Sat, 29 Jul 2017 12:23:16 +0300
Message-ID: <20170729092316.GI13672@mtr-leonro.local>
References: <20170726053749.GV3259@mtr-leonro.local>
 <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
 <20170726130350.GW3259@mtr-leonro.local>
 <a1abee42-58d2-aba6-bc56-9bf1830a4539@redhat.com>
 <20170728043233.GE13672@mtr-leonro.local>
 <1501260896.2593.18.camel@redhat.com>
 <20170728192930.GH13672@mtr-leonro.local>
 <347f8b97-6b81-94a7-d71b-7023d2ed3dac@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <347f8b97-6b81-94a7-d71b-7023d2ed3dac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 28, 2017 at 03:42:52PM -0400, Doug Ledford wrote:
> On 7/28/2017 3:29 PM, Leon Romanovsky wrote:
> > On Fri, Jul 28, 2017 at 12:54:56PM -0400, Doug Ledford wrote:
> >> On Fri, 2017-07-28 at 07:32 +0300, Leon Romanovsky wrote:
>
> >> officially landed in their repo (unless there are review issues or
> >> build failures that kick it back out), so I don't know why you would
> >> expect different from me, but it's not gonna happen.
> >
> > I didn't expect anything different from you. What I expected from you is
> > to take a look on one patchset, decide go/no go, add to your branch, push
> > to github and 0-build (it very good in queuing jobs),
>
> Right now 0day is taking 10-13hours to give me results.  If people are
> queueing up test runs for every single patch (or small patch series),
> then no wonder it's taking so long.  That's horribly inefficient.  There
> is enough stuff for me to look at that I'm batching it up, applying
> multiple series to a specific branch, and then doing the build testing
> at the end for the whole group.  If I know I'm looking at 10 small patch
> series in a given day, then I doubt you will ever get me to send them
> all separately to 0day as that sort of behavior is likely precisely why
> it's taking 10+ hours to get results right now.  If people *didn't* do
> that, then the results might get in much sooner.

It now explains why you are getting results so late.

Doug,
The 0-day service runs their checks on every commit which doesn't exist
in its database (it checks by hash) and posts results for latest commit
without relation to success/failure. For intermediate commits, it posts
result on failure only.

So your batch posting is the reason why you are not getting results
immediately and it is not relevant for "efficiency". One of the goals
for the 0-day service is to support bisectable commits, by ensuring
compilation at least.

Thanks

>
> > announce and so on
> > till all patches are tested and it can be forwarded to k.o.
> >
> > Sorry, if I expected too much.
> >
> >>
> >>> As I said more than once, I'm fine with sequential work, I'm fine
> >>> with
> >>> the fact that not all my code is accepted, I'm fine with scheduled
> >>> delays, but I'm not fine with silence.
> >>
> >>
> >>
> >> --
> >> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>     GPG KeyID: B826A3330E572FDD
> >>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll8VAQACgkQ5GN7iDZy
WKf0QxAAtpuBuDf3OdpIPXvMWiqV3v04qTGy1R3ycoQ4DX+Qssm50fz0Gva2aHzp
tO81k7p/hCWKD4SxBuBWHryzJzhMIqQwc9UuNvuBtrDOBp/bpshsZe7PuSCPaH6J
dUc8WiNxi14XaOGfjoLC9LKkLZAjEgCH3GD++lJUoC3yN/6MgQDfWReba4lCyamX
Lv2f35mPHri5/9bMNDHPQ+x0uvAArd/682CclBqp/W2FZVdM7QjBOmPRXg/HWG59
sa6s9mmC9Gjt532Bn+TFF05hd+NoAumzg4WX/jwqHfoz/EQlzhMLHv6umWfsL5W3
6+ARtWq6/1py8NeKzbn7b2XUrdXrqzMemfchXI0Pc8QhOf+wdWI7tUruMlE2Gq2J
mG/XiPoxoNKNpwxL3ZnGD3xdI8IichjDwEHG96XtpfEknunE6qb01fxY7shFesVA
pJ7Mf8OCk57q5Eub/rHYHeTPJeat9SBvu7aR+6+aUr8tQ1gVjEvrhtkS32EFbEAe
Axbjo9nMUjnZxp0yZEPmKd5WlAJkT0KGg5ndlanLL2KdHXVV35l5PedX/Km8tflb
JYlM06Ef6vn41kiL19B2K13VwNHKBxcMtBHOR4HZ5cjTQuAMDtlopB1zOeZPiH8d
5VicNCM7bJn814l80nTATBf/ChUyKLX6QXqr+PrQhkXLeoD/ygA=
=xUq7
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

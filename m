From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Crashes due to concurrent calls to ib_unmap_fmr()
Date: Tue, 18 Apr 2017 20:44:30 +0300
Message-ID: <20170418174430.GD14088@mtr-leonro.local>
References: <5C9E097E-938D-4F41-9EA4-003F77A54DAD@oracle.com>
 <20170415095528.GK1343@mtr-leonro.local>
 <A9FF7F7C-F936-4925-B3A6-31684613B69F@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A9FF7F7C-F936-4925-B3A6-31684613B69F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Knut Omang <Knut.Omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 17, 2017 at 01:45:24PM -0400, Chuck Lever wrote:
>
> > On Apr 15, 2017, at 5:55 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Fri, Apr 14, 2017 at 11:51:39AM -0400, Chuck Lever wrote:
> >> Howdy-
> >>
> >> I recently found a way to crash my HCA (and the whole system) using a
> >> signal on an NFS/RDMA mount point that is using FMR. I've documented
> >> the issue:
> >>
> >> https://bugzilla.linux-nfs.org/show_bug.cgi?id=305
> >>
> >> And I have an NFS/RDMA fix I'm testing for v4.13. The fix is to prevent
> >> simultaneous calls to ib_unmap_fmr with the same FMR.
> >>
> >> While working on the fix, I've been looking for any documentation
> >> regarding serialization requirements for ib_unmap_fmr. Knut Omang pointed
> >> out to me that Documentation/infiniband/core-locking.txt makes this bold
> >> statement:
> >>
> >>> Reentrancy
> >>>
> >>>  All of the methods in struct ib_device exported by a low-level
> >>>  driver must be fully reentrant.  The low-level driver is required to
> >>>  perform all synchronization necessary to maintain consistency, even
> >>>  if multiple function calls using the same object are run
> >>>  simultaneously.
> >>>
> >>>  The IB midlayer does not perform any serialization of function calls.
> >>>
> >>>  Because low-level drivers are reentrant, upper level protocol
> >>>  consumers are not required to perform any serialization.
> >>
> >> Does this re-entrancy guarantee apply only when ib_unmap_fmr is called
> >> concurrently with unique FMRs?
> >
> > According to description, it should apply to all operations on ib_device
> > without any exclusion.
> >
> >>
> >> I've been told it is not possible for ib_unmap_fmr to detect when it has
> >> been invoked in different threads with the same FMR.
> >
> > Right, FMR management is implemented as direct writes to MPT and MTT
> > tables. HW doesn't distinguish simultaneous calls to the TPT cache.
> >
> >> but apparently the > user space equivalent does not have the same
> >> vulnerability (I did not test this assertion).
> >>
> >> I'm wondering what is proper closure here (aside from merging the
> >> NFS/RDMA fix).
> >
> > Maybe serialize unmap_frm (workqueue) from the driver side?
>
> Either correcting the documentation or a driver change is OK with me.
>
> Claiming that "upper level protocol consumers are not required to
> perform any serialization" seems like a stretch.

Right,

I added Jack to this thread, and we will need a couple of days to think
internally about possible solutions.

Thanks

>
>
> --
> Chuck Lever
>
>
>

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj2UH4ACgkQ5GN7iDZy
WKeh3Q/8DVqkWsV8PGxTyMJApI8x0eHzoOHFi51NexRx/6O+xFX8r3TW/k+xOP4o
khBNg8ekZYj6OGMCKP1gxTgC3rvOXE/GMTtl0LIPooIRcEunF7bkRGu8kLYF8bJh
hCVoBY93pbsG+zQnchfNGpAy8LJLeY0owFU43IyvlCsWR0yiQqEevR5ch2EvzEEK
NlQfSQM7o1pFF+IAP7nE7yu5YWf+qovlRHwzLM86GWFcLsyAjlmH23MHXx64Z5jr
vXU7IunaENa2arDnkq8om6+hzdXMSqUw0QCJOg9aI6+A/juCRoskEWeH7tN6F/Mb
6P/+52VDx+gvdtSN5a2yfrXQu1uJ1mF3Yhe6iUEJmnONjHnmhRepkPGVbTSPUS2e
+08Fnl3ZK4Ax5m7bPYPbV5GnWW0bHbkoSwZ3oMtLetqpvDh8mUPQUp5C+SAX60EE
tw6ztFY9ZEsHKvfi+cOJN7wmInCyfRRQDwyREysc+UmZcO2FnYW8pB2CDTyj89cq
7TkFz8K6y0LGgCsFYguDKGVtHD1A/VThJRpWFx/mCaGFP1A7pEwQALsmcYPCmRd1
8avdCiFHb1pncp/EsGn01+rUUjtjFr1bFvrP2jCvsHvSsVBJBl1IhBd0++YXJua7
rH9VXYNKcyM8P86SRF4wzh/7Gioo2Edw82K1ANiSSz6t0YZaLZo=
=4WZs
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

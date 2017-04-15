From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Crashes due to concurrent calls to ib_unmap_fmr()
Date: Sat, 15 Apr 2017 12:55:28 +0300
Message-ID: <20170415095528.GK1343@mtr-leonro.local>
References: <5C9E097E-938D-4F41-9EA4-003F77A54DAD@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AwgMNpd3VkAVXjS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5C9E097E-938D-4F41-9EA4-003F77A54DAD-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Knut Omang <Knut.Omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7AwgMNpd3VkAVXjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2017 at 11:51:39AM -0400, Chuck Lever wrote:
> Howdy-
>
> I recently found a way to crash my HCA (and the whole system) using a
> signal on an NFS/RDMA mount point that is using FMR. I've documented
> the issue:
>
> https://bugzilla.linux-nfs.org/show_bug.cgi?id=305
>
> And I have an NFS/RDMA fix I'm testing for v4.13. The fix is to prevent
> simultaneous calls to ib_unmap_fmr with the same FMR.
>
> While working on the fix, I've been looking for any documentation
> regarding serialization requirements for ib_unmap_fmr. Knut Omang pointed
> out to me that Documentation/infiniband/core-locking.txt makes this bold
> statement:
>
> > Reentrancy
> >
> >   All of the methods in struct ib_device exported by a low-level
> >   driver must be fully reentrant.  The low-level driver is required to
> >   perform all synchronization necessary to maintain consistency, even
> >   if multiple function calls using the same object are run
> >   simultaneously.
> >
> >   The IB midlayer does not perform any serialization of function calls.
> >
> >   Because low-level drivers are reentrant, upper level protocol
> >   consumers are not required to perform any serialization.
>
> Does this re-entrancy guarantee apply only when ib_unmap_fmr is called
> concurrently with unique FMRs?

According to description, it should apply to all operations on ib_device
without any exclusion.

>
> I've been told it is not possible for ib_unmap_fmr to detect when it has
> been invoked in different threads with the same FMR.

Right, FMR management is implemented as direct writes to MPT and MTT
tables. HW doesn't distinguish simultaneous calls to the TPT cache.

> but apparently the > user space equivalent does not have the same
> vulnerability (I did not test this assertion).
>
> I'm wondering what is proper closure here (aside from merging the
> NFS/RDMA fix).

Maybe serialize unmap_frm (workqueue) from the driver side?

Thanks

>
>
> --
> Chuck Lever
>
>
>

--7AwgMNpd3VkAVXjS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljx7hAACgkQ5GN7iDZy
WKcHChAAjEsbXSs575eIzUTohf6OCXNd4HkfzfiXRszF6ZfQ6mgX0hXsF4I27QpV
3HNfrpB+6syyfnfKkcv5WFJWFDNNYFVrFoFI8laT16C0APn10lvVkJX3OR6Q3IqV
1yHhwbMZ1LFsp5Gb2SeXiTVfIpNS0XknFnR52tj33gW4TIfDCI0sWDwsvWIIRwO2
VivqMkQf3u6pXfjDuMGzl5ssZwrJI2tkwBjZj12/04aWcSDymzewTfscG/bNeZdy
tdzruu4qsN1ZkhryPKlGY7XmKj9OdOdeKp2GXSNJwLFAv2YlA2oEJczwz6nFHtq+
tSpPdCrUILdU5fkskrTs3+KaMc4HRJ4GAhyyhNUWqJAtAiL6aXcdFJKZRFrb+mD6
WIybm8oKwn4mmbf+wfTqcA/7EgvJ+pXFlfFo6sCxAshjWD8mQNFOHcvFmUxlbyTS
iO05uUn6UoAO27UFpZub55V/P08TvcnT6FFojWqh5klP5uBCjR8u+u83kcyccFKh
xPh/OHtowALaOuOBpL7u9McYmhioSbWo/CImEO6iDfdwpzAMOwjPRwFHHxjC6gKR
FwvvH05i7v/Ce/DLRu0GxZOFa7+WdjFeqTOhlk1GkD23xWBL93eeEjWygHiSxEyW
mdrZyBr56N3mw/ToQoo7nQnSDhHQl+D/wnkdKCn0EBCnYc9xCSI=
=1JEf
-----END PGP SIGNATURE-----

--7AwgMNpd3VkAVXjS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

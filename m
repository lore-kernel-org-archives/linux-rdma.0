From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iproute2-next 00/10] RDMA resource tracking
Date: Tue, 6 Feb 2018 09:29:50 +0200
Message-ID: <20180206072950.GI2567@mtr-leonro.local>
References: <20180131081156.19607-1-leon@kernel.org>
 <20180205172553.5826642d@xeon-e3>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="c7hkjup166d4FzgN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180205172553.5826642d@xeon-e3>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--c7hkjup166d4FzgN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2018 at 05:25:53PM -0800, Stephen Hemminger wrote:
> On Wed, 31 Jan 2018 10:11:46 +0200
> Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> > Changelog:
> >  v2 -> v3:
> >    * Rebased to commit: 1e24e773f144 ("Merge branch 'iproute2-master' into iproute2-next")
> >    * Refreshed include/uapi/rdma/rdma_netlink.h file
> >    * Fixed bug, where cxgb4 was printed twice.
> >  v1 -> v2;
> >    * Added checks for all occurrences of strdup failures and added patch
> >      with fix of already merged code.
> >    * Sync with latest kernel code.
> >    * Rewrote table representation to be similar to "ip route" output.
> >    * Implemented string filters.
> >    * Removed curr/max representation from the summary output.
> >  v0 -> v1:
> >    * Fixed subject title in patch #1: rdam -> rdma.
> >    * Added newline between variable declaration and the code.
> >    * Add check to failure in strdup() call in rd_check_is_string_filtered().
> >    * Rewrote res_qp_parse_cb() to avoid long lines and extra indentation.
> >
> > ------------------------------------------------------------------------
> >
> > David, Stephen,
> >
> > The kernel code is accepted to the RDMA and will be sent to Linus in
> > this merge window, and this is refreshed version of user space part.
> >
> > Because, I found bug in handling cxgb4 devices and we cleaned header
> > file a little bit more, it was more wise to resend the series instead
> > of applying v2.
> >
> > https://patchwork.ozlabs.org/project/netdev/list/?series=RDMA+resource+tracking&submitter=68852&state=8&q=&archive=&delegate=
> >
> > Thanks
> >
> > Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > [1] https://www.spinics.net/lists/linux-rdma/msg59535.html
> >
> > Leon Romanovsky (10):
> >   rdma: Add option to provide "-" sign for the port number
> >   rdma: Make visible the number of arguments
> >   rdma: Add filtering infrastructure
> >   rdma: Set pointer to device name position
> >   rdma: Allow external usage of compare string routine
> >   rdma: Update kernel header file
> >   rdma: Add resource tracking summary
> >   rdma: Add QP resource tracking information
> >   rdma: Document resource tracking
> >   rdma: Check return value of strdup call
> >
> >  include/uapi/rdma/rdma_netlink.h |  67 +++++-
> >  man/man8/rdma-resource.8         |  86 +++++++
> >  rdma/Makefile                    |   2 +-
> >  rdma/link.c                      |   2 +-
> >  rdma/rdma.c                      |   4 +-
> >  rdma/rdma.h                      |  28 ++-
> >  rdma/res.c                       | 486 +++++++++++++++++++++++++++++++++++++++
> >  rdma/utils.c                     | 321 +++++++++++++++++++++++++-
> >  8 files changed, 971 insertions(+), 25 deletions(-)
> >  create mode 100644 man/man8/rdma-resource.8
> >  create mode 100644 rdma/res.c
> >
> > --
> > 2.16.1
> >
>
> Applied these to the master branch.
> Dropped the kernel header update, picked that up through the other update process.

Thanks a lot

--c7hkjup166d4FzgN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp5WW4ACgkQ5GN7iDZy
WKdMUQ/+PmWV+mF0x0b5fuGfHw3bjiK5EEB5Ao3/2ZmTLdGnePOqvIGF2THvuOoh
cCNB2EUyuYakAOZfidJliGxy5RHdvJkLRLy/h8j/tbdxF5REn30FaMaJkiqeuSHy
14A3Jzis96GluwfHMoyxw9XbvFYIF/nCRFrIbmcBuxzL1HsqjdcyDmrXznxx0Pmi
yem0pfuUhHFQ+cnFn1TETpnNEvPeXs5EeMfPJTLI1kmlI4G2M0kxYSp/OGUQtXXK
WeYI/O0KmMnd2pVmF+1WYkpGEFclzQc49OplUBLhXo9b+G0VHvAGgty5LpZT+X5A
HyLV36nLBgvHgeohCT8UCnzqqSx3TnXcCYonCFAILHTdc5d/ApbtfS3K8TcqEXUX
l9WBmiGb+sOSGzocVbB3XdZdNxxhit3zVo2PMFKk2OYe+Xu8zfCD5Ppkjk0F0ivo
lfImG3tMn8xdbl/T5mCxRQUS4oB6LzMlHLWaxNjTD98jkRMP56OGDdn0wfpjigok
pa9UI71CbqQKG3F/HR8rTf/O5h1pdbwb7CmzaS/dR0mPcP/TMfA/wuEww9wNLwWw
Q9eFvGAvBMwhDw4GZfLejCCUZjU2eQ939I8KyjXoEnYfF0TgrIQ3lc6YVEQZQpko
euNkA6FmCthRDBuygtdnT1u6AD+RLUjAejoHQg2Fac0qkTS/zqE=
=K5O/
-----END PGP SIGNATURE-----

--c7hkjup166d4FzgN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Fri, 13 May 2016 07:22:17 +0300
Message-ID: <20160513042217.GD11827@leon.nu>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9dbc023f-e442-843a-ab68-eec38ca1d6b7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 12, 2016 at 10:01:17PM -0400, Doug Ledford wrote:
> On 05/12/2016 01:44 PM, Leon Romanovsky wrote:
> > Hi Doug,
> >=20
> > I prepared the base tree [1] with patches sent to RDMA mailing and pass=
ed review.
>=20
> You can't know that.  The reason I say that is because they have to pass
> my review as well, and that's usually an implicit thing.  If I review
> them and they have already passed list review and they pass my review,
> then I include them.  If they don't pass my review (which isn't often if
> the other people on the list have already spoke up, but does happen),
> then I ask for revisions.  If you take them without an explicit review
> from me, then you don't know if I'll ask for a revision or not.  It's
> premature.

Yes, I don't know for sure, but you can see that patches which I chose
have no dispute over them and have no reasons do not to be accepted.

>=20
> > This base tree is part of linux-next and kbuild system, and it passed
> > sanity checks.
>=20
> Most, there was a linux-next build failure that I'm sure is related to a
> change I hadn't had a chance to look into yet but looked fishy to me
> (the move to put ib_addr into ib_core looks like it's broken, but I
> hadn't delved into the code to verify it...the linux-next build failure
> from tonight makes me thing that it is).

It is caused by **not merged and delayed** topic branches. Both topic/fix_c=
ore and
topic/rdwa-rw-api touched drivers/infiniband/core/Makefile and created merge
conflict.

The merge commit is here [1] and the simple fix is
diff --cc drivers/infiniband/core/Makefile
index 2c6dc6b,26987d9..f0a5276
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@@ -8,9 -8,9 +8,9 @@@ obj-$(CONFIG_INFINIBAND_USER_MAD) +=3D     ib
  obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=3D       ib_uverbs.o ib_ucm.o \
                                          $(user_access-y)

- ib_core-y :=3D			packer.o ud_header.o verbs.o cq.o sysfs.o \
+ ib_core-y :=3D			packer.o ud_header.overbs.o cq.o rw.o sysfs.o \
				device.o fmr_pool.o cache.o netlink.o \
-                               roce_gid_mgmt.o addr.o
-                               roce_gid_mgmt.o mr_pool.o
++				roce_gid_mgmt.o addr.o mr_pool.o
ib_core-$(CONFIG_INFINIBAND_USER_MEM) +=3D umem.o
ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) +=3D umem_odp.o umem_rbtree.o

Based on your methodology such merge failures are unavoidable and I'm
not feeling well with your conclusion that topic/fix_core broke the
build.

>=20
> > I believe that it will save you a lot of work and time if you use it
> > as a base for next merge window submission (4.7).
>=20
> Not really.  I still have to review the patches, and I still have to
> update patchworks, and when I'm sorting through patchworks is when I get
> the patches to include.  The incremental time to grab the patches out of
> patchworks and run git am -s on the bundle is negligible.  The real time
> is in reading the patches, and this doesn't save me any of that time.

I'm not working with patchworks, so I can't save here, but IMHO it still
valuable and save time:
1. Separated by topics
2. ROB tags
3. cleanpatch + checkpatch before merging
4. We (Intel and Mellanox) already run their test regressions on the upstre=
am code
and we will run it on **almost** (pending your acceptance) latest ->next br=
anch.
So the bugs will be caught before sending pull request to Linus.

> The help is appreciated though ;-)

Thanks,
Will you support my effort to continue publish ->next tree?

>=20
> > The topics which were added:
> >  * topic/fix-core
> >  * topic/hfi1
> >  * topic/i40iw
> >  * topic/ipoib
> >  * topic/iw_cxgb4
> >  * topic/iwcm
> >  * topic/nes
> >  * topic/rdma-rw-api
> >  * topic/srp
> >=20
> > [1]
> > Git repository:
> > git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git rdma-=
next
> >=20
> > Gitweb:
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Drdma-next
> >=20
> > Thanks.
> >=20


[1]
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/commit/?h=
=3Drdma-next&id=3Dd77eb1c067de68982a63063dc391a28c450ebd64

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXNVZ5AAoJEORje4g2clinKB0QAIrlmtPMj1AQrtZuzgzi8zZH
RC4sjWET28oaDXuXgEbdvVekMMba3dnI0RxymZrkC6gvz9IaESFzD0EXq5DWDwai
O4SOB2t1qKVJiSVUe3Biv9F7vdvaZ0S5ZzOW9IOeRo2rx6Mf+Mxx+ZJzkg6uWxtc
IKPDw6O9XqfNW5PWsXyDQCRIr9xHjMQv2NCB3o84SodxQ0FQW01R/qWG9N7RQRy9
26b4M4dcaZLmv5UQRtpbZS7e5nuSoslNo3XD/vznZLJTnYFtj+gaVWDwT9YjgBU3
KwaI0TxfST2yG6/Blw51tk522SsDkyA0GXM/hQpZMwIqhiDuWX2ck4N4ChGWTMhg
2gvIszhJEoWPYs2qEtscmeh2auichxcVH/tzy2ggHkosuHXBbCANNC7D16ut6G7C
exE5AWjZ/qAeyxMcjTHzkqCX1JZJp8O/RpxcRE3aY/px3FG3XbUYk+dv3Rv580CS
Iwn1gbL60S5IjSqSSCzg3Ui1KnIIp8y42PTCFcvesFLdgIEXGrr7X7MdngSj9G92
F2y3MhJjRIhwrgFU96n2HSWvrAPB8KDz3sS6WYbhw0JzlChrIBIyDS9nVAk6pJq8
bdsrLKggaqyqLyZ7IgoB1O689L/S2v7HAuj0Wr6vGhAzelCqOcwBM8R+Lt2JrO1n
DUw2CkNK8s8OGppckmVD
=0WLT
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

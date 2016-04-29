From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/2] mlx5_core: mlx5_ifc updates
Date: Fri, 29 Apr 2016 22:41:35 +0300
Message-ID: <20160429194135.GA25593@leon.nu>
References: <1460563864-22931-1-git-send-email-saeedm@mellanox.com>
 <CALzJLG__o56edSf__To-BM6jakuwP7zAAEEQH8LQNTKp-2LRDQ@mail.gmail.com>
 <20160415.172254.1148340547086083909.davem@davemloft.net>
 <20160418151205.GO6349@leon.nu>
 <5722BBD1.3030005@redhat.com>
 <20160429050752.GB774@leon.nu>
 <f31784f8-080d-6a5c-2396-8eecc831416e@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f31784f8-080d-6a5c-2396-8eecc831416e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 01:56:07PM -0400, Doug Ledford wrote:
> On 04/29/2016 01:07 AM, Leon Romanovsky wrote:
> > On Thu, Apr 28, 2016 at 09:41:37PM -0400, Doug Ledford wrote:
> >> On 04/18/2016 11:12 AM, Leon Romanovsky wrote:
> >>> On Fri, Apr 15, 2016 at 05:22:54PM -0400, David Miller wrote:
> >>>> From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> >>>> Date: Fri, 15 Apr 2016 20:10:07 +0300
> >>>>
> >>>>> On Wed, Apr 13, 2016 at 7:11 PM, Saeed Mahameed <saeedm-VPRAkNaXOzXQFizaE/u3fw@public.gmane.org=
m> wrote:
> >>>
> >>> Hi Doug,
> >>> Can you please take this patchset in addition to Dave? It will save
> >>> our list from many kbuild errors.
> >>
> >> Dave, did you pull this from Leon's git repo, or apply patches and
> >> generate new, unique commit hashes?
> >=20
> > Doug,
> > We sent IFC changes before I had a tree, so Dave took it as separate
> > commits. The coming release submission will be based on my tree.
>=20
> The point of my question was that if we both take in patches, we
> generate diffs with different commit hashes, and that technicall
> represents a merge (although if the patches are identical, they should
> auto-merge).  Linus had requested we pull from the same tree so we both
> get the same commit hashes, then no merge conflicts since git will
> recognize the commits as being *exactly* identical.  Right now, the only
> way to accomplish that is for me to pull net-next and base my for-next
> on net-next.

I don't think that is really needed. I recall two reasons for his
request: one was mentioned by you and the second was need to chose
which tree has right order of subsequent commits.

In this merge window, we choose very carefully patch sets and their
common part, so no merge conflict between different trees will occur,
because of Mellanox code.

Whatever you decide to pull or not and something will go wrong,
please put all blame on me.

Thanks.

>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXI7jvAAoJEORje4g2clinBEQQAL1yWabXP3kopfouFKf50Fao
yLNIKk6n6murEEUYHwempW7xXrYQYfqOK67TjyNAYT8mD2W6E2IdLfHaVpdyzl6b
4a17+HVY49poEMGLxS8MrXaoU3vaNLLXf/gGHpYa6Ns5lETeQ2vAQurv528obuJc
vYLi/U1nFWRvC4ngDy/rWWg9L9dUxQ4V09YyNpb/JapU61o2ZooRTJBOsj8au2vQ
MHT2kRgVnD8eSAHWtyaSVMcLeB/9UjsCP4I/3D61erhTQBDb8bxtonZZIBek1c1K
1ZyRsRip4jfpoSQPgAoG8djAyz9+TE+wvbTSYFzgstA1ddvxZB0pCRxWFCSqLjjY
8b4hu7Bb7BqVcrkAkOR/nYg957Tan0NmB+E8RVmEeaycgvgutZ1S6DqzbxNEomEY
TdAuGrw8rnylN02tbrUqM0WHHnDVZEwp15JGeJ/+lnCrl54+9Fp79FQpu+ZIlE7W
b8H0r0ylxmefEzMX1dPTcBb+M1Dim0LrOOuTjWMyzS/OhcT8tliqoEp6bbMAZZ03
3hIpnBeP1PrV9RSCZPjAxILio/ld6468DHhklrtePGxf4HjfbZVqd5ztzoQRpl5p
Z2pwisXZfbj5IsqkT8kBEcZyw+DVUVGILV+JCZSv8sZdgVnHnvCSBa4Ur1SCjq+V
TfF5kLpieY5Tl5AcmiI9
=wkD9
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

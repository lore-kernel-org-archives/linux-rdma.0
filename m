From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Fri, 30 Dec 2016 08:55:10 +0200
Message-ID: <20161230065510.GL26885@mtr-leonro.local>
References: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
 <20161229081756.GI26885@mtr-leonro.local>
 <20161230045011.GA79815@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qgd2S+2VS1hsWwXW"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161230045011.GA79815@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
To: Kenneth Lee <liguozhu@hisilicon.com>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Qgd2S+2VS1hsWwXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 30, 2016 at 12:50:11PM +0800, Kenneth Lee wrote:
> Hi, Leon,
>
> 1. I do change the title except for the version number itself:) But my English
> is quite bad, maybe the title is still quite stupid. I can update it according
> to your advice.

Yes, please
The main points are:
1. Remove "bugifix", it is not needed.
2. Use description in the title and not function names.

>
> 2. I catched the bug by reading the final code, not by bisect-ing the old
> commit. Do you means I should find out which commit introducing the bug? It will
> not be easily to say which it is because it is a "missing bug", rather than a
> "introduced bug". Indicate the commit may not help to remove a patch/commit from
> the stable tree.

The fixes line won't cause for removal of commit, but to addition of
yours on top of their code base.

git blame is your friend.

one fixes line is:
Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")

and the second line is !!!!! NOT !!!!!, you need to go deeper in the logs !!!!!!
Fixes: f7c6a7b5d599 ("IB/uverbs: Export ib_umem_get()/ib_umem_release() to modules")

>
> Could you please give more suggestion? Thanks.

Please, don't use top-posting for this mailing list.
It is really-really annoying.

>
> On Thu, Dec 29, 2016 at 10:17:56AM +0200, Leon Romanovsky wrote:
> > Date: Thu, 29 Dec 2016 10:17:56 +0200
> > From: Leon Romanovsky <leon@kernel.org>
> > To: Kenneth Lee <liguozhu@hisilicon.com>
> > CC: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
> >  robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no,
> >  vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com,
> >  krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com,
> >  linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
> > User-Agent: Mutt/1.7.2 (2016-11-26)
> > Message-ID: <20161229081756.GI26885@mtr-leonro.local>
> >
> > On Thu, Dec 29, 2016 at 04:27:28PM +0800, Kenneth Lee wrote:
> > > There are two bugfixes in this patch:
> > >
> > > 1. When the execution go to the ib_umem_odp_get() path, pid should be put
> > >    back.
> > > 2. When the memory allocation fail, the pid also should be put back before
> > >    exit.
> > >
> > > Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> > > Reviewed-by: Haggai Eran <haggaie@mellanox.com>
> > > ---
> > > Change from v1 to v2:
> > >   Correcting the patch title and description
> >
> > I don't see any changes except version in the title.
> > What about anything like this?
> > [PATCH v3] IB/umem: Release pid in error and ODP flows
> >
> > And Fixes line please, it will help to forward it to stable trees.
> >
> > Thanks
>
>
>
> --
> 			-Kenneth(Hisilicon)

--Qgd2S+2VS1hsWwXW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhmBM4ACgkQ5GN7iDZy
WKff9xAAhi+05a6IF2QBntHXQxdnpTXH+oU1ETt2z1Ygy8/pjjEZOQuqgDXg5AH1
ozYSkEAsGSrKEX6mDQtSAcrwkgJh2f8NFit7+xLcG7r7gpCQERnOVWUzVTq0iqPA
G0Eaha0rSuZOL89lJ4ROrLsRNNkULUp1asEb4r/v8morgv6pOLe3ilxJ+h2W0eZs
+SWGNSi/ROJ//INokPUlUc3m17+/cB0qrnV6FVYaY3+n4cnVZLo+R+PzE8S/zh4u
j//rgPGaH98AGsThNx5/G3m1x19+zq1mLS9QQisda3w4YMWKXmDeRmAl+86mUixF
t5T2hxA/9sPcjs42kjeBAL8bb3UG5eY0kj0rKRLESEcRs5vPaBNbCiysj/ejBVAL
eylxvm6m5OtrhvbG9jwxa2re+CPM0fFdxqTH0YwVPLip8gTO3gffnx7rU5h0r9Ld
2kExca56zQ9e9/L9n6rGbFELpG3ZNjNHyADv1n4L+oABRDfgvYA/zm/5lSQO77HJ
/PqdkZFONrG4tjWZeA3Yd+7q+phwXPfyiRAg5gnvwmiZAYTVV1TVV20fvebjcyEu
qknBjZLqNZSyZo9ZzZSERjH3yfIGZG8O/KN+yhmYEGdqhL5f8ui8qKtxJ/3QkOAH
zv84wuykv7+FQAVMAwjLBksB9VD2q6vNgGJSmEtvi3gUlN5TcEc=
=KOYQ
-----END PGP SIGNATURE-----

--Qgd2S+2VS1hsWwXW--

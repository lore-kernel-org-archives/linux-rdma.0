From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v3 0/1] Use HMM for ODP v3
Date: Thu, 11 Apr 2019 12:29:43 +0000
Message-ID: <20190411122940.GZ3201@mtr-leonro.mtl.com>
References: <20190410154125.21350-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Tdr039sUWCyRuLRO"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410154125.21350-1-jglisse@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "jglisse@redhat.com" <jglisse@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

--Tdr039sUWCyRuLRO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2019 at 11:41:24AM -0400, jglisse@redhat.com wrote:
> From: J=E9r=F4me Glisse <jglisse@redhat.com>
>
> Changes since v1/v2 are about rebase and better comments in the code.
> Previous cover letter slightly updated.
>
>
> This patchset convert RDMA ODP to use HMM underneath this is motivated
> by stronger code sharing for same feature (share virtual memory SVM or
> Share Virtual Address SVA) and also stronger integration with mm code to
> achieve that. It depends on HMM patchset posted for inclusion in 5.2 [2]
> and [3].
>
> It has been tested with pingpong test with -o and others flags to test
> different size/features associated with ODP.
>
> Moreover they are some features of HMM in the works like peer to peer
> support, fast CPU page table snapshot, fast IOMMU mapping update ...
> It will be easier for RDMA devices with ODP to leverage those if they
> use HMM underneath.
>
> Quick summary of what HMM is:
>     HMM is a toolbox for device driver to implement software support for
>     Share Virtual Memory (SVM). Not only it provides helpers to mirror a
>     process address space on a device (hmm_mirror). It also provides
>     helper to allow to use device memory to back regular valid virtual
>     address of a process (any valid mmap that is not an mmap of a device
>     or a DAX mapping). They are two kinds of device memory. Private memory
>     that is not accessible to CPU because it does not have all the expect=
ed
>     properties (this is for all PCIE devices) or public memory which can
>     also be access by CPU without restriction (with OpenCAPI or CCIX or
>     similar cache-coherent and atomic inter-connect).
>
>     Device driver can use each of HMM tools separatly. You do not have to
>     use all the tools it provides.
>
> For RDMA device i do not expect a need to use the device memory support
> of HMM. This device memory support is geared toward accelerator like GPU.
>
>
> You can find a branch [1] with all the prerequisite in. This patch is on
> top of rdma-next with the HMM patchset [2] and mmu notifier patchset [3]
> applied on top of it.
>
> [1] https://cgit.freedesktop.org/~glisse/linux/log/?h=3Drdma-5.2

Hi Jerome,

I took this branch and merged with our latest rdma-next, but it doesn't
compile.

In file included from drivers/infiniband/hw/mlx5/mem.c:35:
=2E/include/rdma/ib_umem_odp.h:110:20: error: field _mirror_ has
incomplete type
  struct hmm_mirror mirror;
                      ^~~~~~
=2E/include/rdma/ib_umem_odp.h:132:18: warning: _struct hmm_range_ declared=
 inside parameter list will not be visible outside of this definition or de=
claration
struct hmm_range *range);
	^~~~~~~~~
make[4]: *** [scripts/Makefile.build:276: drivers/infiniband/hw/mlx5/mem.o]=
 Error 1

The reason to it that in my .config, ZONE_DEVICE, MEMORY_HOTPLUG and HMM op=
tions were disabled.

Thanks

--Tdr039sUWCyRuLRO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcrzM0AAoJEORje4g2clinEt4P/3wiD/ydhWQnQz/BSONuyzO9
TpkWmDo9g8kUY53myMIlmzDSdoAS4SaJmTBCE/gwotsqQ3WUpCovy7p4oY+W6oK7
kwgHSTKqTT76oSNM609j4fYn45TK2kvZ+n4XXW9gvdmXnbVsQV8NvpCKU01JuTuf
mfqL5HVk5QMwnAHDW/7+E8hBEt28DF2nSizD66qs4pZUhv8cLFcPrL0HcqdtRew1
m4YZEPvnqkDfyBou4Elje+g2UipqIiF/fLE3p9kBp0uxPP5MVbjxGG+tQ/8AA/WA
dbHIU+sNevjfeM0rblA83wsX5kWYOE1e3umk2IZYVvB5xzrfgbnRbPzHH7OqyM/r
YVQUvZpglLd7dX6Ciwny3qICEphvH9375i9WkKlGRLXbvUATqdDwghfHbjxNSfwe
dnRpjY6H+7ARPtxonoLPVIDPgVt2BJ07YRyDApY6yu3H/TKwVXu9tTgVmYuUslmE
bk2hAfxRX8fnYHUVKVyx3cRdvn1pt3uSUAimtBe23xYfuEQ4CioNBjtKRiV8Glg3
Q1yJadrdcNBwB8MWP24V46K30edgGi5pEa8A1K2jjt3zSb5Fe33q4Jdjq2S9B3/O
4RFeNtsdkfqCuLbB3f3gG7StuNlKfjb/5h3UuRFFDMFMk49hzleBYGUJhirWgylJ
EB1NHvWV1nG5yhJTCnFN
=3csj
-----END PGP SIGNATURE-----

--Tdr039sUWCyRuLRO--

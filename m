From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/14] Revise the DMA barrier macros in ibverbs
Date: Tue, 28 Feb 2017 12:47:05 -0500
Message-ID: <11c92f40-9a8e-59df-092a-d94c4309818e@redhat.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1488297611.86943.215.camel@redhat.com>
 <C6384D48-FC47-4046-8025-462E1CB02A34@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hURGJ0olE9F70gr9J6iK4WUIVlRuKxrrA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C6384D48-FC47-4046-8025-462E1CB02A34-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hURGJ0olE9F70gr9J6iK4WUIVlRuKxrrA
Content-Type: multipart/mixed; boundary="bThJ8T8vtEHJN4NwWdvwsxUu05EJEFarQ";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <11c92f40-9a8e-59df-092a-d94c4309818e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/14] Revise the DMA barrier macros in ibverbs
References: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1488297611.86943.215.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <C6384D48-FC47-4046-8025-462E1CB02A34-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <C6384D48-FC47-4046-8025-462E1CB02A34-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bThJ8T8vtEHJN4NwWdvwsxUu05EJEFarQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2/28/2017 11:38 AM, Majd Dibbiny wrote:
>=20
>> On Feb 28, 2017, at 6:00 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:=

>>
>>> On Thu, 2017-02-16 at 12:22 -0700, Jason Gunthorpe wrote:
>>> Now that the header is private to the library we can change it.
>>>
>>> We have never had a clear definition for what our wmb() or wc_wmb()
>>> even do,
>>> and they don't match the same macros in the kernel. This causes
>>> problems for
>>> non x86 arches as they have no idea what to put in their versions of
>>> the macros
>>> and often just put the strongest thing.
>>>
>>> This also causes problems for the driver authors who have no idea how=

>>> to use
>>> these barriers properly, there are several instances of that :(
>>>
>>> My approach here is to introduce a selection of macros that have
>>> narrow and
>>> clearly defined purposes. The selection is based on things the set of=

>>> drivers
>>> actually do, which turns out to be fairly narrowly defined.
>>>
>>> Then I went through all the drivers and adjusted them to various
>>> degrees to
>>> use the new macro names. In a few drivers I added more/stronger
>>> barriers.
>>> Overall this tries hard not to break anything by weaking existing
>>> barriers.
>>>
>>> A future project for someone would be to see if the CPU ASM makes
>>> sense..
>>>
>>> https://github.com/linux-rdma/rdma-core/pull/79
>>>
>>> Jason Gunthorpe (14):
>>>   mlx5: Use stdatomic for the in_use barrier
>>>   Provide new names for the CPU barriers related to DMA
>>>   cxgb3: Update to use new udma write barriers
>>>   cxgb4: Update to use new udma write barriers
>>>   hns: Update to use new udma write barriers
>>>   i40iw: Get rid of unique barrier macros
>>>   mlx4: Update to use new udma write barriers
>>>   mlx5: Update to use new udma write barriers
>>>   nes: Update to use new udma write barriers
>>>   mthca: Update to use new mmio write barriers
>>>   ocrdma: Update to use new udma write barriers
>>>   qedr: Update to use new udma write barriers
>>>   vmw_pvrdma: Update to use new udma write barriers
>>>   Remove the old barrier macros
>>>
>>>  providers/cxgb3/cq.c             |   2 +
>>>  providers/cxgb3/cxio_wr.h        |   2 +-
>>>  providers/cxgb4/qp.c             |  20 +++-
>>>  providers/cxgb4/t4.h             |  48 ++++++--
>>>  providers/cxgb4/verbs.c          |   2 +
>>>  providers/hns/hns_roce_u_hw_v1.c |  13 +-
>>>  providers/i40iw/i40iw_osdep.h    |  14 ---
>>>  providers/i40iw/i40iw_uk.c       |  26 ++--
>>>  providers/mlx4/cq.c              |   6 +-
>>>  providers/mlx4/qp.c              |  19 +--
>>>  providers/mlx4/srq.c             |   2 +-
>>>  providers/mlx5/cq.c              |   8 +-
>>>  providers/mlx5/mlx5.h            |   7 +-
>>>  providers/mlx5/qp.c              |  18 +--
>>>  providers/mlx5/srq.c             |   2 +-
>>>  providers/mthca/cq.c             |  10 +-
>>>  providers/mthca/doorbell.h       |   2 +-
>>>  providers/mthca/qp.c             |  20 ++--
>>>  providers/mthca/srq.c            |   6 +-
>>>  providers/nes/nes_uverbs.c       |  16 +--
>>>  providers/ocrdma/ocrdma_verbs.c  |  16 ++-
>>>  providers/qedr/qelr_verbs.c      |  32 +++--
>>>  providers/vmw_pvrdma/cq.c        |   6 +-
>>>  providers/vmw_pvrdma/qp.c        |   8 +-
>>>  util/udma_barrier.h              | 250 +++++++++++++++++++++++++++
>>> ------------
>>>  25 files changed, 354 insertions(+), 201 deletions(-)
>>
>> Thanks, series merged.
> Hi Doug,
>=20
> This is a very sensitive series that we haven't Acked yet.
> It might have performance and functional/correctness implications.
> Also, as you can see we still have open discussions with Jason.
>=20
> We would really appreciate a heads up before merging topics that have o=
n going discussions and give us a chance to Ack.

Yes, I'm seeing that.  I had thought it was more settled than it is
evidently.  But, I haven't merged anything else yet, so any follow on
patches can be taken before anything else and produce a nice sequential
patch flow.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--bThJ8T8vtEHJN4NwWdvwsxUu05EJEFarQ--

--hURGJ0olE9F70gr9J6iK4WUIVlRuKxrrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYtbeZAAoJELgmozMOVy/dXaIP/1HiWLYRoa0WbcQaNREdv7PX
lzLsmzvGvOVFJtki9OHLOTDAZu+YK0tzQ6Y6awWYkaNZ91WcPrbIF6y2Dhmv0kBm
qyNXVxbYl7FszK5BWas7texlqYX4QLsg33s8nOUbyDbW9Nsk+aJ1O1OKY1xZKk7P
eVdN6cAODn4eIgu8y4JF4mnXTuJy3B9nbUPyxKTURbumcn57nJDCdlszPs0t8Dv4
ddDe6U3XTo68MA9HcwKEUcdEufvGKyeDg5ahkyZ13itOGPpIxBWK7SlkO2J2saA6
E3MhtFmoelk3u1IXpfwH/spWJVcClLQzhbcQ2bQdpv2/fTDBpOfggxRU88nMuBlE
bOj8llKsGeC7iS08oAPnc8Y0jvhR8t8fwnt3YLBQ3wCFZ8jNcT9s0F0Xt8Grmayz
NTu2uZKguBHimIMNza8eaRGgr6i3LMYcoWdeB+LGvhFl/ox2sljrMKpkJbsTFZIY
cs4zwZO6o8wCIuZOd2nYTd7Fj3fezc4dxv19SsFwQnEADssFhYFxZshNdNAKpT7w
bFFLDcyXQR49ASawi9dr85XpokuDSiAdY/nqw4StbcGPJIzkRQwSfP6iS/GiucSv
B6SdXz1XBc0uXD1czMV1EKu8cFImnsWlUd7vg3qGu+oeI+qZMrLhGNc05KE/eMGU
AV+PhauYRTTg9IWTjrrD
=qPk3
-----END PGP SIGNATURE-----

--hURGJ0olE9F70gr9J6iK4WUIVlRuKxrrA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

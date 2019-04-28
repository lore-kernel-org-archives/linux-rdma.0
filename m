From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Sun, 28 Apr 2019 11:52:12 +0000
Message-ID: <20190428115207.GA11924@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Third rc pull request

Nothing particularly special here. There is a small merge conflict
with Adrea's mm_still_valid patches which is resolved as below:

diff --cc drivers/infiniband/core/uverbs_main.c
index db20b6e0f253c9,f2e7ffe6fc5466..7843e89235c34b
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@@ -1039,7 -992,9 +1039,9 @@@ void uverbs_user_mmap_disassociate(stru
  		 * at a time to get the lock ordering right. Typically there
  		 * will only be one mm, so no big deal.
  		 */
 -		down_write(&mm->mmap_sem);
 +		down_read(&mm->mmap_sem);
+ 		if (!mmget_still_valid(mm))
+ 			goto skip_mm;
  		mutex_lock(&ufile->umap_lock);
  		list_for_each_entry_safe (priv, next_priv, &ufile->umaps,
  					  list) {
@@@ -1051,9 -1006,11 +1053,10 @@@
 =20
  			zap_vma_ptes(vma, vma->vm_start,
  				     vma->vm_end - vma->vm_start);
 -			vma->vm_flags &=3D ~(VM_SHARED | VM_MAYSHARE);
  		}
  		mutex_unlock(&ufile->umap_lock);
+ 	skip_mm:
 -		up_write(&mm->mmap_sem);
 +		up_read(&mm->mmap_sem);
  		mmput(mm);
  	}
  }

The tag for-linus-merged with my merge resolution to your tree is also avai=
lable to pull.

Thanks,
Jason

The following changes since commit dc4060a5dc2557e6b5aa813bf5b73677299d62d2:

  Linux 5.1-rc5 (2019-04-14 15:17:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 2557fabd6e29f349bfa0ac13f38ac98aa5eafc74:

  RDMA/hns: Bugfix for mapping user db (2019-04-25 10:40:04 -0300)

----------------------------------------------------------------
5.1 Third RC pull request

One core bug fix and a few driver ones

- FRWR memory registration for hfi1/qib didn't work with with some iovas
  causing a NFSoRDMA failure regression due to a fix in the NFS side

- A command flow error in mlx5 allowed user space to send a corrupt
  command (and also smash the kernel stack we've since learned)

- Fix a regression and some bugs with device hot unplug that was
  discovered while reviewing Andrea's patches

- hns has a failure if the user asks for certain QP configurations

----------------------------------------------------------------
Guy Levi (1):
      IB/mlx5: Fix scatter to CQE in DCT QP creation

Jason Gunthorpe (3):
      RDMA/mlx5: Do not allow the user to write to the clock page
      RDMA/mlx5: Use rdma_user_map_io for mapping BAR pages
      RDMA/ucontext: Fix regression with disassociate

Josh Collier (1):
      IB/rdmavt: Fix frwr memory registration

Lijun Ou (1):
      RDMA/hns: Bugfix for mapping user db

 drivers/infiniband/core/uverbs.h        |  1 +
 drivers/infiniband/core/uverbs_main.c   | 52 +++++++++++++++++++++++++++++=
++--
 drivers/infiniband/hw/hns/hns_roce_qp.c |  2 +-
 drivers/infiniband/hw/mlx5/main.c       | 12 ++++----
 drivers/infiniband/hw/mlx5/qp.c         | 11 ++++---
 drivers/infiniband/sw/rdmavt/mr.c       | 17 ++++++-----
 include/uapi/rdma/mlx5-abi.h            |  1 +
 7 files changed, 76 insertions(+), 20 deletions(-)
(diffstat from tag for-linus-merged)

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlzFk+QACgkQOG33FX4g
mxqIkA/+JBDrzPRJjwhMY0PJLS+MYMKNnFLRkU7JymP40qMKVxSfqxiNTHztP+Rb
UoKipsXh654KpVWCwaPS2JvEcy4BNRLhI15zym5fFXsgCGK1oxlnjLbI22lBBshm
8YXK1KVZtzdXkPpdgR+kz8whssk0HzKKPIh0sloph/RG8+VR47Kl17y3bo2NuOP6
tBfyVRUdSPd0tPXmqaEo7UqokMcw/DBXL08U0QTkISzQgqvWI4DdQnxo+u5L85V/
wyvK26TOZaKU/Lb4zMWOgy5NTrmwNwcuxpdWl2z4oTcb0DQKNMkCYWW1UIfC9azW
1com9jPngNnivOAWYp1qLvpwMfBia7yJnMfr6te0swXQUfrVeyStndRiuAOMM4E5
3Y5YJ51VynWT1cpky+tLiKUGl2BMlD/vu7x7VV2OR2V+hIoYyd2eDJ0qun7K7Ytq
hXM4MOhTfuVDnGZxpIWf+92GwzqJjgQYzqi175nTDWcUdCKwM4NM/fUUEHMy4gmb
rbUtCxq4JPq65a64tfJt8D2lu6Ppp09U6d2hrtUfcAcwZWOT+DSSoJrzVivW9Hiq
xKjU64LDk9v3G1kHKsV5NRXuQeLDQn7sxzE8T+cZR6YvoLopX6LlBw9DwYrJglgO
1lgBNNBzQQsexkqw9PQkrusLq/h1/RozDaXvsOYr2s5+/Z9R9tc=
=2zuv
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

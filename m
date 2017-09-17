From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15 has been released
Date: Sun, 17 Sep 2017 15:58:48 +0300
Message-ID: <20170917125848.GB5788@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tag v15
Tagger: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun Sep 17 14:13:51 2017 +0300

rdma-core-15

Updates from version 14:

 - Many fixes, improvements to debian package
 - Addition of SuSE packaging files
 - Linux kernel coding style enforcement
 - Add Broadcom BCM57454/BCM58730/BCM57452/BCM58802 to the list of supported devices
 - Extend qedr to support iWARP in addition to RoCE
 - Common infrastructure to auto-load RDMA kernel modules
 - Various integration of udev and systemd
 - Cleanup of RedHat packaging files
 - Numerous static checkers fixes and enforcement in Travis CI
 - Expose mlx5 multi packet capabilities
 - Add support for delay drop ability in a WQ
 - Add RSS support in mlx4
 - Verbs support for source QPN
 - Add inline-receive support to mlx4
 - External memory binding for HW resources in mlx5
 - Verbs and mlx5/mlx4 DV fixes
 - Encode the verbs private ABI version number in verbs_register_driver
 - Add ability to build all combinations of static/dynamic libraries for
   the verbs and provides
 - Cbuild and travis CI tweaks
 - Explicitly mention license in individual files
 - Countless number of fixes for whole package
-----BEGIN PGP SIGNATURE-----

iQJEBAABCAAuFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm+YD0QHGxlb25Aa2Vy
bmVsLm9yZwAKCRDkY3uINnJYp7gxD/9NVGvjfO3r0ZWI2V8U/9rUyLjDcQdWMixw
CMidReskUxk9sm7RCvbt1S0OfdqlEQJst2F2j3/xgG67Yo8t3j4i0/eVoJ+b3dFD
c4L4qQaNGWdCSCdI/169jSC31WxyT2CtgzQtzIagQ9JGUejkyKYwM44eHbB/shzK
//7bMvI4kGJKygOchvPSAers/qY+3IqFnVytzN7334FYde9ksw32HRPKtQN3Ww5W
+kQhNzy4p2+ZMW2ERnHyAmErG7K/SJE+oRXD+dcH0v61gGIxBjtEoCERDoVFzoY2
Z5UoQXFfHguZEsJzTS7u1gYZ5qCs0dYNzuALdKTZEH38vQzwbM9g1t3ApNdhsjM2
1m4dYJt5fKrc/+1LcXKSk9ERWkkLMD+yDKzr8VvO3AhgzhVGFXNv6fE+1HvZhqHq
cHIsdOadRturRMQGwHGlNx1vney6OxS7zl2eFyJYYysmbtKocL7K95rrgFNi8LgG
SE7hVWfl5k54IkV9engeKzcYps23hni+UH7eUZdYrG1eYNQHRdAKHLZXAmE/6vMT
o+MHurWQxPkzzg6DHbjI9eXQX7/nznA3BRMNbPZXIkbfyvkGQPeVEeV0AFWJ4S2/
gyo5og31siy/k254onAD0WoPSM/VvtCD8ecgdv8uyCnTxq7m+O1Xf+caY7KWr7Xl
aUATfiLYuQ==
=4GLY
-----END PGP SIGNATURE-----


--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm+cYgACgkQ5GN7iDZy
WKeI3g/9G2vvFWw4RbUbF5sxGUtb57PKZuntb5tqEZtco81yCw/TwJfl5OJsU3oe
DxLpK3cXTEb4AMxo/Hjo4GQKVZA4E2nq81TtfrmWlbRmgeVRtYQ2VLWtjKekPbgC
38jukdqOWl2lbBpZ1UpNJnRgTFLKN5fvGNKmg6k/kM42rTd5E/NX7s8CKTUOQfGQ
dZmVxXtc8IwpcfDGL5kcDEwqltwUH3HxgQHwK9amWH9kfch9kaalJswv6iXKNdTf
5Mof0dndF1yTuAGI9GJkDlMxj+N0y6q4cbRbxyTNPKyaOXdgObq53r/kbz6t+jRY
g4evYbb+xPvYPFPupU949s6SudbPpLcu5Y/NCo5IoDHbnBHeDSCaT+3+LkSaBSXj
BK2iazUZHk3emJ8zYJU7g65Mu+q7TEmnnj1mqet8Ezdn+rNVqGEGZ77Gvm7ghFvI
VOXZCaNg/LLrDKAVaLp7XUoBhCDT63T0PJAfTp/2rNrvb5ORcrQUznLQ5AluX7XO
brGm6jRRjukgC5oCurR0fSDlM6iZ9CyEQfWWmoEOjS1TR1ousp6t4vMtvWW2kfUl
HLu3PfhQeFYyjlz9yl4nEHFbFPJ1MV6W+WjZpTsV9ejLC/6wYv//IhoQHjj+nVjO
tb9tS1XRNuxmLV+P9Wqa2Immq5ZkGETbmb3AcmgUgBr6FUpmjUs=
=CgoZ
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

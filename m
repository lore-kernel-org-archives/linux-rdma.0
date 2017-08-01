From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Tue, 01 Aug 2017 08:31:49 -0400
Message-ID: <1501590709.2725.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here's the information from the tag:

tag v15-rc1
Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Aug 1 08:18:05 2017 -0400

rdma-core-15-rc1

Updates from rdma-core version 14:

- Add flow steering drop action
- mmio_flush_write fixes
- Fixes for uclibc
- Add common mmio accessor routines and remove per provider mmio
  routines
- qedr fixes
- Lots of fixes for debian packaging
- Copyright fixes
- Properly conflict with infiniband-diags
- Add direct verbs support to mlx4 provider
- Improvement to Travis CI checking
- Enforce kernel coding style in rdma-core
- Add initial verbs hotplug support
- Sparse annotations
- Systemd updates for srp_daemon and iwpmd
- Red Hat packaging fixes
- Properly make the entire rdma-core support udev hotplug activation
- Packaging fixes related to the joining of packages and globs that are
  no longer valid
-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJZgHNpAAoJELgmozMOVy/djucQAKEN9HSobCNJU7ZXxvN99uLO
4o3N17jDSzY8EfqGYX1n/1/+SxB0o3qsysNgW7I8FqQZOjz0DjlhEwP3J9HnD0Hb
wE/tu4mbDRurtgh+qaNcxRLrzED6/lqn1PSvePjKg6T81jfzfvXOx+2LYb4r5oEe
KIcj/bCE+aGyySm6gDiKVxm8oVRvvQp/NfqqMNVhbGz9Ezi2ZJkfG/FOTo0jFDwX
xzrAAAv9iTpmm7Hp2vJkHV65zPEoMXuSlu7vRUjaOWeboyIJLwur9OyMu+fkWWvX
EV3fckwseqBhOvuxmV9ZhEbfgxvt6UIwRSBtvnPbgIukBWWQlVkCT5aehceQWUpY
guEsxb4LvbIeYTEfrfhCLF/l9BI/QfQ+SZmeWe3LAox2K0fxzOIbUU1Lki/vRsuf
jvZwIuD6JVRhi2FQNNePms3/wayZcRZxjbMnPE5WbSfRxXDa/28dTaMbp+VoBiex
On2ykJT5qBTYRPIgPL3wHqdNTsh4gsYHAaCQzDR2z0zESuNXB0bcbFcRkgBSNaAb
cvN0QrpkNMAsmqSRXsDbcPj/Pb3yUuTf+ZSaXxL6SafnFvb1xH4P7thWC9wGVcw3
XHkZzu+BEUwMzJkZzNnCu3IXECF8PKk6GttuxhYPvzZ0DK6Ve8qpdzoKgvgZNlZ5
Wy9pRgI9q7qRe9NoZUKX
=sqn3
-----END PGP SIGNATURE-----

This is a little bit late, so it would be best to keep -rc cycles on it
to a minimum and get the final version pushed out soon.  With the
"excitement" of this last release cycle/merge window, this slipped my
mind.  My apologies.

It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

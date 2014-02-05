From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] libibumad 1.3.9 release
Date: Wed, 05 Feb 2014 12:33:55 -0500
Message-ID: <52F27603.5030807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 1.3.9 release of libibumad.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
52a81356906f4faf29a6cf9583161aa8  libibumad-1.3.9.tar.gz

Alex Netes (1):
      libibumad: Fix memory leak in resolve_ca_port

Hal Rosenstock (2):
      libibumad: update shared library version
      libibumad: package version update for 1.3.9 release

Ilya Nelkenbaum (1):
      libibumad/umad.c: In resolve_ca_port, skip ethernet link layer ports

Ira Weiny (3):
      libibumad: fix umad_register man page
      libibumad: update umad_[send|recv] man pages to document how rmpp is handled
      libibumad: document the setting of errno for umad_send and umad_recv
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

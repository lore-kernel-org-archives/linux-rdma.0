From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 0/4] IB cache port state, use it when resolve address
Date: Mon, 2 Jan 2017 13:15:03 +0100
Message-ID: <CAMGffE=-dN6jpJUHyNEHra1P=SLYiO47pMbMoKSNf6Njy=znKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Folks,

This is my forth attempt to fix rdma_revolve_addr may resolve to first
port even it's down[1].

As Jason and Hefty suggested, I now cache port_state in ib_core, and
update cma_resolve_ib_dev and cma_bind_loopback to use it.

0001-IB-core-add-port-state-cache.patch
0002-IB-core-export-ib_get_cached_port_state.patch
0003-cma-resolve-to-first-active-ib-port.patch
0004-cma-use-cached-port-state-when-bind-loopback.patch

[1]http://marc.info/?l=3Dlinux-rdma&m=3D148102306632521&w=3D2

Changes from v1:
- Add Hefty's Acked-by.
- rebase on Doug's rdma/k.o/for-4.10 (commit
5cc8fabc5e4c588c75a5ec21423e7c3425f69f48)
- fix a mem leak in ib_cache_setup_one in error case in first patch.

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

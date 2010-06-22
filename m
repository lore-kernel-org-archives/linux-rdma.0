From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: mlx4 pci device table
Date: Tue, 22 Jun 2010 10:30:17 +0300 (IDT)
Message-ID: <Pine.LNX.4.64.1006221025130.11239@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny, Roland

I wonder if you can spare few words what would be the correct location
of the PCI Id table under the two tier architecture of the mlx4 driver?

If the table is placed in mlx4_core (as of today in upstream), then I
assume the mlx4_en and _ib aren't being probed by pci hot-plug
mechasnisms, correct? else if you put it in _en _ib et al files, then
one has to maintain two copies of the table, but maybe this would be
the correct approach? how this should work with multi-protcol mlx4
devices and/or IBoE?

Yevgeny, I see you placed in ofed some patch which isn't upstream
who puts a copy or some modified clone of the table in mlx4_en, what
the problem you were trying to solve?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

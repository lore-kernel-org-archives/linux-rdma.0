From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 pci device table
Date: Wed, 23 Jun 2010 16:17:04 -0700
Message-ID: <adafx0ds5jj.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.64.1006221025130.11239@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1006221025130.11239-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org> (Or
	Gerlitz's message of "Tue, 22 Jun 2010 10:30:17 +0300 (IDT)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > If the table is placed in mlx4_core (as of today in upstream), then I
 > assume the mlx4_en and _ib aren't being probed by pci hot-plug
 > mechasnisms, correct? else if you put it in _en _ib et al files, then
 > one has to maintain two copies of the table, but maybe this would be
 > the correct approach? how this should work with multi-protcol mlx4
 > devices and/or IBoE?

I think the current upstream location is correct.  This matches the
practice of eg iw_cxgb3 as well as cxgb3i, bnx2i etc.  This does have
the disadvantage that mlx4_en and mlx4_ib are not auto-loaded by PCI
hotplug, but so it goes.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] Add fcoe, fcoib drivers for mlx4 device
Date: Mon, 09 Aug 2010 09:10:26 -0700
Message-ID: <adar5i7zs0d.fsf@roland-alpha.cisco.com>
References: <4C5C9170.20706@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5C9170.20706-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Fri, 06 Aug
	2010 15:49:20 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Unfortunately it will probably be a while before I can look at this in
any detail, but here are some obvious things to fix:

 - The actual FC/SCSI driver will need to be reviewed on
   linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org of course; so please CC that list.

 - The ordering/split of patches seems off; in particular I notice that
   the patch that adds the new drivers into the build system comes
   before the patch that actually adds the new drivers, which is
   obviously wrong (since the kernel will be broken if we apply patch
   9/10 but not 10/10).

 - None of the patch subjects contain a subject that says what part of
   the kernel they touch.  For example, instead of

    "[PATCH 01/10]  pre-reserve MPTs for FC"

   please write:

    "[PATCH 01/10] mlx4_core: Pre-reserve MPTs for FC"

   otherwise I waste time having to fix it up by hand.  (And also if you
   want to do things exactly write, please capitalize the subject but do
   not put in a final '.'  But I usually do not complain about that
   level of detail)

 - Every patch seems to have the changelog and diffstat twice.  Please
   fix (and include a "---" between the changelog and diffstat).  If you
   prepare a clean git tree, then git format-patch will get everything
   exactly correct.

 - There seem to be a lot of whitespace and other formatting problems.
   Please run patches through checkpatch.pl and fix any real problems
   that it finds (0 warnings are not necessary since some warnings are
   false positives; but I suspect for these patches most won't be).
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

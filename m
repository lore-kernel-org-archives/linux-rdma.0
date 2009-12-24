From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Thu, 24 Dec 2009 16:50:53 +0200
Message-ID: <20091224145053.GO26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of the management (OpenSM and infiniband
diagnostics) tarballs available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:

1281c3497086f3348b8ede7c3c5dcacf  libibumad-1.3.4.tar.gz
02d0c65079c067e0e933c4822dad8b28  libibmad-1.3.4.tar.gz
3bdd9f288b50c9031883d2d7c2f15937  opensm-3.3.5.tar.gz
b40e2136204f653c675f40516936ecea  infiniband-diags-1.5.5.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Sasha


Al Chu (2):
      remove obsoleted option from iblinkinfo manpage
      correct manpages for tools that are no longer scripts

Hal Rosenstock (2):
      opensm/osm_vendor_ibumad.c: Add transaction ID to osm_vendor_send log message
      opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, revert setting of init failure on QoS initialization failures

Sasha Khapyorsky (6):
      opensm/osm_sa_path_record.c: don't set dgid pointer for local subnet
      opensm: cosmetic cleanup
      opensm: add Voltaire copyright notice
      opensm_release_notes-3.3: RN update
      opensm: update libraries version strings
      management: packages versions update

Yevgeny Kliteynik (3):
      opensm/osm_vl15intf.c: reverting commit 546399c3b983cdfe7adf4bd0b179358744603478
      opensm: copyright updates
      opensm/osm_mcast_mgr.c: fix osm_mcast_mgr_compute_max_hops for managed switch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

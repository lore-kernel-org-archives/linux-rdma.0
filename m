From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 0/3] opensm: Bug fixes for torus-2QoS patchset
Date: Tue, 16 Feb 2010 09:16:42 -0700
Message-ID: <1266337005-29874-1-git-send-email-jaschut@sandia.gov>
References: <1261169461-2516-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1261169461-2516-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches fix bugs discovered during further testing of the
torus-2QoS routing module for OpenSM.

(See http://www.spinics.net/lists/linux-rdma/msg01438.html
and http://www.spinics.net/lists/linux-rdma/msg01938.html)


Jim Schutt (3):
  opensm: Use local variables when searching for torus-2QoS master
    spanning tree root.
  opensm: Fix handling of torus-2QoS topology discovery for radix 4
    torus dimensions.
  opensm: Avoid havoc in dump_ucast_routes() caused by torus-2QoS
    persistent use of osm_port_t:priv.

 opensm/include/opensm/osm_switch.h |   12 +
 opensm/opensm/osm_dump.c           |    2 +-
 opensm/opensm/osm_switch.c         |    7 +-
 opensm/opensm/osm_ucast_mgr.c      |    1 +
 opensm/opensm/osm_ucast_torus.c    |  418 +++++++++++++++---------------------
 5 files changed, 193 insertions(+), 247 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

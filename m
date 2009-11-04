From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/3 v2] opensm: connect switches in trees
Date: Wed, 04 Nov 2009 13:08:27 +0200
Message-ID: <4AF160AB.1000008@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha.

[v2 - no changes, just rebased and resolved conflicts]

The following patch series handles switch-2-switch down/up
connections in trees.
The currently existing option '--connect_roots' is not enough:
this option just adds down/up connections between the tree roots,
but it still leaves many switches unreachable from roots.

Patch 1/3: added new option '--connect_switches'
Patch 2/3: implemented '--connect_roots' and '--connect_switches'
           in fat-tree routing
Patch 3/3: implemented '--connect_switches' in up/down routing.

-- Yevgeny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org
Subject: how to force opensmd to recalculate all =?UTF-8?q?paths=3F?=
Date: 19 Feb 2010 12:42:52 +0100
Message-ID: <20100219114252.4060E3D1821@f53.poczta.interia.pl>
Mime-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

My case is simple - opensm does not recalculate paths unless necessary,
i.e. one of physical links on the way disappears. I just introduced
significant topology changes and need opensm to take them into
consideration. New links were added, a lot of them. Is there any way of
telling opensm to recalculate all paths? At the moment all new links are
happily ignored and i can find no way of doing that live.

My vendor has bad habit of asking me to add ib link here and there to
nullify bottleneck identified and, well, while all new paths are up, I can
find no way of rebalancing paths, so they stay unused.

I'm running OFED-1.3.2-20090119-0501, so all ideas for this version or a
newer one are welcome.

Regards,

kovlensky


----------------------------------------------------------------------
Szybkie i niedrogie... Tylko dla mezczyzn!
Sprawdz >>> http://link.interia.pl/f25a7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

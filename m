From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey()
 to search for 16-bit pkey match
Date: Tue, 11 Sep 2012 13:43:57 -0700
Message-ID: <CAL1RGDXpeK3KjrmzyivQs8FOs2dg5MqSmuVsdRE+bVD5OXe6BA@mail.gmail.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
 <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il>
 <504F70FB.6030806@redhat.com> <CAL1RGDW6D25s+R8HuxK-DMrsS_wvKDTL+LSp2X-TK8gB8Vm2Fg@mail.gmail.com>
 <504FA064.6040002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504FA064.6040002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 11, 2012 at 1:34 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Well, at this point, the mlx4 driver uses them, the rdmacm kernel driver
> uses them, and both QLogic/Intel drivers have their own internal pkey
> table implementation.  So, it isn't so much upper layer as it is drivers.

rdmacm is an upper-level protocol (it's above the midlayer / hardware
abstraction).

mlx4 and mthca look up P_Keys because of internal details of how they
send MADs, and really they should move to maintaining their own P_Key
table too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

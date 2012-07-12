From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Thu, 12 Jul 2012 20:24:34 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D4726ED@FMSMSX108.amr.corp.intel.com>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>,<32E1700B9017364D9B60AED9960492BC0D47265A@FMSMSX108.amr.corp.intel.com>
 <36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The RCU and reference count protect the individual entries in the hash.
> The R/W lock protects the hash table itself. e.g. deleting the hash table itself,
> or in the future re-sizing it.
> S.P.

Understood.

Good job!  This a been thorn for a long time!

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

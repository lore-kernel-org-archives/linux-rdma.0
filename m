From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Thu, 12 Jul 2012 17:58:25 -0700 (PDT)
Message-ID: <20120712.175825.1973614213454644336.davem@davemloft.net>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>
	<32E1700B9017364D9B60AED9960492BC0D47265A@FMSMSX108.amr.corp.intel.com>
	<36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 12 Jul 2012 20:13:28 +0000

> The RCU and reference count protect the individual entries in the hash.
> The R/W lock protects the hash table itself. e.g. deleting the hash table itself, or in the future re-sizing it.

You don't need a R/W lock for that, we have RCU hash tables that get resized
dynamically and the lookup still only needs pure RCU protection.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Sun, 15 Jul 2012 13:17:51 +0300
Message-ID: <500298CF.3010304@mellanox.com>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com> <32E1700B9017364D9B60AED9960492BC0D47265A@FMSMSX108.amr.corp.intel.com> <36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6@MTLDAG01.mtl.com> <20120712.175825.1973614213454644336.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120712.175825.1973614213454644336.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/13/2012 3:58 AM, David Miller wrote:
> From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 12 Jul 2012 20:13:28 +0000
>
>> The RCU and reference count protect the individual entries in the hash. The R/W lock protects the hash table itself. e.g. deleting the hash table itself, or in the future re-sizing it.
>
> You don't need a R/W lock for that, we have RCU hash tables that get resized
> dynamically and the lookup still only needs pure RCU protection.


OK, we see now that __ipv4_neigh_lookup for example uses pure RCU 
protection, will modify the patch to apply the same practice.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

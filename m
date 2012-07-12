From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Thu, 12 Jul 2012 16:52:48 +0300
Message-ID: <4FFED6B0.5040006@mellanox.com>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341914495-32730-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/10/2012 1:01 PM, Or Gerlitz wrote:
> [...] This patch aims to solve the race conditions found in the IPoIB driver.
>
> The patch breaks the connection between the core networking neighbour structure
> and the ipoib_neigh structure. Except for avoiding the race, it allows to in
> under a setup where SKBs carrying IP packets that don't have any associated
> neighbour are transmitted through IPoIB.
>
> We add an ipoib_neigh hash table with 1024 buckets. The hash table key is the destination
> hardware address. Thus the ipoib_neigh is fetched from the hash table and not
> dereferenced from the stashed location at the neighbour structure. The hash table uses
> both RCU and reference count mechanisms to guarantee that no ipoib_neigh instance is
> ever deleted while in use. [...]

Hi Roland, Dave,

Any comments on this patch?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

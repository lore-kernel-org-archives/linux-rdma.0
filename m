From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Mon, 10 Sep 2012 13:35:07 +0300
Message-ID: <504DC25B.1030501@mellanox.com>
References: <20549.47088.805176.786765@iinet.net.au> <CAJZOPZLXktTREd3xmE=v14HpP1O+EgiqA54LHwQvPNXNX9Rr7A@mail.gmail.com> <CAL1RGDXZtqWcFhPXnit=O81wACdXsyDziv6ivkXMOcTf+8_X6w@mail.gmail.com> <201209100957.08509.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201209100957.08509.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/09/2012 09:57, Jack Morgenstein wrote:
> + *
> + * For API usage, in general,
> + * - any function _modifying_ the the tree or tags (inserting or deleting
> + *   items, setting or clearing tags must exclude other modifications, and
> + *   exclude any functions reading the tree.
> + * - any function _reading_ the the tree or tags (looking up items or tags,
> + *   gang lookups) must exclude modifications to the tree, but may occur
> + *   concurrently with other readers.
> + *
> + * The notable exceptions to this rule are the following functions:
> + * radix_tree_lookup
> + * radix_tree_tag_get
> + * radix_tree_gang_lookup
> + * radix_tree_gang_lookup_tag
> + * radix_tree_tagged
> + *
>
> ======= JPM -- Note the following text! =========================
> + * The first 4 functions are able to be called locklessly, using RCU. The
> + * caller must ensure calls to these functions are made within rcu_read_lock()
> + * regions.
> ===========================================
>
> + * Other readers (lock-free or otherwise) and modifications may be
> + * running concurrently.
>
> Roland, the above states explicitly that radix_tree_lookup should be called only under rcu_read_lock()!
> This is NOT the case in our driver, in mlx4_eq_int()/mlx4_cq_completion() .
>
> Looks to me, then, that the spinlock in mlx4_cq_completion() is required.
>
>

Jack,  Max

Actually, can't we do well with rcu_read_lock() in mlx4_cq_completion() 
as that commit documentation suggests?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver CQ completion handler
Date: Mon, 10 Sep 2012 09:57:08 +0300
Message-ID: <201209100957.08509.jackm@dev.mellanox.co.il>
References: <20549.47088.805176.786765@iinet.net.au> <CAJZOPZLXktTREd3xmE=v14HpP1O+EgiqA54LHwQvPNXNX9Rr7A@mail.gmail.com> <CAL1RGDXZtqWcFhPXnit=O81wACdXsyDziv6ivkXMOcTf+8_X6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXZtqWcFhPXnit=O81wACdXsyDziv6ivkXMOcTf+8_X6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sunday 09 September 2012 18:10, Roland Dreier wrote:
> 
> Please look at commit 7cf9c2c76c1a ("[PATCH] radix-tree: RCU lockless readside")
> 
Roland,

What about the following note (from the commit diff mentioned above):
+/**
+ * Radix-tree synchronization
+ *
+ * The radix-tree API requires that users provide all synchronisation (with
+ * specific exceptions, noted below).
+ *
+ * Synchronization of access to the data items being stored in the tree, and
+ * management of their lifetimes must be completely managed by API users.
+ *
+ * For API usage, in general,
+ * - any function _modifying_ the the tree or tags (inserting or deleting
+ *   items, setting or clearing tags must exclude other modifications, and
+ *   exclude any functions reading the tree.
+ * - any function _reading_ the the tree or tags (looking up items or tags,
+ *   gang lookups) must exclude modifications to the tree, but may occur
+ *   concurrently with other readers.
+ *
+ * The notable exceptions to this rule are the following functions:
+ * radix_tree_lookup
+ * radix_tree_tag_get
+ * radix_tree_gang_lookup
+ * radix_tree_gang_lookup_tag
+ * radix_tree_tagged
+ *

======= JPM -- Note the following text! =========================
+ * The first 4 functions are able to be called locklessly, using RCU. The
+ * caller must ensure calls to these functions are made within rcu_read_lock()
+ * regions.
===========================================

+ * Other readers (lock-free or otherwise) and modifications may be
+ * running concurrently.

Roland, the above states explicitly that radix_tree_lookup should be called only under rcu_read_lock()!
This is NOT the case in our driver, in mlx4_eq_int()/mlx4_cq_completion() .

Looks to me, then, that the spinlock in mlx4_cq_completion() is required.

- Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

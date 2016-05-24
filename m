From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI 2/8] lib/nlattr: Add parsing netlink and validate using callback
Date: Tue, 24 May 2016 17:35:20 +0300
Message-ID: <1464100526-31730-3-git-send-email-leonro@mellanox.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When parsing netlink packets, users may want to do some extra
validations on the netlink attributes. Adding nla_parse_cb, which
gets an extra callback parameter. This function is invoked for every
netlink attribute. If the callback fails, parsing will fail as well.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/netlink.h |  1 -
 include/net/netlink.h   |  5 +++++
 lib/nlattr.c            | 43 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index da14ab6..a08b63b 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -117,7 +117,6 @@ netlink_skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 
 #define NLMSG_DEFAULT_SIZE (NLMSG_GOODSIZE - NLMSG_HDRLEN)
 
-
 struct netlink_callback {
 	struct sk_buff		*skb;
 	const struct nlmsghdr	*nlh;
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 0e31727..70ba851 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -149,6 +149,8 @@
  *   nla_find()				find attribute in stream of attributes
  *   nla_find_nested()			find attribute in nested attributes
  *   nla_parse()			parse and validate stream of attrs
+ *   nla_parse_cb()			parse stream of attrs and call to
+ *						callback for every nlattr
  *   nla_parse_nested()			parse nested attribuets
  *   nla_for_each_attr()		loop over all attributes
  *   nla_for_each_nested()		loop over the nested attributes
@@ -237,6 +239,9 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 		 const struct nla_policy *policy);
 int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 	      int len, const struct nla_policy *policy);
+int nla_parse_cb(struct nlattr **tb, int maxtype, const struct nlattr *head,
+		 int len, const struct nla_policy *policy,
+		 int (*cb)(const struct nlattr *, void *), void *cb_priv);
 int nla_policy_len(const struct nla_policy *, int);
 struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
 size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
diff --git a/lib/nlattr.c b/lib/nlattr.c
index f5907d2..ec79387 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -165,22 +165,28 @@ nla_policy_len(const struct nla_policy *p, int n)
 EXPORT_SYMBOL(nla_policy_len);
 
 /**
- * nla_parse - Parse a stream of attributes into a tb buffer
+ * nla_parse_cb - Parse a stream of attributes into a tb buffer with callback
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
  * @head: head of attribute stream
  * @len: length of attribute stream
  * @policy: validation policy
+ * @cb: callback function and data, must not be NULL
+ * @cb_priv: private data for the callback
  *
  * Parses a stream of attributes and stores a pointer to each attribute in
  * the tb array accessible via the attribute type. Attributes with a type
  * exceeding maxtype will be silently ignored for backwards compatibility
  * reasons. policy may be set to NULL if no validation is required.
+ * For every validated nla, the function calls the user-space callback.
+ * If the callback fails (returns with non-zero value), parsing is terminated
+ * and this value is returned as error.
  *
  * Returns 0 on success or a negative error code.
  */
-int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
-	      int len, const struct nla_policy *policy)
+int nla_parse_cb(struct nlattr **tb, int maxtype, const struct nlattr *head,
+		 int len, const struct nla_policy *policy,
+		 int (*cb)(const struct nlattr *, void *), void *cb_priv)
 {
 	const struct nlattr *nla;
 	int rem, err;
@@ -196,6 +202,9 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 				if (err < 0)
 					goto errout;
 			}
+			err = cb(nla, cb_priv);
+			if (err)
+				goto errout;
 
 			tb[type] = (struct nlattr *)nla;
 		}
@@ -209,6 +218,34 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 errout:
 	return err;
 }
+EXPORT_SYMBOL(nla_parse_cb);
+
+static int nla_pass_all_cb(const struct nlattr *nla, void *priv)
+{
+	return 0;
+}
+
+/**
+ * nla_parse - Parse a stream of attributes into a tb buffer
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @head: head of attribute stream
+ * @len: length of attribute stream
+ * @policy: validation policy
+ *
+ * Parses a stream of attributes and stores a pointer to each attribute in
+ * the tb array accessible via the attribute type. Attributes with a type
+ * exceeding maxtype will be silently ignored for backwards compatibility
+ * reasons. policy may be set to NULL if no validation is required.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
+	      int len, const struct nla_policy *policy)
+{
+	return nla_parse_cb(tb, maxtype, head, len, policy, nla_pass_all_cb,
+			    NULL);
+}
 EXPORT_SYMBOL(nla_parse);
 
 /**
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 06/20] IB/uverbs: Add PTR_IN attributes that
 are allocated/copied automatically
Date: Mon, 18 Jun 2018 14:48:54 -0600
Message-ID: <20180618204854.GG6805@ziepe.ca>
References: <20180617100006.30663-1-leon@kernel.org>
 <20180617100006.30663-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180617100006.30663-7-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 12:59:52PM +0300, Leon Romanovsky wrote:
> From: Matan Barak <matanb@mellanox.com>
> 
> Adding UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY flag to PTR_IN attributes.
> By using this flag, the parse automatically allocates and copies the
> user-space data. This data is accessible by using uverbs_attr_get_len
> and uverbs_attr_get_alloced_ptr inline accessor functions from the
> handler.
> 
> Signed-off-by: Matan Barak <matanb@mellanox.com>
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/uverbs_ioctl.c | 25 ++++++++++++++++++++++++-
>  include/rdma/uverbs_ioctl.h            | 25 +++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
> index 8cc3e8dad9b5..ee15c9ca788b 100644
> +++ b/drivers/infiniband/core/uverbs_ioctl.c
> @@ -114,7 +114,26 @@ static int uverbs_process_attr(struct ib_device *ibdev,
>  		    uattr->attr_data.reserved)
>  			return -EINVAL;
>  
> -		e->ptr_attr.data = uattr->data;
> +		if (val_spec->flags & UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY &&
> +		    uattr->len > sizeof(((struct ib_uverbs_attr *)0)->data)) {

Why open-code uverbs_attr_ptr_is_inline() ?

> diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
> index bd6bba3a6e04..0e6f782727bd 100644
> +++ b/include/rdma/uverbs_ioctl.h
> @@ -65,6 +65,8 @@ enum {
>  	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
>  	/* Support extending attributes by length, validate all unknown size == zero  */
>  	UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO = 1U << 1,
> +	/* Valid only for PTR_IN. Allocate and copy the data inside the parser */
> +	UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY = 1U << 2,
>  };
>  
>  /* Specification of a single attribute inside the ioctl message */
> @@ -431,6 +433,17 @@ static inline struct ib_uobject *uverbs_attr_get_uobject(const struct uverbs_att
>  	return attr->obj_attr.uobject;
>  }
>  
> +static inline int uverbs_attr_get_len(const struct uverbs_attr_bundle *attrs_bundle,
> +				      u16 idx)
> +{
> +	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
> +
> +	if (IS_ERR(attr))
> +		return PTR_ERR(attr);
> +
> +	return attr->ptr_attr.len;
> +}
> +
>  static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
>  				 size_t idx, const void *from, size_t size)
>  {
> @@ -457,6 +470,18 @@ static inline bool uverbs_attr_ptr_is_inline(const struct uverbs_attr *attr)
>  	return attr->ptr_attr.len <= sizeof(attr->ptr_attr.data);
>  }
>  
> +static inline void *uverbs_attr_get_alloced_ptr(const struct uverbs_attr_bundle *attrs_bundle,
> +						u16 idx)
> +{
> +	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
> +
> +	if (IS_ERR(attr))
> +		return (void *)attr;
> +
> +	return uverbs_attr_ptr_is_inline(attr) ? u64_to_ptr(void *, attr->ptr_attr.data) :
> +		u64_to_ptr(void, attr->ptr_attr.data);

WTF is this:

   u64_to_ptr(void *, attr->ptr_attr.data) 

That returns attr->ptr_attr.data casted to a void **, then casts it to
a void * - which is identical to u64_to_ptr(void, attr->ptr_attr.data)

It should be &attr->ptr_attr.data. And the return should be const, the
caller shouldn't be mutating the copy.

All this use of u64_to_ptr is ugly needless obfuscation here, and
look, it causes bugs. Use a union.

Like this:

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 8cc3e8dad9b506..82c5d33195dfc7 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -114,9 +114,27 @@ static int uverbs_process_attr(struct ib_device *ibdev,
 		    uattr->attr_data.reserved)
 			return -EINVAL;
 
-		e->ptr_attr.data = uattr->data;
 		e->ptr_attr.len = uattr->len;
 		e->ptr_attr.flags = uattr->flags;
+
+		if (val_spec->flags & UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY &&
+		    !uverbs_attr_ptr_is_inline(e)) {
+			void *p;
+
+			p = kvmalloc(uattr->len, GFP_KERNEL);
+			if (!p)
+				return -ENOMEM;
+
+			e->ptr_attr.ptr = p;
+
+			if (copy_from_user(p, u64_to_user_ptr(uattr->data),
+					   uattr->len)) {
+				kvfree(p);
+				return -EFAULT;
+			}
+		} else {
+			e->ptr_attr.data = uattr->data;
+		}
 		break;
 
 	case UVERBS_ATTR_TYPE_IDR:
@@ -201,6 +219,10 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 								     commit);
 				if (!ret)
 					ret = current_ret;
+			} else if (spec->type == UVERBS_ATTR_TYPE_PTR_IN &&
+				   spec->flags & UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY &&
+				   !uverbs_attr_ptr_is_inline(attr)) {
+				kvfree(attr->ptr_attr.ptr);
 			}
 		}
 	}
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index bd6bba3a6e04a1..6e1c322ff5c015 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -65,6 +65,8 @@ enum {
 	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
 	/* Support extending attributes by length, validate all unknown size == zero  */
 	UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO = 1U << 1,
+	/* Valid only for PTR_IN. Allocate and copy the data inside the parser */
+	UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY = 1U << 2,
 };
 
 /* Specification of a single attribute inside the ioctl message */
@@ -323,7 +325,15 @@ struct uverbs_object_tree_def {
  */
 
 struct uverbs_ptr_attr {
-	u64		data;
+	/*
+	 * If UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY is set then the 'ptr' is
+	 * used.
+	 */
+	union
+	{
+		void *ptr;
+		u64 data;
+	};
 	u16		len;
 	/* Combination of bits from enum UVERBS_ATTR_F_XXXX */
 	u16		flags;
@@ -431,6 +441,17 @@ static inline struct ib_uobject *uverbs_attr_get_uobject(const struct uverbs_att
 	return attr->obj_attr.uobject;
 }
 
+static inline int uverbs_attr_get_len(const struct uverbs_attr_bundle *attrs_bundle,
+				      u16 idx)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	return attr->ptr_attr.len;
+}
+
 static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
 				 size_t idx, const void *from, size_t size)
 {
@@ -457,6 +478,18 @@ static inline bool uverbs_attr_ptr_is_inline(const struct uverbs_attr *attr)
 	return attr->ptr_attr.len <= sizeof(attr->ptr_attr.data);
 }
 
+static inline const void *uverbs_attr_get_alloced_ptr(
+	const struct uverbs_attr_bundle *attrs_bundle, u16 idx)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+
+	if (IS_ERR(attr))
+		return (void *)attr;
+
+	return uverbs_attr_ptr_is_inline(attr) ? &attr->ptr_attr.data :
+						 attr->ptr_attr.ptr;
+}
+
 static inline int _uverbs_copy_from(void *to,
 				    const struct uverbs_attr_bundle *attrs_bundle,
 				    size_t idx,

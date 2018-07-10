From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 6/9] IB/mlx5: Introduce vendor create and
 destroy flow methods
Date: Tue, 10 Jul 2018 11:44:17 -0600
Message-ID: <20180710174417.GC8266@ziepe.ca>
References: <20180708102445.25496-1-leon@kernel.org>
 <20180708102445.25496-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180708102445.25496-7-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 08, 2018 at 01:24:42PM +0300, Leon Romanovsky wrote:

> +static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(struct ib_device *ib_dev,
> +						      struct ib_uverbs_file *file,
> +						      struct uverbs_attr_bundle *attrs)
> +{
> +	struct mlx5_ib_dev *dev = to_mdev(ib_dev);

Same comment as before, the dev needs to come from uboj->context->device

> -/* Used by drivers to declare a complete parsing tree for a single method that
> - * differs only in having additional driver specific attributes.
> +/* Used by drivers to declare a complete parsing tree for new methods
>   */
> -#define ADD_UVERBS_ATTRIBUTES_SIMPLE(_name, _object_id, _method_id, ...)       \
> -	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
> -		_method_id)[] = { __VA_ARGS__ };                               \
> -	static const struct uverbs_method_def UVERBS_METHOD(_method_id) = {    \
> -		.id = _method_id,                                              \
> -		.num_attrs = ARRAY_SIZE(UVERBS_METHOD_ATTRS(_method_id)),      \
> -		.attrs = &UVERBS_METHOD_ATTRS(_method_id),                     \
> -	};                                                                     \
> +#define ADD_UVERBS_METHODS(_name, _object_id, ...)                             \
>  	static const struct uverbs_method_def *const UVERBS_OBJECT_METHODS(    \
> -		_object_id)[] = { &UVERBS_METHOD(_method_id) };                \
> +		_object_id)[] = { __VA_ARGS__ };                               \
>  	static const struct uverbs_object_def _name##_struct = {               \
>  		.id = _object_id,                                              \
> -		.num_methods = 1,                                              \
> +		.num_methods = ARRAY_SIZE(UVERBS_OBJECT_METHODS(_object_id)),  \
>  		.methods = &UVERBS_OBJECT_METHODS(_object_id)                  \
>  	};                                                                     \
>  	static const struct uverbs_object_def *const _name##_ptrs[] = {        \
> @@ -123,4 +115,17 @@
>  		.objects = &_name##_ptrs,                                      \
>  	}
>  
> +/* Used by drivers to declare a complete parsing tree for a single method that
> + * differs only in having additional driver specific attributes.
> + */
> +#define ADD_UVERBS_ATTRIBUTES_SIMPLE(_name, _object_id, _method_id, ...)       \
> +	static const struct uverbs_attr_def *const UVERBS_METHOD_ATTRS(        \
> +		_method_id)[] = { __VA_ARGS__ };                               \
> +	static const struct uverbs_method_def UVERBS_METHOD(_method_id) = {    \
> +		.id = _method_id,                                              \
> +		.num_attrs = ARRAY_SIZE(UVERBS_METHOD_ATTRS(_method_id)),      \
> +		.attrs = &UVERBS_METHOD_ATTRS(_method_id),                     \
> +	};                                                                     \
> +	ADD_UVERBS_METHODS(_name, _object_id, _method_id)

Wow. How does that even compile? Oh I see, the only two users are
passing in a 0 constant which the compiler will understand as NULL
without a warning.

I guess this is an instant crash at runtime?

Should be:

	ADD_UVERBS_METHODS(_name, _object_id, &UVERBS_METHOD(_method_id)

Jason

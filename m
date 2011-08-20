From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 06/37] add rxe_param.h
Date: Sat, 20 Aug 2011 17:27:09 +0200
Message-ID: <CAO+b5-q5ohgttDAc45MSKrSUdUVOfR3xHMSY99JtfX_MetSw8Q@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.415281967@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.415281967-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +enum rxe_mtu {
> +	RXE_MTU_INVALID = 0,
> +	RXE_MTU_256	= 1,
> +	RXE_MTU_512	= 2,
> +	RXE_MTU_1024	= 3,
> +	RXE_MTU_2048	= 4,
> +	RXE_MTU_4096	= 5,
> +	RXE_MTU_8192	= 6,
> +};

Do the numerical values in the above enum have a meaning ? If not, how
about using log2(mtu) for the numerical values and leaving out all
names except RXE_MTU_INVALID ? That would allow to simplify the
implementation of the two functions below.

Also, in the function rxe_param_set_mtu() it is verified whether the
user-provided mtu is in the range (256..4096). Shouldn't there be
symbolic names for these two extreme values ?

> +static inline int rxe_mtu_enum_to_int(enum rxe_mtu mtu)
> +{
> +	switch (mtu) {
> +	case RXE_MTU_256:	return	256;
> +	case RXE_MTU_512:	return	512;
> +	case RXE_MTU_1024:	return	1024;
> +	case RXE_MTU_2048:	return	2048;
> +	case RXE_MTU_4096:	return	4096;
> +	case RXE_MTU_8192:	return	8192;
> +	default:		return	-1;
> +	}
> +}

For this function I'd prefer a function name like "log2_mtu_to_mtu"
instead of "rxe_mtu_enum_to_int". It seems to me that all cases except
"default" produce the value (1 << (8 + log2_mtu)), so the above
function can be made shorter.

> +static inline enum rxe_mtu rxe_mtu_int_to_enum(int mtu)
> +{
> +	if (mtu < 256)
> +		return 0;
> +	else if (mtu < 512)
> +		return RXE_MTU_256;
> +	else if (mtu < 1024)
> +		return RXE_MTU_512;
> +	else if (mtu < 2048)
> +		return RXE_MTU_1024;
> +	else if (mtu < 4096)
> +		return RXE_MTU_2048;
> +	else if (mtu < 8192)
> +		return RXE_MTU_4096;
> +	else
> +		return RXE_MTU_8192;
> +}

The above function can be made shorter by using the function ilog2()
defined in <linux/log2.h>.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

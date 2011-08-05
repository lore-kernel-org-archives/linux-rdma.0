From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 01/37] add slice by 8 algorithm to crc32.c
Date: Fri, 5 Aug 2011 20:39:48 +0200
Message-ID: <CAO+b5-rFs79znwVcG42Px2i351vhiz9hFyCJV5qg77of8Y6P5Q@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.154338911@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.154338911-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote=
:
> -#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-=
1
> -# error CRC_BE_BITS must be a power of 2 between 1 and 8
> +#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS =3D=3D 16 || =
\
> + =A0 =A0 =A0 CRC_BE_BITS & CRC_BE_BITS-1
> +# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
> =A0#endif

It's a little unfortunate that Roland's macro
BUILD_BUG_ON_NOT_POWER_OF_2() can't be used in the above - that would
make the "CRC_BE_BITS & CRC_BE_BITS-1" part more readable.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

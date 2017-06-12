From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:28:02 +0000
Message-ID: <1497281280.2770.1.camel@wdc.com>
References: <20170612064918.12510-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612064918.12510-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <B6A32F27A780C64DB4B6E95E5E1EEDB7-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-12 at 09:49 +0300, Leon Romanovsky wrote:
> Out of order data placement capability indicates that if HCA receives
> out of order RDMA packets, their data placement can be done at the
> desired memory destination given in the packet(s). This is applicable
> to RDMA read and write operations.

Hello Leon and Parav,

Since PCIe writes can be executed out of order, shouldn't that be mentioned
in Documentation/infiniband/out_of_order.txt? See also the documentation of
the=A0Device Control Register and the Enable Relaxed
Ordering bit in the PCIe
spec.

Additionally, since not handling out-of-order RDMA writes correctly is an U=
LP
bug and since there are more ULPs that handle out-of-order writes correctly
than ULPs that don't handle out-of-order writes correctly, if a new flag is
introduced, shouldn't that be a flag to disable out-of-order writes?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

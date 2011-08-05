From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 33/37] add rxe_net.c
Date: Fri, 5 Aug 2011 14:17:04 -0500
Message-ID: <027d01cc53a4$430b0780$c9211680$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.765038738@systemfabricworks.com> <CAO+b5-pk-X7aGgg12ND17OLcqcLU6qyiV+vf22anh9bYsXUUzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pk-X7aGgg12ND17OLcqcLU6qyiV+vf22anh9bYsXUUzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David McMillen <davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Friday, August 05, 2011 1:48 PM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 33/37] add rxe_net.c
> 
> On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> 
> (resending as plain text)
> 
> +static __be64 rxe_mac_to_eui64(struct net_device *ndev)
> +{
> +    unsigned char *mac_addr = ndev->dev_addr;
> +    __be64 eui64;
> +    unsigned char *dst = (unsigned char *)&eui64;
> +
> +    dst[0] = mac_addr[0] ^ 2;
> +    dst[1] = mac_addr[1];
> +    dst[2] = mac_addr[2];
> +    dst[3] = 0xff;
> +    dst[4] = 0xfe;
> +    dst[5] = mac_addr[3];
> +    dst[6] = mac_addr[4];
> +    dst[7] = mac_addr[5];
> +
> +    return eui64;
> +}
> 
> The above is a standard EUI-48 into EUI-64 translation I assume ?
Yes.
> 
> Also, I haven't found a function that does the opposite translation -
> does that mean that there is no GID-to-rxe-device translation in the
> ib_rxe driver yet ? I'd like to give ib_srp over ib_rxe a try, but as
> far as I can see that won't work yet ?

There are a couple of issues with SRP/RoCE. One of them is that the current
scheme for configuring connections is based on DM MADs. The other is the one
you mention. We (SFW) looked at both problems a couple of years ago and came
up with a version of SRP that runs over RDMACM. SRP was standardized before
RDMACM was a gleam in Sean's eye and assumes that it has the entire private
data area for CM MADs to pass parameters. But if you squeeze a little you
can get it all in after the area that RDMACM takes. We have versions of SRPI
and SRPT that can use RDMACM for connection setup. Since RDMACM supports
connection setup automatically for RoCE you're all fixed. In order to make
this commercially practical you would have to go back to NCITS and update
the SRP standard but I'm not too sure that there is enough interest to make
that happen. The other problem requires making changes to the special file
that sets up the connection. We also have this patch.

If you are interested in this I would be glad to work with you to try to get
these patches into OFED.

> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

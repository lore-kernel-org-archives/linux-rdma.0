From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: interoperability issue between rxe and mlx5
Date: Mon, 5 Feb 2018 15:09:27 +0200
Message-ID: <CAG9sBKPtDAApLxuOvM-1pyEain-aPm-bmBu1rp7DsnuvRUT-UA@mail.gmail.com>
References: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On the network trace, for the size=4093, I see:
> Read request for 4093
> Read response first data 1024bytes
> Read response middle data 1024bytes
> Read response middle data 1024bytes
> Read response last data 1024bytes
> Read request for 1021
> Read response last data1024
>
> Then the last two message are repeated 6times. Then disconnect.
>

Hi Olga
It looks like that the last response packet is sent with wrong size
and continues to do so for repeated retries until the requester gives
up.
I'll try to look into it and update

thanks
Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

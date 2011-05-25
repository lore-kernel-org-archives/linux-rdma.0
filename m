From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 15:10:18 -0700
Message-ID: <BANLkTi=NkZQX2JFa99qkVpLAchRjNoYOhg@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
 <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com> <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
 <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com> <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2011 at 2:46 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> At least can we make this a runtime thing? =A0If we're able to set a
>> port as IB vs ethernet then # of VLs seems like it should be doable =
too.
>
> Here I lost you again, the policy is dictated by the module param,
> which whose default value should be turned on, the code that sets the
> mtu and VL cap is executed each time the function change by the patch
> is called, which in turn happens each time an IB link type is sensed
> or dictated for the port.

I mean set the MTU port-by-port with the module loaded, the same way
we are supposed to be able to do for the port type.  Rather than having
one global module parameter.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

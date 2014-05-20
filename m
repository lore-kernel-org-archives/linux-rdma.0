From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: help with IB_WC_MW_BIND_ERR
Date: Tue, 20 May 2014 15:50:59 -0400
Message-ID: <E9C5BF5E-BB15-4924-8537-96AB263AED9A@oracle.com>
References: <B34C7243-DCF8-472B-B156-9B8791F0F475@oracle.com> <CABgxfbHu8Wga6tX7iPyNb0aZaVY7XizAY_jpJW6+Nk2H9Gva5w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbHu8Wga6tX7iPyNb0aZaVY7XizAY_jpJW6+Nk2H9Gva5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 20, 2014, at 3:39 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:

> On Tue, May 20, 2014 at 11:55 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
> wrote:
>> Hi-
>>=20
>> What does it mean when a LOCAL_INV work request fails with a
>> IB_WC_MW_BIND_ERR completion?
>>=20
>=20
> Mapping an IB error code has been a great pain (at least for me)
> unless you have access to the HCA firmware. In this case, I think it
> implies memory protection error (registration issues).... say in cxgb=
4
> driver, it is associated with invalidate shared MR or invalidate boun=
d
> memory window (with a QP):
>=20
>                case T4_ERR_INVALIDATE_SHARED_MR:
>                case T4_ERR_INVALIDATE_MR_WITH_MW_BOUND:
>                        wc->status =3D IB_WC_MW_BIND_ERR;
>                        break;
>=20
> "drivers/infiniband/hw/cxgb4/cq.c" line 654 of 898 --72%-- col 11-25
>=20
> You'll probably need to mention the HCA name so the firmware people,
> if they are reading this, could pinpoint the exact cause.

Thanks. ConnectX-2, mlx4 provider.

The IB architecture spec lists five conditions that could result in an
IB_WC_MW_BIND_ERR completion of LOCAL_INV:

1. Memory access was attempted on an L_Key or R_Key that is in the
   Invalid State;

2. Memory Region could not be Invalidated, because it is a Shared
   Memory Region;

3. Memory Region can not be invalidated because it has bound Memory
   Window; or

4. Memory Region could not be Invalidated, because it was created
   through a Register Memory Region or Reregister Memory Region.

5. Memory Window could not be Invalidated, because it was a Type 1
   Memory Window.

This is with FRMR and the MR is not shared (I think?). So I expect I=92=
m
dealing with condition 1. But I can=92t seem to make any more headway o=
n
confirming that, or how it got that way.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

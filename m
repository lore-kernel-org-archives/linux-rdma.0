From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Thu, 11 Mar 2010 18:29:56 +0100
Message-ID: <A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
References: <20100310155749.GA25964@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20100310155749.GA25964@vlad-laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Vlad,

Did you consider my input in http://www.mail-archive.com/linux-rdma@vge=
r.kernel.org/msg02803.html wrt. to these enhancements?

=20

Thanks, H=E5kon

On Mar 10, 2010, at 16:57 , Vladimir Sokolovsky wrote:

> Hi Roland,
>=20
> This patchset adds support for the following enhanced atomic
> operations:
> - Masked atomic compare and swap
> - Masked atomic fetch and add
>=20
> These operations enable using a smaller amount of memory when using
> multiple locks by using portions of a 64 bit value in an atomic
> operation.
> For some applications the memory savings are very significant. One
> example is fine grain lock implementations for huge data sets. In
> other cases, the benefit is the ability to update multiple fields wit=
h
> a single io operation.
>=20
> Vladimir Sokolovsky(2):
> IB/core: Add support for enhanced atomic operations
> mlx4/IB: Add support for enhanced atomic operations
>=20
> changes from V2:
> - patch #1:=20
>  Updated description
>  Renamed:
>        IB_WR_ATOMIC_MASKED_CMP_AND_SWP -> IB_WR_MASKED_ATOMIC_CMP_AND=
_SWP
>        IB_WR_ATOMIC_MASKED_FETCH_AND_ADD -> IB_WR_MASKED_ATOMIC_FETCH=
_AND_ADD
>  In the ib_send_wr struct the new fields added before the rkey field
>=20
> - patch #2:
>  Set IB_DEVICE_MASKED_ATOMIC flag with other flags that get set for
>  all devices
>=20
> Regards,
> Vladimir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

H=E5kon Bugge
Haakon.bugge-U0mLk4xYmo8@public.gmane.org
+47 924 84 514



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

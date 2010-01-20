From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/documentation: fix typo in include/rdma/ib_verbs.h
Date: Wed, 20 Jan 2010 20:23:37 +0100
Message-ID: <e2e108261001201123xc4e07edu106bb8714843a12b@mail.gmail.com>
References: <e2e108261001200456r470e7e51p67504454acbc3258@mail.gmail.com>
	 <adamy088u47.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamy088u47.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 20, 2010 at 8:16 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> - * =A0 may also be |ed in to request a hint about missed events=
, as
> =A0> + * =A0 may also be passed in to request a hint about missed eve=
nts, as
>
> I don't think this is a typo -- the comment is trying to say that the
> "report missed events" flag can be OR-ed in, ie |ed in.

Sorry for the misunderstanding. Since there is at least one person who
misunderstood this (me), maybe it's a good idea to replace "|ed" by
"or-ed" ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

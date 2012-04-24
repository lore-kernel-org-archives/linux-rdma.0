From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: possible recursive locking detected in the cma?
Date: Tue, 24 Apr 2012 13:31:02 -0700
Message-ID: <CAL1RGDUZMAOrAQG_sg9iuF4tEWSgb2Zaun01C1VXkm1RVC7WMA@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373469D8171@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373469D8171-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 24, 2012 at 12:37 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [ INFO: possible recursive locking detected ]
>> 3.3.0-32035-g1b2649e-dirty #4 Not tainted
>> ---------------------------------------------
>> kworker/5:1/418 is trying to acquire lock:
>> =A0(&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0138a41>]
>> rdma_destroy_id+0x33/0x1f0 [rdma_cm]
>
> cma_req_handler() calls rdma_destroy_id() for the newly created rdma_=
cm_id. =A0rdma_destroy_id() acquires the handler_mutex for that id.
>
>> but task is already holding lock:
>> =A0(&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>]
>> cma_disable_callback+0x24/0x45 [rdma_cm]
>
> cma_req_handler() calls cma_disable_callback)() for the listening rdm=
a_cm_id. =A0The listening handler_mutex is held throughout the callback=
=2E

lockdep tracks things by lock class, so it doesn't know the two
handler_mutexes are different.

The usual fix is to use mutex_lock_nested, cf "Exception: Nested data
dependencies leading to nested locking" in
Documentation/lockdep-design.txt.  I haven't looked at how easy that
is to do in this case.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

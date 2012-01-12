From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: endian question about struct srp_direct_buf
Date: Thu, 12 Jan 2012 12:52:49 +0100
Message-ID: <CAO+b5-q5UrjL9YUg5gvN4PUVBzGtjLh8rD6M-sTDYK0YA46wXA@mail.gmail.com>
References: <20120112114122.GA29021@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120112114122.GA29021-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2012 at 12:41 PM, Dan Carpenter
<dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Sparse complains because len in struct srp_direct_buf is declared as
> big endian but it's used throughout as CPU endian. =A0struct
> srp_indirect_buf has the same thing. =A0It's declared one way but use=
d the
> other way.
>
> $ grep -w len drivers/scsi -R | grep -w md
> drivers/scsi/ibmvscsi/ibmvfc.c: =A0 =A0 =A0 =A0 md[i].len =3D sg_dma_=
len(sg);
> drivers/scsi/ibmvscsi/ibmvstgt.c: =A0 =A0 =A0 =A0 =A0 =A0 =A0 mlen =3D=
 min(rest, md[i].len);
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md->len, sc=
si_sg_count(sc));
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0len =3D min(scsi_bufflen(sc=
), md->len);
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0len =3D md->len;
> drivers/scsi/libsrp.c: =A0err =3D rdma_io(sc, sg, nsg, md, 1, dir, le=
n);
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0md =3D dma_alloc_coherent(i=
ue->target->dev, id->table_desc.len,
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0sg_init_one(&dummy, md, id-=
>table_desc.len);
> drivers/scsi/libsrp.c: =A0err =3D rdma_io(sc, sg, nsg, md, nmd, dir, =
len);
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0dma_free_coherent(iue->targ=
et->dev, id->table_desc.len, md, token);
> drivers/scsi/libsrp.c: =A0 =A0 =A0 =A0 =A0len =3D md->len;
>
> Probably we should just change the declaration to u32?

(resending as plain text)

No. The SRP spec says that that field is big endian and the ib_srp
driver uses that field as a big endian field. The output above (libsrp
+ ibmvstgt) is code that is used by the ibmvstgt driver only, and the
reason that driver works fine without endianness conversion is because
it is only used on PowerPC systems.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

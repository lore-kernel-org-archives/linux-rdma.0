From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] libmlx4: Fix a compiler warning
Date: Mon, 10 Oct 2011 17:41:16 -0700
Message-ID: <CAL1RGDVNoh1Fdm5pvDaeB9YykRpfXMe-s+P_iHs=8Z_r5_DpBQ@mail.gmail.com>
References: <201110101947.34035.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110101947.34035.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2011 at 10:47 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> =
wrote:
> - =A0 =A0 =A0 uint32_t hi =3D *(uint32_t *)(gid->raw);
> - =A0 =A0 =A0 uint32_t lo =3D *(uint32_t *)(gid->raw + 4);
> - =A0 =A0 =A0 if (hi =3D=3D htonl(0xfe800000) && lo =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 uint32_t hi =3D gid->u32[0];
> + =A0 =A0 =A0 uint32_t lo =3D gid->u32[1];

Thanks, however I like to keep libmlx4 backwards compatible
if possible.  So we can't do this unconditionally.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

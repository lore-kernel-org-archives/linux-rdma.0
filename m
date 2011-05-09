From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V4 1/6] IB Netlink Infrastructure
Date: Mon, 9 May 2011 12:35:26 -0700
Message-ID: <BANLkTi=J6ZTFCz12XkL4-ZeUsuAKODRjOw@mail.gmail.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com> <1294068834-17778-2-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294068834-17778-2-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +int ibnl_add_client(int index, int nops,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct ibnl_client_cbs cb=
_table[])
> +{
> + =A0 =A0 =A0 struct ibnl_client *cur;
> + =A0 =A0 =A0 struct ibnl_client *nl_client =3D kmalloc(sizeof *nl_cl=
ient, GFP_ATOMIC);
> +
> + =A0 =A0 =A0 if (!nl_client)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 nl_client->index =3D index;
> + =A0 =A0 =A0 nl_client->nops =3D nops;
> + =A0 =A0 =A0 nl_client->cb_table =3D cb_table;
> + =A0 =A0 =A0 mutex_lock(&ibnl_mutex);

quick question: why is GFP_ATOMIC used here?  It seems that since the
function later does mutex_lock(), there can't be any problem with sleep=
ing.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Fri, 11 Nov 2011 12:41:04 +0100
Message-ID: <CAO+b5-oX94=81Gdr2cs0VFoF8Yb+B1DAT2Z+h2UeP6q111Rv7g@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318556901-14850-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +static void srpt_drop_tport(struct se_wwn *wwn)
> +{
> + =A0 =A0 =A0 struct srpt_port *sport =3D container_of(wwn, struct sr=
pt_port, port_wwn);
> +
> + =A0 =A0 =A0 pr_debug("drop_tport(%s\n", config_item_name(&sport->po=
rt_wwn.wwn_group.cg_item));

A minor comment: the above statement always never prints the port name
- it always prints the following:

ib_srpt drop_tport((null)

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

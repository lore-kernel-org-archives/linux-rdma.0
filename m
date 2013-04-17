From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: linux-next: Tree for Apr 17 (infiniband/rdma)
Date: Wed, 17 Apr 2013 11:13:58 -0700
Message-ID: <CAL1RGDWhij_HwACeGH-=eXKrtTG67rKtJPvtSQrEWQsSYR7gAQ@mail.gmail.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au> <516EE4BD.3000200@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516EE4BD.3000200-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2013 at 11:06 AM, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> on x86_64:
>
> drivers/built-in.o: In function `isert_free_np':
> ib_isert.c:(.text+0x6e8a77): undefined reference to `rdma_destroy_id'
> drivers/built-in.o: In function `isert_conn_setup_qp':
> ib_isert.c:(.text+0x6e9038): undefined reference to `rdma_create_qp'

Nic, I think isert needs a "depends on INFINIBAND_ADDR_TRANS" to avoid this.
(this is coming from the SCSI target tree, not the InfiniBand/RDMA tree)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

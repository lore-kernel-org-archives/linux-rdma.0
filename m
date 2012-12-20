From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Wed, 19 Dec 2012 16:22:54 -0800
Message-ID: <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
References: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121220094433.791d70e55ae5e3325a6190fc-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 19, 2012 at 2:44 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the infiniband tree, today's linux-next build (x86_64_
> allmodconfig) failed like this:
>
> In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
>                  from drivers/scsi/csiostor/csio_scsi.h:49,
>                  from drivers/scsi/csiostor/csio_init.h:45,
>                  from drivers/scsi/csiostor/csio_attr.c:45:
> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of 'enum fw_retval'
> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum fw_retval'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally defined here
> drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumerator 'FW_ENOEXEC'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definition of 'FW_ENOEXEC' was here
> drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumerator 'FW_ENOMEM'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definition of 'FW_ENOMEM' was here
> drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumerator 'FW_EADDRINUSE'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definition of 'FW_EADDRINUSE' was here
>
> And several others similar.
>
> Caused by commit f65b56b15931 ("RDMA/cxgb4: Fix LE hash collision bug for
> active open connection").


Vipul, is the right fix to pull the full list of FW return values from
t4fw_api_stor.h into t4fw_api.h as part of this patch (f65b56b15931)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

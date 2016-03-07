From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH RESEND] qib:Fix concurrent access in the function,
 qib_init_iba6120_funcs
Date: Mon, 7 Mar 2016 22:49:48 +0200
Message-ID: <20160307204948.GI13396@leon.nu>
References: <1457323126-19686-1-git-send-email-xerofoify@gmail.com>
 <32E1700B9017364D9B60AED9960492BC25A7C169@fmsmsx120.amr.corp.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25A7C169-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2016 at 04:34:04PM +0000, Marciniszyn, Mike wrote:
> > This fixes concurrent access in the function, qib_init_iba6120_funcs by locking
> > around the calls to when setting up f_sendctrl and f_set_armlauch function
> > pointers to the functions, sendctrl_6120_mod qib_set_6120_armlaunch due to
> > these functions needing to have their caller to hold the spinlock that is part of
> > the qib_ibport pointer they are using and due to the lock not being held by
> > higher up functions in the caller stack we need to hold it in qib_init_iba6210 to
> > avoid conncurrent access when setting up these function pointers.
> > 
> 
> I'm not sure I agree.
> 
> static struct pci_driver qib_driver = {
>         .name = QIB_DRV_NAME,
>         .probe = qib_init_one,
>         .remove = qib_remove_one,
>         .id_table = qib_pci_tbl,
>         .err_handler = &qib_pci_err_handler,
> };
> 
> The only caller is the probe function, which naturally protects since the device cannot be used until the probe returns.
> 
> Are you actually having an issue with this older version of a qib card?

IMHO no,
The author is famous developer - Nick Krause [1].

[1]
http://news.softpedia.com/news/Malevolent-Developer-Trolls-Linux-Kernel-Development-with-Lots-of-Broken-Patches-453709.shtml

> 
> The other board specific routines if this indeed is an issue, would need to be fixed as well since that have the same chip specific routine.
> 
> Mike
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RESEND] qib:Fix concurrent access in the function,
 qib_init_iba6120_funcs
Date: Mon, 7 Mar 2016 16:34:04 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25A7C169@fmsmsx120.amr.corp.intel.com>
References: <1457323126-19686-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457323126-19686-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This fixes concurrent access in the function, qib_init_iba6120_funcs by locking
> around the calls to when setting up f_sendctrl and f_set_armlauch function
> pointers to the functions, sendctrl_6120_mod qib_set_6120_armlaunch due to
> these functions needing to have their caller to hold the spinlock that is part of
> the qib_ibport pointer they are using and due to the lock not being held by
> higher up functions in the caller stack we need to hold it in qib_init_iba6210 to
> avoid conncurrent access when setting up these function pointers.
> 

I'm not sure I agree.

static struct pci_driver qib_driver = {
        .name = QIB_DRV_NAME,
        .probe = qib_init_one,
        .remove = qib_remove_one,
        .id_table = qib_pci_tbl,
        .err_handler = &qib_pci_err_handler,
};

The only caller is the probe function, which naturally protects since the device cannot be used until the probe returns.

Are you actually having an issue with this older version of a qib card?

The other board specific routines if this indeed is an issue, would need to be fixed as well since that have the same chip specific routine.

Mike




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

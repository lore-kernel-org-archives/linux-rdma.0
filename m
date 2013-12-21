From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-next 9/9] IB/usnic: Fix sparse should be static warnings
Date: Sat, 21 Dec 2013 11:09:15 +0100
Message-ID: <52B568CB.2070804@acm.org>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com> <1387298917-7365-10-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-10-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/17/13 17:48, Upinder Malhi wrote:
> Sparse spit out few functions should be static warnings.  This
> patch provides a fix for the warnings.
> 
> [ ... ]
> @@ -579,6 +580,7 @@ static void __exit usnic_ib_destroy(void)
>  {
>  	usnic_dbg("\n");
>  	usnic_debugfs_exit();
> +	usnic_transport_fini();
>  	unregister_netdevice_notifier(&usnic_ib_netdevice_notifier);
>  	pci_unregister_driver(&usnic_ib_pci_driver);
>  	usnic_uiom_fini();

To me the above looks like a behavior change and not just a fix for a
sparse warning. Shouldn't this change be moved into a separate patch ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

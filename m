From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 9/9] IB/usnic: Fix sparse should be static
 warnings
Date: Tue, 7 Jan 2014 22:14:15 +0000
Message-ID: <C3CDE016-3DF5-4BAC-80BF-A840141E41C3@cisco.com>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com>
 <1387298917-7365-10-git-send-email-umalhi@cisco.com>
 <52B568CB.2070804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B568CB.2070804-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Content-ID: <BFD9CA9F65CA54429EE5C8D0213021A7-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The below patch fixes the warning, exactly as the description states; no guarantees have been made that the fixes are only comestic.  No reason to put this in another patch.

Upinder

On Dec 21, 2013, at 2:09 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On 12/17/13 17:48, Upinder Malhi wrote:
>> Sparse spit out few functions should be static warnings.  This
>> patch provides a fix for the warnings.
>> 
>> [ ... ]
>> @@ -579,6 +580,7 @@ static void __exit usnic_ib_destroy(void)
>> {
>> 	usnic_dbg("\n");
>> 	usnic_debugfs_exit();
>> +	usnic_transport_fini();
>> 	unregister_netdevice_notifier(&usnic_ib_netdevice_notifier);
>> 	pci_unregister_driver(&usnic_ib_pci_driver);
>> 	usnic_uiom_fini();
> 
> To me the above looks like a behavior change and not just a fix for a
> sparse warning. Shouldn't this change be moved into a separate patch ?
> 
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

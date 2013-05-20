From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 22:50:31 +0300
Message-ID: <CAJZOPZLaXDjMHWCoo5Gs_iEro22o6XS2u-f6E9SLtH3AFMu_mQ@mail.gmail.com>
References: <519686B4.7010300@profitbricks.com>
	<CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com>
	<5197F447.5020702@profitbricks.com>
	<51986A8B.9030806@mellanox.com>
	<519898B0.1000901@profitbricks.com>
	<5199E747.3070502@mellanox.com>
	<CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com>
	<519A01DD.6080906@mellanox.com>
	<CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com>
	<519A1C60.4060005@mellanox.com>
	<CAD+HZHUKU3qq_WbaoW8NfwkoMQWQKeVS1GTGXxBRUEJOridEyg@mail.gmail.com>
	<519A275B.9070400@mellanox.com>
	<519A34F9.3080700@profitbricks.com>
	<CAJZOPZKQF-qWLKAtuh8tJvPeMmWJTsXqG5P_0ELBs3EKYDh4sA@mail.gmail.com>
	<519A7BAA.1080008@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519A7BAA.1080008-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 20, 2013 at 10:38 PM, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
>
> The bug in our production environment is introduced in our backport
> about ipoib fixes from mainline, and when we hit that bug we reverted
> back to old kernel without the backport patch, and the bug didn't happen for now.
>
> This list_del_init patch do fix list corruption warning, but it's not the one we hit in production, the list corruption is reproduced in our test setup with bug injection patch && iperf -P 50 && mode switch.
>
> Is this clear for you now?


NO, you say that the list_del_init patch eliminates the "list
corruption warning", does the "list corruption" is still reproduced in
your test setup even when  the patch is applied?! what's the trace?
and what is the trace you see in your production when using kernel X
(which?) patches with commit Y (which?)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

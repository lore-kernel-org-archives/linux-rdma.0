From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/CMA: fail qkey setting for RDMA_PS_IPOIB and IB_LINK_LAYER_ETHERNET
Date: Fri, 8 Jul 2011 14:02:44 +0300
Message-ID: <CAG9sBKNFrBoHoyNLbnTZyBuc+bQ0JexuRtHryXa9aW7Jstb0cg@mail.gmail.com>
References: <1310045857-26040-1-git-send-email-monis@mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A8237302D0F3@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302D0F3-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <orend-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes, the kernel crashed after watchdog detected a lockup. This
happened while running udaddy -p 0x2 with RoCE. The crash isn't 100%
reproducible but I have a pair of nodes where that used to crash with
probability of 50%.
The fix you suggest seems to detect the mismatch between port space
and link layer earlier, so I guess it handles the bug better. I'll
rewrite, retest and send a fix on Sunday.

- monis

On Thu, Jul 7, 2011 at 7:55 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> In general, when link layer is ETHERNET it is wrong to use IPoIB por=
t space
>> since
>> no IPoIB interface is available. Specifically, setting qkey when por=
t space is
>> RDMA_PS_IPOIB, requires SA query which is impossible when link layer=
 is
>> IB_LINK_LAYER_ETHERNET.
>
> Can you describe the problem that the current code causes? =A0Does it=
 lead to a kernel crash?
>
> Maybe the issue is that port space ipoib should never be associated w=
ith a non-IB device, with a check added to cma_acquire_dev().
>
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [Bug 37402] New: kernel BUG at drivers/pci/intel-iommu.c:1656
 while registering memory for InfiniBand
Date: Mon, 13 Jun 2011 09:16:47 -0700
Message-ID: <BANLkTinYGyK_Acu5MB5PDqj-fODu6mMkJQ@mail.gmail.com>
References: <bug-37402-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bug-37402-11804-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jesse Barnes <jbarnes-Y1mF5jBUw70BENJcbMCuUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi intel-iommu guys,

It seems that the user is getting this BUG when doing something that
essentially does
dma_map_sg() for 1GB of memory.  AFAICT, the mlx4 driver is correctly d=
oing

	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));

during init, but the BUG being hit here is:

	BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1) >> addr_=
width);

Any suggestions on what might be going wrong here?

Thanks,
  Roland

On Mon, Jun 13, 2011 at 1:37 AM,  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org>=
 wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D37402
>
> =A0 =A0 =A0 =A0 =A0 Summary: kernel BUG at drivers/pci/intel-iommu.c:=
1656 while
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0registering memory for InfiniB=
and
> =A0 =A0 =A0 =A0 =A0 Product: Drivers
> =A0 =A0 =A0 =A0 =A0 Version: 2.5
> =A0 =A0Kernel Version: 2.6.38.6-26.rc1.fc15.x86_64
> =A0 =A0 =A0 =A0 =A0Platform: All
> =A0 =A0 =A0 =A0OS/Version: Linux
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Tree: Fedora
> =A0 =A0 =A0 =A0 =A0 =A0Status: NEW
> =A0 =A0 =A0 =A0 =A0Severity: normal
> =A0 =A0 =A0 =A0 =A0Priority: P1
> =A0 =A0 =A0 =A0 Component: Infiniband/RDMA
> =A0 =A0 =A0 =A0AssignedTo: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN6+46SIhDJjyZ@public.gmane.org=
rg
> =A0 =A0 =A0 =A0ReportedBy: fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> =A0 =A0 =A0 =A0Regression: No
>
>
> Created an attachment (id=3D61782)
> =A0--> (https://bugzilla.kernel.org/attachment.cgi?id=3D61782)
> Crash dump
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Dem=
ail
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
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

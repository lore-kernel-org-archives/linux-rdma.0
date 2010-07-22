From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4_core unable to use MSI-x on our nodes
Date: Thu, 22 Jul 2010 13:47:01 -0600
Message-ID: <20100722194701.GO7920@obsidianresearch.com>
References: <AANLkTinco6znrHkoE9vL1n7KrrZ68zPExPUPQeDHD64i@mail.gmail.com> <Pine.GSO.4.40.1007221320200.17-300000@kappa.cse.ohio-state.edu> <6203933669E90E4AB42B5BC4EDE38D350CF01EF379@orsmsx510.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6203933669E90E4AB42B5BC4EDE38D350CF01EF379-qERRe+bbXDTTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 22, 2010 at 10:56:55AM -0700, Meyer, Donald J wrote:

> In our dmesg log I see "mlx4_core 0000:02:00.0: Only 12 MSI-X
> vectors available, need 25. Not using MSI-X" which if I read it
> correctly says our mlx4_core is unable to use MSI-X which if I also
> understand correctly means the mlx4_core can't use the sharing of
> interrupts among all processors.
 
> If this is correct, do we want to try to fix this so the mlx4_core
> can use MSI-X and share the interrupts?
 
Yes, you will get better performance with MSI-X, fixing it is
worthwhile..

> And if we do want to fix this, do you have any suggestions for how
> to fix it?

AFAIK, the only way to fix this is to user a newer kernel (or
different build options?).. Some kernels do not provide very many
interrupt vectors so they get exhausted easily.

Ie the 2.6.28 kernel I have here is using vector numbers 2298 for MSI
vectors.. There are lots of interrupts available :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

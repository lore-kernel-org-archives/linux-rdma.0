From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Linux DMA address
Date: Mon, 2 Jul 2012 13:44:12 +0200
Message-ID: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,
in the context of ib memory management on Linux we are going to use
ib_get_dma_mr() in conjunction with ib_dma_map_single(). The
ib_dma_map_single is described as "Map a kernel virtual address to DMA
address", i have a question on the returned value "DMA address". I lear=
ned
somewhere that DMA address is not necessarily a 64-bit real address.

When we call ib_dma_map_single() with same buffer-address, size and
dma_data_direction, but with different ib_devs. Would that generate the
same Linux DMA address on all ib devices? Sure we will have controls in
place that not both devices write into the buffer simultaneously. So wh=
ats
the nature of the returned DMA address of ib_dma_map_single and can we
assume that it is the same value on different devices on one system?
Thanks for your time spending on this topic.

Kind regards
Klaus Wacker
IBM Systems &Technology Group, Systems Software Development
SW Linux on System z Dev & Service
Phone: 	+49-7031-16-3779 	 IBM Deutschland 	E-Mail:
kdwacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org 	 Schoenaicher Str. 220		 71032 Boeblingen,
Germany
IBM Deutschland Research & Development GmbH / Vorsitzende des
Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stutt=
gart,
HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

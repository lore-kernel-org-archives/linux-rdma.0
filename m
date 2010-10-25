From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced
 error reporting fails
Date: Mon, 25 Oct 2010 13:35:33 -0700
Message-ID: <1288038933.27343.392.camel@chromite.mv.qlogic.com>
References: <20101022222937.28161.50341.stgit@chromite.mv.qlogic.com>
	 <20101022222951.28161.23347.stgit@chromite.mv.qlogic.com>
	 <20101022225710.GD15514@obsidianresearch.com>  <adabp6ksk83.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZzYhRbHPrJx1v3pSd7tu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabp6ksk83.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--=-ZzYhRbHPrJx1v3pSd7tu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 2010-10-23 at 13:54 -0700, Roland Dreier wrote:
> I'm lost on which initialization / cleanup fixes are the right ones to
> take for qib.  Can someone point me to the definitive set of patches?
> 
>  - R.

If Jason agrees, they are the attached.
There are probably more error paths that need fixing
but I think separate patches make sense for those.

--=-ZzYhRbHPrJx1v3pSd7tu
Content-Disposition: inline
Content-Description: Attached message - [PATCH 1/2] IB/qib: fix
 uninitialized pointer if CONFIG_PCI_MSI not set
Content-Type: message/rfc822

Received: from mail25-db3-R.bigfish.com (213.199.154.136) by
 avexcashub1.qlogic.org (10.1.4.161) with Microsoft SMTP Server (TLS) id
 8.1.436.0; Fri, 22 Oct 2010 15:36:54 -0700
Received: from mail25-db3 (localhost.localdomain [127.0.0.1])	by
 mail25-db3-R.bigfish.com (Postfix) with ESMTP id 2C407440138;	Fri, 22 Oct
 2010 22:36:53 +0000 (UTC)
Received: from mail25-db3 (localhost.localdomain [127.0.0.1]) by mail25-db3
 (MessageSwitch) id 1287786996442519_8471; Fri, 22 Oct 2010 22:36:36 +0000
 (UTC)
Received: from DB3EHSMHS005.bigfish.com (unknown [10.3.81.249])	by
 mail25-db3.bigfish.com (Postfix) with ESMTP id 612837B8051;	Fri, 22 Oct
 2010 22:36:36 +0000 (UTC)
Received: from vger.kernel.org (209.132.180.67) by DB3EHSMHS005.bigfish.com
 (10.3.87.105) with Microsoft SMTP Server id 14.0.482.44; Fri, 22 Oct 2010
 22:36:34 +0000
Received: (majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org) by vger.kernel.org via listexpand	id
 S1750837Ab0JVWgb (ORCPT <rfc822;ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>	+ 3 others);
 Fri, 22 Oct 2010 18:36:31 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:47773 "HELO
 mx.mv.qlogic.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
 id S1751032Ab0JVWgb (ORCPT <rfc822;linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>);	Fri, 22
 Oct 2010 18:36:31 -0400
Received: from chromite.mv.qlogic.com (chromite.mv.qlogic.com [10.29.2.82])
 by mx.mv.qlogic.com (Postfix) with ESMTP id B355E143006C;	Fri, 22 Oct 2010
 15:29:46 -0700 (PDT)
Received: from chromite.mv.qlogic.com (localhost.localdomain [127.0.0.1])
 by chromite.mv.qlogic.com (Postfix) with ESMTP id 797C014294D;	Fri, 22 Oct
 2010 15:29:46 -0700 (PDT)
From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
 <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Fri, 22 Oct 2010 15:29:46 -0700
Subject: [PATCH 1/2] IB/qib: fix uninitialized pointer if CONFIG_PCI_MSI
 not set
Thread-Topic: [PATCH 1/2] IB/qib: fix uninitialized pointer if
 CONFIG_PCI_MSI not	set
Thread-Index: ActyOaE0pgMqEcSrTvqbS6bBSD89aQ==
Message-ID: <20101022222937.28161.50341.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: avexcashub1.qlogic.org
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
user-agent: StGIT/0.14.3
list-id: <linux-rdma.vger.kernel.org>
x-bigfish: vps7(zzzz1202hzz8275bh8275dha509lz2dh74hadk61h)
x-fb-ss: 0,
x-spam-tcs-scl: 0:0
x-spamscore: 7
x-mailing-list: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
x-reverse-dns: vger.kernel.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Evolution-Source: 
 imap://QLOGIC%5crcampbell%5cralph.campbell-1Ir95CONgH1JT58TF3CVyuPtBvJflD2D@public.gmane.org/
Content-Transfer-Encoding: 7bit

If CONFIG_PCI_MSI is not set, and a QLE7140 is present, the
pointer "dd" was uninitialized.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index f1d16d3..f3b5039 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1243,6 +1243,7 @@ static int __devinit qib_init_one(struct pci_dev *pdev,
 		qib_early_err(&pdev->dev, "QLogic PCIE device 0x%x cannot "
 		      "work if CONFIG_PCI_MSI is not enabled\n",
 		      ent->device);
+		dd = ERR_PTR(-ENODEV);
 #endif
 		break;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-ZzYhRbHPrJx1v3pSd7tu
Content-Disposition: inline
Content-Description: Attached message - [PATCH 2/2] IB/qib: Allow driver to
 load if PCIe advanced error reporting fails
Content-Type: message/rfc822

Received: from mail33-db3-R.bigfish.com (213.199.154.136) by
 avexcashub2.qlogic.org (10.1.4.162) with Microsoft SMTP Server (TLS) id
 8.1.436.0; Fri, 22 Oct 2010 15:36:37 -0700
Received: from mail33-db3 (localhost.localdomain [127.0.0.1])	by
 mail33-db3-R.bigfish.com (Postfix) with ESMTP id 3AF21DC871C;	Fri, 22 Oct
 2010 22:36:36 +0000 (UTC)
Received: from mail33-db3 (localhost.localdomain [127.0.0.1]) by mail33-db3
 (MessageSwitch) id 1287786995880538_18624; Fri, 22 Oct 2010 22:36:35 +0000
 (UTC)
Received: from DB3EHSMHS005.bigfish.com (unknown [10.3.81.250])	by
 mail33-db3.bigfish.com (Postfix) with ESMTP id D48DE33004E;	Fri, 22 Oct
 2010 22:36:35 +0000 (UTC)
Received: from vger.kernel.org (209.132.180.67) by DB3EHSMHS005.bigfish.com
 (10.3.87.105) with Microsoft SMTP Server id 14.0.482.44; Fri, 22 Oct 2010
 22:36:34 +0000
Received: (majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org) by vger.kernel.org via listexpand	id
 S1751209Ab0JVWgb (ORCPT <rfc822;ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>	+ 3 others);
 Fri, 22 Oct 2010 18:36:31 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:47774 "HELO
 mx.mv.qlogic.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
 id S1750837Ab0JVWgb (ORCPT <rfc822;linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>);	Fri, 22
 Oct 2010 18:36:31 -0400
Received: from chromite.mv.qlogic.com (chromite.mv.qlogic.com [10.29.2.82])
 by mx.mv.qlogic.com (Postfix) with ESMTP id 01E5F143007D;	Fri, 22 Oct 2010
 15:29:55 -0700 (PDT)
Received: from chromite.mv.qlogic.com (localhost.localdomain [127.0.0.1])
 by chromite.mv.qlogic.com (Postfix) with ESMTP id EED8714294D;	Fri, 22 Oct
 2010 15:29:54 -0700 (PDT)
From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
 <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Fri, 22 Oct 2010 15:29:54 -0700
Subject: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced error
 reporting fails
Thread-Topic: [PATCH 2/2] IB/qib: Allow driver to load if PCIe advanced
 error	reporting fails
Thread-Index: ActyOZakiVW794teT4azIyUX1AOOnw==
Message-ID: <20101022222951.28161.23347.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
References: <20101022222937.28161.50341.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
In-Reply-To: <20101022222937.28161.50341.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: avexcashub2.qlogic.org
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
user-agent: StGIT/0.14.3
list-id: <linux-rdma.vger.kernel.org>
x-bigfish: vps7(zzzz1202hzz8275bh8275dha509lz2dh74hadk61h)
x-spam-tcs-scl: 0:0
x-spamscore: 7
x-greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri,
 22 Oct 2010 18:36:31 EDT
x-mailing-list: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
x-reverse-dns: vger.kernel.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Evolution-Source: 
 imap://QLOGIC%5crcampbell%5cralph.campbell-1Ir95CONgH1JT58TF3CVyuPtBvJflD2D@public.gmane.org/
Content-Transfer-Encoding: 7bit

Some PCIe root complex chip sets don't support advanced error reporting.
Allow the driver to load OK if pci_enable_pcie_error_reporting() fails.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_pcie.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 7fa6e55..8a64426 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -109,10 +109,12 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	ret = pci_enable_pcie_error_reporting(pdev);
-	if (ret)
+	if (ret) {
 		qib_early_err(&pdev->dev,
 			      "Unable to enable pcie error reporting: %d\n",
 			      ret);
+		ret = 0;
+	}
 	goto done;
 
 bail:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-ZzYhRbHPrJx1v3pSd7tu
Content-Disposition: inline
Content-Description: Attached message - [PATCH] IB/qib: clean up properly
 if pci_set_consistent_dma_mask() fails
Content-Type: message/rfc822

Received: from mail144-tx2-R.bigfish.com (65.55.88.113) by
 avexcashub1.qlogic.org (10.1.4.161) with Microsoft SMTP Server (TLS) id
 8.1.436.0; Fri, 22 Oct 2010 17:09:50 -0700
Received: from mail144-tx2 (localhost.localdomain [127.0.0.1])	by
 mail144-tx2-R.bigfish.com (Postfix) with ESMTP id A36E7600711;	Sat, 23 Oct
 2010 00:09:50 +0000 (UTC)
Received: from mail144-tx2 (localhost.localdomain [127.0.0.1]) by
 mail144-tx2 (MessageSwitch) id 1287792587934781_3798; Sat, 23 Oct 2010
 00:09:47 +0000 (UTC)
Received: from TX2EHSMHS020.bigfish.com (unknown [10.9.14.250])	by
 mail144-tx2.bigfish.com (Postfix) with ESMTP id E065818C8056;	Sat, 23 Oct
 2010 00:09:47 +0000 (UTC)
Received: from vger.kernel.org (209.132.180.67) by TX2EHSMHS020.bigfish.com
 (10.9.99.120) with Microsoft SMTP Server id 14.0.482.44; Sat, 23 Oct 2010
 00:09:47 +0000
Received: (majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org) by vger.kernel.org via listexpand	id
 S1754890Ab0JWAJi (ORCPT <rfc822;ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>	+ 3 others);
 Fri, 22 Oct 2010 20:09:38 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:44849 "HELO
 mx.mv.qlogic.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
 id S1752037Ab0JWAJi (ORCPT <rfc822;linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>);	Fri, 22
 Oct 2010 20:09:38 -0400
Received: from chromite.mv.qlogic.com (chromite.mv.qlogic.com [10.29.2.82])
 by mx.mv.qlogic.com (Postfix) with ESMTP id F01E9143006C;	Fri, 22 Oct 2010
 17:09:30 -0700 (PDT)
Received: from chromite.mv.qlogic.com (localhost.localdomain [127.0.0.1])
 by chromite.mv.qlogic.com (Postfix) with ESMTP id BCF6414294D;	Fri, 22 Oct
 2010 17:09:30 -0700 (PDT)
From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
 <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Fri, 22 Oct 2010 17:09:30 -0700
Subject: [PATCH] IB/qib: clean up properly if pci_set_consistent_dma_mask()
 fails
Thread-Topic: [PATCH] IB/qib: clean up properly if
 pci_set_consistent_dma_mask()	fails
Thread-Index: ActyRpx6jccK1xoGSQmt4p7Bv6P5Rg==
Message-ID: <20101023000925.30641.2559.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: avexcashub1.qlogic.org
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
user-agent: StGIT/0.14.3
list-id: <linux-rdma.vger.kernel.org>
x-bigfish: vps17(z875rzzz1202hzz8275bh8275dha509lz2dh74hadk61h)
x-spam-tcs-scl: 0:0
x-spamscore: 17
x-mailing-list: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
x-reverse-dns: vger.kernel.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Evolution-Source: 
 imap://QLOGIC%5crcampbell%5cralph.campbell-1Ir95CONgH1JT58TF3CVyuPtBvJflD2D@public.gmane.org/
Content-Transfer-Encoding: 7bit

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Clean up properly if pci_set_consistent_dma_mask() fails.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_pcie.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 8a64426..48b6674 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -103,9 +103,11 @@ int qib_pcie_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	} else
 		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (ret)
+	if (ret) {
 		qib_early_err(&pdev->dev,
 			      "Unable to set DMA consistent mask: %d\n", ret);
+		goto bail;
+	}
 
 	pci_set_master(pdev);
 	ret = pci_enable_pcie_error_reporting(pdev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-ZzYhRbHPrJx1v3pSd7tu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

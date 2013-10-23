From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Wed, 23 Oct 2013 11:36:45 -0400
Message-ID: <20131023153645.GA28011@phenom.dumpdata.com>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com>
 <20131021140607.GQ20913@ics.muni.cz>
 <20131021141855.GA4211@phenom.dumpdata.com>
 <5265560602000078000FC73E@nat28.tlf.novell.com>
 <20131021144407.GC4560@phenom.dumpdata.com>
 <5265609802000078000FC7B7@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5265609802000078000FC7B7-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 21, 2013 at 04:12:56PM +0100, Jan Beulich wrote:
> >>> On 21.10.13 at 16:44, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On Mon, Oct 21, 2013 at 03:27:50PM +0100, Jan Beulich wrote:
> >> >>> On 21.10.13 at 16:18, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >> > On Mon, Oct 21, 2013 at 04:06:07PM +0200, Lukas Hejtmanek wrote:
> >> >>         Region 2: Memory at 380fff000000 (64-bit, prefetchable) [size=8M]
> >> >...
> >> > --- a/arch/x86/xen/setup.c
> >> > +++ b/arch/x86/xen/setup.c
> >> > @@ -92,6 +92,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
> >> >  
> >> >                 __set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
> >> >         }
> >> > +       /* Anything past the balloon area is marked as identity. */
> >> > +       for (pfn = xen_max_p2m_pfn; pfn < MAX_DOMAIN_PAGES; pfn++)
> >> > +               __set_phys_to_machine(pfn, IDENTITY_FRAME(pfn));
> >> 
> >> Hardly - MAX_DOMAIN_PAGES derives from
> >> CONFIG_XEN_MAX_DOMAIN_MEMORY, which in turn is unrelated
> >> to where MMIO might be. Should you perhaps simply start from
> > 
> > Looks like your mailer ate some words.
> 
> I don't think so - they're all there in the text you quoted.
> 
> >> an all 1:1 mapping, inserting the RAM translations as you find
> >> them?
> > 
> > 
> > Yeah, as this code can be called for the regions under 4GB. Definitly
> > needs more analysis.
> > 
> > Were you suggesting a lookup when we scan the PCI devices? (xen_add_device)?
> 
> That was for PVH, and is obviously fragile, as there can be MMIO
> regions not matched by any PCI device's BAR. We could hope for
> all of them to be below 4Gb, but I think (based on logs I got to see
> recently from a certain vendor's upcoming systems) this isn't going
> to work out.

This is the patch I had in mind that I think will fix these issues. But
I would appreciate testing it and naturally send me the dmesg if possible.


diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b232908..258e3f9 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -133,6 +133,25 @@ static void balloon_append(struct page *page)
 	adjust_managed_page_count(page, -1);
 }
 
+/*
+ * Check if any the balloon pages overlap with the supplied
+ * pfn and its range.
+ */
+bool balloon_pfn(unsigned long pfn, unsigned long nr)
+{
+	struct page *page;
+
+	if (list_empty(&ballooned_pages))
+		return false;
+
+	list_for_each_entry(page, &ballooned_pages, lru) {
+		unsigned long b_pfn = page_to_pfn(page);
+
+		if (b_pfn >= pfn && b_pfn < pfn + nr)
+			return true;
+	}
+	return false;
+}
 /* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
 static struct page *balloon_retrieve(bool prefer_highmem)
 {
diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index 18fff88..7e5ff49 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -17,11 +17,16 @@
  * Author: Weidong Han <weidong.han-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  */
 
+#define DEBUG 1
+
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <xen/xen.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/page.h>
+#include <xen/balloon.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -123,10 +128,78 @@ static int xen_add_device(struct device *dev)
 		r = HYPERVISOR_physdev_op(PHYSDEVOP_manage_pci_add,
 			&manage_pci);
 	}
-
 	return r;
 }
 
+static void xen_p2m_add_device(struct device *dev)
+{
+	int i;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	/* Verify whether the MMIO BARs are 1-1 in the P2M. */
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		unsigned long pfn, start, end, ok_pfns;
+		char bus_addr[64];
+		char *fmt;
+
+		if (!pci_resource_len(pci_dev, i))
+			continue;
+
+		if (pci_resource_flags(pci_dev, i) == IORESOURCE_IO)
+			fmt = " (bus address [%#06llx-%#06llx])";
+		else
+			fmt = " (bus address [%#010llx-%#010llx])";
+
+		snprintf(bus_addr, sizeof(bus_addr), fmt,
+			 (unsigned long long) (pci_resource_start(pci_dev, i)),
+			 (unsigned long long) (pci_resource_end(pci_dev, i)));
+
+		start = pci_resource_start(pci_dev, i) >> PAGE_SHIFT;
+		end = pci_resource_end(pci_dev, i) >> PAGE_SHIFT;
+
+		/*
+		 * We don't worry about the balloon scratch page as it has a
+		 * valid PFN - which means we will catch in the loop below.
+		 */
+		if (balloon_pfn(start, end - start)) {
+			dev_warn(dev, "%s is within balloon pages!\n", bus_addr);
+			continue;
+		}
+
+		for (ok_pfns = 0, pfn = start; pfn < end; pfn ++) {
+			unsigned long mfn = pfn_to_mfn(pfn);
+
+			if (mfn == pfn) {
+				ok_pfns ++;
+				continue;
+			}
+			if (mfn != INVALID_P2M_ENTRY) { /* RAM */
+				dev_warn(dev, "%s is within RAM [%lx] region!\n", bus_addr, pfn);
+				break;
+			}
+		}
+		dev_dbg(dev, "%s pfn:%lx, s:%lx, e:%lx ok:%ld\n", bus_addr, pfn, start, end, ok_pfns);
+		if (pfn != end - 1) /* We broke out of the loop above. */
+			continue;
+
+		if (ok_pfns == end - start) /* All good. */
+			continue;
+
+		dev_dbg(dev, "%s [%lx->%lx]\n", bus_addr, start, end);
+
+		/* This BAR was not detected during E820 parsing. */
+		for (pfn = start; pfn < end; pfn ++) {
+			if (!set_phys_to_machine(pfn, pfn))
+				break;
+		}
+		WARN(pfn != end - 1, "Only set %ld instead of %ld PFNs!\n",
+		     end - pfn, end - start);
+
+		dev_info(dev, "%s set %ld page(s) to 1-1 mapping.\n",
+			 bus_addr, end - pfn);
+	}
+}
+
 static int xen_remove_device(struct device *dev)
 {
 	int r;
@@ -164,10 +237,14 @@ static int xen_pci_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
-		r = xen_add_device(dev);
+		if (xen_initial_domain())
+			r = xen_add_device(dev);
+		if (r == 0)
+			xen_p2m_add_device(dev);
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
-		r = xen_remove_device(dev);
+		if (xen_initial_domain())
+			r = xen_remove_device(dev);
 		break;
 	default:
 		return NOTIFY_DONE;
@@ -185,9 +262,8 @@ static struct notifier_block device_nb = {
 
 static int __init register_xen_pci_notifier(void)
 {
-	if (!xen_initial_domain())
+	if (!xen_domain())
 		return 0;
-
 	return bus_register_notifier(&pci_bus_type, &device_nb);
 }
 
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index a4c1c6a..60ecc50 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -41,3 +41,4 @@ static inline int register_xen_selfballooning(struct device *dev)
 	return -ENOSYS;
 }
 #endif
+bool balloon_pfn(unsigned long pfn, unsigned long nr);
> 
> Jan
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

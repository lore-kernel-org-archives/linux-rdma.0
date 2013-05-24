From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Patch: Support for Xeon Phi
Date: Fri, 24 May 2013 20:16:22 +0200
Message-ID: <519FAE76.6060804@acm.org>
References: <20130524170253.GC2591@pyxis.br.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130524170253.GC2591-3v4vfGR2gegKq2+8A78TPA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryce Lelbach <blelbach-eiRV2mVQLkiVc3sceRu5cw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/24/13 19:02, Bryce Lelbach wrote:
> The attached patch modifies the kernel Infiniband drivers to support the Xeon Phi
> co-processor.
> 
> This patch is a modified version of a patch from Intel's MPSS framework
> (specifically, from the "KNC_gold_update_1-2.1.4982-15-rhel-6.3" package), which
> will apply to a 3.7.8 kernel (I am about to try it on a 3.8 kernel). To the best
> of my knowledge, newer RHEL kernels are shipped with this patch.

Please have a look at https://www.kernel.org/doc/Documentation/SubmittingPatches and please fix at least the whitespace errors in your patch. This is what checkpatch reports for your patch:

WARNING: line over 80 characters
#8: FILE: drivers/infiniband/core/sysfs.c:613:
+	case RDMA_NODE_MIC:	  return sprintf(buf, "%d: MIC\n", dev->node_type);

WARNING: line over 80 characters
#103: FILE: drivers/infiniband/core/uverbs_cmd.c:57:
+static int uverbs_copy_from_udata(void *dest, struct ib_udata *udata, size_t len)

WARNING: Avoid CamelCase: <mthca_MAP_ICM_page>
#202: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:503:
+	ret = mthca_MAP_ICM_page(dev, sg_dma_address(&chunk->page_list[0]),

WARNING: suspect code indent for conditional statements (8, 7)
#213: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:523:
 	if (ret) {
[...]
+       ib_umem_release(db_tab->page[i].umem);

WARNING: please, no spaces at the start of a line
#215: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:525:
+       ib_umem_release(db_tab->page[i].umem);$

WARNING: Avoid CamelCase: <mthca_UNMAP_ICM>
#238: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:555:
+		mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);

ERROR: code indent should use tabs where possible
#272: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:611:
+           ib_umem_release(db_tab->page[i].umem);$

WARNING: please, no spaces at the start of a line
#272: FILE: drivers/infiniband/hw/mthca/mthca_memfree.c:611:
+           ib_umem_release(db_tab->page[i].umem);$

WARNING: line over 80 characters
#322: FILE: include/rdma/ib_verbs.h:893:
+	struct ib_umem_ops     *umem_ops;	/* set to NULL for default ops */

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 8 warnings, 326 lines checked

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/10] providers: Use the new match_device and
 allocate_device ops
Date: Sun, 24 Sep 2017 14:10:53 -0600
Message-ID: <20170924201053.GA31652@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <BN3PR07MB257813BD7D36694EBF97BA91F8650@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB257813BD7D36694EBF97BA91F8650-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER (for hf1.ko)" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER (for ib_qib.ko)" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq5hl2p70BpVqQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 24, 2017 at 01:44:58PM +0000, Amrani, Ram wrote:
> Please use qelr_ prefix for the functions.
> There shouldn't be any qedr in this file except for a comment, maybe.

I changed the series like so:

diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 1297e8e16acee5..fa2be455edc93e 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -223,7 +223,7 @@ static void qelr_free_context(struct ibv_context *ibctx)
        free(ctx);
 }
 
-static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
+static struct verbs_device *qelr_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
        struct qelr_device *dev;
 
@@ -235,11 +235,11 @@ static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 }
 
 static const struct verbs_device_ops qelr_dev_ops = {
-       .name = "qelr",
+       .name = "qedr",
        .match_min_abi_version = QELR_ABI_VERSION,
        .match_max_abi_version = QELR_ABI_VERSION,
        .match_table = hca_table,
-       .alloc_device = qedr_device_alloc,
+       .alloc_device = qelr_device_alloc,
        .uninit_device = qelr_uninit_device,
        .alloc_context = qelr_alloc_context,
        .free_context = qelr_free_context,

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

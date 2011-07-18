From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] libmthca 1.0.5 and libmlx4 1.0.2 are released
Date: Mon, 18 Jul 2011 11:12:30 -0600
Message-ID: <20110718171230.GA26012@obsidianresearch.com>
References: <1309981353-14301-1-git-send-email-roland@kernel.org>
 <CD250C48050CFB4D95E78C95F2FDDD6E071C09B6@mtldag02.mtl.com>
 <CAG4TOxN7iWn7JN7Yg_FMO1qdKFhhPXaujC-Chc=DfCyFMpxO5A@mail.gmail.com>
 <CD250C48050CFB4D95E78C95F2FDDD6E071C9C38@mtldag02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E071C9C38-orl5n1AObOGuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 18, 2011 at 08:42:25AM +0000, Tziporet Koren wrote:

> CX3 is using libmlx4 and not libmthca.
> Vlad sent a patch on 1/19/11:
> http://www.spinics.net/lists/linux-rdma/msg07237.html

> Is contain adding several device IDs including CX3

Why is that test even in libmlx4?

Maybe this is a better choice:

diff --git a/src/mlx4.c b/src/mlx4.c
index 1295c53..bc8ee72 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -53,21 +53,6 @@
 #define PCI_VENDOR_ID_MELLANOX			0x15b3
 #endif
 
-#define HCA(v, d) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = d }
-
-struct {
-	unsigned		vendor;
-	unsigned		device;
-} hca_table[] = {
-	HCA(MELLANOX, 0x6340),	/* MT25408 "Hermon" SDR */
-	HCA(MELLANOX, 0x634a),	/* MT25408 "Hermon" DDR */
-	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
-	HCA(MELLANOX, 0x6732),	/* MT25408 "Hermon" DDR PCIe gen2 */
-	HCA(MELLANOX, 0x673c),	/* MT25408 "Hermon" QDR PCIe gen2 */
-};
-
 static struct ibv_context_ops mlx4_ctx_ops = {
 	.query_device  = mlx4_query_device,
 	.query_port    = mlx4_query_port,
@@ -183,27 +168,7 @@ static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
 {
 	char			value[8];
 	struct mlx4_device    *dev;
-	unsigned		vendor, device;
-	int			i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return NULL;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return NULL;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			goto found;
-
-	return NULL;
 
-found:
 	if (abi_version < MLX4_UVERBS_MIN_ABI_VERSION ||
 	    abi_version > MLX4_UVERBS_MAX_ABI_VERSION) {
 		fprintf(stderr, PFX "Fatal: ABI version %d of %s is not supported "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

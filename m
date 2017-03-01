From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Wed, 1 Mar 2017 11:20:39 -0700
Message-ID: <20170301182039.GC14791@obsidianresearch.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488376954-8346-1-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 04:02:08PM +0200, Erez Shitrit wrote:
>     /* default accelerating functions, same as before */
>     struct ib_ipoib_accel_ops default_ipoib_accel_ops = {
>             .ib_dev_init = ipoib_dev_init_default,
>             .ib_dev_cleanup = ipoib_dev_uninit_default,
>             .ib_dev_open = ipoib_ib_dev_open_default,
>             .ib_dev_stop = ipoib_ib_dev_stop_default,
>             .send = ipoib_send,
>             .create_netdev = ipoib_create_netdev_default,
>             .attach_mcast = ipoib_mcast_attach,
>             .dettach_mcast = ipoib_mcast_dettach,
>     };

This is so ridiculously close to what opa_vnic is doing, please try to
work with them to figure out some common version of your
'create_netdev':

+struct ib_ipoib_accel_ops {
+
+       /*
+        * HW provider driver creates the net_device for IPoIB.
+        * hca: The current ib device.
+        * name: is the format of the new network device (probably ib%d)
+        */
+       struct net_device * (*create_netdev)(struct ib_device *hca,
+                                            const char *name,
+                                            void (*setup)(struct net_device *));


vs:

@@ -2110,6 +2128,15 @@  struct ib_device {

+	struct net_device *(*alloc_rdma_netdev)(
+					struct ib_device *device,
+					u8 port_num,
+					enum rdma_netdev_t type,
+					const char *name,
+					unsigned char name_assign_type,
+					void (*setup)(struct net_device *));


I've pointed out again and again you two are working on the same
thing.

It is inexplicable to me you couldn't use this opa_vnic patch as a
starting point for the ipoib api:

https://patchwork.kernel.org/patch/9587819/

I would propose you add a RDMA_NETDEV_IPOIB to their stuff and a
rdma_netdev_get_ipoib_ops(struct net_device *) to get your
rdma_netdev_ipoib_ops.

I also wonder why there are so many ops, for instance the approach of
having the driver set .ndo_stop and others seems better.

ipoib could either 'wrapper' that pointer after calling
alloc_rdma_netdev or it could export enough utility functions for the
driver to implement the needed behavior. (eg this may be more in line
with the "midlayer mistake" thinking of
https://lwn.net/Articles/336262/)

Maybe Niranjana has some suggestions based on learning in vnic, they
tried a few different schemes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

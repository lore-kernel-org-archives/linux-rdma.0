From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC kernel+rdma-core 0/6] Custom/propriatery QP type support
Date: Sun, 26 Nov 2017 19:45:11 +0200
Message-ID: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This RFC is a follow-up for the previous "Vendor-specific QPs" RFC 
( https://www.spinics.net/lists/linux-rdma/msg56322.html ). Below is the
originla RFC text (the patch was not formatted correctly, so I'm resending).
Also, I'd like to provide some insight into the decision to propose a single
QP creation API rather than per-QP-type calls.

The alternative to the proposed mlx5dv_create_qp() is to have different calls
for each QP type, such as mlx5dv_create_dct() and mlx5dv_create_dci() in this case.
In both cases the function would retunr strcut *ibv_qp - usable with any other
QP-related call. We consider the former to be closer to Verbs style, while the
latter will require a new function for each new QP type and may lead to some
boiler-plate code - typically such functions will just pass these arguments to
the provider via the kernel (as a "custom QP").

Another (minor) issue would be dynamic loading, if the app is build with a newer
version and some mlx5dv_create_recent_qp() - which is not present in the local
version of the library (though this problem has some solutions). 


Original RFC Text
-----------------
The purpose of this RFC is to show method by which a vendor can add a software
interface support for a QP type that is not described in the InfiniBand spec.
Generally speaking, a QP is an software object used by abstract software interface
to send and receive data to and from the hardware. The InfiniBand spec describes
several types of QPs, different from each other by the service that they provide.
Vendors that implement network services that are not described in the InfiniBand
spec may want to use the verbs interface to create, modify, query and destroy a QP
to maintain a software object that keeps the context of the hardware QP. However,
we don't want to taint the IB/core layer with code that is vendor specific and
leave all vendor logic to be done in the vendor driver. To do this we suggest a new
QP type - IB_QPT_VENDOR which is almost all the addition to IB/core. The following
describes the flow to create a vendor QP but it can be easily applied to modify query
and destroy operations.

A vendor that implements a new QP type will provide an interface to send a command to
the kernel to create a QP of this type. Of course that this is probably not enough
data to create the QP so the vendor will also provide in that interface a way to pass
extra data that is required to create the QP. This extra data will be passed through the
vendor channel which is not described here. The IB/core layer in the kernel may process
the command with respect to the new QP type but without assuming anything that is not
general to all vendor QPs. For example the IB/core layer may not validate the that the
receive CQ is different from the send CQ for vendor QP but it may assume that that zero
length send queue means that send CQ is not present.

This message will be followed by patches that implement the above and use the mlx5 driver
as an example vendor.

The following patches to kernel show the changes in code that are required to 
- IB/core: Introduce vendor QP type
- IB/mlx5: Example use of vendor QP

The following patches to userspace show the changes in code
- verbs: Intorduce QP type IBV_QPT_VENDOR
- mlx5: Introduce mlx5dv_create_qp()


and an application that want to create a vendor QP (in this case the send part of the DC
transport service)  will look like this

{
                struct ibv_context      *context;
                struct ibv_pd           *pd;
                struct ibv_cq           *cq;
                struct ibv_qp           *qp;
                int                     qp_depth = 128;
                struct ibv_qp_attr      attr;
                struct ibv_qp_init_attr_ex      init_attr;
                struct mlx5dv_qp_init_attr      dv_init_attr;

                context = ibv_open_device(ib_dev);
                if (!context) {
                        fprintf(stderr, "Couldn't get context for %s\n",
                                        ibv_get_device_name(ib_dev));
                        return -1;
                }
                pd = ibv_alloc_pd(context);
                if (!pd) {
                        fprintf(stderr, "Couldn't allocate PD\n");
                        return -1;
                }
                cq = ibv_create_cq(context, qp_depth + 1, NULL, NULL, 0);
                if (cq) {
                        fprintf(stderr, "Couldn't create CQ\n");
                        return -1;
                }

                init_attr.send_cq = cq;
                init_attr.recv_cq = cq;
                init_attr.cap.max_send_wr  = 100;
                init_attr.cap.max_send_sge  = 1;
                init_attr.qp_type = IBV_QPT_VENDOR;
                init_attr.pd = pd;

                dv_init_attr.vendor_qp_type = MLX5_VENDOR_QPT_DCI;

                qp = mlx5dv_create_qp(context, &init_attr, &dv_init_attr);
                if (qp) {
                        fprintf(stderr, "Couldn't create QP\n");
                        return -1;
                }

                fprintf(stdout, "Success: Create DC send QP\n");
        }


-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

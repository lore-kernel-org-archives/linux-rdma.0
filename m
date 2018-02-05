From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 13:06:48 -0600
Message-ID: <020d01d39eb4$78ef7fe0$6ace7fa0$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <20180201084944.GH2055@mtr-leonro.local> <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com> <20180204150553.GH27780@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > >
> > > There is no ib_device at this point, so caller (and owner) must be
saved
> > > until the cm_id is bound to a device (or possibly devices for
listening
> > > ids).
> >
> > Why do we need previous owner? Can it be that rdma_create_id was
> > performed by one process and cma_attach by another?
> 
> Yes.  Connection setup events are processed on rdma_cm (and ib_cm/iw_cm)
> workqueue threads.   Here's one example:  The application creates a cm_id,
> binds to 0.0.0.0/0 and listens.  But there are no rdma devices at this
point.  There
> is a cm_id owned by the application, but not bound to any device.  Then,
lets say
> mlx4 and cxgb4 both get inserted.  The rdma_cm will  discover the new rdma
> devices, create and attach child cm_ids to those devices.  This is done in
a workq
> thread driven off of the ib_client device_add upcall.  So what we really
want to
> show is that these per-device cm_ids are owned by the same application.
> 
> There are other cases, that I've seen with just nvme/f host.   I'll
produce more
> examples to help us understand if there is a better path than what I've
proposed
> in this patch.

Here are trace events for setting up an nvmef connection.   They trace
_rdma_create_id(), _cma_attach_to_dev(), and _rdma_accept().  This was
gathered with the following patch on top of cm_id my series (just so you
understand where I took these stack traces).  Beyond the patch at the end of
this email, I show the pr_debug() output at create_id() and attach_to_dev()
for the cm_ids created as part of the nvmf connection setup.  

>From this, I conclude 2 things:  

1) the KBUILD_MODNAME needs to come from the rdma_create_id() or
rdma_accept() calls since _cma_attach_to_dev can be done in the rdma_cm
workqueue context.

2) uaccess_kernel() is not an indicator of a kernel rdma application.  At
least in the context of cm_ids.  So I simply key on if the cm_id is created
by rdma_ucm module or not.  If the cm_id is created by rdma_ucm, the pid is
saved and the kern_name is null, Otherwise, the pid is 0 and the kern_name
is set to the module name of the caller of rdma_create_id() or rdma_accept()
static inlines using KBUILD_MODNAME.

Debug patch:

----
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ddd8174..5e17a27 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -479,6 +479,8 @@ static void _cma_attach_to_dev(struct rdma_id_private
*id_priv,
        list_add_tail(&id_priv->list, &cma_dev->id_list);
        id_priv->id.res.type = RDMA_RESTRACK_CM_ID;
        id_priv->id.res.kern_name = id_priv->id.caller;
+       pr_debug("caller/pid from create_id %s/%u current pid %u
uaccess_kernel() %u\n", id_priv->id.caller, id_priv->owner,
task_pid_nr(current), uaccess_kernel());
+       WARN_ON(1);
        rdma_restrack_add(&id_priv->id.res);
 }

@@ -763,6 +765,8 @@ struct rdma_cm_id *__rdma_create_id(struct net *net,
        if (!id_priv)
                return ERR_PTR(-ENOMEM);

+       pr_debug("caller/pid %s/%u uaccess_kernel() %u\n", caller,
task_pid_nr(current), uaccess_kernel());
+       WARN_ON(1);
        if (caller)
                id_priv->id.caller = caller;
        else
@@ -3762,6 +3766,9 @@ int __rdma_accept(struct rdma_cm_id *id, struct
rdma_conn_param *conn_param,

        id_priv = container_of(id, struct rdma_id_private, id);

+       pr_debug("caller/pid from create_id %s/%u current pid %u
uaccess_kernel() %u\n", id_priv->id.caller, id_priv->owner,
task_pid_nr(current), uaccess_kernel());
+       WARN_ON(1);
+
        if (caller)
                id_priv->id.caller = caller;
        else

------

Nvmf connection setup traces:

This is the nvmf target creating the cm_id and binding/listening:

create_id - notice uaccess_kernel() is 0, even though this is a kernel
application:

[42241.528534] __rdma_create_id: caller/pid nvmet_rdma/9591 uaccess_kernel()
0
...
[42241.717259]  nvmet_rdma_add_port+0x98/0x1c0 [nvmet_rdma]
[42241.723261]  nvmet_enable_port+0x36/0xd0 [nvmet]
[42241.733007]  nvmet_port_subsys_allow_link+0xfd/0x130 [nvmet]
...

attach_to_dev - same issue - uaccess_kernel() returns 0 for a kernel
application cm_id:

[42241.838916] _cma_attach_to_dev: caller/pid from create_id nvmet_rdma/0
current pid 9591 uaccess_kernel() 0
...
[42242.030931]  cma_attach_to_dev+0x12/0x40 [rdma_cm]
[42242.036485]  cma_acquire_dev+0x2d1/0x380 [rdma_cm]
[42242.042029]  rdma_bind_addr+0x783/0x830 [rdma_cm]
[42242.053275]  nvmet_rdma_add_port+0xc9/0x1c0 [nvmet_rdma]
[42242.059321]  nvmet_enable_port+0x36/0xd0 [nvmet]
[42242.069128]  nvmet_port_subsys_allow_link+0xfd/0x130 [nvmet]

Here is the nvmf host side creating and connecting:

create_id - again uaccess_kernel() indicates this is user, but the
application is kernel:

[42508.786910] __rdma_create_id: caller/pid nvme_rdma/9602 uaccess_kernel()
0
...
[42508.978059]  nvme_rdma_alloc_queue+0x8c/0x180 [nvme_rdma]
[42508.984182]  nvme_rdma_configure_admin_queue+0x1d/0x2a0 [nvme_rdma]
[42508.991178]  nvme_rdma_create_ctrl+0x36c/0x626 [nvme_rdma]
[42508.997397]  nvmf_create_ctrl.isra.6+0x72f/0x900 [nvme_fabrics]
[42509.008708]  nvmf_dev_write+0x87/0xec [nvme_fabrics]

attach_to_dev, as part of RESOLVE_ADDR/ROUTE.  Note uaccess_kernel() is 1
here, and it is called from ib_core, so the real module name would be lost
if it wasn't saved at create_id time.

[42509.123809] _cma_attach_to_dev: caller/pid from create_id nvme_rdma/0
current pid 3340 uaccess_kernel() 1
...
[42509.322662]  cma_attach_to_dev+0x12/0x40 [rdma_cm]
[42509.328198]  cma_acquire_dev+0x2d1/0x380 [rdma_cm]
[42509.333726]  addr_handler+0xca/0x1a0 [rdma_cm]
[42509.338910]  process_one_req+0x87/0x120 [ib_core]
[42509.344350]  process_one_work+0x141/0x340
[42509.349091]  worker_thread+0x47/0x3e0

Here is the target side getting the incoming connection request and
creating/attaching the child cm_id:

Create_id.  Note the uaccess_kernel() is 1 and the module is rdma_cm:

[42509.406886] __rdma_create_id: caller/pid nvmet_rdma/3340 uaccess_kernel()
1
...
[42509.606618]  iw_conn_req_handler+0x6e/0x1f0 [rdma_cm]
[42509.633472]  cm_work_handler+0xd6a/0xd80 [iw_cm]
[42509.638810]  process_one_work+0x141/0x340
[42509.643528]  worker_thread+0x47/0x3e0

Attach_to_dev - caller is again rdma_cm.

[42509.700727] _cma_attach_to_dev: caller/pid from create_id nvmet_rdma/0
current pid 3340 uaccess_kernel() 1
...
[42509.899997]  cma_attach_to_dev+0x12/0x40 [rdma_cm]
[42509.905527]  cma_acquire_dev+0x2d1/0x380 [rdma_cm]
[42509.911056]  iw_conn_req_handler+0xc1/0x1f0 [rdma_cm]
[42509.933385]  cm_work_handler+0xd6a/0xd80 [iw_cm]
[42509.938710]  process_one_work+0x141/0x340
[42509.943428]  worker_thread+0x47/0x3e0

And here the nvmf target accepts the connection:

[42510.000986] __rdma_accept: caller/pid from create_id nvmet_rdma/0 current
pid 3340 uaccess_kernel() 1
...
[42510.199502]  nvmet_rdma_queue_connect+0x6ac/0x990 [nvmet_rdma]
[42510.206071]  iw_conn_req_handler+0x16f/0x1f0 [rdma_cm]
[42510.211949]  cm_work_handler+0xd6a/0xd80 [iw_cm]
[42510.217297]  process_one_work+0x141/0x340
[42510.222036]  worker_thread+0x47/0x3e0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

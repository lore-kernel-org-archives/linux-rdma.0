From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Thu, 2 Mar 2017 13:06:19 -0700
Message-ID: <20170302200619.GA17530@obsidianresearch.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
 <20170301182039.GC14791@obsidianresearch.com>
 <CAAk-MO9tAHioaSXv8MPu=Kf3QSxjuQhAt6vYRVCzuNriXkm-+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO9tAHioaSXv8MPu=Kf3QSxjuQhAt6vYRVCzuNriXkm-+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 02, 2017 at 09:13:33PM +0200, Erez Shitrit wrote:

> but, we need to remember that IPoIB acceleration and VNIC are coming
> to solve different issues.

Seriously? Have you read the vnic patches and looked at what they are
doing with their create_netdev and related?

It is *exactly* the same problem - the lowlevel driver has
accelerations that apply to skbs that are slow/impossible to use over
verbs.

There is no 'magic' going on there, the vnic ulp plays exactly the
same role as ipoib in arbitrating the control plane side, while the
stuff under create_netdev is concerned entirely with accelerated rx/tx
of skbs

ipob is entirely the same, and needs to converge on the same generic
interface for shuffling skbs (which is netdev ndo) and generic
itnerface to provide any special functions like attach/detach

Most of your comments, and from others at Mellanox make me think you
have not really internallized what the vnic patches that add the
create_ndev api are all about.

> 2. we wanted to keep the IPoIB code as clean as we can, so we created
> a "default acceleration" that works the same way as it was before, the
> idea that leads that is to separate the HW specific from the
> control/management area, and that is done better/simpler with the set
> of functions that are exposed.

Yes, this is the right way to go.

> 3. We are using some functions that are not part of the ndo calls or
> are used differently for example:

What these patches do is not consistent with the rest of the stack.

Niranjana choose to add control functions directly to 'rdma_netdev', I
think that is a reasonable choice and you should do the same:

+struct rdma_netdev {
+	void *clnt_priv;
+
+	/* control functions */
+	void (*set_id)(struct net_device *netdev, int id);
+};

Add ipoib_attach_mcast/etc

Maybe propose to Niranjana that this should be a struct
rdma_netdev_ops pointer.

For everything else I would use ndo ops directly and do not involve
the rdma side.

> I think that we can change the create_netdev api to be like is in the
> VNIC code, but we would like to keep the rest of the functions in
> our

Of course you can, it is the same function!

Both patchsets need to adopt the same scheme for dealing with 'priv'
data in the netdev, and the same signature for the create_netdev()
driver op. The vnic approach is reasonable here and provides a
dedicated priv for the driver and a second priv for the management
layer.

You should start here:

https://patchwork.kernel.org/patch/9587819/

And propose any fundamental modifications to Niranjana.

For instance, ipoib should define a header like 'opib_vnic.h' that
specifies ipoib versions of opa_vnic_rdma_netdev, opa_vnic_priv,
opa_vnic_dev_priv, and so on.

> struct and suggest the VNIC driver will use it in order to get the
> pointer of the create_netdev, We think that struct of pointers to
> functions can be flexible to future needs with no need to consider the
> ndo existence.

I think that misses the point, there many ndo ops that are
relavent only to the low level driver (eg ndo_select_queue,
ndo_features_check, etc) and those should just be directly hooked by
the low level driver without involvement from the ipoib layer.

For instance instead of having ipoib ndo_start_xmit call a
ops->start(), it is more consistent with netdev for the driver to
provide ndo_start_xmit and call ipoib_get_ah() to get the path
information.

This broadly makes more sense because the driver might want to return
NETDEV_TX_BUSY right away and doesn't need to be forced to do a
mandatory AH lookup by the ipoib wrapper.

In general wrapping the ndo calls in ipoib is probably not a great
idea. (same comment applies to vnic)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

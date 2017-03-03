From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Thu, 2 Mar 2017 16:14:32 -0800
Message-ID: <20170303001431.GB66720@knc-06.sc.intel.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com>
 <20170301182039.GC14791@obsidianresearch.com>
 <CAAk-MO9tAHioaSXv8MPu=Kf3QSxjuQhAt6vYRVCzuNriXkm-+A@mail.gmail.com>
 <20170302200619.GA17530@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170302200619.GA17530-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I haven't gone through the patches in detail yet.
Jason already responded regarding using 'rdma netdev' for this use case.
I agree with it and adding couple points to that here.

On Thu, Mar 02, 2017 at 01:06:19PM -0700, Jason Gunthorpe wrote:
>On Thu, Mar 02, 2017 at 09:13:33PM +0200, Erez Shitrit wrote:
>
>> 3. We are using some functions that are not part of the ndo calls or
>> are used differently for example:
>
>What these patches do is not consistent with the rest of the stack.
>
>Niranjana choose to add control functions directly to 'rdma_netdev', I
>think that is a reasonable choice and you should do the same:
>
>+struct rdma_netdev {
>+	void *clnt_priv;
>+
>+	/* control functions */
>+	void (*set_id)(struct net_device *netdev, int id);
>+};
>
>Add ipoib_attach_mcast/etc
>
>Maybe propose to Niranjana that this should be a struct
>rdma_netdev_ops pointer.
>
>For everything else I would use ndo ops directly and do not involve
>the rdma side.
>

Many of the operations in ib_ipoib_accel_ops can use ndo calls or can be easily 
be adopted to use them.

>> I think that we can change the create_netdev api to be like is in the
>> VNIC code, but we would like to keep the rest of the functions in
>> our
>
>Of course you can, it is the same function!
>
>Both patchsets need to adopt the same scheme for dealing with 'priv'
>data in the netdev, and the same signature for the create_netdev()
>driver op. The vnic approach is reasonable here and provides a
>dedicated priv for the driver and a second priv for the management
>layer.
>
>You should start here:
>
>https://patchwork.kernel.org/patch/9587819/
>
>And propose any fundamental modifications to Niranjana.
>
>For instance, ipoib should define a header like 'opib_vnic.h' that
>specifies ipoib versions of opa_vnic_rdma_netdev, opa_vnic_priv,
>opa_vnic_dev_priv, and so on.
>
>> struct and suggest the VNIC driver will use it in order to get the
>> pointer of the create_netdev, We think that struct of pointers to
>> functions can be flexible to future needs with no need to consider the
>> ndo existence.
>
>I think that misses the point, there many ndo ops that are
>relavent only to the low level driver (eg ndo_select_queue,
>ndo_features_check, etc) and those should just be directly hooked by
>the low level driver without involvement from the ipoib layer.
>
>For instance instead of having ipoib ndo_start_xmit call a
>ops->start(), it is more consistent with netdev for the driver to
>provide ndo_start_xmit and call ipoib_get_ah() to get the path
>information.
>
>This broadly makes more sense because the driver might want to return
>NETDEV_TX_BUSY right away and doesn't need to be forced to do a
>mandatory AH lookup by the ipoib wrapper.
>
>In general wrapping the ndo calls in ipoib is probably not a great
>idea. (same comment applies to vnic)
>

Having OPA_VNIC call a function out of ib_ipoib_accel_ops is not right design 
at all.
'rdma netdev' is a generic netdev interface which can be used for multiple use 
cases.
Both OPA_VNIC and this should use 'rdma netdev' interface. OPA_VNIC is already 
doing it by defining RDMA_NETDEV_OPA_VNIC.
The control ops should be associated with the 'rdma netdev' and not the other 
way round.

You can put the control ops in the ipoib wrapper around 'rdma_netdev' (opa_vnic 
defines opa_vnic_rdma_netdev structure, ipoib can define a similar one) or 
directly under 'rdma_netdev' structure perhaps.
I am seeing in PATCH#26, mlx5 driver is accessing ipoib ULP's private data 
structure, which it shouldn't. VNIC using rdma netdev clearly distinguishes 
between client and device private data structures.

Niranjana

>Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

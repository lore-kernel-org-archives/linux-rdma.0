From: Bruce McKenzie <sales-uUyUjRhFbRmVZhT2dXthUg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Sat, 8 Jun 2013 02:31:00 +0000 (UTC)
Message-ID: <loom.20130608T041932-498@post.gmane.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org




Bart Van Assche <bvanassche@...> writes:

> 
> On 11/20/12 05:04, Vasiliy Tolstov wrote:
> > Thanks for this backport! I have some problem under sles 11 sp2 (kernel
3.0.42-
> > 0.7-xen) then i shutdown srp target (reboot one sas server) multipath
-ll does
> > not respond. If i provide in multipath and srp identical dev_loss_tmo and
> > fast_io_fail_tmo nothing changed. multipath -ll unblocks only then the
server
> > goes up.
> 
> That's strange. After the fast_io_fail_tmo timer has fired multipath -ll 
> should unblock independent of the state of the SRP target.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Hi Bart.

any advice on using this fix with MD raid 1? a guide or site you know of?

ive compiled ubuntu 13.04 to kernel 3.6.11 with OFED 2 from Mellanox, and it
works ok, performance is a little better with SRP.  Some packages dont seem
to work, ie srptools and IB-diags some commands fail, which looks like those
tools havenet been tested with 3.6.11?  or updated.

Ive tried using DRBD with pacemaker Stonith etc (which also works on 3.6.11)
but it only works with iSCSI over IPOIB.  ie virtual nic with mounted LVM
using scst to present file i/o.  and pacemaker to fail over the VIP to node
2.  But OFED 2 doesnt seem to support SDP to have to rep via IPOIB which is
slow even over dedicated IB_IPOIB nic.  IE DRBD rep is 200MB/s

Any help or direction would be greatfull.
Cheers
Bruce McKenzie



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

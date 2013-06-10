From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: How to do replication right with SRP or remote storage?
Date: Mon, 10 Jun 2013 14:05:28 +0200
Message-ID: <51B5C108.1030803@profitbricks.com>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <loom.20130608T041932-498@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130608T041932-498-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bruce McKenzie <sales-uUyUjRhFbRmVZhT2dXthUg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08.06.2013 04:31, Bruce McKenzie wrote:
> Hi Bart.
> 
> any advice on using this fix with MD raid 1? a guide or site you know of?
> 
> ive compiled ubuntu 13.04 to kernel 3.6.11 with OFED 2 from Mellanox, and it
> works ok, performance is a little better with SRP.  Some packages dont seem
> to work, ie srptools and IB-diags some commands fail, which looks like those
> tools havenet been tested with 3.6.11?  or updated.
> 
> Ive tried using DRBD with pacemaker Stonith etc (which also works on 3.6.11)
> but it only works with iSCSI over IPOIB.  ie virtual nic with mounted LVM
> using scst to present file i/o.  and pacemaker to fail over the VIP to node
> 2.  But OFED 2 doesnt seem to support SDP to have to rep via IPOIB which is
> slow even over dedicated IB_IPOIB nic.  IE DRBD rep is 200MB/s
> 
> Any help or direction would be greatfull.
> Cheers
> Bruce McKenzie
> 

(changed subject into something I think is more appropriate)

Hi Bruce,

thanks for contacting me privately in parallel. I can answer you the
replication questions. In order to share experience for others I reply
here again.

Please evaluate the ib_srp fixes from Bart and from me as well and send
us your feedback!

We are still negotiating how to do fast IO failing and the automatic
reconnect right, also together with the Mellanox SRP guys Sagi Grimberg,
Vu Pham, Oren Duer and others.

You need these patches in order to fail IO in the time you want to the
upper layers so that dm-multipath can fail over the path first and
ib_srp continuously tries to reconnect the failed path. If the other
path also fails, then very likely the storage server is down, so you
fail the IO further up to MD RAID-1 so that it can fail that replica.

For replication the last slide of my talk on LinuxTag this year could be
interesting for you:

http://www.slideshare.net/SebastianRiemer/infini-band-rdmaforstoragesrpvsiser-21791250

That slide caused a lot of discussion afterwards. The thing is that
replication of remote storage is best on the initiator (a single kernel
manages all replica, parallel network paths, symmetric latency,...).

The bad news is that replication of virtual/remote storage with MD
RAID-1 is a use case which basically works but has some issues which
Neil Brown doesn't want to have fixed in mainline. So you need a kernel
developer for some cool features like e.g. safe VM live migration.

Perhaps, I should collect all guys who require MD RAID-1 for remote
storage replication in order to put some pressure on Neil. At least some
things of this use case are easy to merge with mainline behavior like
e.g. letting MD assembly scale right (mdadm searches the whole /dev
without a need). I was surprised that he will make the data offset
settable again so that you can set it to 4 MiB (1 LV extent). We already
have that by custom patches on top of mdadm 3.2.6.

DRBD is already with iSCSI crap. 200 MB/s with IB sounds familiar. I had
250 MB/s in primary/secondary setup with DRBD during evaluation. That's
store&forward writes to the secondary which is slooooow. Chained network
paths! With Ethernet that hurts even more. People report 70 MB/s with
that. I've taught them how to use blktrace and it became obvious that
they were trapped in latency.

I can also recommend you Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>. He also
uses SRP with MD RAID-1. He could convince Neil to fix the MD data
offet. OpenSource is all about the right allies,....

Cheers,
Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

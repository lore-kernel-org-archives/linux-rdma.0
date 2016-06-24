From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Interrupted IO causing async errors
Date: Thu, 23 Jun 2016 20:15:29 -0400
Message-ID: <BDD2D64C-7A05-42EB-83C2-F95825C7579D@oracle.com>
References: <00e101d1cd65$e19bf360$a4d3da20$@opengridcomputing.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00e101d1cd65$e19bf360$a4d3da20$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve-

> On Jun 23, 2016, at 11:42 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
> Hey chuck, we observe with 4.7-rc4 (and older kernels too) that interrupting a
> dbench test on a nfsrdma/cxgb4 mount while it is doing heavy I/O can result in
> cxgb4 logging an "invalid stag" error on an ingress RDMA WRITE message.   Is
> this expected?  I'm wondering if this is a normal side effect of interrupting
> the IO on the mount.  Maybe due to the mount options or NFS version?    This
> error could happen if the NFSRDMA client invalidated MRs that were advertised to
> the server for IO, while IO was still in flight.  Is this expected or should we
> dive in further?  Thoughts?  thanks...

When an application is signaled, outstanding RPCs are terminated.
When an RPC completes, whether because a reply was received,
or because the local application has died, any memory that was
registered on behalf of that RPC is invalidated before it can be
used for something else. The data in that memory remains at rest
until invalidation and DMA unmapping is complete.

It appears that your server is attempting to read an argument or
write a result for an RPC that is no longer pending. I think both
sides should report a transport error, and the connection should
terminate. No other problems, though: other operation should
continue normally after the client re-establishes a fresh connection.

If this doesn't match your observations, let me know.

> Here are the details of the test.
> 
> Steps:
> 
> -> Load iw_cxgb4,rdma_ucm on both nodes.
> -> Assign ip to chelsio interfaces on both nodes.
> 
> Server Side [gayabari]:
> 
> -> mknod /dev/ram0 b 1 0
> -> modprobe brd rd_nr=1 rd_size=1048576
> -> mkdir /nfsrdma 
> -> mkfs.ext3 /dev/ram0
> -> mount /dev/ram0 /nfsrdma
> -> vim /etc/exports
>   /nfsrdma  *(sync,insecure,rw,no_root_squash,no_subtree_check)
> 
> -> modprobe xprtrdma 
> -> modprobe svcrdma
> -> service nfsserver restart 
> -> echo rdma 20049 > /proc/fs/nfsd/portlist
> -> exportfs -rav
> 
> Client Side [sonada]:
> 
> -> modprobe xprtrdma 
> -> modprobe svcrdma
> 
> -> mount 102.1.1.186:/nfsrdma/ -o
> rdma,port=20049,vers=3,wsize=65536,rsize=65536
> /mnt/ 
> 
> -> Then run below command on client [sonada] : 
> sonada:~ # dbench -t100 -D /root/share1/  10
> 
> 
> -> Issue is seen only on killing dbench test in between otherwise it ran fine.
> 
> Error seen on the nfsdma client:
> 
> [ 1593.398351] cxgb4 0000:01:00.4: AE qpid 1028 opcode 0 status 0x1 type 0 len
> 0x18e6009c wrid.hi 0x2cce2dc wrid.lo 0x2
> [ 1593.398374] RPC:       rpcrdma_qp_async_error_upcall: QP request error on
> device cxgb4_0 ep ffff88022f3567e8
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

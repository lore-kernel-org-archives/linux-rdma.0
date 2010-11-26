From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations (was:  uverbs:
 handle large number of entries)
Date: Fri, 26 Nov 2010 11:56:17 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
References: <20101007161649.GD21206@obsidianresearch.com>
	<20101007165947.GD11681@bicker>
	<20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker>
	<20101012210118.GR24268@obsidianresearch.com> <20101013091312.GB6060@bicker>
	<20101123071025.GI1522@bicker> <adahbf6gytv.fsf@cisco.com>
	<20101124221845.GH2369@obsidianresearch.com> <adad3pugi90.fsf@cisco.com>
 <20101125041337.GA11049@obsidianresearch.com> <4CEE7A22.2040706@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CEE7A22.2040706-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some time ago we discussed a possibility of removing usage of nes_ud_sksq for IMA driver as a blocker of pushing IMA solution to kernel.org. 

The proposal was using OFED transmit optimized path by /dev/infiniband/rdma_cm instead of using private nes_ud_sksq device.

I made an implementation of such solution for checking the performance impact and looking for optimize the existing code. 

I made a simple send test (sendto in kernel) using my NEHALEM i7 machine. 
Current nes_ud_sksq implementation achieved about 1,25mln pkts/sec.
The OFED path (with rdma_cm call) achieved about 0,9mlns pkts/sec.


I run oprofile on rdma_cm code and got a following results:

        samples  %        linenr info                 app name                 symbol name
2586067  24.5323  nes_uverbs.c:558            libnes-rdmav2.so         nes_upoll_cq
1198042  11.3650  (no location information)   vmlinux                  __up_read
539258    5.1156  (no location information)   vmlinux                  copy_user_generic_string
407884    3.8693  msa_verbs.c:1692            libmsa.so.1.0.0          msa_post_send
304569    2.8892  msa_verbs.c:2098            libmsa.so.1.0.0          usq_sendmsg_noblock
299954    2.8455  (no location information)   vmlinux                  __kmalloc
297463    2.8218  (no location information)   libibverbs.so.1.0.0      /usr/lib64/libibverbs.so.1.0.0
267951    2.5419  uverbs_cmd.c:1433           ib_uverbs.ko             ib_uverbs_post_send
264709    2.5111  (no location information)   vmlinux                  kfree
205107    1.9457  port.c:2947                 libmsa.so.1.0.0          sendto
146225    1.3871  (no location information)   vmlinux                  __down_read
145941    1.3844  (no location information)   libpthread-2.5.so        __write_nocancel
139934    1.3275  nes_ud.c:1746               iw_nes.ko                nes_ud_post_send_new_path
131879    1.2510  send.c:32                   msa_tst                  blocking_test_send(void*)
127519    1.2097  (no location information)   vmlinux                  system_call
123552    1.1721  port.c:858                  libmsa.so.1.0.0          find_mcast
109249    1.0364  nes_verbs.c:3478            iw_nes.ko                nes_post_send
92060     0.8733  (no location information)   vmlinux                  vfs_write
90187     0.8555  uverbs_cmd.c:144            ib_uverbs.ko             __idr_get_uobj
89563     0.8496  nes_uverbs.c:1460           libnes-rdmav2.so         nes_upost_send

Form the trace it looks like the    __up_read() - 11% wastes most of time. It is called from idr_read_qp when a  put_uobj_read is called. 

        if (copy_from_user(&cmd, buf, sizeof cmd))  - 5% it is called twice from ib_uverbs_post_send() for IMA and once in ib_uverbs_write() per each frame
                return -EFAULT;

and __kmalloc/kfree - 5% is the third function that has a big meaning. It is called twice for each frame transmitted.

It is about 20% of performance loss comparing to nes_ud_sksq path which we miss when we use a OFED path. 

What I can modify is a kmalloc/kfree optimization - it is possible to make allocation only at start and use pre-allocated buffers.

 I don't see any way for optimalization of idr_read_qp usage or copy_user. In current approach we use a shared page and a separate nes_ud_sksq handle for each created QP so there is no need for any user space data copy or QP lookup. 

Do you have any idea how can we optimize this path?

Regards,

Mirek

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org] 
Sent: Thursday, November 25, 2010 4:01 PM
To: Walukiewicz, Miroslaw
Cc: Jason Gunthorpe; Roland Dreier; Roland Dreier; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations (was: uverbs: handle large number of entries)

Jason Gunthorpe wrote:
> Hmm, considering your list is everything but Mellanox, maybe it makes much more sense to push the copy_to_user down into the driver - ie a ibv_poll_cq_user - then the driver can construct each CQ entry on the stack and copy it to userspace, avoid the double copy, allocation and avoid any fixed overhead of ibv_poll_cq.
>
> A bigger change to be sure, but remember this old thread:
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg05114.html
> 2x improvement by removing allocs on the post path..
Hi Mirek,

Any updates on your findings with the patches?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 0/4] XRC kernel patch set
Date: Tue, 18 May 2010 14:54:55 +0300
Message-ID: <201005181454.55783.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

I resurrected my first try at the XRC patch set.
All the reference counting and management of XRC RCV QPs is now done in the core layer.
The low-level driver only contains create, modify, query and destroy methods.
(I also extracted the common parts of mlx4_ib_query_xrc_rcv_qp and mlx4_ib_query_qp
and placed them in a helper function). 

The reg and unreg verbs are implemented exclusively in the core and uverbs layers.

This patch set is different from the one I submitted previously.
1. patch "Support for Associating XRC domains to inodes" is not in the new set, since you fixed the counting issues.
2. Patch "ib_core: implement XRC RCV qp's" is now replaced by 2 patches --one for
   the ib core layer (V2 1/4) and one for the uverbs layer (V2 2/4)
3. the new patches 3/4 and 4/4 cover the low-level driver, as before
 
The semantics of the destroy verb is now unconditional destruction of the xrc rcv QP. If the app
has done a register on this QP (in another process), the process which registered will no longer be able to use that
QP (i.e, the QP and all its registrations are GONE.  No kernel panics, but the app will not work).

Thus, per the IB Spec, we have XRC RCV create/modify/query/destroy.  In addition, we also have register and
unregister verbs so that the creating process does not need to be the one destroying the QP -- the QP is simply
destroyed (via the low-level driver call) when no more processes are registered to it.

Per your questions:
> I don't really understand the semantics here.  What is supposed to
> happen if I do create/reg/destroy?  
The QP is destroyed.
> What happens if one process does 
> destroy while another process is still registered? 
That is an application bug.  The QP is in fact destroyed, and the registration is cancelled due to QP destruction.
> To make everything 
> even more confusing, mlx4 defines unreg_rxc_rcv_qp to be equivalent to
> destroy_xrc_rcv_qp.
There is no longer an mlx4 unreg_xrc_rcv_qp function.  There is only mlx4 destroy_xrc_rcv_qp

> shouldn't the uverbs core be
> handling the counting/listing of xrc rcv qps and just ask the low-level
> driver to destroy the QP when it's really done with it?
That is what I do now. Counting/listing is done in the core layer.  That layer also distributes
async events on the XRC RCV qp to all processes which have registered with the QP.

I think that these changes eliminate most of the confusion.

Please review the new patch series.
Thanks!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: qib_lookup_qpn() appears to leak pointer out of
 rcu_read_unlock()
Date: Wed, 12 Feb 2014 13:59:30 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F3D24@FMSMSX107.amr.corp.intel.com>
References: <20140212003511.GA27242@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140212003511.GA27242-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> So what am I missing here?
> 

The atomic increment of a reference count:

struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
{
        struct qib_qp *qp = NULL;

        rcu_read_lock();
        if (unlikely(qpn <= 1)) {
                if (qpn == 0)
                        qp = rcu_dereference(ibp->qp0);
                else
                        qp = rcu_dereference(ibp->qp1);
                if (qp)
                        atomic_inc(&qp->refcount); <--------------------------
        } else {
                struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
                unsigned n = qpn_hash(dev, qpn);

                for (qp = rcu_dereference(dev->qp_table[n]); qp;
                        qp = rcu_dereference(qp->next))
                        if (qp->ibqp.qp_num == qpn) {
                                atomic_inc(&qp->refcount); <---------------------
                                break;
                        }
        }
        rcu_read_unlock();
        return qp;
}

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

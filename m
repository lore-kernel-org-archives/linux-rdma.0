From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Jun 21 (infiniband: qib)
Date: Fri, 21 Jun 2013 08:30:05 -0700
Message-ID: <51C4717D.4090002@infradead.org>
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 06/21/13 01:17, Stephen Rothwell wrote:
> Hi all,
> 
> Happy solstice!
> 
> Changes since 20130620:
> 


on x86_64:

when CONFIG_SMP is not enabled:

(from qib.h:)

#ifdef CONFIG_INFINIBAND_QIB_DCA
struct qib_irq_notify {
	int rcv;
	void *arg;
	struct irq_affinity_notify notify;
};
#endif

struct irq_affinity_notify is only defined for CONFIG_SMP or GENERIC_HARDIRQS.
Build error happens when one of those is not enabled.


In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
drivers/infiniband/hw/qib/qib.h:447:29: error: field 'notify' has incomplete type
make[4]: *** [drivers/infiniband/hw/qib/qib_cq.o] Error 1




-- 
~Randy

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver CQ completion handler
Date: Mon, 10 Sep 2012 16:17:46 +0300
Message-ID: <201209101617.46581.jackm@dev.mellanox.co.il>
References: <20549.47088.805176.786765@iinet.net.au> <201209100957.08509.jackm@dev.mellanox.co.il> <504DC25B.1030501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504DC25B.1030501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Monday 10 September 2012 13:35, Or Gerlitz wrote:
> Jack, =A0Max
>=20
> Actually, can't we do well with rcu_read_lock() in mlx4_cq_completion=
()=20
> as that commit documentation suggests?
>=20
I don't know. I do notice (in file include/linux/rcupdate.h) that rcu_r=
ead_lock/unlock
is meant to be used in the interrupt context. Would it be sufficient (b=
esides rcu_read_lock/unlock calls) to add
a call rcu_synchronize() in mlx4_cq_free (after calling synchronize_irq=
)?

Could we also then dispense with the spinlocks in mlx4_cq_event() as we=
ll?

Acquiring the SINGLE cq_table->lock spinlock for EVERY completion event
of EVERY cq seems very nasty to me (probably why Roland did not do this=
), and it would
clearly be desirable not to have to do this.=20

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

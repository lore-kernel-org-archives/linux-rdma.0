From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver CQ completion handler
Date: Tue, 11 Sep 2012 09:03:39 +0300
Message-ID: <201209110903.39789.jackm@dev.mellanox.co.il>
References: <20549.47088.805176.786765@iinet.net.au> <201209101617.46581.jackm@dev.mellanox.co.il> <504DEAB7.2070101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504DEAB7.2070101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Monday 10 September 2012 16:27, Or Gerlitz wrote:
> I =A0took a look on the practice/wrapping used over the mm subsystem =
for=20
> radix_tree_lookup calls, whose maintainer,
> Andrew Morton is signed on the patch Roland pointed to, its just=20
> rcu_read_lock/unlock, seems this is what to do as well.
>=20
In addition, need to do a synchronize_rcu when deleting, per
the comment in include/linux/rcupdate.h:

* It is still required that the caller manage the synchronization and l=
ifetimes
* of the items. So if RCU lock-free lookups are used, typically this wo=
uld mean
* that the items have their own locks, or are amenable to lock-free acc=
ess; and
* that the items are freed by RCU (or only freed after having been dele=
ted from
* the radix tree *and* a synchronize_rcu() grace period).

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

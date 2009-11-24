From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/53] IB/qib: Add Makefile (ipath vs qib)
Date: Tue, 24 Nov 2009 09:10:36 -0800
Message-ID: <alpine.LFD.1.10.0911240907260.420@topaz.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com> <20091119233706.30356.20051.stgit@chromite.mv.qlogic.com> <adaeinu6owu.fsf@roland-alpha.cisco.com> <alpine.LFD.1.10.0911191700500.21294@topaz.mv.qlogic.com>
 <adamy2c3754.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamy2c3754.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Nov 2009, Roland Dreier wrote:
|  > |  > +ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o
|  > | 
|  > | Seems you put the 6120 in the module device table even if PCI_MSI isn't
|  > | set... does the driver build without MSI enabled?
|  > 
|  > Yes.  It just doesn't work well.  It works well enough to tell people
|  > what the problem is, which is what we wanted.
| 
| No, it doesn't even build with CONFIG_PCI_MSI=n (and spews a bunch of
| warnings before failing).  Seriously, try it.

We'll fix it.  It was working; we missed the breakage.

|  > The ipath driver has some significant problems with verbs, and those
|  > problems have been fixed based on the significant restructuring and
|  > rewrites in the ib_qib driver, so it's unlikely that any customer would
|  > want to continue to use the ib_ipath driver in any case.
| 
| I don't think we can drop 6110 support so blithely.  I just did a quick
| check, and brand-new HTX HCAs still seem readily available on ebay, so I

They are likely available because they are old and slow, and few people
can use them (because so few HTX-capable systems were ever built).

If you feel strongly enough about it, ipath can remain as is, we just
don't plan any work on it (including stripping out other board support,
although of course others are welcome to do so).

Dave Olson
dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

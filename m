From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Fri, 10 Apr 2015 21:07:11 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504102104180.917@gentwo.org>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com> <alpine.DEB.2.11.1504090955080.19714@gentwo.org> <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.11.1504091329180.24028@gentwo.org>
 <5526e18b.a50c450a.4b9f.77beSMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.11.1504101011300.30374@gentwo.org> <5528418E.9040403@nasa.gov>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5528418E.9040403-NSQ8wuThN14@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Cc: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 10 Apr 2015, Bob Ciotti wrote:

> > Well applications can screw up yes but the fabric *IS* lossless.
>
> This is a very bad assumption. Fabric *is not* lossless.

I guess then we need to get our money back because it was advertised to be
lossless....

> Packet loss happens - for various reasons that are typically specific to the
> environment.

Right. Even the most reliable transport will not work if someone goes
postal and gets a big sledgehammer and starts hitting the equipment with
that.

> If HW never broke, and systems were never overloaded, room temperatures never
> fluctuated, IB
> cables were always reliable... Its not that uncommon to see packet loss on a
> perfectly functioning
> (large) system let alone one thats having HW issues...

If things break then yes but otherwise the fabric is expected to behave as
advertised.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

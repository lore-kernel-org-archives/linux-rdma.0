From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3 v5] IB/srp: Preparation for transmit ring response allocation
Date: Thu, 19 Aug 2010 19:41:21 +0200
Message-ID: <AANLkTinVdE4-GFw6GKK8PCkXiYLJgt0hqVPzGX7OhEXO@mail.gmail.com>
References: <201008162054.06416.bvanassche@acm.org>
	<1282175086.25848.17.camel@obelisk.thedillows.org>
	<AANLkTim=ESAvKNCocpCKGuqaGVnO4FMhBck9+NaoRBZB@mail.gmail.com>
	<1282214698.25848.35.camel@obelisk.thedillows.org>
	<AANLkTikNUWtw5fHR44HEWK=ceXQ+mxKSKKS1=qrgudXB@mail.gmail.com>
	<1282238719.9393.3.camel@lap75545.ornl.gov>
	<adaiq36se83.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq36se83.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 19, 2010 at 7:29 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> =A0> > Putting the rsv assignment on the same line as its declaration=
 would
> =A0> > make that line exceed 80 columns and hence would trigger a che=
ckpatch
> =A0> > complaint, so it's better to keep it as it is now.
>
> =A0> I didn't check it with checkpatch, but vi tells me it is 78 char=
acters.
>
> In any case I think the 80 column thing should be treated as a flexib=
le
> guideline, not a strict rule. =A0If the code looks significantly bett=
er
> with an 85 or 90 column line than split across two lines, then I thin=
k
> it's better to keep it on one line.

I can remove the "TX_" part from the SRP_TX_IU_... constants. That
keeps the constant names unambiguous, makes them more readable and
also makes the rsv assignment fit on the same line as the declaration.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

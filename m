From: "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
 parameters
Date: Fri, 20 Jul 2012 17:12:00 +0000
Message-ID: <F5ED8E150D0FF14F82CAF3C46756763210780FCC@FMSMSX107.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
 <20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Ultimately, I agree with you.  Besides the general usability issue, there are some obvious limitations to this method.  However, we need this functionality and there is nothing else that exists that we could use.  As Mike points out, we need these to be available to the module at module init.

Another reason for this method is that it gave us backward compatibility with old configurations (settings will not brake for customers who only update the driver.)

- Mitko

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
> Sent: Thursday, July 19, 2012 11:27
> To: Marciniszyn, Mike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port
> parameters
> 
> [resending because I forgot to cc linux-rdma]
> 
> On Thu, Jul 19, 2012 at 6:04 AM, Mike Marciniszyn
> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > Add support for per-device/per-port driver parameters allowing users
> > to specify different values for different ports/devices. All converted
> > parameters will behave as expected if the old parameter format is
> > used.
> >
> > New per-device/per-port parameter format:
> >     <param>=[<d>,]<u>[:<p>]=<v>[,<u>[:<p>]=<v>]
> > where:
> >     <param> - driver parameter name
> >     <d> - default value applicable to all devices/ports
> >     <u> - unit number (zero-based)
> >     <p> - port number (1-based)
> >     <v> - numeric value
> 
> I think this is pushing the module parameter facility way past the breaking
> point of usability.  We really need to come up with a better way to get
> complex structured config info like this into the drive
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

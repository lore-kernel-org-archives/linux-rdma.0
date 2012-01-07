From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Sat, 7 Jan 2012 09:59:14 +0000
Message-ID: <CAO+b5-oN=3VFo3Rmj09mZwvZej8O+DxzMatD361Vvx_HzA7pFw@mail.gmail.com>
References: <4EFC987B.6070901@list-group.com>
	<1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
	<CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823732566B335@ORSMSX101.amr.corp.intel.com>
	<CAO+b5-pk8v-1+STkYXmwTv2nKyQJcZd575dJW6Hipfo5_AchwA@mail.gmail.com>
	<CAL1RGDXtZA=6uvCE73isD7cu2=LU4b3CGPs4g7UMPmW=1xqgww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXtZA=6uvCE73isD7cu2=LU4b3CGPs4g7UMPmW=1xqgww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 5, 2012 at 5:29 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> =
wrote:
> That should be OK. =A0ib_uverbs_destroy_cq() doesn't really do anythi=
ng
> until ib_destroy_cq() has returned, and at that point it is guarantee=
d
> that the completion handler for the CQ is done.

That sounds like a requirement for low-level IB drivers. Has it
already been considered to document this requirement in
Documentation/infiniband/core_locking.txt ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

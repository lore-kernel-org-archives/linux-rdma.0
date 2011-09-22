From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 14:40:10 -0400
Message-ID: <4E7B810A.3020806@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com> <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/22/2011 2:36 PM, Bart Van Assche wrote:
>> libibnetdisc/src/ibnetdisc.c |    2 +-
>> >  src/ibportstate.c            |    4 ++--
>> >  2 files changed, 3 insertions(+), 3 deletions(-)
>> >  mode change 100644 => 100755 libibnetdisc/src/ibnetdisc.c
>> >  mode change 100644 => 100755 src/ibportstate.c
> A minor nit: is this mode change really necessary ? (I know Visual
> Studio does enable the execute bit without asking.)

It shouldn't add +w to the permissions of those files in linux.

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

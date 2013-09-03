From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Slow performance with librspreload.so
Date: Tue, 03 Sep 2013 08:06:53 -0400
Message-ID: <5225D0DD.7060803@dev.mellanox.co.il>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237388CA96AD@ORSMSX109.amr.corp.intel.com> <CAJH6TXhAuSDytS5O1cJMg3iatq+STkwhPUG2zmexJ5tmt3Foqg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237388CA9865@ORSMSX109.amr.corp.intel.com> <CAJH6TXgA0ghKX1P8UUAMFKY9o0xBJ0j4-kFa_M4a4ecdzoD0HA@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237388CA9C6B@ORSMSX109.amr.corp.intel.com> <CAJH6TXiYLKt3b1UFsZt7uFwDbWcDFnHNnS8CTO24Gt-2zn+Qiw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237388CA9D8A@ORSMSX109.amr.corp.intel.com> <CAJH6TXhWWMBbopDLZY2+rrNOm2m5gcmObj7Sr16u2qrNW_NHgw@mail.gmail.com> <CAJH6TXgR=wVGyyHrpTKkBw-5M=A9-tGzjpYcV6NWpk8uKvFn8Q@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237388CAA11B@ORSMSX109.amr.corp.intel.com> <CAJH6TXgu4L8g
 nqQX1fKZ=ioZDxUMnj=s3h0qkYh1_35VWpMJ1g@mail.gmail.com> <000c01cea63e$1e20eae0$5a62c0a0$@soft-forge.com> <CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXiOToa2-EOj6Hz-rkVHt3tCSh4jnLbKZs69GhT7dFeH0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/31/2013 3:51 PM, Gandalf Corvotempesta wrote:
> By the way, increasing MTU to 4096 will give me more performance?

With mthca, due to quirk, optimal performance is achieved at 1K MTU.
OpenSM can reduce the MTU in returned PathRecords to 1K when one end of
the path is mthca and actual path MTU is > 1K. This is controlled by
enable_quirks config parameter which defaults to FALSE (don't do this).

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

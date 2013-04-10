From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Wed, 10 Apr 2013 08:32:55 +0300
Message-ID: <20130410053255.GC12777@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
 <515F42EE.8060203@linux.vnet.ibm.com>
 <20130409190350.GB8212@redhat.com>
 <5164BFE3.4040204@linux.vnet.ibm.com>
 <20130410032449.GA12777@redhat.com>
 <5164EB5F.80403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5164EB5F.80403-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 10, 2013 at 12:32:31AM -0400, Michael R. Hines wrote:
> On 04/09/2013 11:24 PM, Michael S. Tsirkin wrote:
> >Which mechanism do you refer to? You patches still seem to pin
> >each page in guest memory at some point, which will break all COW.
> >In particular any pagemap tricks to detect duplicates on source
> >that I suggested won't work.
> 
> Sorry, I mispoke. I'm reffering to dynamic server page registration.
> 
> Of course it does not eliminate pinning - but it does mitigate the
> foot print of the VM as a feature that was requested.
> 
> I have implemented it and documented it.
> 
> - Michael

Okay, but GIFT is supposed to be used on send side: it's only allowed
with local/remote read access, and serves to reduce memory usage
on send side.
For example, disable zero page detection and look at memory usage
on send side before and after migration.
Dynamic registration on the receive side is nice but seems
completely unrelated ...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

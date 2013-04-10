From: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Wed, 10 Apr 2013 12:28:59 -0400
Message-ID: <5165934B.6050802@linux.vnet.ibm.com>
References: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3948.40205@linux.vnet.ibm.com> <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com> <515F42EE.8060203@linux.vnet.ibm.com> <20130409190350.GB8212@redhat.com> <5164BFE3.4040204@linux.vnet.ibm.com> <20130410032449.GA12777@redhat.com> <5164EB5F.80403@linux.vnet.ibm.com> <20130410053255.GC12777@redhat.com> <516589C8.1040606@linux.vnet.ibm.com> <20130410150539.GA24381@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410150539.GA24381-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/10/2013 11:05 AM, Michael S. Tsirkin wrote:
> On Wed, Apr 10, 2013 at 11:48:24AM -0400, Michael R. Hines wrote:
>> There's a very nice, simple client/server RDMA application on the
>> internet you can use to test your patch.
>>
>> http://thegeekinthecorner.wordpress.com/2010/09/28/
>> rdma-read-and-write-with-ib-verbs/
>>
>> This guy provides the source code which dumps several gigabytes over RDMA
>> to the other side.
>>
>> There's no need to run QEMU to test your patch,
>> assuming you have access to infiniband hardware.
>>
>> - Michael
>
> Does this app have any COW pages?

It can easily be made to be. It's just a couple of C source files.

I've only used it for basic testing.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Wed, 10 Apr 2013 11:48:24 -0400
Message-ID: <516589C8.1040606@linux.vnet.ibm.com>
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
	<20130410053255.GC12777@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="------------040004040303040409010709"
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20130410053255.GC12777@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Roland Dreier <roland@kernel.org>, qemu-devel@nongnu.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Sean Hefty <sean.hefty@intel.com>, Christoph Lameter <cl@linux.com>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040004040303040409010709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


There's a very nice, simple client/server RDMA application on the
internet you can use to test your patch.

http://thegeekinthecorner.wordpress.com/2010/09/28/rdma-read-and-write-with-ib-verbs/

This guy provides the source code which dumps several gigabytes over RDMA
to the other side.

There's no need to run QEMU to test your patch,
assuming you have access to infiniband hardware.

- Michael

On 04/10/2013 01:32 AM, Michael S. Tsirkin wrote:
> On Wed, Apr 10, 2013 at 12:32:31AM -0400, Michael R. Hines wrote:
>> On 04/09/2013 11:24 PM, Michael S. Tsirkin wrote:
>>> Which mechanism do you refer to? You patches still seem to pin
>>> each page in guest memory at some point, which will break all COW.
>>> In particular any pagemap tricks to detect duplicates on source
>>> that I suggested won't work.
>> Sorry, I mispoke. I'm reffering to dynamic server page registration.
>>
>> Of course it does not eliminate pinning - but it does mitigate the
>> foot print of the VM as a feature that was requested.
>>
>> I have implemented it and documented it.
>>
>> - Michael
> Okay, but GIFT is supposed to be used on send side: it's only allowed
> with local/remote read access, and serves to reduce memory usage
> on send side.
> For example, disable zero page detection and look at memory usage
> on send side before and after migration.
> Dynamic registration on the receive side is nice but seems
> completely unrelated ...
>


--------------040004040303040409010709
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <div class="moz-cite-prefix"><br>
      There's a very nice, simple client/server RDMA application on the
      <br>
      internet you can use to test your patch.<br>
      <br>
      <meta http-equiv="content-type" content="text/html;
        charset=ISO-8859-1">
      <a
href="http://thegeekinthecorner.wordpress.com/2010/09/28/rdma-read-and-write-with-ib-verbs/">http://thegeekinthecorner.wordpress.com/2010/09/28/rdma-read-and-write-with-ib-verbs/</a><br>
      <br>
      This guy provides the source code which dumps several gigabytes
      over RDMA<br>
      to the other side.<br>
      <br>
      There's no need to run QEMU to test your patch,<br>
      assuming you have access to infiniband hardware.<br>
      <br>
      - Michael<br>
      <br>
      On 04/10/2013 01:32 AM, Michael S. Tsirkin wrote:<br>
    </div>
    <blockquote cite="mid:20130410053255.GC12777@redhat.com" type="cite">
      <pre wrap="">On Wed, Apr 10, 2013 at 12:32:31AM -0400, Michael R. Hines wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">On 04/09/2013 11:24 PM, Michael S. Tsirkin wrote:
</pre>
        <blockquote type="cite">
          <pre wrap="">Which mechanism do you refer to? You patches still seem to pin
each page in guest memory at some point, which will break all COW.
In particular any pagemap tricks to detect duplicates on source
that I suggested won't work.
</pre>
        </blockquote>
        <pre wrap="">
Sorry, I mispoke. I'm reffering to dynamic server page registration.

Of course it does not eliminate pinning - but it does mitigate the
foot print of the VM as a feature that was requested.

I have implemented it and documented it.

- Michael
</pre>
      </blockquote>
      <pre wrap="">
Okay, but GIFT is supposed to be used on send side: it's only allowed
with local/remote read access, and serves to reduce memory usage
on send side.
For example, disable zero page detection and look at memory usage
on send side before and after migration.
Dynamic registration on the receive side is nice but seems
completely unrelated ...

</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------040004040303040409010709--

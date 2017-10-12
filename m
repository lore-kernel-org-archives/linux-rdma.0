From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Thu, 12 Oct 2017 22:27:11 +0000
Message-ID: <OF42A3C910.DFAA760B-ON002581B7.007B56BC-002581B7.007B56C0@notes.na.collabserv.com>
References: <20171008123240.GA31066@infradead.org>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171008123128.GA28815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171008123240.GA31066-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Christoph Hellwig 
>Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Date: 10/08/2017 03:30PM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
>
>On Sun, Oct 08, 2017 at 05:31:28AM -0700, Christoph Hellwig wrote:
>> How well has this been tested?  How well does it perform,
>> e.g. compare performance for NVMe vs RoCE2 or a native iWarp
>adapter.
>
>err, s/RoCE2/SoftRoCE/ ..
>
>--

Christoph,

Thanks for asking. I did not compare with SoftRoCE yet.
Maybe we are in the same ballpark. Maybe siw has advantages
in terms of bandwidth if it uses GSO, and SoftRoCE may
be a little faster regarding delay. But, we have
to check.

We used siw alot for RDMA application development (this
is where those nasty debug statements came from - we
mostly debugged RDMA applications). So it
has some stability. We tested on large installations
(up to 4k nodes) running GPFS with RDMA enabled on it
(BlueGene that time).

Using ib_read/write_bw/lat, on a single 100Gb link, and
one connection, we see close to 65Gb/s throughput READ/WRITE.
WRITE delay is reported to be around 7us, READ ~13us. All
measured using two Chelsio T6 with RDMA offload disabled,
and Intel Xeon E5-2640 v3. We are aware of possible code
optimization to reach better performance (e.g. better
NUMA awareness)

I hope that email makes it to the list. I have to teach
my email client to talk ASCII. I am happy to be back ;)

Thanks and best regards,
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

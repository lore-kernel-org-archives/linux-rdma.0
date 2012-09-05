From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 19:53:26 +0000
Message-ID: <0000013997fe9059-0684e333-c270-48be-b37b-904f9831efa3-000000@email.amazonses.com>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov> <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com> <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov> <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000@email.amazonses.com>
 <78D8717C-0505-408B-8625-A9124AB33C9E@ornl.gov> <0000013997d35848-57319f33-839b-4480-a075-53b36f67bfe2-000000@email.amazonses.com> <E88DEA9F-416B-4663-A292-5780DFF9B641@ornl.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E88DEA9F-416B-4663-A292-5780DFF9B641-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 5 Sep 2012, Atchley, Scott wrote:

> With Myricom 10G NICs, for example, you just need one core and it can do
> line rate with 1500 byte MTU. Do you count the stateless offloads as
> band-aids? Or something else?

The stateless aids also have certain limitations. Its a grey zone if you
want to call them band aids. It gets there at some point because stateless
offload can only get you so far. The need to send larger sized packets
through the kernel increases the latency and forces the app to do larger
batching. Its not very useful if you need to send small packets to a
variety of receivers.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

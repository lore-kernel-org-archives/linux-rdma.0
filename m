From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA and memory ordering
Date: Thu, 14 Nov 2013 15:47:23 -0400
Message-ID: <CADPSxAgdiOT1Vo_JUaR7fp29x=+B2cDNT49WQxNN0nYq91svZQ@mail.gmail.com>
References: <CADPSxAhAGYZude8CM65-UDvfiPscStgcNsAfs=2XBbntg-wL0w@mail.gmail.com>
	<5281FFF9.5070705@gmail.com>
	<CADPSxAh6i74j8JVmWncttN6W4ithTGmsMgqWWpoBy2Z8RRb=_g@mail.gmail.com>
	<20131112183142.GB6639@obsidianresearch.com>
	<CADPSxAgF1CAiYoYbxbCON4NCD-tH8cAsJFRtECkTGJJQC4MXCg@mail.gmail.com>
	<20131112211123.GA29132@obsidianresearch.com>
	<CADPSxAhzmaut9s9L1fv5urhzX8xKU9GbL6z1TkOX3FuM4NUsww@mail.gmail.com>
	<20131113180915.GA6597@obsidianresearch.com>
	<CADPSxAiepGuzWYXjyDxnSzER5MqL57fZ9mh83SLwV461PwZO3Q@mail.gmail.com>
	<20131114190514.GB21549@obsidianresearch.com>
	<CADPSxAg0k5SuxCX=3CMNV8-xME55p3iL4BMqnq0ji---kN6ZEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAg0k5SuxCX=3CMNV8-xME55p3iL4BMqnq0ji---kN6ZEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Gabriele Svelto <gabriele.svelto-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I should do the experiment with 2 processes however..

On Thu, Nov 14, 2013 at 3:33 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Jason,
>
> I just got an email saying that Mellanox does infact use an ordering
> for reads and writes. So I think we can blame the CPU or the PCI for
> the unordered reads.
>
> On Thu, Nov 14, 2013 at 3:05 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Thu, Nov 14, 2013 at 01:12:55AM -0400, Anuj Kalia wrote:
>>
>>> So, another question: why are the reads unordered while the writes are
>>> ordered? I think by now we can assume write ordering (my experiments +
>>> MVAPICH uses it). Can the PCI reorder the reads issued by the HCA?
>>
>> Without fencing there is no gurantee in what order things are made
>> visible, and the CPU will flush its write buffers however it likes.
> I'm using fencing in the read experiment. The code at the server looks
> like this:
>
> while(1) {
>         for(i = 0; i < EXTENT_CAPACITY; i++) {
>             ptr[EXTENT_CAPACITY - i - 1] = iter;
>             asm volatile ("" : : : "memory");
>             asm volatile("mfence" ::: "memory");
>         }
>         iter ++;
>         usleep(2000 + (rand() % 200));
>     }
>
>> The PCI subsystem can also re-order reads however it likes, that is
>> part of the PCI spec. In a 2 socket system don't be surprised if cache
>> lines on different sockets complete out of order.
>> Think of this as a classic multi-threaded race condition, and not
>> related to PCI. If you do the same test using 2 threads you probably
>> get the same results.
>>
> The PCI explanation sounds good.
> However, with a fence after every update, I don't think multiple
> sockets will be a problem.
>>> > Intel hardware is very good at hiding ordering issues 99% of the time,
>>> > but in many cases there can be a stress'd condition that will show a
>>> > different result.
>>
>>> Hmm.. I'm willing to run billions of iterations of the test. That
>>> should give some confidence.
>>
>> Not really, repeating the same test billions of times is not
>> comprehensive.  You need to stress the system in all sorts of
>> different ways to see different behavior.
> Hmm.. It's not really the same test. My server sleeps for a randomly
> chosen large duration between updates. If the test passes for many
> iterations, we can assume that we've tested a lot of interleavings.
> But yes, that doesn't give 100% confidence.
>> For instance, in a 2 socket system there are likely all sorts of crazy
>> sensitivities that depend on which socket the memory lives, which
>> socket holds the newest cacheline, which socket has an old line, which
>> socket is connected directly to the HCA, etc.
> Again, does that matter with fences? With a fence after every update,
> there is a real time ordering for when the updates appear in the cache
> hierarchy regardless of the socket.
>>
>> Jason
>
> Regards,
> Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

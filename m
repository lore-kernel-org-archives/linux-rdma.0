From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Tue, 05 May 2015 16:57:55 -0400
Message-ID: <55492ED3.7000507@talpey.com>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net> <20150505154411.GA16729@infradead.org> <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com> <20150505172540.GA19442@infradead.org> <55490886.4070502@talpey.com> <20150505191012.GA21164@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150505191012.GA21164-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/5/2015 3:10 PM, Christoph Hellwig wrote:
> On Tue, May 05, 2015 at 02:14:30PM -0400, Tom Talpey wrote:
>> As you might guess, I can go on at length about this. :-) But, if
>> you have a kernel service, the ability to pin memory, and you
>> want it to go fast, you want FRWR.
>
> Basically most in-kernel consumers seem to have the same requirements:
>
>   - register a struct page, which can be kernel or user memory (it's
>     probably pinned in your Terms, but we don't really use that much in
>     kernelspace).

Actually, I strongly disagree that the in-kernel consumers want to
register a struct page. They want to register a list of pages, often
a rather long one. They want this because it allows the RDMA layer to
address the list with a single memory handle. This is where things
get tricky.

So the "pinned" or "wired" term is because in order to do RDMA, the
page needs to have a fixed mapping to this handle. Usually, that means
a physical address. There are some new approaches that allow the NIC
to raise a fault and/or walk kernel page tables, but one way or the
other the page had better be resident. RDMA NICs, generally speaking,
don't buffer in-flight RDMA data, nor do you want them to.

>   - In many but not all cases we might need an offset/length for each
>     page (think struct bvec, paged sk_buffs, or scatterlists of some
>     sort), in other an offset/len for the whole set of pages is fine,
>     but that's a superset of the one above.

Yep, RDMA calls this FBO and length, and further, the protocol requires
that the data itself be contiguous within the registration, that is, the
FBO can be non-zero, but no other holes be present.

>   - we usually want it to be as fast as possible

In the case of file protocols such as NFS/RDMA and SMB Direct, as well
as block protocols such as iSER, these registrations are set up and
torn down on a per-I/O basis, in order to protect the data from
misbehaving peers or misbehaving hardware. So to me as a storage
protocol provider, "usually" means "always".

I totally get where you're coming from, my main question is whether
it's possible to nail the requirements of some useful common API.
It has been tried before, shall I say.

Tom.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
